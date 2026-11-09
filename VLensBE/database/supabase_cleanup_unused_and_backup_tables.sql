-- ==============================================================================
-- VIETLENS BACKEND - SUPABASE CLEANUP SCRIPT
-- Dọn dẹp các bảng tàn dư không còn sử dụng và bảng backup tạm thời:
-- 1. heritage_info_backup_20261107 (bảng backup tạm thời trước deduplication)
-- 2. heritage_translations_backup_20261107 (bảng backup tạm thời trước deduplication)
-- 3. heritage_info_backup_pre_dedup (bảng backup tạm thời trước deduplication)
-- 4. heritage_translations_backup_pre_dedup (bảng backup tạm thời trước deduplication)
-- 5. ai_chat_history (bảng cũ đã được thay thế hoàn toàn bởi chat_sessions & chat_messages)
-- 6. event_tracking (bảng tàn dư không có entity hay chức năng nào sử dụng)
-- ==============================================================================

BEGIN;

-- 1. Xóa các bảng backup tạm thời
DROP TABLE IF EXISTS public.heritage_info_backup_20261107 CASCADE;
DROP TABLE IF EXISTS public.heritage_translations_backup_20261107 CASCADE;
DROP TABLE IF EXISTS public.heritage_info_backup_pre_dedup CASCADE;
DROP TABLE IF EXISTS public.heritage_translations_backup_pre_dedup CASCADE;

-- 2. Xóa các bảng tàn dư từ thiết kế cũ
DROP TABLE IF EXISTS public.ai_chat_history CASCADE;
DROP TABLE IF EXISTS public.event_tracking CASCADE;

COMMIT;

-- Xác nhận danh sách bảng hiện tại trong schema public
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public' 
ORDER BY table_name;
