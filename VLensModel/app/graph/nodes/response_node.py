import json

from app.graph.state import (
    AgentState
)

from app.llm.groq_client import (
    invoke_llm
)

from app.llm.prompts.response_prompts import (
    RESPONSE_SYSTEM_PROMPT
)


# =========================================================
# RESPONSE NODE
# =========================================================

def response_node(
    state: AgentState
):

    print("\n===================================")
    print(" DRAFT (RESPONSE) NODE ")
    print("===================================\n")

    tool_results = state.get("tool_results", {}) or {}

    # =====================================================
    # BUILD CONTEXT
    # =====================================================

    context = {

        "landmark_name":
        state.get(
            "landmark_name"
        ),

        "city":
        state.get(
            "detected_city"
        ),

        "country":
        state.get(
            "detected_country"
        ),

        "intents":
        state.get(
            "intents"
        ),

        "tool_results":
        tool_results
    }

    print("\n===== RESPONSE CONTEXT =====\n")

    print(context)

    # =====================================================
    # USER QUERY & TARGET LANGUAGE
    # =====================================================

    user_query = state.get(
        "user_query",
        ""
    )

    language = (state.get("language") or "vi").strip().lower()
    is_japanese = language.startswith("ja")
    is_english = language.startswith("en")

    if is_japanese:
        language_directive = """
=========================================================
DIRECTIVE: TARGET RESPONSE LANGUAGE IS JAPANESE (日本語)
=========================================================
- The user requested this response in JAPANESE.
- You MUST write your entire response strictly in polite, natural JAPANESE using Keigo (敬語: です・ます).
- DO NOT use Vietnamese or English greetings (use "こんにちは！" or "VietLensへようこそ！").
- Section titles must be in Japanese (e.g. "### 🏛️ 建築のハイライト", "### 📜 歴史と文化的意義", "### 💡 観光のヒント").
- Present the landmark name bilingually: Japanese name followed by Vietnamese name in parentheses, for example: "ドラゴン橋 (Cầu Rồng)", "ソンハン旋回橋 (Cầu Quay Sông Hàn)".
"""
    elif is_english:
        language_directive = """
=========================================================
DIRECTIVE: TARGET RESPONSE LANGUAGE IS ENGLISH
=========================================================
- The user requested this response in ENGLISH.
- You MUST write your entire response strictly in natural ENGLISH.
- DO NOT use any Vietnamese greetings or sentences (no "Chào bạn", no Vietnamese explanations).
- Section titles must be in English (e.g. "### 🏛️ Architectural Highlights", "### 📜 Historical Overview", "### 💡 Tips for Visitors").
- Present the landmark name bilingually: English name followed by Vietnamese name in parentheses, for example: "Han River Bridge (Cầu Quay Sông Hàn)".
"""
    else:
        language_directive = """
=========================================================
DIRECTIVE: TARGET RESPONSE LANGUAGE IS VIETNAMESE
=========================================================
- Hãy trả lời toàn bộ bằng TIẾNG VIỆT tự nhiên, trang nhã, giàu bản sắc văn hóa.
"""

    # =====================================================
    # BUILD PROMPT
    # =====================================================

    target_lang_label = 'JAPANESE' if is_japanese else ('ENGLISH' if is_english else 'VIETNAMESE')

    prompt = f"""
{RESPONSE_SYSTEM_PROMPT}

{language_directive}

=========================================================
USER QUERY
=========================================================

{user_query}

=========================================================
AVAILABLE INFORMATION
=========================================================

{json.dumps(context, indent=2)}

REMINDER: Obey the TARGET RESPONSE LANGUAGE ({target_lang_label}) strictly!
"""

    # =====================================================
    # GENERATE RESPONSE
    # =====================================================

    final_response = invoke_llm(
        prompt
    )

    try:
        print("\n===== FINAL RESPONSE =====\n")
        print(final_response)
    except Exception:
        pass

    # =====================================================
    # RETURN
    # =====================================================

    return {

        "final_answer":
        final_response
    }
