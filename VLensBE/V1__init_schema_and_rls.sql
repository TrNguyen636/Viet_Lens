-- ==============================================================================
-- VIETLENS PRODUCTION DATABASE MIGRATION SCRIPT
-- Schema Definition & Row Level Security (RLS) Configuration
-- ==============================================================================

-- Bật extension uuid-ossp và pgcrypto nếu chưa có
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- ------------------------------------------------------------------------------
-- 1. BẢNG HERITAGE_INFO (Di sản văn hóa & Địa danh lịch sử)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.heritage_info (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    province VARCHAR(100),
    address VARCHAR(255),
    description TEXT,
    image_url TEXT,
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION
);

-- ------------------------------------------------------------------------------
-- 2. BẢNG HERITAGE_TRANSLATIONS (Bản dịch đa ngôn ngữ cho di sản)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.heritage_translations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    heritage_id UUID NOT NULL REFERENCES public.heritage_info(id) ON DELETE CASCADE,
    language_code VARCHAR(10) NOT NULL,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    province VARCHAR(100),
    address VARCHAR(255),
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_heritage_language UNIQUE (heritage_id, language_code)
);

-- ------------------------------------------------------------------------------
-- 3. BẢNG USERS (Đồng bộ từ Supabase Auth)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.users (
    id UUID PRIMARY KEY, -- Khớp chính xác với auth.users.id
    email VARCHAR(255),
    full_name VARCHAR(255),
    avatar_url TEXT,
    role VARCHAR(50) NOT NULL DEFAULT 'USER',
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- ------------------------------------------------------------------------------
-- 4. BẢNG SAVED_PLACES (Địa danh yêu thích / Bookmark của người dùng)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.saved_places (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    heritage_id UUID NOT NULL REFERENCES public.heritage_info(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_saved_place_user_heritage UNIQUE (user_id, heritage_id)
);

-- ------------------------------------------------------------------------------
-- 5. BẢNG REVIEWS (Đánh giá và nhận xét của người dùng cho từng di sản)
-- ------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS public.reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
    heritage_id UUID NOT NULL REFERENCES public.heritage_info(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_review_user_heritage UNIQUE (user_id, heritage_id)
);

-- ==============================================================================
-- 6. TẠO INDEXES TỐI ƯU HIỆU NĂNG TRUY VẤN
-- ==============================================================================
CREATE INDEX IF NOT EXISTS idx_heritage_category ON public.heritage_info(category);
CREATE INDEX IF NOT EXISTS idx_heritage_province ON public.heritage_info(province);
CREATE INDEX IF NOT EXISTS idx_heritage_coords ON public.heritage_info(latitude, longitude);
CREATE INDEX IF NOT EXISTS idx_translations_heritage ON public.heritage_translations(heritage_id);
CREATE INDEX IF NOT EXISTS idx_saved_places_user ON public.saved_places(user_id);
CREATE INDEX IF NOT EXISTS idx_reviews_heritage ON public.reviews(heritage_id);
CREATE INDEX IF NOT EXISTS idx_reviews_user ON public.reviews(user_id);

-- ==============================================================================
-- 7. KÍCH HOẠT VÀ THIẾT LẬP ROW LEVEL SECURITY (RLS)
-- ==============================================================================

-- Bật RLS trên toàn bộ 5 bảng công khai
ALTER TABLE public.heritage_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.heritage_translations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.saved_places ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.reviews ENABLE ROW LEVEL SECURITY;

-- 7.1 Chính sách cho heritage_info: Mọi người (anon + authenticated) đều có quyền đọc
DROP POLICY IF EXISTS "Allow public read access on heritage_info" ON public.heritage_info;
CREATE POLICY "Allow public read access on heritage_info"
    ON public.heritage_info FOR SELECT
    USING (true);

-- 7.2 Chính sách cho heritage_translations: Mọi người đều có quyền đọc
DROP POLICY IF EXISTS "Allow public read access on heritage_translations" ON public.heritage_translations;
CREATE POLICY "Allow public read access on heritage_translations"
    ON public.heritage_translations FOR SELECT
    USING (true);

-- 7.3 Chính sách cho users:
-- - Cho phép người dùng xem thông tin của chính mình
DROP POLICY IF EXISTS "Users can read own profile" ON public.users;
CREATE POLICY "Users can read own profile"
    ON public.users FOR SELECT
    USING (auth.uid() = id);

-- - Cho phép người dùng cập nhật thông tin của chính mình
DROP POLICY IF EXISTS "Users can update own profile" ON public.users;
CREATE POLICY "Users can update own profile"
    ON public.users FOR UPDATE
    USING (auth.uid() = id);

-- 7.4 Chính sách cho saved_places:
-- - Người dùng chỉ đọc được bookmark của chính mình
DROP POLICY IF EXISTS "Users can read own saved places" ON public.saved_places;
CREATE POLICY "Users can read own saved places"
    ON public.saved_places FOR SELECT
    USING (auth.uid() = user_id);

-- - Người dùng chỉ thêm được bookmark của chính mình
DROP POLICY IF EXISTS "Users can insert own saved places" ON public.saved_places;
CREATE POLICY "Users can insert own saved places"
    ON public.saved_places FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- - Người dùng chỉ xóa được bookmark của chính mình
DROP POLICY IF EXISTS "Users can delete own saved places" ON public.saved_places;
CREATE POLICY "Users can delete own saved places"
    ON public.saved_places FOR DELETE
    USING (auth.uid() = user_id);

-- 7.5 Chính sách cho reviews:
-- - Mọi người đều xem được đánh giá (kể cả Guest)
DROP POLICY IF EXISTS "Public can read reviews" ON public.reviews;
CREATE POLICY "Public can read reviews"
    ON public.reviews FOR SELECT
    USING (true);

-- - Người dùng chỉ tạo được đánh giá mang ID của chính mình
DROP POLICY IF EXISTS "Users can insert own reviews" ON public.reviews;
CREATE POLICY "Users can insert own reviews"
    ON public.reviews FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- - Người dùng chỉ sửa/xóa đánh giá của chính mình
DROP POLICY IF EXISTS "Users can update own reviews" ON public.reviews;
CREATE POLICY "Users can update own reviews"
    ON public.reviews FOR UPDATE
    USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own reviews" ON public.reviews;
CREATE POLICY "Users can delete own reviews"
    ON public.reviews FOR DELETE
    USING (auth.uid() = user_id);
