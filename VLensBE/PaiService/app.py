import os
import io
import sys
import base64
import logging
import re
import unicodedata
import asyncio
from contextlib import asynccontextmanager
from typing import Optional, Any, Dict, List, cast

import math
from collections import Counter
from dotenv import load_dotenv
from fastapi import FastAPI, File, UploadFile, Query, HTTPException, Header, status
from fastapi.middleware.cors import CORSMiddleware
from starlette.responses import FileResponse
from pydantic import BaseModel, Field
from PIL import Image

import requests
import torch
import torch.nn.functional as F
import torchvision.transforms as T
import torchvision.models as models
from supabase import create_client, Client

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")
if hasattr(sys.stderr, "reconfigure"):
    sys.stderr.reconfigure(encoding="utf-8", errors="replace")

# Configure logging
logging.basicConfig(level=logging.INFO, format="%(asctime)s [%(levelname)s] %(message)s")
logger = logging.getLogger("VietLens-PaiService")

# ==============================================================================
# 1. LOAD CONFIGURATION FROM .ENV
# ==============================================================================
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ENV_PATH = os.path.join(BASE_DIR, ".env")
if not os.path.exists(ENV_PATH):
    ENV_PATH = os.path.join(os.path.dirname(BASE_DIR), ".env")

load_dotenv(ENV_PATH)

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")
MODEL_FILENAME = os.getenv("MODEL_PATH", "efficientnet_b0_central_vn_vqa.pth")
MODEL_PATH = os.path.join(BASE_DIR, MODEL_FILENAME)
FEATURE_BANK_PATH = os.path.join(BASE_DIR, "heritage_feature_bank.pt")

# Qwen2.5-VL Vision Server (Google Colab qua Ngrok Tunnel hoặc Local Mock Server)
QWEN_VISION_URL = os.getenv("QWEN_VISION_URL", "http://127.0.0.1:8080").rstrip("/")
QWEN_TIMEOUT_SECONDS = int(os.getenv("QWEN_TIMEOUT_SECONDS", "35"))

# Global references
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
model: Optional[torch.nn.Module] = None
model_weights_loaded: bool = False
supabase: Optional[Client] = None
feature_bank_embeddings: Optional[torch.Tensor] = None

if not SUPABASE_URL or not SUPABASE_KEY:
    logger.warning(f"⚠️ SUPABASE_URL or SUPABASE_KEY not found in {ENV_PATH}! Database lookups may be unavailable.")
else:
    logger.info(f"✅ Supabase configured from: {ENV_PATH}")
    try:
        supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
    except Exception as e:
        logger.warning(f"⚠️ Supabase client creation failed: {e}")

logger.info(f"🌐 Qwen Vision Server configured: {QWEN_VISION_URL} (Timeout: {QWEN_TIMEOUT_SECONDS}s)")
feature_bank_heritages: list = []

# In-memory database caches for ultra-fast response (<10ms)
heritage_cache: dict = {}
translation_cache: dict = {}
heritage_word_idf: dict = {}

# ==============================================================================
# 2. IMAGE PREPROCESSING PIPELINE (Cho legacy EfficientNet fallback)
# ==============================================================================
image_transform = T.Compose([
    T.Resize((224, 224)),
    T.ToTensor(),
    T.Normalize(
        mean=[0.485, 0.456, 0.406],
        std=[0.229, 0.224, 0.225]
    )
    
])

# ==============================================================================
# 3. LEGACY MODEL INITIALIZATION (Optional Fallback)
# ==============================================================================
def load_pytorch_model() -> Optional[torch.nn.Module]:
    """Loads EfficientNet-B0 pretrained model if available as a legacy fallback."""
    global model_weights_loaded
    import gc
    if not os.path.exists(MODEL_PATH):
        logger.info(f"ℹ️ Model checkpoint not found at: {MODEL_PATH}. Running primarily on Qwen2.5-VL.")
        return None

    try:
        logger.info(f"Loading legacy PyTorch checkpoint from: {MODEL_PATH}")
        net = models.efficientnet_b0(weights=None)
        net.classifier[1] = torch.nn.Linear(1280, 2785)
        try:
            state_dict = torch.load(MODEL_PATH, map_location=device, weights_only=False, mmap=True)
        except Exception:
            state_dict = torch.load(MODEL_PATH, map_location=device, weights_only=False)
        net.load_state_dict(state_dict)
        del state_dict
        gc.collect()
        model_weights_loaded = True
        net.to(device)
        net.eval()
        logger.info("✅ Legacy EfficientNet model weights loaded successfully.")
        return net
    except Exception as err:
        model_weights_loaded = False
        logger.warning(f"⚠️ Failed to load legacy model weights: {err}")
        return None


