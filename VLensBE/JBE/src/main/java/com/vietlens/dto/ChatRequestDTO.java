package com.vietlens.dto;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * DTO nhận dữ liệu yêu cầu trò chuyện cùng Trợ lý Di sản VietLens:
 * - heritageId: UUID của di sản đang xem
 * - message: Câu hỏi của người dùng
 * - sessionId: (Tùy chọn) ID phiên chat để tự động lưu vào lịch sử
 */
@Data
@Builder
public class ChatRequestDTO {
    private UUID heritageId;
    private String message;
    private UUID sessionId;

    public ChatRequestDTO() {
    }

    public ChatRequestDTO(UUID heritageId, String message) {
        this(heritageId, message, null);
    }

    public ChatRequestDTO(UUID heritageId, String message, UUID sessionId) {
        this.heritageId = heritageId;
        this.message = message;
        this.sessionId = sessionId;
    }
}
