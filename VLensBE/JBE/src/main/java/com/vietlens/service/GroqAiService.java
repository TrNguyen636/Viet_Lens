package com.vietlens.service;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.vietlens.dto.ChatRequestDTO;
import com.vietlens.dto.ChatResponseDTO;
import com.vietlens.entity.HeritageInfo;
import com.vietlens.repository.HeritageInfoRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

/**
 * Service tích hợp Groq API (chuẩn OpenAI format) để xử lý Chatbot đa nhân vật (Multi-Persona) cho di sản.
 */
@Slf4j
@Service
public class GroqAiService {

    private final HeritageInfoRepository heritageRepository;
    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public GroqAiService(HeritageInfoRepository heritageRepository,
                         RestTemplate restTemplate) {
        this.heritageRepository = heritageRepository;
        this.restTemplate = restTemplate;
    }

    @Value("${ai.openai.api-key:${groq.api.key:}}")
    private String apiKey;

    @Value("${ai.openai.base-url:${groq.api.url:https://api.groq.com/openai/v1/chat/completions}}")
    private String baseUrl;

    @Value("${ai.openai.chat.options.model:${groq.api.model:llama-3.3-70b-versatile}}")
    private String model;

    @Value("${ai.openai.chat.options.temperature:0.7}")
    private Double temperature;

    @Value("${ai.openai.chat.options.max-tokens:1024}")
    private Integer maxTokens;

    /**
     * Xử lý yêu cầu trò chuyện cùng Trợ lý Di sản VietLens bằng Groq API (chuẩn OpenAI) có hỗ trợ đa ngôn ngữ
     */
    public ChatResponseDTO chatWithHeritageAi(ChatRequestDTO request, String lang) {
        if (request == null || request.getMessage() == null || request.getMessage().isBlank()) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Câu hỏi của người dùng không được để trống!");
        }

        if (request.getHeritageId() == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Mã di sản (heritageId) là bắt buộc!");
        }

        String langCode = "vi";
        if (lang != null) {
            String l = lang.trim().toLowerCase();
            if (l.startsWith("en")) langCode = "en";
            else if (l.startsWith("ja")) langCode = "ja";
        }

        // 1. Lấy thông tin ngữ cảnh di sản từ database
        HeritageInfo heritage = heritageRepository.findById(request.getHeritageId())
                .orElseThrow(() -> new ResponseStatusException(HttpStatus.NOT_FOUND,
                        "Không tìm thấy di sản với ID: " + request.getHeritageId()));

        // 2. Xây dựng nội dung cho System Message: [System Prompt] + [Ngữ cảnh Di sản]
        String systemContent = buildSystemContent(heritage, langCode);
        String userContent = request.getMessage().trim();
        // Giới hạn độ dài câu hỏi để bảo vệ token và tránh prompt injection quá dài
        if (userContent.length() > 800) {
            userContent = userContent.substring(0, 800);
        }

        // 3. Kiểm tra cấu hình Groq API Key
        if (apiKey == null || apiKey.isBlank() || apiKey.contains("gsk_dan_key_cua_ong_vao_day")) {
            log.warn("⚠️ Chưa cấu hình GROQ_API_KEY hợp lệ! Trả về phản hồi hướng dẫn.");
            String message;
            if ("ja".equals(langCode)) {
                message = "VietLens遺産アシスタントへようこそ！システムに有効なGROQ_API_KEYが設定されていません。環境変数GROQ_API_KEYを設定してください。";
            } else if ("en".equals(langCode)) {
                message = "Welcome to VietLens Heritage Assistant! The system is missing a valid GROQ_API_KEY. Please configure GROQ_API_KEY in the environment.";
            } else {
                message = "Chào bạn! Tôi là Trợ lý Di sản VietLens. Hệ thống hiện chưa có GROQ_API_KEY hợp lệ. Vui lòng cấu hình biến môi trường GROQ_API_KEY.";
            }

            return ChatResponseDTO.builder()
                    .heritageId(heritage.getId())
                    .heritageName(heritage.getName())
                    .reply(message)
                    .build();
        }

        // 4. Gửi request tới Groq API có bọc Fallback an toàn (tránh làm crash UI khi AI quá tải/timeout)
        String replyText;
        try {
            replyText = callGroqApi(systemContent, userContent);
        } catch (Exception ex) {
            log.warn("Groq AI không phản hồi kịp ({}), kích hoạt câu trả lời dự phòng ngữ cảnh...", ex.getMessage());
            replyText = buildFallbackReply(heritage, langCode);
        }