def extract_features(img_tensor: torch.Tensor) -> torch.Tensor:
    """Extracts 1280-d normalized visual feature embedding."""
    if model is None:
        raise RuntimeError("Model is not initialized.")
    with torch.no_grad():
        features = cast(Any, model).features(img_tensor)
        features = cast(Any, model).avgpool(features)
        features = torch.flatten(features, 1)
        return F.normalize(features, p=2, dim=1)


def refresh_database_cache():
    """Caches all heritage records and translations in memory."""
    global supabase, heritage_cache, translation_cache
    if not supabase:
        return

    try:
        logger.info("Refreshing in-memory Supabase caches...")
        # 1. Fetch heritage_info
        h_res = supabase.table("heritage_info").select(
            "id, name, province, category, address, description, image_url, latitude, longitude"
        ).execute()
        
        heritage_rows: List[Dict[str, Any]] = cast(List[Dict[str, Any]], h_res.data or [])
        heritage_cache = {row["id"]: row for row in heritage_rows}
        logger.info(f"✅ Cached {len(heritage_cache)} heritage records.")
        calculate_dynamic_idf()

        # 2. Fetch heritage_translations
        t_res = supabase.table("heritage_translations").select(
            "heritage_id, language_code, name, province, category, address, description"
        ).execute()

        translation_rows: List[Dict[str, Any]] = cast(List[Dict[str, Any]], t_res.data or [])
        translation_cache = {
            (row["heritage_id"], str(row.get("language_code", "")).lower()): row 
            for row in translation_rows
        }
        logger.info(f"✅ Cached {len(translation_cache)} translation records.")
    except Exception as e:
        logger.error(f"❌ Error refreshing database cache: {e}")


def calculate_dynamic_idf():
    """Tự động tính độ hiếm (IDF) của từng từ dựa trên cơ sở dữ liệu Supabase thực tế."""
    global heritage_word_idf
    if not heritage_cache:
        return
    N = len(heritage_cache)
    df = Counter()
    for h in heritage_cache.values():
        name = h.get("name") or ""
        norm = strip_accents_and_normalize(name)
        words = set(norm.split())
        for w in words:
            df[w] += 1
    heritage_word_idf = {w: math.log((N + 1) / (c + 1)) + 1.0 for w, c in df.items()}
    logger.info(f"✅ Đã tính toán độ hiếm TF-IDF động cho {len(heritage_word_idf)} từ vựng di sản.")


def load_feature_bank():
    """Loads pre-indexed visual feature embeddings if available."""
    global feature_bank_embeddings, feature_bank_heritages
    import gc
    if os.path.exists(FEATURE_BANK_PATH):
        logger.info(f"Loading feature bank from: {FEATURE_BANK_PATH}")
        try:
            bank = torch.load(FEATURE_BANK_PATH, map_location=device, weights_only=False, mmap=True)
        except Exception:
            bank = torch.load(FEATURE_BANK_PATH, map_location=device, weights_only=False)
        feature_bank_embeddings = bank["embeddings"].to(device)
        feature_bank_heritages = bank["heritages"]
        emb_shape = feature_bank_embeddings.shape if feature_bank_embeddings is not None else "Unknown"
        del bank
        gc.collect()
        logger.info(f"✅ Loaded feature bank with {len(feature_bank_heritages)} heritage entries. Shape: {emb_shape}")
    else:
        logger.info(f"ℹ️ Feature bank not present at {FEATURE_BANK_PATH}.")

