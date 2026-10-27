import os
import io
import sys
import urllib.parse
import requests
from dotenv import load_dotenv

# Set UTF-8 encoding safely on Windows
if sys.platform == "win32":
    try:
        sys.stdout.reconfigure(encoding="utf-8", errors="replace")
        sys.stderr.reconfigure(encoding="utf-8", errors="replace")
    except Exception:
        pass

import torch
import torch.nn.functional as F
import torchvision.transforms as T
import torchvision.models as models
from PIL import Image
from supabase import create_client, Client

# 1. Load configuration from .env file
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
ENV_PATH = os.path.join(BASE_DIR, ".env")
load_dotenv(ENV_PATH)

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY") or os.getenv("SUPABASE_ANON_KEY")

if not SUPABASE_URL or not SUPABASE_KEY:
    print(f"❌ Error: SUPABASE_URL or SUPABASE_KEY not found in {ENV_PATH}", flush=True)
    sys.exit(1)

print(f"✅ Loaded Supabase config from {ENV_PATH}", flush=True)
supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

# 2. Setup Device & Model
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
print(f"Using compute device: {device}", flush=True)

model_path = os.path.join(BASE_DIR, "efficientnet_b0_central_vn_vqa.pth")
print(f"Loading weights from: {model_path}", flush=True)

model = models.efficientnet_b0(weights=None)
model.classifier[1] = torch.nn.Linear(1280, 2785)
model.load_state_dict(torch.load(model_path, map_location=device, weights_only=False))
model.to(device)
model.eval()

# 3. Image Preprocessing Pipeline (ImageNet standard)
transform = T.Compose([
    T.Resize((224, 224)),
    T.ToTensor(),
    T.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225])
])

def extract_features(img: Image.Image) -> torch.Tensor:
    with torch.no_grad():
        tensor = transform(img).unsqueeze(0).to(device)
        features = model.features(tensor)
        features = model.avgpool(features)
        features = torch.flatten(features, 1)
        return F.normalize(features, p=2, dim=1).cpu()

# 4. Fetch all heritage records from Supabase
print("Fetching heritage list from Supabase...", flush=True)
res = supabase.table("heritage_info").select("id, name, province, category, image_url, latitude, longitude").execute()
heritages = res.data
print(f"Fetched {len(heritages)} heritage records.", flush=True)

# 5. Local image lookup paths
danang_dir = os.path.join(os.path.dirname(BASE_DIR), "DataSeeding", "heritage_image")
extracted_dir = os.path.join(os.path.dirname(BASE_DIR), "DataSeeding", "extracted_images")

danang_files = {}
if os.path.exists(danang_dir):
    danang_files = {f.lower(): os.path.join(danang_dir, f) for f in os.listdir(danang_dir)}

extracted_files = {}
if os.path.exists(extracted_dir):
    extracted_files = {f.lower(): os.path.join(extracted_dir, f) for f in os.listdir(extracted_dir)}

feature_list = []
valid_heritages = []

print("Extracting visual feature embeddings for all heritage sites...", flush=True)
session = requests.Session()

for idx, h in enumerate(heritages):
    url = h.get("image_url") or ""
    fname = urllib.parse.unquote(url.split("/")[-1]).lower()
    
    img = None
    # 1st try: local extracted images
    if fname in extracted_files:
        try:
            img = Image.open(extracted_files[fname]).convert("RGB")
        except Exception:
            img = None
            
    # 2nd try: local danang images
    if img is None and fname in danang_files:
        try:
            img = Image.open(danang_files[fname]).convert("RGB")
        except Exception:
            img = None

    # 3rd try: check fuzzy match in danang files
    if img is None and danang_files:
        clean_name = h["name"].lower().replace(" ", "")
        for df, dpath in danang_files.items():
            if clean_name[:5] in df.replace(" ", ""):
                try:
                    img = Image.open(dpath).convert("RGB")
                    break
                except Exception:
                    pass

    # 4th try: download from Supabase Storage image_url
    if img is None and url.startswith("http"):
        try:
            resp = session.get(url, timeout=4)
            if resp.status_code == 200:
                img = Image.open(io.BytesIO(resp.content)).convert("RGB")
        except Exception:
            pass

    if img is not None:
        emb = extract_features(img)
        feature_list.append(emb)
        valid_heritages.append(h)
        print(f"[{idx+1}/{len(heritages)}] ✅ Indexed: {h.get('name', 'Heritage')}", flush=True)
    else:
        print(f"[{idx+1}/{len(heritages)}] ⚠️ Skipped: {h.get('name', 'Heritage')}", flush=True)

if not feature_list:
    print("❌ Error: No features extracted.", flush=True)
    sys.exit(1)

all_embeddings = torch.cat(feature_list, dim=0) # Shape: (N, 1280)
print(f"Feature tensor shape: {all_embeddings.shape}", flush=True)

output_bank_path = os.path.join(BASE_DIR, "heritage_feature_bank.pt")
torch.save({
    "embeddings": all_embeddings,
    "heritages": valid_heritages
}, output_bank_path)

print(f"✅ Successfully created feature bank with {len(valid_heritages)} entries at: {output_bank_path}", flush=True)