        return ChatResponseDTO.builder()
                .heritageId(heritage.getId())
                .heritageName(heritage.getName())
                .reply(replyText)
                .build();
    }

    /**
     * Câu trả lời dự phòng ngữ cảnh khi dịch vụ AI ngoại vi gặp sự cố hoặc timeout
     */
    private String buildFallbackReply(HeritageInfo heritage, String langCode) {
        String desc = (heritage.getDescription() != null && !heritage.getDescription().isBlank())
                ? heritage.getDescription()
                : "Một trong những địa danh di sản văn hóa lịch sử tiêu biểu của Việt Nam.";
        String shortDesc = desc.length() > 250 ? desc.substring(0, 250) + "..." : desc;

        if ("ja".equals(langCode)) {
            return String.format("現在AIサービスへの接続が混み合っております。" +
                    "%s (%s) の基本情報をお届けします: %s",
                    heritage.getName(),
                    heritage.getProvince() != null ? heritage.getProvince() : "ベトナム",
                    shortDesc);
        } else if ("en".equals(langCode)) {
            return String.format("Network connection to AI services is currently limited. " +
                    "Here is verified information regarding %s (in %s): %s",
                    heritage.getName(),
                    heritage.getProvince() != null ? heritage.getProvince() : "Vietnam",
                    shortDesc);
        }

        return String.format("Hiện tại kết nối AI đang chập chờn hoặc lưu lượng quá tải. " +
                "Tôi xin chia sẻ nhanh thông tin về %s (tại %s): %s",
                heritage.getName(),
                heritage.getProvince() != null ? heritage.getProvince() : "Việt Nam",
                shortDesc);
    }

    /**
     * Gọi Groq API theo định dạng OpenAI:
     * Headers: Authorization: Bearer {groq.api.key}, Content-Type: application/json
     * Body: { "model": "...", "messages": [{"role": "system", ...}, {"role": "user", ...}] }
     * Response: choices[0].message.content
     */
    private String callGroqApi(String systemContent, String userContent) {
        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(apiKey.trim());

            List<Map<String, String>> messages = List.of(
                    Map.of("role", "system", "content", systemContent),
                    Map.of("role", "user", "content", userContent)
            );

            Map<String, Object> requestBody = Map.of(
                    "model", model,
                    "messages", messages,
                    "temperature", temperature != null ? temperature : 0.7,
                    "max_tokens", maxTokens != null ? maxTokens : 1024
            );

            String requestUrl = resolveRequestUrl(baseUrl);

            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

            ResponseEntity<String> response = restTemplate.postForEntity(requestUrl, entity, String.class);

            if (response.getStatusCode().is2xxSuccessful() && response.getBody() != null) {
                JsonNode root = objectMapper.readTree(response.getBody());
                // Trích xuất: choices[0].message.content
                JsonNode contentNode = root.path("choices")
                        .path(0)
                        .path("message")
                        .path("content");

                if (!contentNode.isMissingNode() && !contentNode.asText().isBlank()) {
                    // Loại bỏ hoàn toàn các ký tự in đậm Markdown như **, ***, ****
                    return contentNode.asText().replaceAll("\\*{2,}", "").trim();
                }
            }

            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR, "Không nhận được nội dung trả lời từ Groq API.");

        } catch (HttpStatusCodeException ex) {
            log.error("Lỗi HTTP từ Groq API: Status={}, Body={}", ex.getStatusCode(), ex.getResponseBodyAsString());
            throw new ResponseStatusException(HttpStatus.BAD_GATEWAY,
                    "Lỗi từ Groq AI: " + ex.getStatusText() + " - " + ex.getResponseBodyAsString());
        } catch (Exception ex) {
            log.error("Lỗi xử lý khi gọi Groq API: {}", ex.getMessage(), ex);
            throw new ResponseStatusException(HttpStatus.INTERNAL_SERVER_ERROR,
                    "Lỗi xử lý AI: " + ex.getMessage());
        }
    }

    /**
     * Tạo nội dung System Message kết hợp giữa vai trò Trợ lý Di sản và thông tin chi tiết của di sản
     */
    private String buildSystemContent(HeritageInfo heritage, String langCode) {
        String assistantRole;
        String instructions;

        if ("ja".equals(langCode)) {
            assistantRole = """
                [ROLE - VIETLENS HERITAGE ASSISTANT (日本語)]:
                あなたはベトナムの文化遺産と歴史的建築物の保存・紹介を行う公式VietLens遺産アシスタントです。
                - トーン＆マナー: 温かく、丁寧で礼儀正しい敬語を用い、歴史的根拠と文化への敬意を持って感動を伝える語り口。
                - 回答範囲: 歴史、建築的特徴、地域の伝説、参観のポイント、文化的意義について親切に解説します。
                """;
            instructions = """
                [回答のガイドライン]:
                1. 必ず流暢で自然、かつ格式ある日本語（敬語・丁寧語）で回答してください。
                2. 上記の遺産コンテキストの情報を自然に織り込んで質問に的確に答えてください。
                3. スマートフォンで読みやすいよう、適度な段落分けを行ってください。
                4. 【厳禁】'**' や '****' などのマークダウン太字は一切使用せず、自然なプレーンテキストで回答してください。
                """;
        } else if ("en".equals(langCode)) {
            assistantRole = """
                [ROLE - VIETLENS HERITAGE ASSISTANT]:
                You are the official VietLens Cultural Heritage Assistant, dedicated to preserving and sharing Vietnam's profound historical and architectural legacy.
                - Persona Tone: Warm, articulate, historically grounded, culturally respectful, and inspiring.
                - Scope: Answer inquiries regarding history, architecture, local legends, visitor tips, and cultural significance.
                """;
            instructions = """
                [LANGUAGE & ANSWERING INSTRUCTIONS]:
                1. Language requirement: You MUST answer entirely in fluent, natural, and culturally articulate English. If you introduce traditional Vietnamese terms, briefly clarify their meaning.
                2. Integrate the heritage context above naturally and informatively.
                3. Format with clean, mobile-friendly paragraph spacing.
                4. STRICTLY PROHIBITED: DO NOT use markdown bold like '**' or '****'. Always write natural plain text.
                """;
        } else {
            assistantRole = """
                [VAI TRÒ - TRỢ LÝ DI SẢN VIỆTLENS]:
                Bạn là Trợ lý Di sản Văn hóa VietLens chính thức, đại diện cho nền tảng số hóa và bảo tồn di sản văn hóa Việt Nam.
                - Giọng điệu: Trầm ấm, uyên bác, lịch sự, truyền cảm hứng và đậm đà bản sắc dân tộc.
                - Trọng tâm nội dung: Giải đáp cặn kẽ về lịch sử hình thành, niên đại, triều đại, nét độc đáo kiến trúc, câu chuyện văn hóa tiền nhân và kinh nghiệm tham quan thực tế.
                """;
            instructions = """
                [HƯỚNG DẪN TRẢ LỜI]:
                1. Trả lời một cách tự nhiên, sâu sắc, cuốn hút và chính xác bằng tiếng Việt.
                2. Kết hợp thông tin ngữ cảnh của di sản để trả lời đúng trọng tâm câu hỏi của người dùng.
                3. Trình bày ngắt đoạn rõ ràng, dễ đọc trên màn hình điện thoại di động.
                4. TUYỆT ĐỐI KHÔNG dùng ký tự in đậm Markdown như '**' hoặc '****'. Hãy viết văn bản thuần túy (plain text) tự nhiên, không bao bọc từ ngữ trong dấu sao.
                """;
        }

        return String.format("""
            %s

            [THÔNG TIN NGỮ CẢNH DI SẢN]:
            - Tên di sản: %s
            - Thể loại: %s
            - Tỉnh/Thành phố: %s
            - Địa chỉ: %s
            - Tọa độ: (Vĩ độ: %s, Kinh độ: %s)
            - Mô tả chi tiết: %s

            %s
            """,
                assistantRole,
                heritage.getName(),
                heritage.getCategory() != null ? heritage.getCategory() : "Di sản văn hóa",
                heritage.getProvince() != null ? heritage.getProvince() : "Việt Nam",
                heritage.getAddress() != null ? heritage.getAddress() : "Chưa cập nhật",
                heritage.getLatitude() != null ? heritage.getLatitude() : 0.0,
                heritage.getLongitude() != null ? heritage.getLongitude() : 0.0,
                heritage.getDescription() != null ? heritage.getDescription() : "",
                instructions
        );
    }

    /**
     * Chuẩn hóa URL gọi sang Groq API, hỗ trợ linh hoạt các định dạng URL:
     * - https://api.groq.com/openai/v1/chat/completions
     * - https://api.groq.com/openai/v1
     * - https://api.groq.com/openai
     * - https://api.groq.com/openai/v1/models (loại bỏ /models để tránh lỗi 404/502)
     */
    private String resolveRequestUrl(String rawUrl) {
        if (rawUrl == null || rawUrl.isBlank()) {
            return "https://api.groq.com/openai/v1/chat/completions";
        }
        String cleanUrl = rawUrl.trim();
        if (cleanUrl.endsWith("/chat/completions")) {
            return cleanUrl;
        }
        if (cleanUrl.endsWith("/models") || cleanUrl.endsWith("/models/")) {
            cleanUrl = cleanUrl.replaceAll("/models/?$", "");
        }
        if (cleanUrl.endsWith("/v1") || cleanUrl.endsWith("/v1/")) {
            cleanUrl = cleanUrl.replaceAll("/?$", "");
            return cleanUrl + "/chat/completions";
        }
        cleanUrl = cleanUrl.replaceAll("/?$", "");
        return cleanUrl + "/v1/chat/completions";
    }
}
