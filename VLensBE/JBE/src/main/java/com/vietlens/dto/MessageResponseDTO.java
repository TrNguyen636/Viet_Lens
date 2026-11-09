package com.vietlens.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * DTO phản hồi chi tiết tin nhắn trong phiên.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MessageResponseDTO {
    private UUID id;
    private UUID sessionId;
    private String sender;
    private String content;
    private String imageUrl;
    private Double confidenceScore;
    private OffsetDateTime createdAt;
}