# ==============================================================================
# 4. LIFESPAN CONTEXT MANAGER
# ==============================================================================
@asynccontextmanager
async def lifespan(app: FastAPI):
    global model, supabase
    logger.info("=== Starting VietLens Python AI Microservice (Qwen2.5-VL Powered) ===")
    
    # 1. Init Supabase client
    if SUPABASE_URL and SUPABASE_KEY:
        try:
            supabase = create_client(SUPABASE_URL, SUPABASE_KEY)
            refresh_database_cache()
        except Exception as e:
            logger.warning(f"⚠️ Supabase initialization failed: {e}")
        
    # 2. Init PyTorch legacy model (optional fallback)
    try:
        model = load_pytorch_model()
    except Exception as e:
        logger.info(f"PyTorch model not initialized: {e}")
    
    # 3. Load feature bank
    try:
        load_feature_bank()
    except Exception as e:
        logger.info(f"Feature bank not loaded: {e}")
    
    logger.info(f"=== VietLens AI Service is Ready (Target: {QWEN_VISION_URL}) ===")
    yield
    logger.info("=== Shutting Down VietLens AI Service ===")

# ==============================================================================
# 5. FASTAPI APPLICATION SETUP
# ==============================================================================
app = FastAPI(
    title="VietLens AI Vision Microservice",
    description="Cultural Heritage Recognition & Visual QA Engine using Qwen2.5-VL and Supabase",
    version="2.0.0",
    lifespan=lifespan
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==============================================================================
# 6. RESPONSE SCHEMAS
# ==============================================================================
class PredictResponse(BaseModel):
    success: bool
    recognized: bool = True
    rejection_reason: Optional[str] = None
    heritage_id: Optional[str] = None
    heritage_name: str
    confidence_score: float
    raw_similarity: float
    category: str = "Văn hóa & Di sản"
    province: str = "Việt Nam"
    address: Optional[str] = None
    description: Optional[str] = None
    image_url: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    language: str = "vi"
    vision_reasoning: Optional[str] = Field(None, description="Lý giải thị giác chi tiết từ mô hình Qwen-VL")
    alternative_candidates: List[str] = Field(default_factory=list, description="Danh sách địa danh thay thế nếu có")


class PredictBase64Request(BaseModel):
    image_base64: str = Field(..., max_length=10_000_000, description="Base64 encoded image string (max ~10MB)")
    lang: Optional[str] = "vi"

# ==============================================================================
# 7. QWEN2.5-VL SYSTEM PROMPT & REMOTE CLIENT
# ==============================================================================
VISION_SYSTEM_PROMPT = """
You are an expert Vietnamese cultural heritage and landmark recognition AI.

Your task is to analyze the provided image carefully using ONLY visible visual evidence.

You must identify:
- landmark name
- city
- country
- visual reasoning
- uncertainty level

=========================================================
CRITICAL RULES
=========================================================

1. DO NOT hallucinate landmarks.

2. PRIVACY & DOMAIN FILTERING (CRITICAL):
- If the image does NOT contain a landscape, historical site, monument, or recognized geographical landmark (e.g., if the image is a person's face, a selfie, an animal, an indoor object, a document, or anything unrelated), you MUST refuse to identify it.
- In this case, you MUST set `landmark_name` to exactly "OUT_OF_DOMAIN" and explain the reason in `vision_reasoning` (e.g. "This image contains personal identifiable information or is unrelated to landmarks.").
- Do NOT guess or return any alternative candidates for out-of-domain images.

3. ONLY identify landmarks that are visually supported by the image.

4. If uncertain:
- lower confidence
- explain ambiguity
- avoid guessing aggressively

5. Avoid overconfidence. Use confidence above 0.9 ONLY if the landmark is extremely recognizable.

6. Use visual evidence such as:
- architectural structure
- clock towers
- roofs
- bridges
- statues
- rivers
- surrounding environment
- signs or text
- cultural symbols

7. If multiple landmarks are possible, mention uncertainty in reasoning.

8. If the landmark cannot be confidently identified, return "Unknown".

=========================================================
ALTERNATIVE CANDIDATES RULES
=========================================================
- If the landmark is ambiguous or visually similar to multiple locations, provide possible alternatives.
- Include up to 3 possible landmark candidates.
- Candidates should ONLY be visually plausible.
- If confidence is high (> 0.90), alternative_candidates should usually be empty.
- Do NOT invent random landmarks.
- If no reasonable alternatives exist, return an empty list.

=========================================================
OUTPUT FORMAT
=========================================================
Return valid JSON ONLY.
{
    "landmark_name": "...",
    "city": "...",
    "country": "...",
    "reasoning_confidence": 0.0,
    "vision_reasoning": "...",
    "alternative_candidates": []
}

CONFIDENCE GUIDELINES:
0.90 - 1.00: Extremely certain, iconic landmark, strong visual evidence
0.70 - 0.89: Likely correct, good visual evidence
0.50 - 0.69: Moderate uncertainty, ambiguous features
0.00 - 0.49: Weak evidence, highly uncertain

IMPORTANT: Return JSON ONLY. Do not wrap with markdown code fences.
"""

def get_dynamic_vision_prompt() -> str:
    """Nạp danh mục tên di tích động từ Supabase vào prompt tham chiếu của Qwen-VL (Không hardcode)."""
    if heritage_cache:
        unique_names = list(dict.fromkeys(
            h.get("name", "").strip() for h in heritage_cache.values() if h.get("name")
        ))
        sample_names = ", ".join(unique_names[:80])
        return (
            VISION_SYSTEM_PROMPT
            + "\n\n=========================================================\n"
            + "KNOWN VIETNAMESE LANDMARK REFERENCE LIST (From Database):\n"
            + sample_names
            + "\nIf the image visually matches one of these known landmarks, use the exact name from this reference list.\n"
            + "========================================================="
        )
    return VISION_SYSTEM_PROMPT


def call_qwen_vision_server(image: Image.Image) -> dict:
    """Gửi ảnh đến máy chủ Qwen2.5-VL Vision (Colab Ngrok hoặc Local Mock Server)."""
    buffer = io.BytesIO()
    
    # Resize hợp lý để tối ưu thời gian upload qua tunnel mạng (tối đa cạnh dài 1024px)
    w, h = image.size
    max_dimension = 1024
    if max(w, h) > max_dimension:
        ratio = max_dimension / float(max(w, h))
        target_size = (int(w * ratio), int(h * ratio))
        optimized_image = image.resize(target_size, Image.Resampling.LANCZOS)
    else:
        optimized_image = image

    optimized_image.convert("RGB").save(buffer, format="JPEG", quality=85)
    buffer.seek(0)

    url = f"{QWEN_VISION_URL}/predict_landmark"
    logger.info(f"Calling Qwen Vision API at: {url}")

    try:
        response = requests.post(
            url,
            files={"file": ("photo_scan.jpg", buffer.getvalue(), "image/jpeg")},
            data={"prompt": get_dynamic_vision_prompt()},
            timeout=QWEN_TIMEOUT_SECONDS
        )
    except requests.exceptions.RequestException as e:
        logger.error(f"Cannot connect to Qwen Vision Server ({url}): {e}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Không thể kết nối đến máy chủ nhận diện Qwen Vision ({url}). Vui lòng đảm bảo Colab Ngrok đang hoạt động: {str(e)}"
        )

    if response.status_code != 200:
        logger.error(f"Qwen Vision Server returned HTTP {response.status_code}: {response.text}")
        raise HTTPException(
            status_code=status.HTTP_502_BAD_GATEWAY,
            detail=f"Máy chủ Vision trả về mã lỗi HTTP {response.status_code}."
        )

    try:
        resp_data = response.json()
        if isinstance(resp_data, str):
            clean_match = re.search(r"\{.*\}", resp_data, re.DOTALL)
            import json
            resp_data = json.loads(clean_match.group(0)) if clean_match else {}
        return resp_data
    except Exception as err:
        logger.error(f"Failed to parse JSON response from Qwen Vision Server: {err}")
        return {
            "landmark_name": "Unknown",
            "reasoning_confidence": 0.0,
            "vision_reasoning": "Không thể phân tích kết quả JSON từ mô hình thị giác.",
            "alternative_candidates": []
        }

# ==============================================================================
# 8. HERITAGE RESOLVER (Ánh xạ tên nhận diện vào Supabase Database)
# ==============================================================================
def strip_accents_and_normalize(text: str) -> str:
    """Loại bỏ dấu tiếng Việt và chuẩn hóa ký tự để so khớp linh hoạt."""
    if not text:
        return ""
    text = text.replace("đ", "d").replace("Đ", "d")
    nfkd = unicodedata.normalize("NFKD", text)
    only_ascii = "".join([c for c in nfkd if not unicodedata.combining(c)])
    cleaned = re.sub(r"[^\w\s]", " ", only_ascii).lower()
    return re.sub(r"\s+", " ", cleaned).strip()

HERITAGE_ALIASES: Dict[str, str] = {
    "ho guom": "ho hoan kiem",
    "hoan kiem": "ho hoan kiem",
    "thap rua": "ho hoan kiem",
    "dinh doc lap": "dinh doc lap",
    "hoi truong thong nhat": "dinh doc lap",
    "chua mot cot": "chua mot cot",
    "dien huu tu": "chua mot cot",
    "kinh thanh hue": "quan the di tich co do hue",
    "dai noi hue": "quan the di tich co do hue",
    "hoang thanh hue": "quan the di tich co do hue",
    "ngo mon": "quan the di tich co do hue",
    "chua thien mu": "chua thien mu",
    "linh mu": "chua thien mu",
    "van mieu": "van mieu - quoc tu giam",
    "quoc tu giam": "van mieu - quoc tu giam",
    "cau vang": "cau vang",
    "ba na": "cau vang",
    "chua tran quoc": "chua tran quoc",
    "nha tho duc ba": "nha tho duc ba",
    "nha tho lon": "nha tho lon ha noi",
    "thap ba ponagar": "thap ba po nagar",
    "ponagar": "thap ba po nagar",
    "thanh nha ho": "thanh nha ho",
    "pho co hoi an": "pho co hoi an",
    "chua cau": "chua cau",
    "thanh dia my son": "thanh dia my son",
    "my son": "thanh dia my son",
    "lang khai dinh": "lang khai dinh",
    "lang tu duc": "lang tu duc",
    "lang minh mang": "lang minh mang",
    "dia dao cu chi": "dia dao cu chi",
    "ben nha rong": "ben nha rong",
}

def resolve_heritage_match(predicted_name: str, city: Optional[str] = None) -> Optional[str]:
    """
    Ánh xạ tên nhận diện từ Qwen-VL vào heritage_id trong cơ sở dữ liệu Supabase
    bằng thuật toán Weighted Jaccard TF-IDF động (Không hardcode).
    """
    if not predicted_name or not heritage_cache:
        return None

    norm_target = strip_accents_and_normalize(predicted_name)
    if not norm_target:
        return None

    target_words = set(norm_target.split())
    if not target_words:
        return None

    # Tầng 1: So khớp trực tiếp (Exact Match)
    for h_id, h_data in heritage_cache.items():
        norm_h_name = strip_accents_and_normalize(h_data.get("name") or "")
        if norm_target == norm_h_name:
            return h_id

    # Tầng 2: So khớp Alias lịch sử
    alias_target = None
    for alias_key, target_kw in HERITAGE_ALIASES.items():
        if alias_key in norm_target:
            alias_target = target_kw
            break

    if alias_target:
        for h_id, h_data in heritage_cache.items():
            norm_h_name = strip_accents_and_normalize(h_data.get("name") or "")
            if alias_target == norm_h_name:
                return h_id

    # Tầng 3: So khớp chuỗi con có độ dài lớn (>= 12 ký tự)
    for h_id, h_data in heritage_cache.items():
        norm_h_name = strip_accents_and_normalize(h_data.get("name") or "")
        if (len(norm_target) >= 12 and norm_target in norm_h_name) or \
           (len(norm_h_name) >= 12 and norm_h_name in norm_target):
            return h_id

    # Tầng 4: So khớp tương đồng TF-IDF có trọng số từ hiếm động
    best_id = None
    best_score = 0.0
    q_weight = sum(heritage_word_idf.get(w, 4.5) for w in target_words)

    for h_id, h_data in heritage_cache.items():
        h_name = h_data.get("name") or ""
        norm_h_name = strip_accents_and_normalize(h_name)
        h_words = set(norm_h_name.split())
        if not h_words:
            continue

        intersection = target_words.intersection(h_words)
        if not intersection:
            continue

        matched_weight = sum(heritage_word_idf.get(w, 4.5) for w in intersection)
        h_weight = sum(heritage_word_idf.get(w, 4.5) for w in h_words)

        total_union_weight = q_weight + h_weight - matched_weight
        score = matched_weight / total_union_weight if total_union_weight > 0 else 0

        # Ưu tiên cộng điểm nếu cụm từ nằm trọn trong nhau
        if norm_h_name in norm_target or norm_target in norm_h_name:
            score += 0.25

        if score > best_score and score >= 0.40:
            best_score = score
            best_id = h_id

    return best_id

# ==============================================================================
# 9. INFERENCE CORE ENGINE
# ==============================================================================
def run_legacy_efficientnet_inference(image: Image.Image, lang_code: str) -> PredictResponse:
    """Fallback an toàn khi Qwen Server không phản hồi."""
    tensor = image_transform(image).unsqueeze(0).to(device)
    matched_heritage_id = None
    raw_similarity = 0.0

    if feature_bank_embeddings is not None and len(feature_bank_heritages) > 0:
        query_emb = extract_features(tensor)
        sims = torch.mm(query_emb, feature_bank_embeddings.T).squeeze(0)
        best_idx = int(torch.argmax(sims).item())
        raw_similarity = float(sims[best_idx].item())
        matched_h = feature_bank_heritages[best_idx]
        matched_heritage_id = matched_h.get("id") if isinstance(matched_h, dict) else None

    if raw_similarity < 0.60 or matched_heritage_id is None:
        fallback_msg = "Không nhận diện được di sản văn hóa" if lang_code == "vi" else "Heritage not recognized"
        return PredictResponse(
            success=True,
            recognized=False,
            rejection_reason="LOW_CONFIDENCE",
            heritage_id=None,
            heritage_name=fallback_msg,
            confidence_score=round(raw_similarity, 3),
            raw_similarity=round(raw_similarity, 3),
            category="Không xác định" if lang_code == "vi" else "Unknown",
            province="Việt Nam",
            address="",
            description=fallback_msg,
            image_url="",
            latitude=None,
            longitude=None,
            language=lang_code,
            vision_reasoning="Nhận diện bằng mô hình cục bộ với độ tin cậy thấp.",
            alternative_candidates=[]
        )

    base_info = heritage_cache.get(matched_heritage_id) or {}
    return PredictResponse(
        success=True,
        recognized=True,
        rejection_reason=None,
        heritage_id=str(matched_heritage_id),
        heritage_name=base_info.get("name") or "Di sản Việt Nam",
        confidence_score=round(raw_similarity, 3),
        raw_similarity=round(raw_similarity, 3),
        category=base_info.get("category") or "Văn hóa & Di sản",
        province=base_info.get("province") or "Việt Nam",
        address=base_info.get("address") or "",
        description=base_info.get("description") or "",
        image_url=base_info.get("image_url") or "",
        latitude=base_info.get("latitude"),
        longitude=base_info.get("longitude"),
        language=lang_code,
        vision_reasoning="Nhận diện thông qua mô hình trích xuất đặc trưng cục bộ.",
        alternative_candidates=[]
    )


def run_inference(image: Image.Image, lang: str = "vi") -> PredictResponse:
    """
    Core Pipeline nhận diện thị giác bằng Qwen2.5-VL VLM:
    1. Gửi ảnh đến Qwen Vision API (/predict_landmark).
    2. Kiểm tra từ chối Out-Of-Domain hoặc ảnh không rõ ràng.
    3. Ánh xạ tên địa danh vào Supabase PostgreSQL qua Heritage Resolver.
    4. Trả về PredictResponse với lý do thị giác (vision_reasoning) và ứng viên thay thế.
    """
    lang_code = (lang or "vi").strip().lower()
    if lang_code not in ("vi", "en"):
        lang_code = "vi"

    # 1. Gọi Qwen-VL Vision Server kèm fallback an toàn
    try:
        qwen_data = call_qwen_vision_server(image)
    except Exception as e:
        logger.warning(f"Qwen Vision Server error ({e}), chuyển sang Fallback EfficientNet...")
        if model is not None and model_weights_loaded and feature_bank_embeddings is not None:
            return run_legacy_efficientnet_inference(image, lang_code)
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"Máy chủ nhận diện Qwen Vision và Fallback đều không khả dụng: {str(e)}"
        )

    landmark_name = str(qwen_data.get("landmark_name") or "Unknown").strip()
    city = str(qwen_data.get("city") or "").strip()
    country = str(qwen_data.get("country") or "").strip()
    reasoning_confidence = float(qwen_data.get("reasoning_confidence", 0.0) or 0.0)
    vision_reasoning = str(qwen_data.get("vision_reasoning") or "").strip()
    alternative_candidates = qwen_data.get("alternative_candidates") or []

    # 2. Xử lý trường hợp ảnh ngoài miền (Out-Of-Domain) hoặc không rõ
    is_out_of_domain = (landmark_name.upper() == "OUT_OF_DOMAIN")
    is_unknown = (landmark_name.upper() == "UNKNOWN")
    is_low_confidence = (reasoning_confidence < 0.45)

    if is_out_of_domain or is_unknown or is_low_confidence:
        rejection_reason = "OUT_OF_DOMAIN" if is_out_of_domain else ("LOW_CONFIDENCE" if is_low_confidence else "UNKNOWN_LANDMARK")
        fallback_msg = (
            "Không nhận diện được công trình di tích hoặc danh lam thắng cảnh trong ảnh"
            if lang_code == "vi"
            else "No cultural heritage or landmark detected in this image"
        )
        return PredictResponse(
            success=True,
            recognized=False,
            rejection_reason=rejection_reason,
            heritage_id=None,
            heritage_name=fallback_msg,
            confidence_score=round(reasoning_confidence, 3),
            raw_similarity=round(reasoning_confidence, 3),
            category="Không xác định" if lang_code == "vi" else "Unknown",
            province=city or ("Việt Nam" if lang_code == "vi" else "Vietnam"),
            address="",
            description=vision_reasoning or fallback_msg,
            image_url="",
            latitude=None,
            longitude=None,
            language=lang_code,
            vision_reasoning=vision_reasoning or fallback_msg,
            alternative_candidates=alternative_candidates
        )

    # 3. Ánh xạ vào Supabase Database
    matched_heritage_id = resolve_heritage_match(landmark_name, city)
    base_info = heritage_cache.get(matched_heritage_id) if matched_heritage_id else None

    if base_info:
        # Khớp thành công với di sản trong cơ sở dữ liệu
        h_name = (base_info.get("name") or landmark_name).strip()
        h_category = (base_info.get("category") or "Văn hóa & Di sản").strip()
        h_province = (base_info.get("province") or city or "Việt Nam").strip()
        h_address = base_info.get("address") or ""
        h_description = base_info.get("description") or vision_reasoning
        h_image_url = base_info.get("image_url") or ""
        h_lat = base_info.get("latitude")
        h_lon = base_info.get("longitude")

        if lang_code == "en":
            trans = translation_cache.get((matched_heritage_id, "en")) or {}
            h_name = (trans.get("name") or h_name).strip()
            h_category = (trans.get("category") or h_category).strip()
            h_province = (trans.get("province") or h_province).strip()
            h_address = trans.get("address") or h_address
            h_description = trans.get("description") or h_description
    else:
        # Địa danh do Qwen nhận diện chính xác nhưng chưa nằm trong 172 bản ghi của Supabase
        h_name = landmark_name
        h_category = "Danh lam thắng cảnh" if lang_code == "vi" else "Scenic Landmark"
        h_province = city or ("Việt Nam" if lang_code == "vi" else "Vietnam")
        h_address = f"{h_name}, {h_province}"
        h_description = vision_reasoning
        h_image_url = ""
        h_lat = None
        h_lon = None

    return PredictResponse(
        success=True,
        recognized=True,
        rejection_reason=None,
        heritage_id=str(matched_heritage_id) if matched_heritage_id else None,
        heritage_name=h_name,
        confidence_score=round(reasoning_confidence, 3),
        raw_similarity=round(reasoning_confidence, 3),
        category=h_category,
        province=h_province,
        address=h_address,
        description=h_description,
        image_url=h_image_url,
        latitude=h_lat,
        longitude=h_lon,
        language=lang_code,
        vision_reasoning=vision_reasoning,
        alternative_candidates=alternative_candidates
    )

