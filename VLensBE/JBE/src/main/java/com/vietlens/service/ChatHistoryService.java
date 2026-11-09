package com.vietlens.service;

import com.vietlens.dto.CreateMessageRequest;
import com.vietlens.dto.CreateSessionRequest;
import com.vietlens.dto.MessageResponseDTO;
import com.vietlens.dto.SessionResponseDTO;
import com.vietlens.entity.ChatMessage;
import com.vietlens.entity.ChatSession;
import com.vietlens.entity.HeritageInfo;
import com.vietlens.repository.ChatMessageRepository;
import com.vietlens.repository.ChatSessionRepository;
import com.vietlens.repository.HeritageInfoRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.time.OffsetDateTime;
import java.util.*;

@Slf4j
@Service
@RequiredArgsConstructor
public class ChatHistoryService {

    private final ChatSessionRepository chatSessionRepository;
    private final ChatMessageRepository chatMessageRepository;
    private final HeritageInfoRepository heritageInfoRepository;

    /**
     * Lấy toàn bộ danh sách phiên trò chuyện của người dùng hiện tại,
     * sắp xếp theo thời gian cập nhật gần nhất.
     */
    @Transactional(readOnly = true)
    public List<SessionResponseDTO> getUserSessions(UUID userId) {
        if (userId == null) {
            return Collections.emptyList();
        }

        List<ChatSession> sessions = chatSessionRepository.findByUserIdOrderByUpdatedAtDesc(userId);
        if (sessions.isEmpty()) {
            return Collections.emptyList();
        }

        // Tải trước tên di tích (nếu có) để hiển thị badge
        Map<UUID, String> heritageNameMap = new HashMap<>();
        for (ChatSession s : sessions) {
            if (s.getHeritageId() != null && !heritageNameMap.containsKey(s.getHeritageId())) {
                heritageInfoRepository.findById(s.getHeritageId())
                        .ifPresent(h -> heritageNameMap.put(h.getId(), h.getName()));
            }
        }

        List<SessionResponseDTO> result = new ArrayList<>();
        for (ChatSession s : sessions) {
            // Lấy tin nhắn gần nhất làm preview
            String lastMessage = chatMessageRepository.findFirstBySessionIdOrderByCreatedAtDesc(s.getId())
                    .map(ChatMessage::getContent)
                    .orElse("");

            result.add(SessionResponseDTO.builder()
                    .id(s.getId())
                    .userId(s.getUserId())
                    .heritageId(s.getHeritageId())
                    .heritageName(s.getHeritageId() != null ? heritageNameMap.get(s.getHeritageId()) : null)
                    .title(s.getTitle())
                    .lastMessage(lastMessage)
                    .createdAt(s.getCreatedAt())
                    .updatedAt(s.getUpdatedAt())
                    .build());
        }

        return result;
    }

    /**
     * Tạo một phiên trò chuyện mới cho người dùng.
     */
    @Transactional
    public SessionResponseDTO createSession(UUID userId, CreateSessionRequest request) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa đăng nhập!");
        }

        String title = (request != null && request.getTitle() != null && !request.getTitle().isBlank())
                ? request.getTitle().trim()
                : "Cuộc trò chuyện mới";

        UUID heritageId = (request != null) ? request.getHeritageId() : null;
        String heritageName = null;

        if (heritageId != null) {
            Optional<HeritageInfo> hOpt = heritageInfoRepository.findById(heritageId);
            if (hOpt.isPresent()) {
                heritageName = hOpt.get().getName();
                if ("Cuộc trò chuyện mới".equals(title)) {
                    title = "Khám phá " + heritageName;
                }
            }
        }

        if (title.length() > 255) {
            title = title.substring(0, 252) + "...";
        }

        ChatSession session = ChatSession.builder()
                .userId(userId)
                .heritageId(heritageId)
                .title(title)
                .createdAt(OffsetDateTime.now())
                .updatedAt(OffsetDateTime.now())
                .build();

        ChatSession saved = chatSessionRepository.save(session);

        return SessionResponseDTO.builder()
                .id(saved.getId())
                .userId(saved.getUserId())
                .heritageId(saved.getHeritageId())
                .heritageName(heritageName)
                .title(saved.getTitle())
                .lastMessage("")
                .createdAt(saved.getCreatedAt())
                .updatedAt(saved.getUpdatedAt())
                .build();
    }

    /**
     * Lấy toàn bộ tin nhắn thuộc về một phiên trò chuyện (xác thực quyền sở hữu).
     */
    @Transactional(readOnly = true)
    public List<MessageResponseDTO> getSessionMessages(UUID userId, UUID sessionId) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa đăng nhập!");
        }

        ChatSession session = chatSessionRepository.findByIdAndUserId(sessionId, userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy phiên trò chuyện hoặc bạn không có quyền truy cập!"));

        List<ChatMessage> messages = chatMessageRepository.findBySessionIdOrderByCreatedAtAsc(session.getId());
        List<MessageResponseDTO> dtoList = new ArrayList<>();

        for (ChatMessage m : messages) {
            dtoList.add(MessageResponseDTO.builder()
                    .id(m.getId())
                    .sessionId(m.getSessionId())
                    .sender(m.getSender())
                    .content(m.getContent())
                    .imageUrl(m.getImageUrl())
                    .confidenceScore(m.getConfidenceScore())
                    .createdAt(m.getCreatedAt())
                    .build());
        }

        return dtoList;
    }

    /**
     * Thêm tin nhắn vào phiên và cập nhật thời gian sửa đổi gần nhất của phiên.
     */
    @Transactional
    public MessageResponseDTO addMessage(UUID userId, UUID sessionId, CreateMessageRequest request) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa đăng nhập!");
        }

        if (request == null || request.getContent() == null || request.getContent().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Nội dung tin nhắn không được để trống!");
        }

        ChatSession session = chatSessionRepository.findByIdAndUserId(sessionId, userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy phiên trò chuyện hoặc bạn không có quyền truy cập!"));

        String sender = (request.getSender() != null && !request.getSender().isBlank())
                ? request.getSender().trim().toLowerCase()
                : "user";

        ChatMessage msg = ChatMessage.builder()
                .sessionId(session.getId())
                .sender(sender)
                .content(request.getContent().trim())
                .imageUrl(request.getImageUrl())
                .confidenceScore(request.getConfidenceScore())
                .createdAt(OffsetDateTime.now())
                .build();

        ChatMessage savedMsg = chatMessageRepository.save(msg);

        // Cập nhật updatedAt của session
        session.setUpdatedAt(OffsetDateTime.now());
        chatSessionRepository.save(session);

        return MessageResponseDTO.builder()
                .id(savedMsg.getId())
                .sessionId(savedMsg.getSessionId())
                .sender(savedMsg.getSender())
                .content(savedMsg.getContent())
                .imageUrl(savedMsg.getImageUrl())
                .confidenceScore(savedMsg.getConfidenceScore())
                .createdAt(savedMsg.getCreatedAt())
                .build();
    }

    /**
     * Xóa một phiên trò chuyện (xóa cascade toàn bộ tin nhắn bên trong).
     */
    @Transactional
    public void deleteSession(UUID userId, UUID sessionId) {
        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa đăng nhập!");
        }

        ChatSession session = chatSessionRepository.findByIdAndUserId(sessionId, userId)
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND, "Không tìm thấy phiên trò chuyện hoặc bạn không có quyền truy cập!"));

        chatSessionRepository.delete(session);
        log.info("[ChatHistoryService] Đã xóa thành công phiên trò chuyện {} của user {}", sessionId, userId);
    }
}
