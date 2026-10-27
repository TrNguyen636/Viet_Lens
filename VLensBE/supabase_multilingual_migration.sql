-- ==============================================================================
-- VIETLENS: MIGRATION SCRIPT ĐA NGÔN NGỮ (I18N) & ROW LEVEL SECURITY (RLS)
-- Mục đích:
--   1. Tạo bảng vệ tinh `heritage_translations` lưu trữ bản dịch đa ngôn ngữ.
--   2. Đánh index hiệu năng cao (Composite B-Tree).
--   3. Cấu hình Row Level Security (RLS) chuẩn Supabase Best Practices (Public Read, Admin Write).
--   4. Tự động đồng bộ toàn bộ dữ liệu Tiếng Việt ('vi') hiện có từ `heritage_info`.
--   5. Nạp dữ liệu mẫu Tiếng Anh ('en') cho các di sản nổi bật.
-- ==============================================================================

-- 1. TẠO BẢNG HERITAGE_TRANSLATIONS
CREATE TABLE IF NOT EXISTS heritage_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    heritage_id UUID NOT NULL REFERENCES heritage_info(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL, -- 'vi' hoặc 'en'
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100),
    province VARCHAR(100),
    address VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),

    -- Đảm bảo mỗi di sản chỉ có duy nhất 1 bản ghi cho mỗi mã ngôn ngữ
    CONSTRAINT uq_heritage_language UNIQUE (heritage_id, language_code)
);

-- 2. TẠO INDEXES TỐI ƯU HIỆU NĂNG QUERY
-- Index chính để JOIN giữa heritage_info và heritage_translations với language_code
CREATE INDEX IF NOT EXISTS idx_heritage_trans_lookup 
ON heritage_translations (heritage_id, language_code);

-- Index lọc nhanh theo ngôn ngữ
CREATE INDEX IF NOT EXISTS idx_heritage_trans_lang 
ON heritage_translations (language_code);

-- 3. KÍCH HOẠT VÀ CẤU HÌNH ROW LEVEL SECURITY (RLS)
ALTER TABLE heritage_translations ENABLE ROW LEVEL SECURITY;

-- 3.1. Policy Đọc Công Khai (Public Read)
-- Cho phép cả khách vãng lai (anon) và người dùng đã đăng nhập (authenticated) xem bản dịch di sản
DROP POLICY IF EXISTS "Cho phép đọc công khai heritage_translations" ON heritage_translations;
CREATE POLICY "Cho phép đọc công khai heritage_translations"
ON heritage_translations
FOR SELECT
TO anon, authenticated
USING (true);

-- 3.2. Policy Ghi / Sửa / Xóa (Admin Write Only)
-- Chỉ những tài khoản có vai trò 'ADMIN' trong bảng users mới có quyền thao tác dữ liệu
-- Sử dụng (SELECT auth.uid()) để Postgres cache giá trị thay vì gọi lại hàm ở mỗi dòng
DROP POLICY IF EXISTS "Chỉ admin mới có quyền chỉnh sửa heritage_translations" ON heritage_translations;
CREATE POLICY "Chỉ admin mới có quyền chỉnh sửa heritage_translations"
ON heritage_translations
FOR ALL
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = (SELECT auth.uid())
      AND users.role = 'ADMIN'
  )
)
WITH CHECK (
  EXISTS (
    SELECT 1 FROM users
    WHERE users.id = (SELECT auth.uid())
      AND users.role = 'ADMIN'
  )
);

-- 4. TỰ ĐỘNG MIGRATE DỮ LIỆU TIẾNG VIỆT ('vi') TỪ BẢNG HERITAGE_INFO HIỆN TẠI
INSERT INTO heritage_translations (heritage_id, language_code, name, description, category, province, address)
SELECT 
    id, 
    'vi', 
    name, 
    description, 
    category, 
    province, 
    address
FROM heritage_info
ON CONFLICT (heritage_id, language_code) 
DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    category = EXCLUDED.category,
    province = EXCLUDED.province,
    address = EXCLUDED.address,
    updated_at = NOW();

