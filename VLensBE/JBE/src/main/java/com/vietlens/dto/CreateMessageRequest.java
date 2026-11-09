package com.vietlens.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO yêu cầu gửi tin nhắn vào phiên trò chuyện.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class CreateMessageRequest {
    private String sender; // "user" hoặc "advisor"
    private String content;
    private String imageUrl;
    private Double confidenceScore;
}