# ==============================================================================
# 10. ENDPOINTS
# ==============================================================================
@app.get("/")
def root():
    return {
        "service": "VietLens AI Vision Microservice",
        "version": "2.0.0",
        "vision_engine": "Qwen2.5-VL-3B-Instruct (Multimodal VLM)",
        "qwen_server_url": QWEN_VISION_URL,
        "status": "online",
        "docs_url": "/docs"
    }


@app.get("/api/v1/health")
def health_check():
    qwen_reachable = False
    try:
        r = requests.get(f"{QWEN_VISION_URL}/", timeout=3)
        qwen_reachable = (r.status_code == 200)
    except Exception:
        qwen_reachable = False

    return {
        "status": "healthy",
        "vision_engine": "Qwen2.5-VL",
        "qwen_server_url": QWEN_VISION_URL,
        "qwen_server_connected": qwen_reachable,
        "legacy_model_loaded": model is not None and model_weights_loaded,
        "cached_heritages": len(heritage_cache),
        "cached_translations": len(translation_cache)
    }


@app.post("/api/v1/predict", response_model=PredictResponse)
async def predict_heritage(
    file: UploadFile = File(..., description="Image file captured from mobile camera or gallery"),
    lang: str = Query("vi", pattern="^(vi|en)$", description="Language code ('vi' or 'en')")
):
    """Predict heritage from uploaded multipart/form-data image file using Qwen2.5-VL."""
    try:
        contents = await file.read()
        image = Image.open(io.BytesIO(contents)).convert("RGB")
    except Exception as e:
        logger.error(f"Error opening image: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid image file: {str(e)}"
        )

    return await asyncio.to_thread(run_inference, image, lang)


