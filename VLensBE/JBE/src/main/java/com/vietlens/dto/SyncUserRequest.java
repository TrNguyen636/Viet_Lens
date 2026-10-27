package com.vietlens.dto;

import com.vietlens.entity.UserRole;
import lombok.Builder;
import lombok.Data;

/**
 * DTO nhận dữ liệu đồng bộ người dùng từ Frontend (tùy chọn bổ sung ngoài token).
 */
@Data
@Builder
public class SyncUserRequest {
    private String token;     // Token Supabase (nếu Frontend gửi trong body thay vì Authorization header)
    private String fullName;  // Họ tên người dùng muốn tùy chỉnh
    private String avatarUrl; // URL ảnh đại diện
    private UserRole role;    // Phân quyền (GUEST hoặc USER)

    public SyncUserRequest() {
    }

    public SyncUserRequest(String token, String fullName, String avatarUrl, UserRole role) {
        this.token = token;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
        this.role = role;
    }
}