-- 5. NẠP DỮ LIỆU BẢN DỊCH TIẾNG ANH ('en') MẪU CHO CÁC DI SẢN TIÊU BIỂU
-- Bản dịch cho Dinh Độc Lập
INSERT INTO heritage_translations (heritage_id, language_code, name, description, category, province, address)
SELECT 
    id,
    'en',
    'Independence Palace (Reunification Hall)',
    'Independence Palace is a special national historic monument located in the heart of District 1, Ho Chi Minh City. Designed by renowned architect Ngo Viet Thu, the structure harmonizes traditional Eastern philosophy with modern architecture. It witnessed a historic moment at noon on April 30, 1975, when liberation army tanks broke through the iron gates, marking the complete reunification of Vietnam.',
    'Historical Relic',
    'Ho Chi Minh City',
    '135 Nam Ky Khoi Nghia Street, Ben Thanh Ward, District 1, Ho Chi Minh City'
FROM heritage_info
WHERE name ILIKE '%Dinh Độc Lập%' OR name ILIKE '%Dinh Doc Lap%'
ON CONFLICT (heritage_id, language_code) DO NOTHING;

-- Bản dịch cho Biệt Thự Pháp Cổ Hà Nội
INSERT INTO heritage_translations (heritage_id, language_code, name, description, category, province, address)
SELECT 
    id,
    'en',
    'Ancient French Villas of Hanoi',
    'French colonial villas in Hanoi were built from the late 19th to early 20th centuries, blending Neoclassical and Art Deco architectural styles with the local tropical monsoon climate. Featuring elegant arched roofs, characteristic yellow ochre walls, ornate iron fences, and verdant gardens, these architectural jewels give Hanoi its distinct, timeless charm.',
    'Architecture & Heritage',
    'Hanoi',
    'Ba Dinh & Hoan Kiem Districts, Hanoi Capital City'
FROM heritage_info
WHERE name ILIKE '%Biệt Thự Pháp Cổ%' OR name ILIKE '%Biet Thu Phap Co%'
ON CONFLICT (heritage_id, language_code) DO NOTHING;

-- Bản dịch cho Đàn Cò (Đàn Nhị)
INSERT INTO heritage_translations (heritage_id, language_code, name, description, category, province, address)
SELECT 
    id,
    'en',
    'Dan Co (Vietnamese Two-Stringed Fiddle)',
    'Dan Co, also known as Dan Nhi, is a traditional bowed string instrument playing a pivotal role in Vietnamese folk music. Simple in structure with a slender neck, a python skin-covered sound box, and two silk strings, the instrument produces an expressive, soulful sound echoing the heart of Vietnamese people, frequently featured in Nha Nhac Royal Court Music, Cheo theater, Don Ca Tai Tu, and Xam singing.',
    'Culture & Folk Art',
    'Hanoi',
    'Vietnam National Academy of Music, Hanoi Capital City'
FROM heritage_info
WHERE name ILIKE '%Đàn Cò%' OR name ILIKE '%Dan Co%' OR name ILIKE '%Đàn Nhị%'
ON CONFLICT (heritage_id, language_code) DO NOTHING;

-- Bản dịch cho Hội Cờ Người Dân Gian
INSERT INTO heritage_translations (heritage_id, language_code, name, description, category, province, address)
SELECT 
    id,
    'en',
    'Traditional Human Chess Festival',
    'Human chess is an intellectual and cultural sport featured in traditional spring festivals throughout northern Vietnam, especially in the Kinh Bac cultural region. A massive chessboard is laid out in the village communal courtyard where elegant young men and women in traditional attire serve as live chess pieces, moving to the rhythmic beats of drums and commands of master elders.',
    'Traditional Festival',
    'Bac Ninh',
    'Dinh Bang Village, Tu Son City, Bac Ninh Province'
FROM heritage_info
WHERE name ILIKE '%Cờ Người%' OR name ILIKE '%Co Nguoi%'
ON CONFLICT (heritage_id, language_code) DO NOTHING;
