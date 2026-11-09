from langchain_groq import ChatGroq

from app.config.settings import settings


# =========================================================
import os

DEFAULT_GROQ_MODEL = os.getenv("GROQ_MODEL", "qwen/qwen3.8-27b")

llm = ChatGroq(
    model=DEFAULT_GROQ_MODEL,
    api_key=settings.GROQ_API_KEY,
    temperature=0.3,
    max_tokens=1024
)


# =========================================================
# BASIC TEXT GENERATION
# =========================================================

def invoke_llm(prompt: str) -> str:

    response = llm.invoke(prompt)

    return response.content


# =========================================================
# STRUCTURED JSON GENERATION
# =========================================================

def invoke_json_llm(prompt: str) -> str:

    response = llm.invoke(

        prompt,

        response_format={
            "type": "json_object"
        }
    )

    return response.content
