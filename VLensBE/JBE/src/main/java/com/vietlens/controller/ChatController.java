package com.vietlens.controller;

import com.vietlens.dto.ChatRequestDTO;
import com.vietlens.dto.ChatResponseDTO;
import com.vietlens.dto.CreateMessageRequest;
import com.vietlens.security.SecurityUtils;
import com.vietlens.security.UserPrincipal;
import com.vietlens.service.ChatHistoryService;
import com.vietlens.service.GroqAiService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/ai")
public class ChatController {

    private final GroqAiService groqAiService;
    private final ChatHistoryService chatHistoryService;

    public ChatController(GroqAiService groqAiService, ChatHistoryService chatHistoryService) {
        this.groqAiService = groqAiService;
        this.chatHistoryService = chatHistoryService;
    }

    /**
     * API Trợ lý Di sản VietLens qua Groq AI:
     * POST /api/ai/chat
     * - Yêu cầu xác thực: Header 'Authorization: Bearer <token>'
     * - Request body: { "heritageId": "...", "message": "...", "sessionId": "..." (tùy chọn) }
     */
    @PostMapping("/chat")
    public ResponseEntity<ChatResponseDTO> chat(
            @RequestBody ChatRequestDTO request,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        ChatResponseDTO response = groqAiService.chatWithHeritageAi(request, lang);

        // Nếu request có sessionId và người dùng đã xác thực, tự động đồng bộ tin nhắn vào lịch sử
        if (request != null && request.getSessionId() != null) {
            UUID userId = (principal != null) ? principal.getId() : SecurityUtils.getCurrentUserId().orElse(null);
            if (userId != null) {
                try {
                    // 1. Lưu câu hỏi của User
                    chatHistoryService.addMessage(userId, request.getSessionId(),
                            CreateMessageRequest.builder()
                                    .sender("user")
                                    .content(request.getMessage())
                                    .build());

                    // 2. Lưu câu trả lời từ AI Advisor
                    if (response != null && response.getReply() != null) {
                        chatHistoryService.addMessage(userId, request.getSessionId(),
                                CreateMessageRequest.builder()
                                        .sender("advisor")
                                        .content(response.getReply())
                                        .build());
                    }
                } catch (Exception ex) {
                    log.warn("Không thể tự động lưu hội thoại vào session {}: {}", request.getSessionId(), ex.getMessage());
                }
            }
        }

        return ResponseEntity.ok(response);
    }
}
