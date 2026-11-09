package com.vietlens.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * DTO phản hồi thông tin phiên trò chuyện.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class SessionResponseDTO {
    private UUID id;
    private UUID userId;
    private UUID heritageId;
    private String heritageName;
    private String title;
    private String lastMessage;
    private OffsetDateTime createdAt;
    private OffsetDateTime updatedAt;
}
