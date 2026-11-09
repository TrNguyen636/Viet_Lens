import os
import shutil
import json
import csv

# Paths
TRAIN_DIR = 'Data For Training/Vietnam_Landmark_MQA_Dataset/landmark_vietnam_dataset_split/train'
CSV_INFO_PATH = 'Data For Training/data/processed/landmark_vietnam_info.csv'
ENRICHED_JSON = 'C:/Users/ADMIN/.gemini/antigravity/brain/3ecea76f-d6a9-4bcf-a602-c77340d36a5d/scratch/enriched_landmarks.json'

OUTPUT_DIR = 'VLensBE/database/landmark_images/landmarks'
MANIFEST_CSV = 'VLensBE/database/manifest_landmark_images.csv'
SUPABASE_BASE_URL = 'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/vqa-images/landmarks'

os.makedirs(OUTPUT_DIR, exist_ok=True)

# 1. Load CSV info
csv_map = {}
with open(CSV_INFO_PATH, 'r', encoding='utf-8-sig') as f:
    reader = csv.DictReader(f)
    for row in reader:
        csv_map[row['landmark_id'].strip()] = row['landmark_name'].strip()

# 2. Load enriched landmarks
with open(ENRICHED_JSON, 'r', encoding='utf-8') as f:
    landmarks = json.load(f)

manifest_rows = []
copied_count = 0
total_bytes = 0

for idx, lm in enumerate(landmarks, 1):
    name_vi = lm['name_vi']
    name_en = lm['name_en']
    raw_name = lm['raw_name'].strip()
    sample_img = lm.get('sample_image', '')
    folder_id = sample_img.split('/')[0] if '/' in sample_img else ''
    
    # Source image file
    src_filename = f"train_{folder_id}_1.jpg"
    src_path = os.path.join(TRAIN_DIR, folder_id, src_filename)
    
    # Destination image file
    dst_filename = f"train_{folder_id}_1.jpg"
    dst_path = os.path.join(OUTPUT_DIR, dst_filename)
    
    if os.path.exists(src_path):
        shutil.copy2(src_path, dst_path)
        file_size = os.path.getsize(dst_path)
        total_bytes += file_size
        copied_count += 1
        status = "OK"
    else:
        file_size = 0
        status = "FILE_NOT_FOUND"
        print(f"Warning: Missing file for {name_vi} ({folder_id}) at {src_path}")
    
    supabase_url = f"{SUPABASE_BASE_URL}/{dst_filename}"
    
    manifest_rows.append({
        "stt": idx,
        "landmark_id": folder_id,
        "name_vi": name_vi,
        "name_en": name_en,
        "raw_name": raw_name,
        "filename": dst_filename,
        "file_size_kb": round(file_size / 1024, 2),
        "status": status,
        "supabase_url": supabase_url
    })

# Write manifest CSV
with open(MANIFEST_CSV, 'w', encoding='utf-8-sig', newline='') as f:
    writer = csv.DictWriter(f, fieldnames=[
        "stt", "landmark_id", "name_vi", "name_en", "raw_name", 
        "filename", "file_size_kb", "status", "supabase_url"
    ])
    writer.writeheader()
    writer.writerows(manifest_rows)

print(f"Done! Copied {copied_count}/{len(landmarks)} landmark images.")
print(f"Total size: {total_bytes / (1024*1024):.2f} MB.")
print(f"Manifest written to: {MANIFEST_CSV}")