@app.post("/api/v1/predict-base64", response_model=PredictResponse)
async def predict_heritage_base64(req: PredictBase64Request):
    """Predict heritage from JSON payload with base64-encoded image string using Qwen2.5-VL."""
    try:
        raw_b64 = req.image_base64
        if "," in raw_b64:
            raw_b64 = raw_b64.split(",")[1]
        img_bytes = base64.b64decode(raw_b64)
        image = Image.open(io.BytesIO(img_bytes)).convert("RGB")
    except Exception as e:
        logger.error(f"Error decoding base64 image: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Invalid base64 image data: {str(e)}"
        )

    return await asyncio.to_thread(run_inference, image, req.lang or "vi")


@app.post("/api/v1/reload")
def reload_service(x_reload_token: Optional[str] = Header(None, alias="X-Reload-Token")):
    """Reloads database caches without server restart."""
    reload_secret = os.getenv("PAI_RELOAD_SECRET")
    if reload_secret and x_reload_token != reload_secret:
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Forbidden: Invalid or missing X-Reload-Token."
        )
    refresh_database_cache()
    load_feature_bank()
    return {
        "status": "reloaded",
        "cached_heritages": len(heritage_cache),
        "cached_translations": len(translation_cache)
    }


# ==============================================================================
# 11. VECTOR PMTILES STREAMING ENDPOINT (RFC 7233 HTTP 206 Partial Content)
# ==============================================================================
TILE_SEARCH_DIRS = [
    os.path.join(os.path.dirname(os.path.dirname(BASE_DIR)), "VLensFE", "assets", "maps"),
    os.path.join(os.path.dirname(os.path.dirname(os.path.dirname(BASE_DIR))), "VN_map_viewer", "data"),
    os.path.join("C:", os.sep, "Project_DV", "VN_map_viewer", "data"),
    os.path.join("C:", os.sep, "Project_DV", "Viet_Lens", "VLensFE", "assets", "maps"),
]

