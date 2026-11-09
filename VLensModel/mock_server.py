"""
Mock Vision Server for local testing without GPU / Colab.
Run this script to simulate the Qwen-VL model:
    python src/vision_server/mock_server.py
"""

from fastapi import FastAPI, UploadFile, File, Form
import uvicorn

app = FastAPI(title="Mock Vision Server")

@app.get("/")
def root():
    return {"status": "running", "service": "Mock Vision Server"}

@app.post("/predict_landmark")
async def predict_landmark(
    file: UploadFile = File(...),
    prompt: str = Form("")
):
    filename = file.filename.lower() if file.filename else ""
    print(f"[Mock Server] Received image: {filename}")

    # Heuristic matching based on filename or fallback
    if "selfie" in filename or "face" in filename or "dog" in filename or "cat" in filename:
        return {
            "landmark_name": "OUT_OF_DOMAIN",
            "city": "",
            "country": "Việt Nam",
            "reasoning_confidence": 0.15,
            "vision_reasoning": "Hình ảnh chứa đối tượng không phải là danh lam thắng cảnh hoặc di tích văn hóa.",
            "alternative_candidates": []
        }
    elif "cot" in filename:
        name = "Chùa Một Cột"
        city = "Hà Nội"
    elif "doc_lap" in filename or "dinh" in filename:
        name = "Dinh Độc Lập"
        city = "Hồ Chí Minh"
    elif "cau_vang" in filename or "vang" in filename:
        name = "Cầu Vàng (Đà Nẵng)"
        city = "Đà Nẵng"
    elif "ho_guom" in filename or "turtle" in filename or "rua" in filename:
        name = "Hồ Hoàn Kiếm"
        city = "Hà Nội"
    elif "hue" in filename or "kinh_thanh" in filename:
        name = "Đại Nội Huế"
        city = "Thừa Thiên Huế"
    else:
        name = "Chùa Một Cột"
        city = "Hà Nội"

    return {
        "landmark_name": name,
        "city": city,
        "country": "Việt Nam",
        "reasoning_confidence": 0.94,
        "vision_reasoning": f"Nhận diện kiến trúc đặc trưng của {name} tại {city}.",
        "alternative_candidates": ["Chùa Trấn Quốc", "Văn Miếu - Quốc Tử Giám"]
    }

if __name__ == "__main__":
    import os
    port = int(os.getenv("MOCK_VISION_PORT", "8082"))
    print(f"[Mock Vision Server] Running on http://0.0.0.0:{port} (Avoiding port 8080 of Spring Boot)")
    uvicorn.run(app, host="0.0.0.0", port=port)