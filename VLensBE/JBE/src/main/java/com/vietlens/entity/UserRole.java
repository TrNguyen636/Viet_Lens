package com.vietlens.entity;

/**
 * Phân quyền người dùng trong ứng dụng
 */
public enum UserRole {
    GUEST, // Khách vãng lai, tài khoản ẩn danh
    USER   // Người dùng chính thức đã đăng nhập qua Supabase
}
