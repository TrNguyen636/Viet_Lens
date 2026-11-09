import base64
import json
import re
import requests

from io import BytesIO

from PIL import Image

from app.config.settings import settings

from app.llm.prompts.vision_prompts import (
    VISION_SYSTEM_PROMPT
)


def is_corrupted_output(text: str) -> bool:
    """Checks if model output contains NaN/FP16 corruption or non-Latin/non-Vietnamese garbage tokens."""
    if not text or not text.strip():
        return True
    s = text.strip()
    if s in ("Unknown", "Failed to parse model output."):
        return True
    # Detect repeated garbage characters (e.g. "ž愕ž愕...") or CJK characters in Vietnamese/English landmark names
    if re.search(r"[\u4e00-\u9fff\u3040-\u30ff]", s) or "ž" in s:
        return True
    if len(s) >= 6 and len(set(s)) <= 3:
        return True
    return False


# =========================================================
# VISION CLIENT
# =========================================================

class VisionClient:

    def __init__(self):

        self.base_url = settings.PINGGY_URL
        self.groq_api_key = settings.GROQ_API_KEY

    # =====================================================
    # FALLBACK / VERIFICATION VIA GROQ QWEN 3.8 27B VISION
    # =====================================================

    def analyze_with_groq_vision(self, image_bytes: bytes, prompt: str):
        if not self.groq_api_key:
            return None
        try:
            print("[VisionClient] Running high-accuracy Qwen 3.8 27B Vision verification...")
            b64_img = base64.b64encode(image_bytes).decode("utf-8")
            payload = {
                "model": "qwen/qwen3.8-27b",
                "messages": [
                    {
                        "role": "user",
                        "content": [
                            {"type": "text", "text": prompt},
                            {
                                "type": "image_url",
                                "image_url": {"url": f"data:image/jpeg;base64,{b64_img}"}
                            }
                        ]
                    }
                ],
                "temperature": 0.1,
                "max_tokens": 512,
                "response_format": {"type": "json_object"}
            }
            resp = requests.post(
                "https://api.groq.com/openai/v1/chat/completions",
                headers={
                    "Authorization": f"Bearer {self.groq_api_key}",
                    "Content-Type": "application/json"
                },
                json=payload,
                timeout=25
            )
            if resp.status_code == 200:
                content = resp.json()["choices"][0]["message"]["content"]
                parsed = json.loads(content)
                return {
                    "landmark_name": parsed.get("landmark_name", "Unknown"),
                    "city": parsed.get("city", "Unknown"),
                    "country": parsed.get("country", "Việt Nam"),
                    "reasoning_confidence": float(parsed.get("reasoning_confidence", 0.95) or 0.95),
                    "vision_reasoning": parsed.get("vision_reasoning", "Identified via Qwen Vision."),
                    "alternative_candidates": parsed.get("alternative_candidates", [])
                }
        except Exception as e:
            print(f"[VisionClient Groq Fallback Error]: {e}")
        return None

    # =====================================================
    # IMAGE -> STRUCTURED LANDMARK ANALYSIS
    # =====================================================

    def analyze_landmark(
        self,
        image: Image,
        user_query: str = ""
    ):

        # -------------------------------------------------
        # BUILD PROMPT
        # -------------------------------------------------

        prompt = f"""
{VISION_SYSTEM_PROMPT}

=========================================================
USER QUERY
=========================================================

{user_query}
"""

        # -------------------------------------------------
        # CONVERT IMAGE
        # -------------------------------------------------

        buffer = BytesIO()
        image.save(buffer, format="JPEG")
        image_bytes = buffer.getvalue()
        buffer.seek(0)

        # -------------------------------------------------
        # REMOTE INFERENCE (COLAB / MOCK VISION SERVER)
        # -------------------------------------------------
        result = None
        try:
            response = requests.post(
                f"{self.base_url}/predict_landmark",
                files={"file": image_bytes},
                data={"prompt": prompt},
                timeout=35
            )
            if response.status_code == 200:
                result = response.json()
            else:
                print(f"[VisionClient Warning] Vision Server returned HTTP {response.status_code}")
        except Exception as e:
            print(f"[VisionClient Warning] Primary Vision Server error: {e}")

        # -------------------------------------------------
        # PARSE & VALIDATE PRIMARY OUTPUT
        # -------------------------------------------------
        if result:
            landmark_name = result.get("landmark_name", "Unknown")
            city = result.get("city", "Unknown")
            country = result.get("country", "Vietnam")
            confidence = float(result.get("reasoning_confidence", 0.0) or 0.0)
            vision_reasoning = result.get("vision_reasoning", "No reasoning provided.")

            raw_output = result.get("raw_output", "")
            if landmark_name == "Unknown" and raw_output and not is_corrupted_output(raw_output):
                raw_clean = raw_output.strip()
                if "outside scope" in raw_clean.lower() or "out_of_domain" in raw_clean.lower():
                    landmark_name = "OUT_OF_DOMAIN"
                    vision_reasoning = raw_clean
                else:
                    prefix = "Based on the visual features, this is "
                    body = raw_clean
                    if prefix.lower() in body.lower():
                        idx = body.lower().find(prefix.lower()) + len(prefix)
                        body = body[idx:].strip()
                    body = body.rstrip(".")
                    parts = [p.strip() for p in body.split(",") if p.strip()]
                    if parts and not is_corrupted_output(parts[0]):
                        landmark_name = parts[0]
                        if len(parts) > 1 and (not city or city == "Unknown"):
                            city = parts[1]
                        if confidence <= 0.01:
                            confidence = 0.92
                        vision_reasoning = raw_clean

            # Check if Colab output is valid and not corrupted by FP16 NaN / hallucination
            if landmark_name == "OUT_OF_DOMAIN":
                return {
                    "landmark_name": "OUT_OF_DOMAIN",
                    "city": "",
                    "country": country,
                    "reasoning_confidence": confidence,
                    "vision_reasoning": vision_reasoning,
                    "alternative_candidates": []
                }

            if not is_corrupted_output(landmark_name) and confidence >= 0.75:
                return {
                    "landmark_name": landmark_name,
                    "city": city,
                    "country": country,
                    "reasoning_confidence": confidence,
                    "vision_reasoning": vision_reasoning,
                    "alternative_candidates": result.get("alternative_candidates", [])
                }
            else:
                print(
                    f"[VisionClient] Colab output uncertain or corrupted (landmark='{landmark_name}', conf={confidence:.2f}). "
                    f"Switching to Qwen 3.8 27B Vision verification..."
                )

        # -------------------------------------------------
        # SECONDARY VERIFICATION: GROQ QWEN 3.8 27B VISION
        # -------------------------------------------------
        groq_res = self.analyze_with_groq_vision(image_bytes, prompt)
        if groq_res and groq_res.get("landmark_name") != "Unknown":
            return groq_res

        return {
            "landmark_name": "Unknown",
            "reasoning_confidence": 0.0,
            "vision_reasoning": "Could not confidently identify landmark.",
            "alternative_candidates": [],
            "error": "VISION_SERVER_UNREACHABLE" if result is None else None
        }


# =========================================================
# GLOBAL SINGLETON
# =========================================================

vision_client = VisionClient()
