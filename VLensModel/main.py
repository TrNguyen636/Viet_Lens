import os
import sys

os.environ["PYTHONIOENCODING"] = "utf-8"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
if BASE_DIR not in sys.path:
    sys.path.insert(0, BASE_DIR)

for stream in (sys.stdout, sys.stderr):
    if hasattr(stream, "reconfigure"):
        try:
            stream.reconfigure(encoding="utf-8", errors="replace")
        except Exception:
            pass
from fastapi import (
    FastAPI,
    UploadFile,
    File,
    Form,
    BackgroundTasks
)

from fastapi.middleware.cors import (
    CORSMiddleware
)

from PIL import Image

import io

from app.graph.workflow import (
    run_agent_workflow
)

from contextlib import asynccontextmanager
import time
import uuid
from app.config.db import init_db, log_request, log_feedback, get_dashboard_metrics, get_recent_logs
from app.image_utils import preprocess_image
from pydantic import BaseModel

# =========================================================
# FASTAPI APP
# =========================================================

@asynccontextmanager
async def lifespan(app: FastAPI):
    init_db()
    yield

app = FastAPI(
    title="Multimodal Travel Agent API",
    lifespan=lifespan
)

# =========================================================
# CORS
# =========================================================

app.add_middleware(

    CORSMiddleware,

    allow_origins=["*"],

    allow_credentials=True,

    allow_methods=["*"],

    allow_headers=["*"],
)

# =========================================================
# HEALTH CHECK
# =========================================================

@app.get("/")
def health_check():

    return {

        "status": "running",

        "message":
        "Multimodal Travel Agent API is active."
    }


# =========================================================
# MAIN PROCESS ENDPOINTS
# =========================================================

import base64
import re

class ProcessJsonRequest(BaseModel):
    prompt: str
    image_base64: str | None = None
    language: str | None = None

def resolve_target_language(prompt: str | None = "", language: str | None = None) -> str:
    lang = (language or "").strip().lower()
    if lang.startswith("ja"):
        return "ja"
    if lang.startswith("en"):
        return "en"
    if lang.startswith("vi"):
        return "vi"
    
    clean_prompt = prompt or ""
    # 0. Tự động phát hiện nếu người dùng nhập ký tự tiếng Nhật (Hiragana, Katakana, Kanji)
    if re.search(r'[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff]', clean_prompt):
        return "ja"
    
    # 1. Kiểm tra từ khóa yêu cầu tiếng Việt
    has_vi_intent = bool(re.search(
        r'\b(hãy|cho tôi|giới thiệu|ở đâu|là gì|như thế nào|bao nhiêu|bao lâu|lịch sử|kiến trúc|thông tin|di tích|thắng cảnh)\b',
        clean_prompt,
        re.IGNORECASE
    ))
    
    # 2. Kiểm tra từ khóa yêu cầu tiếng Anh
    has_en_intent = bool(re.search(
        r'\b(please|tell me|what|where|how|who|which|is it|identify|provide|summary|history|architecture|information|describe)\b',
        clean_prompt,
        re.IGNORECASE
    ))
    
    if has_en_intent and not has_vi_intent:
        return "en"
    if has_vi_intent and not has_en_intent:
        return "vi"
        
    has_vietnamese_diacritics = bool(re.search(r'[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ]', clean_prompt, re.IGNORECASE))
    if not has_vietnamese_diacritics and has_en_intent:
        return "en"
        
    return "vi"

