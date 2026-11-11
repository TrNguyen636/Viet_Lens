import os
import re
from pydantic_settings import BaseSettings, SettingsConfigDict

BASE_DIR = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
ENV_PATH = os.path.join(BASE_DIR, '.env')

_PLACEHOLDER_PREFIXES = ("your_", "<your", "gsk_dan_key")


def _is_usable_key(key: str) -> bool:
    cleaned = key.strip()
    if not cleaned:
        return False
    lower = cleaned.lower()
    return not any(lower.startswith(p) for p in _PLACEHOLDER_PREFIXES)


class Settings(BaseSettings):

    # =====================================================
    # REMOTE INFERENCE & LLM PROVIDERS
    # =====================================================

    PINGGY_URL: str = ""
    GROQ_API_KEY: str = ""
    GROQ_API_KEYS: str = ""
    GROQ_KEY_COOLDOWN_SECONDS: int = 65

    def get_groq_api_keys(self) -> list[str]:
        """Collects, filters, and deduplicates Groq API keys preserving priority order."""
        candidates: list[str] = []

        if self.GROQ_API_KEY:
            for part in re.split(r"[,;\s]+", self.GROQ_API_KEY.strip()):
                if part:
                    candidates.append(part)

        if self.GROQ_API_KEYS:
            for part in re.split(r"[,;\s]+", self.GROQ_API_KEYS.strip()):
                if part:
                    candidates.append(part)

        numbered_vars: list[tuple[int, str]] = []
        for env_name, env_val in os.environ.items():
            match = re.fullmatch(r"GROQ_API_KEY_(\d+)", env_name)
            if match and env_val:
                numbered_vars.append((int(match.group(1)), env_val))
        for _, val in sorted(numbered_vars, key=lambda item: item[0]):
            candidates.append(val)

        seen: set[str] = set()
        result: list[str] = []
        for raw in candidates:
            cleaned = raw.strip().strip('"').strip("'")
            if _is_usable_key(cleaned) and cleaned not in seen:
                seen.add(cleaned)
                result.append(cleaned)
        return result

    # =====================================================
    # OPEN WEATHER & SERPAPI
    # =====================================================

    OPENWEATHER_API_KEY: str = ""
    OPENWEATHER_CURRENT_URL: str = "https://api.openweathermap.org/data/2.5/weather"
    OPENWEATHER_FORECAST_URL: str = "https://api.openweathermap.org/data/2.5/forecast"
    OPENWEATHER_GEOCODING_URL: str = "http://api.openweathermap.org/geo/1.0/direct"

    SERPAPI_API_KEY: str = ""

    # =====================================================
    # Pydantic Config
    # =====================================================

    model_config = SettingsConfigDict(
        env_file=ENV_PATH,
        case_sensitive=True,
        extra="ignore"
    )


# =========================================================
# GLOBAL SETTINGS OBJECT
# =========================================================

settings = Settings()

