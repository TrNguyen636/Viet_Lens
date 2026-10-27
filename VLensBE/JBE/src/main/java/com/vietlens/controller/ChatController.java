package com.vietlens.controller;

import com.vietlens.dto.ChatRequestDTO;
import com.vietlens.dto.ChatResponseDTO;
import com.vietlens.service.GroqAiService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai")
public class ChatController {

    private final GroqAiService groqAiService;

    public ChatController(GroqAiService groqAiService) {
        this.groqAiService = groqAiService;
    }

    /**
     * API Trợ lý Di sản VietLens qua Groq AI:
     * POST /api/ai/chat
     * - Yêu cầu xác thực: Header 'Authorization: Bearer <token>'
     * - Request body: { "heritageId": "...", "message": "..." }
     */
    @PostMapping("/chat")
    public ResponseEntity<ChatResponseDTO> chat(
            @RequestBody ChatRequestDTO request,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang
    ) {
        ChatResponseDTO response = groqAiService.chatWithHeritageAi(request, lang);
        return ResponseEntity.ok(response);
    }
}