def execute_workflow(prompt: str, pil_image: Image.Image | None, background_tasks: BackgroundTasks, start_time: float, req_id: str, language: str | None = None):
    target_lang = resolve_target_language(prompt, language)
    state = {
        "user_query": prompt,
        "image": pil_image,
        "language": target_lang
    }

    print("\n===== INITIAL STATE =====\n")
    print(state)

    try:
        result = run_agent_workflow(state)
    except Exception as e:
        print("\n===== WORKFLOW ERROR =====\n")
        print(str(e))
        
        latency_ms = (time.time() - start_time) * 1000
        background_tasks.add_task(log_request, req_id, "/process", latency_ms, "Unknown", 0.0, False)

        return {
            "success": False,
            "request_id": req_id,
            "answer": f"⚠️ Có lỗi xảy ra trong quá trình xử lý: {str(e)}",
            "landmark": "Unknown",
            "confidence": 0.0,
            "error": str(e)
        }

    tool_results = result.get("tool_results") or {}
    response = {
        "success": True,
        "request_id": req_id,
        "answer": result.get("final_answer", "No response generated."),
        "landmark": result.get("landmark_name", "Unknown"),
        "city": result.get("detected_city", "Unknown"),
        "country": result.get("detected_country", "Unknown"),
        "confidence": result.get("reasoning_confidence", 0.0),
        "vision_error": result.get("error") or result.get("validation_error") or None,
        "weather": tool_results.get("weather", {}),
        "nearby_places": tool_results.get("nearby_places_result", {})
    }

    print("\n===== FINAL API RESPONSE =====\n")
    print(response)
    
    latency_ms = (time.time() - start_time) * 1000
    background_tasks.add_task(log_request, req_id, "/process", latency_ms, response["landmark"], response["confidence"], True)

    return response

@app.post("/process-json")
async def process_json_endpoint(
    req: ProcessJsonRequest,
    background_tasks: BackgroundTasks
):
    start_time = time.time()
    req_id = str(uuid.uuid4())
    print("\n===================================")
    print(" NEW JSON REQUEST ")
    print("===================================\n")
    print(req.prompt)

    pil_image = None
    if req.image_base64:
        try:
            raw_b64 = req.image_base64
            if "," in raw_b64:
                raw_b64 = raw_b64.split(",")[1]
            image_bytes = base64.b64decode(raw_b64)
            pil_image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            pil_image = preprocess_image(pil_image)
        except Exception as e:
            print("\n===== IMAGE BASE64 DECODE ERROR =====\n", str(e))
            pil_image = None

    return execute_workflow(req.prompt, pil_image, background_tasks, start_time, req_id, req.language)

@app.post("/process")
async def process_request(
    background_tasks: BackgroundTasks,
    prompt: str = Form(...),
    image: UploadFile | None = File(None),
    image_base64: str | None = Form(None),
    language: str | None = Form(None)
):
    start_time = time.time()
    req_id = str(uuid.uuid4())
    print("\n===================================")
    print(" NEW FORM REQUEST ")
    print("===================================\n")
    print(prompt)

    pil_image = None
    try:
        if image is not None:
            print("\n===== IMAGE RECEIVED =====\n")
            print(image.filename)
            image_bytes = await image.read()
            pil_image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            pil_image = preprocess_image(pil_image)
        elif image_base64:
            print("\n===== IMAGE BASE64 RECEIVED =====\n")
            raw_b64 = image_base64
            if "," in raw_b64:
                raw_b64 = raw_b64.split(",")[1]
            image_bytes = base64.b64decode(raw_b64)
            pil_image = Image.open(io.BytesIO(image_bytes)).convert("RGB")
            pil_image = preprocess_image(pil_image)
    except Exception as e:
        print("\n===== IMAGE ERROR =====\n", str(e))
        pil_image = None

    return execute_workflow(prompt, pil_image, background_tasks, start_time, req_id, language)
# ADMIN DASHBOARD ENDPOINTS
# =========================================================

@app.get("/admin/metrics")
def get_metrics():
    """Returns aggregated metrics for the dashboard."""
    return get_dashboard_metrics()

@app.get("/admin/logs")
def get_logs(limit: int = 50):
    """Returns recent requests logs."""
    return get_recent_logs(limit)

class FeedbackRequest(BaseModel):
    request_id: str
    is_correct: bool
    actual_landmark: str | None = None

@app.post("/admin/feedback")
def submit_feedback(feedback: FeedbackRequest):
    """Submit user feedback for a specific request."""
    return log_feedback(feedback.request_id, feedback.is_correct, feedback.actual_landmark)



