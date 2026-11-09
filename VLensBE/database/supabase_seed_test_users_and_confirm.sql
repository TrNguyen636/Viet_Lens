-- ==============================================================================
-- VIETLENS AUTH - SEED TEST USERS & AUTO-CONFIRM
-- Script tự động kích hoạt tài khoản hiện có và tạo thêm người dùng thử nghiệm.
-- Mọi tài khoản đều có:
--   - email_confirmed_at = now() (Không bị lỗi "Email not confirmed")
--   - Mật khẩu mặc định: VietLens@2026
--   - Role trong public.users: USER
-- ==============================================================================

BEGIN;

-- 1. KÍCH HOẠT TÀI KHOẢN CỦA NGUYENVU@VIETLENS.COM
UPDATE auth.users 
SET email_confirmed_at = COALESCE(email_confirmed_at, now()), 
    confirmed_at = COALESCE(confirmed_at, now()),
    raw_user_meta_data = COALESCE(raw_user_meta_data, '{}'::jsonb) || '{"email_verified": true, "full_name": "Vũ Trường Nguyên"}'::jsonb
WHERE email = 'nguyenvu@vietlens.com';

UPDATE auth.identities
SET identity_data = COALESCE(identity_data, '{}'::jsonb) || '{"email_verified": true, "full_name": "Vũ Trường Nguyên"}'::jsonb
WHERE email = 'nguyenvu@vietlens.com';

UPDATE public.users
SET full_name = 'Vũ Trường Nguyên',
    role = 'USER',
    updated_at = now()
WHERE email = 'nguyenvu@vietlens.com';


-- 2. TẠO TÀI KHOẢN DU KHÁCH VIỆT NAM (traveler@vietlens.com / VietLens@2026)
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    confirmed_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    'a1000000-0000-0000-0000-000000000001',
    'authenticated',
    'authenticated',
    'traveler@vietlens.com',
    extensions.crypt('VietLens@2026', extensions.gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Nguyễn Văn Du Khách", "email_verified": true}'::jsonb,
    now(),
    now()
) ON CONFLICT (id) DO UPDATE SET
    encrypted_password = extensions.crypt('VietLens@2026', extensions.gen_salt('bf')),
    email_confirmed_at = now(),
    confirmed_at = now(),
    raw_user_meta_data = '{"full_name": "Nguyễn Văn Du Khách", "email_verified": true}'::jsonb;

INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at,
    email
) VALUES (
    gen_random_uuid(),
    'a1000000-0000-0000-0000-000000000001',
    jsonb_build_object('sub', 'a1000000-0000-0000-0000-000000000001', 'email', 'traveler@vietlens.com', 'email_verified', true, 'full_name', 'Nguyễn Văn Du Khách'),
    'email',
    'a1000000-0000-0000-0000-000000000001',
    now(),
    now(),
    now(),
    'traveler@vietlens.com'
) ON CONFLICT (provider, provider_id) DO NOTHING;

INSERT INTO public.users (id, email, full_name, role, created_at, updated_at)
VALUES (
    'a1000000-0000-0000-0000-000000000001',
    'traveler@vietlens.com',
    'Nguyễn Văn Du Khách',
    'USER',
    now(),
    now()
) ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email, 
    full_name = EXCLUDED.full_name;


-- 3. TẠO TÀI KHOẢN DU KHÁCH NHẬT BẢN (japan.tourist@vietlens.com / VietLens@2026)
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    confirmed_at,
    last_sign_in_at,
    raw_app_meta_data,
    raw_user_meta_data,
    created_at,
    updated_at
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    'a1000000-0000-0000-0000-000000000002',
    'authenticated',
    'authenticated',
    'japan.tourist@vietlens.com',
    extensions.crypt('VietLens@2026', extensions.gen_salt('bf')),
    now(),
    now(),
    now(),
    '{"provider": "email", "providers": ["email"]}'::jsonb,
    '{"full_name": "Tanaka Kenji (田中 健二)", "email_verified": true}'::jsonb,
    now(),
    now()
) ON CONFLICT (id) DO UPDATE SET
    encrypted_password = extensions.crypt('VietLens@2026', extensions.gen_salt('bf')),
    email_confirmed_at = now(),
    confirmed_at = now(),
    raw_user_meta_data = '{"full_name": "Tanaka Kenji (田中 健二)", "email_verified": true}'::jsonb;

INSERT INTO auth.identities (
    id,
    user_id,
    identity_data,
    provider,
    provider_id,
    last_sign_in_at,
    created_at,
    updated_at,
    email
) VALUES (
    gen_random_uuid(),
    'a1000000-0000-0000-0000-000000000002',
    jsonb_build_object('sub', 'a1000000-0000-0000-0000-000000000002', 'email', 'japan.tourist@vietlens.com', 'email_verified', true, 'full_name', 'Tanaka Kenji (田中 健二)'),
    'email',
    'a1000000-0000-0000-0000-000000000002',
    now(),
    now(),
    now(),
    'japan.tourist@vietlens.com'
) ON CONFLICT (provider, provider_id) DO NOTHING;

INSERT INTO public.users (id, email, full_name, role, created_at, updated_at)
VALUES (
    'a1000000-0000-0000-0000-000000000002',
    'japan.tourist@vietlens.com',
    'Tanaka Kenji (田中 健二)',
    'USER',
    now(),
    now()
) ON CONFLICT (id) DO UPDATE SET 
    email = EXCLUDED.email, 
    full_name = EXCLUDED.full_name;

COMMIT;

-- 4. KIỂM TRA LẠI DANH SÁCH USER
SELECT u.id, u.email, u.email_confirmed_at, pu.full_name, pu.role
FROM auth.users u
LEFT JOIN public.users pu ON pu.id = u.id
ORDER BY u.created_at ASC;
