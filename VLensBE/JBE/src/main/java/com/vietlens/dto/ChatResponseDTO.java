package com.vietlens.dto;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * DTO trả về câu trả lời của AI Chatbot.
 */
@Data
@Builder
public class ChatResponseDTO {
    private UUID heritageId;
    private String heritageName;
    private String reply;

    public ChatResponseDTO() {
    }

    public ChatResponseDTO(UUID heritageId, String heritageName, String reply) {
        this.heritageId = heritageId;
        this.heritageName = heritageName;
        this.reply = reply;
    }
}
