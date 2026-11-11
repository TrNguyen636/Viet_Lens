import json
import os
import threading

from langchain_groq import ChatGroq

from app.llm.groq_key_manager import groq_key_manager


DEFAULT_GROQ_MODEL = os.getenv("GROQ_MODEL", "qwen/qwen3.8-27b")

_client_lock = threading.Lock()
_clients: dict[str, ChatGroq] = {}


def _get_client(api_key: str) -> ChatGroq:
    with _client_lock:
        client = _clients.get(api_key)
        if client is None:
            client = ChatGroq(
                model=DEFAULT_GROQ_MODEL,
                api_key=api_key,
                temperature=0.3,
                max_tokens=1024,
                max_retries=0,
            )
            _clients[api_key] = client
        return client


def _content_to_str(content: object) -> str:
    if isinstance(content, str):
        return content
    return json.dumps(content, ensure_ascii=False)


# =========================================================
# BASIC TEXT GENERATION
# =========================================================

def invoke_llm(prompt: str) -> str:
    def _call(api_key: str) -> str:
        response = _get_client(api_key).invoke(prompt)
        return _content_to_str(response.content)

    return groq_key_manager.execute_with_key_fallback(_call)


# =========================================================
# STRUCTURED JSON GENERATION
# =========================================================

def invoke_json_llm(prompt: str) -> str:
    def _call(api_key: str) -> str:
        response = _get_client(api_key).invoke(
            prompt,
            response_format={"type": "json_object"},
        )
        return _content_to_str(response.content)

    return groq_key_manager.execute_with_key_fallback(_call)
