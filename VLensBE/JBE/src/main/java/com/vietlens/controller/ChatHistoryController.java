package com.vietlens.controller;

import com.vietlens.dto.CreateMessageRequest;
import com.vietlens.dto.CreateSessionRequest;
import com.vietlens.dto.MessageResponseDTO;
import com.vietlens.dto.SessionResponseDTO;
import com.vietlens.security.SecurityUtils;
import com.vietlens.service.ChatHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * REST API quản lý Lịch sử trò chuyện cá nhân của người dùng.
 * Yêu cầu: Xác thực thông qua Supabase Access Token (Bearer).
 */
@RestController
@RequestMapping("/api/chat")
@RequiredArgsConstructor
public class ChatHistoryController {

    private final ChatHistoryService chatHistoryService;

    private UUID getAuthenticatedUserId() {
        return SecurityUtils.getCurrentUserId()
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Vui lòng đăng nhập để sử dụng tính năng này!"));
    }

    /**
     * 1. Lấy toàn bộ danh sách phiên trò chuyện của user
     * GET /api/chat/sessions
     */
    @GetMapping("/sessions")
    public ResponseEntity<List<SessionResponseDTO>> getSessions() {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(chatHistoryService.getUserSessions(userId));
    }

    /**
     * 2. Tạo phiên trò chuyện mới
     * POST /api/chat/sessions
     */
    @PostMapping("/sessions")
    public ResponseEntity<SessionResponseDTO> createSession(@RequestBody(required = false) CreateSessionRequest request) {
        UUID userId = getAuthenticatedUserId();
        SessionResponseDTO session = chatHistoryService.createSession(userId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(session);
    }

    /**
     * 3. Lấy toàn bộ tin nhắn thuộc một phiên
     * GET /api/chat/sessions/{sessionId}/messages
     */
    @GetMapping("/sessions/{sessionId}/messages")
    public ResponseEntity<List<MessageResponseDTO>> getSessionMessages(@PathVariable UUID sessionId) {
        UUID userId = getAuthenticatedUserId();
        return ResponseEntity.ok(chatHistoryService.getSessionMessages(userId, sessionId));
    }

    /**
     * 4. Gửi/Lưu tin nhắn vào phiên trò chuyện
     * POST /api/chat/sessions/{sessionId}/messages
     */
    @PostMapping("/sessions/{sessionId}/messages")
    public ResponseEntity<MessageResponseDTO> addMessage(
            @PathVariable UUID sessionId,
            @RequestBody CreateMessageRequest request
    ) {
        UUID userId = getAuthenticatedUserId();
        MessageResponseDTO message = chatHistoryService.addMessage(userId, sessionId, request);
        return ResponseEntity.status(HttpStatus.CREATED).body(message);
    }

    /**
     * 5. Xóa một phiên trò chuyện
     * DELETE /api/chat/sessions/{sessionId}
     */
    @DeleteMapping("/sessions/{sessionId}")
    public ResponseEntity<Map<String, Object>> deleteSession(@PathVariable UUID sessionId) {
        UUID userId = getAuthenticatedUserId();
        chatHistoryService.deleteSession(userId, sessionId);
        return ResponseEntity.ok(Map.of("success", true, "message", "Đã xóa phiên trò chuyện thành công!"));
    }
}
