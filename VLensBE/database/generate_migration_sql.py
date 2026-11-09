import csv

info_file = 'C:/Project_DV/Viet_Lens/Data For Training/CSV file DB/heritage_info_240_clean.csv'
trans_file = 'C:/Project_DV/Viet_Lens/Data For Training/CSV file DB/heritage_translations_240_clean.csv'

with open(info_file, 'r', encoding='utf-8-sig') as f:
    info_rows = list(csv.DictReader(f))

with open(trans_file, 'r', encoding='utf-8-sig') as f:
    trans_rows = list(csv.DictReader(f))

sql_lines = []
sql_lines.append("-- ==============================================================================")
sql_lines.append("-- VIETLENS MIGRATION: STANDARDIZE JAPANESE, IMAGES & SPLIT DRAGON-CARP / LOVE BRIDGE")
sql_lines.append("-- Mục đích:")
sql_lines.append("--   1. Sửa toàn bộ tên tiếng Nhật hiển thị chuẩn cho 34 địa danh (không còn tiếng Việt)")
sql_lines.append("--   2. Khắc phục triệt để các địa danh dùng chung ảnh train_49144_1.jpg bằng ảnh thật")
sql_lines.append("--   3. Tách Cầu Tình Yêu và Tượng Cá Chép Hóa Rồng thành 2 địa danh riêng biệt kề nhau")
sql_lines.append("-- ==============================================================================")
sql_lines.append("")
sql_lines.append("BEGIN;")
sql_lines.append("")

# 1. Update image_url, name, coords for existing heritage_info records
sql_lines.append("-- ------------------------------------------------------------------------------")
sql_lines.append("-- 1. CẬP NHẬT ẢNH THẬT RIÊNG BIỆT & THÔNG TIN CẦU TÌNH YÊU TRONG HERITAGE_INFO")
sql_lines.append("-- ------------------------------------------------------------------------------")

for r in info_rows:
    hid = r['id']
    if hid == 'a1000001-0000-4000-a000-000000000003':
        continue # will insert below
    
    # Check if we should emit an UPDATE
    name_esc = r['name'].replace("'", "''")
    addr_esc = r['address'].replace("'", "''")
    desc_esc = r['description'].replace("'", "''")
    img = r['image_url']
    lat = r['latitude']
    lng = r['longitude']
    
    sql_lines.append(f"""UPDATE heritage_info 
SET name = '{name_esc}',
    address = '{addr_esc}',
    latitude = {lat},
    longitude = {lng},
    image_url = '{img}',
    description = '{desc_esc}'
WHERE id = '{hid}';""")

# 2. Insert Cá Chép Hóa Rồng into heritage_info
sql_lines.append("")
sql_lines.append("-- ------------------------------------------------------------------------------")
sql_lines.append("-- 2. THÊM ĐỊA DANH MỚI: TƯỢNG CÁ CHÉP HÓA RỒNG ĐÀ NẴNG")
sql_lines.append("-- ------------------------------------------------------------------------------")
ca_chep = [r for r in info_rows if r['id'] == 'a1000001-0000-4000-a000-000000000003'][0]
sql_lines.append(f"""INSERT INTO heritage_info (id, name, category, province, province_id, address, latitude, longitude, image_url, description)
VALUES (
    '{ca_chep['id']}',
    '{ca_chep['name'].replace("'", "''")}',
    '{ca_chep['category'].replace("'", "''")}',
    '{ca_chep['province'].replace("'", "''")}',
    '{ca_chep['province_id']}',
    '{ca_chep['address'].replace("'", "''")}',
    {ca_chep['latitude']},
    {ca_chep['longitude']},
    '{ca_chep['image_url']}',
    '{ca_chep['description'].replace("'", "''")}'
)
ON CONFLICT (id) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    latitude = EXCLUDED.latitude,
    longitude = EXCLUDED.longitude,
    image_url = EXCLUDED.image_url,
    description = EXCLUDED.description;
""")

# 3. Update heritage_translations
sql_lines.append("-- ------------------------------------------------------------------------------")
sql_lines.append("-- 3. CẬP NHẬT VÀ BỔ SUNG BẢN DỊCH ĐA NGÔN NGỮ (HERITAGE_TRANSLATIONS)")
sql_lines.append("-- ------------------------------------------------------------------------------")

for r in trans_rows:
    hid = r['heritage_id']
    lang = r['language_code']
    name_esc = r['name'].replace("'", "''")
    cat_esc = r['category'].replace("'", "''")
    prov_esc = r['province'].replace("'", "''")
    addr_esc = r['address'].replace("'", "''")
    desc_esc = r['description'].replace("'", "''")
    
    if hid == 'a1000001-0000-4000-a000-000000000003':
        # Insert
        sql_lines.append(f"""INSERT INTO heritage_translations (heritage_id, language_code, name, category, province, address, description)
VALUES ('{hid}', '{lang}', '{name_esc}', '{cat_esc}', '{prov_esc}', '{addr_esc}', '{desc_esc}')
ON CONFLICT (heritage_id, language_code) DO UPDATE SET
    name = EXCLUDED.name,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    description = EXCLUDED.description;""")
    else:
        # Update
        sql_lines.append(f"""UPDATE heritage_translations
SET name = '{name_esc}',
    address = '{addr_esc}',
    description = '{desc_esc}'
WHERE heritage_id = '{hid}' AND language_code = '{lang}';""")

sql_lines.append("")
sql_lines.append("-- ------------------------------------------------------------------------------")
sql_lines.append("-- 4. KIỂM TOÁN TỰ ĐỘNG SAU KHI CHẠY (VERIFICATION)")
sql_lines.append("-- ------------------------------------------------------------------------------")
sql_lines.append("-- 4.1. Tổng số địa danh chuẩn (Kỳ vọng: 240)")
sql_lines.append("SELECT count(*) AS total_heritage_240 FROM heritage_info;")
sql_lines.append("")
sql_lines.append("-- 4.2. Tổng số bản dịch chuẩn (Kỳ vọng: 720 = 240 x 3)")
sql_lines.append("SELECT count(*) AS total_translations_720 FROM heritage_translations;")
sql_lines.append("")
sql_lines.append("-- 4.3. Kiểm tra Cầu Tình Yêu và Tượng Cá Chép Hóa Rồng (Kỳ vọng: 2 dòng riêng biệt)")
sql_lines.append("SELECT id, name, latitude, longitude, image_url FROM heritage_info WHERE id IN ('63baaf3f-8e8d-4d3d-9475-0475978adbb9', 'a1000001-0000-4000-a000-000000000003');")
sql_lines.append("")
sql_lines.append("-- 4.4. Đảm bảo ảnh chùa ngói đỏ cũ train_49144_1.jpg không còn được dùng cho các địa danh Đà Nẵng / du lịch")
sql_lines.append("SELECT count(*) AS count_train_49144 FROM heritage_info WHERE image_url ILIKE '%train_49144_1.jpg%';")
sql_lines.append("")
sql_lines.append("COMMIT;")

sql_content = "\n".join(sql_lines)
out_sql = 'C:/Project_DV/Viet_Lens/VLensBE/database/supabase_standardize_japanese_images_and_split.sql'
with open(out_sql, 'w', encoding='utf-8') as f:
    f.write(sql_content)

print(f"SQL file generated at {out_sql} ({len(sql_lines)} lines).")