@app.api_route("/tiles/{tile_name}", methods=["GET", "HEAD"])
async def serve_pmtiles(tile_name: str):
    """
    Phục vụ trực tiếp tệp PMTiles (vietnam.pmtiles 318MB, danang.pmtiles 18MB)
    hỗ trợ đầy đủ chuẩn HTTP 206 Partial Content Range Requests (RFC 7233)
    cho MapLibre GL JS trên thiết bị di động.
    """
    safe_name = os.path.basename(tile_name)
    found_path = None
    for d in TILE_SEARCH_DIRS:
        candidate = os.path.join(d, safe_name)
        if os.path.isfile(candidate):
            found_path = candidate
            break

    if not found_path:
        logger.warning(f"Tile file '{safe_name}' not found in search dirs: {TILE_SEARCH_DIRS}")
        raise HTTPException(status_code=404, detail=f"Tile file '{safe_name}' not found.")

    return FileResponse(
        found_path,
        media_type="application/octet-stream",
        headers={
            "Access-Control-Allow-Origin": "*",
            "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
            "Access-Control-Allow-Headers": "Range, Content-Type, Accept",
            "Access-Control-Expose-Headers": "Content-Range, Content-Length, Accept-Ranges",
            "Accept-Ranges": "bytes",
        }
    )

# ==============================================================================
# 12. LOCAL ENTRYPOINT
# ==============================================================================
if __name__ == "__main__":
    import uvicorn
    host = os.getenv("PAI_SERVICE_HOST", "0.0.0.0")
    port = int(os.getenv("PAI_SERVICE_PORT", "8000"))
    logger.info(f"Starting uvicorn server on http://{host}:{port}")
    uvicorn.run("app:app", host=host, port=port, reload=False)
