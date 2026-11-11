import re
import threading
import time
from typing import Callable, TypeVar

from app.config.settings import settings

T = TypeVar("T")

_DAILY_LIMIT_KEYWORDS = (
    "tokens per day",
    "requests per day",
    "tpd",
    "rpd",
    "insufficient_quota",
    "quota exceeded",
)
_RATE_LIMIT_KEYWORDS = (
    "rate_limit",
    "rate limit",
    "too many requests",
    "tokens per minute",
    "requests per minute",
    "tpm",
    "rpm",
    "overloaded",
    "service unavailable",
    "try again in",
)
_INVALID_KEY_KEYWORDS = (
    "invalid_api_key",
    "invalid api key",
    "expired_api_key",
    "organization_restricted",
    "account_deactivated",
    "unauthorized",
)


def mask_key(key: str) -> str:
    """Returns a log-safe masked version of an API key."""
    if not key or len(key) <= 10:
        return "***"
    return f"{key[:7]}...{key[-4:]}"


def _extract_status_code(exc: Exception) -> int | None:
    for attr in ("status_code", "http_status"):
        val = getattr(exc, attr, None)
        if isinstance(val, int):
            return val
    response = getattr(exc, "response", None)
    if response is not None:
        code = getattr(response, "status_code", None)
        if isinstance(code, int):
            return code
    match = re.search(r"\b(401|402|403|429|503)\b", str(exc))
    return int(match.group(1)) if match else None


def _extract_retry_after(exc: Exception) -> int | None:
    response = getattr(exc, "response", None)
    headers = getattr(response, "headers", None) if response is not None else None
    if headers and hasattr(headers, "get"):
        raw = headers.get("retry-after") or headers.get("Retry-After")
        if raw:
            try:
                return max(1, int(float(raw)))
            except ValueError:
                pass
    match = re.search(r"try again in\s+([0-9]+(?:\.[0-9]+)?)\s*(s|m|ms)", str(exc).lower())
    if match:
        val = float(match.group(1))
        unit = match.group(2)
        if unit == "m":
            return max(1, int(val * 60))
        if unit == "s":
            return max(1, int(val))
    return None


def classify_groq_error(
    exc: Exception,
    default_cooldown: int = 65,
) -> tuple[bool, int, str]:
    """
    Classifies a Groq API exception to decide whether to rotate to the next key.

    Returns (should_switch, cooldown_seconds, reason):
      - cooldown_seconds == -1 means permanently disabled until restart (401/403).
      - cooldown_seconds > 0 means temporary cooldown in seconds (429/402/503).
    """
    status = _extract_status_code(exc)
    msg_lower = str(exc).lower()

    if status in (401, 403) or any(k in msg_lower for k in _INVALID_KEY_KEYWORDS):
        return True, -1, f"invalid/revoked key (status={status or 'auth'})"

    if status == 402 or any(k in msg_lower for k in _DAILY_LIMIT_KEYWORDS):
        return True, 1800, f"daily quota exhausted (status={status or 'quota'})"

    if status in (429, 503) or any(k in msg_lower for k in _RATE_LIMIT_KEYWORDS):
        retry_after = _extract_retry_after(exc)
        cooldown = max(retry_after or default_cooldown, 5)
        return True, cooldown, f"rate limited (status={status or 429}, cooldown={cooldown}s)"

    return False, 0, "non-quota error"


class GroqKeyManager:
    """Thread-safe sequential fallback manager for a pool of Groq API keys."""

    def __init__(self, keys: list[str] | None = None, default_cooldown: int | None = None):
        self._lock = threading.RLock()
        self._keys: list[str] = list(keys) if keys is not None else settings.get_groq_api_keys()
        self._default_cooldown = (
            default_cooldown if default_cooldown is not None else settings.GROQ_KEY_COOLDOWN_SECONDS
        )
        self._active_index = 0
        self._cooldown_until: dict[str, float] = {}
        self._disabled: set[str] = set()

    def reload_keys(self, keys: list[str] | None = None) -> None:
        with self._lock:
            self._keys = list(keys) if keys is not None else settings.get_groq_api_keys()
            self._active_index = 0
            self._cooldown_until.clear()
            self._disabled.clear()

    def has_keys(self) -> bool:
        with self._lock:
            return len(self._keys) > 0

    def get_status(self) -> dict[str, int]:
        now = time.monotonic()
        with self._lock:
            total = len(self._keys)
            disabled = sum(1 for k in self._keys if k in self._disabled)
            cooldown = sum(
                1
                for k in self._keys
                if k not in self._disabled and self._cooldown_until.get(k, 0.0) > now
            )
            active = max(0, total - disabled - cooldown)
            return {
                "total": total,
                "active": active,
                "cooldown": cooldown,
                "disabled": disabled,
            }

    def _ordered_candidate_indices(self) -> list[int]:
        """Returns candidate key indices: healthy keys first (starting from _active_index), then cooling-down keys sorted by soonest expiry."""
        now = time.monotonic()
        n = len(self._keys)
        if n == 0:
            return []

        healthy: list[int] = []
        cooling: list[tuple[float, int]] = []
        for offset in range(n):
            idx = (self._active_index + offset) % n
            key = self._keys[idx]
            if key in self._disabled:
                continue
            expiry = self._cooldown_until.get(key, 0.0)
            if expiry <= now:
                healthy.append(idx)
            else:
                cooling.append((expiry, idx))

        cooling.sort(key=lambda item: item[0])
        return healthy + [idx for _, idx in cooling]

    def _mark_failure(self, key: str, cooldown_seconds: int) -> None:
        with self._lock:
            if cooldown_seconds < 0:
                self._disabled.add(key)
            else:
                self._cooldown_until[key] = time.monotonic() + cooldown_seconds

    def _mark_success(self, idx: int) -> None:
        with self._lock:
            key = self._keys[idx]
            self._active_index = idx
            self._cooldown_until.pop(key, None)

    def execute_with_key_fallback(self, operation: Callable[[str], T]) -> T:
        with self._lock:
            candidates = self._ordered_candidate_indices()

        if not candidates:
            raise RuntimeError("No usable GROQ_API_KEY / GROQ_API_KEYS configured.")

        last_exc: Exception | None = None
        for pos, idx in enumerate(candidates):
            key = self._keys[idx]
            try:
                result = operation(key)
                self._mark_success(idx)
                return result
            except Exception as exc:
                last_exc = exc
                should_switch, cooldown_seconds, reason = classify_groq_error(
                    exc, default_cooldown=self._default_cooldown
                )
                if not should_switch:
                    raise

                self._mark_failure(key, cooldown_seconds)
                masked = mask_key(key)
                has_next = pos + 1 < len(candidates)
                if has_next:
                    next_masked = mask_key(self._keys[candidates[pos + 1]])
                    print(
                        f"[GroqKeyManager] Key {masked} failed ({reason}). "
                        f"Falling back to {next_masked}..."
                    )
                else:
                    print(
                        f"[GroqKeyManager] Key {masked} failed ({reason}). "
                        f"All {len(candidates)} candidate key(s) exhausted."
                    )

        if last_exc is not None:
            raise last_exc
        raise RuntimeError("All Groq API keys failed.")


groq_key_manager = GroqKeyManager()
