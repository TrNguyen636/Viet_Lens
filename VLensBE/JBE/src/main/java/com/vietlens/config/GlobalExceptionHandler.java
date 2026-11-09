package com.vietlens.config;

import com.vietlens.dto.ApiErrorResponse;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.client.HttpStatusCodeException;
import org.springframework.web.server.ResponseStatusException;

import java.util.HashMap;
import java.util.Map;

/**
 * Bộ xử lý ngoại lệ toàn cục tập trung (Centralized Global Exception Handler).
 * Bắt mọi ngoại lệ phát sinh trong hệ thống và chuyển đổi thành ApiErrorResponse JSON chuẩn hóa,
 * bảo vệ không để lộ cấu trúc máy chủ, stack traces ra ngoài môi trường Production.
 */
@Slf4j
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(ResponseStatusException.class)
    public ResponseEntity<ApiErrorResponse> handleResponseStatusException(
            ResponseStatusException ex, HttpServletRequest request) {
        log.warn("Lỗi nghiệp vụ [{}]: {}", ex.getStatusCode(), ex.getReason());
        ApiErrorResponse error = ApiErrorResponse.of(
                ex.getStatusCode().value(),
                ex.getStatusCode().toString(),
                ex.getReason() != null ? ex.getReason() : "Yêu cầu không hợp lệ",
                request.getRequestURI()
        );
        return ResponseEntity.status(ex.getStatusCode()).body(error);
    }

    @ExceptionHandler(HttpStatusCodeException.class)
    public ResponseEntity<ApiErrorResponse> handleExternalHttpException(
            HttpStatusCodeException ex, HttpServletRequest request) {
        log.error("Lỗi HTTP từ dịch vụ ngoại vi (Groq/Supabase): Status={}, Body={}",
                ex.getStatusCode(), ex.getResponseBodyAsString());

        String clientMessage = ex.getStatusCode().value() == 429
                ? "Dịch vụ AI đang vượt quá hạn mức sử dụng (Rate limit). Vui lòng thử lại sau giây lát!"
                : "Dịch vụ tích hợp ngoại vi tạm thời gián đoạn. Vui lòng thử lại!";

        ApiErrorResponse error = ApiErrorResponse.of(
                HttpStatus.BAD_GATEWAY.value(),
                "Bad Gateway",
                clientMessage,
                request.getRequestURI()
        );
        return ResponseEntity.status(HttpStatus.BAD_GATEWAY).body(error);
    }

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ApiErrorResponse> handleValidationException(
            MethodArgumentNotValidException ex, HttpServletRequest request) {
        Map<String, String> details = new HashMap<>();
        for (FieldError fieldError : ex.getBindingResult().getFieldErrors()) {
            details.put(fieldError.getField(), fieldError.getDefaultMessage());
        }

        ApiErrorResponse error = ApiErrorResponse.builder()
                .timestamp(java.time.Instant.now().toString())
                .status(HttpStatus.BAD_REQUEST.value())
                .error("Validation Failed")
                .message("Dữ liệu đầu vào không hợp lệ!")
                .path(request.getRequestURI())
                .details(details)
                .build();

        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(error);
    }

    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ApiErrorResponse> handleAccessDenied(
            AccessDeniedException ex, HttpServletRequest request) {
        log.warn("Truy cập bị từ chối: URI={}, Msg={}", request.getRequestURI(), ex.getMessage());
        ApiErrorResponse error = ApiErrorResponse.of(
                HttpStatus.FORBIDDEN.value(),
                "Forbidden",
                "Bạn không có quyền thực hiện hành động này!",
                request.getRequestURI()
        );
        return ResponseEntity.status(HttpStatus.FORBIDDEN).body(error);
    }

    @ExceptionHandler(AuthenticationException.class)
    public ResponseEntity<ApiErrorResponse> handleAuthenticationException(
            AuthenticationException ex, HttpServletRequest request) {
        log.warn("Xác thực thất bại: URI={}, Msg={}", request.getRequestURI(), ex.getMessage());
        ApiErrorResponse error = ApiErrorResponse.of(
                HttpStatus.UNAUTHORIZED.value(),
                "Unauthorized",
                "Yêu cầu xác thực phiên đăng nhập!",
                request.getRequestURI()
        );
        return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(error);
    }

    @ExceptionHandler(Exception.class)
    public ResponseEntity<ApiErrorResponse> handleGenericException(
            Exception ex, HttpServletRequest request) {
        // Bỏ qua việc in stack trace lỗi nếu người dùng đóng app, reload trang hoặc ngắt kết nối sớm (ClientAbortException / Connection reset)
        Throwable cause = ex;
        while (cause != null) {
            String causeName = cause.getClass().getSimpleName();
            String causeMsg = cause.getMessage() != null ? cause.getMessage() : "";
            if ("ClientAbortException".equals(causeName) || causeMsg.contains("Connection reset by peer") || causeMsg.contains("Broken pipe")) {
                log.info("ℹ️ Client (Điện thoại/Trình duyệt) đã ngắt kết nối trước khi server gửi xong phản hồi tại {}", request.getRequestURI());
                return null;
            }
            cause = cause.getCause();
        }

        log.error("Lỗi hệ thống chưa được kiểm soát tại {}: ", request.getRequestURI(), ex);
        ApiErrorResponse error = ApiErrorResponse.of(
                HttpStatus.INTERNAL_SERVER_ERROR.value(),
                "Internal Server Error",
                "Hệ thống đang bận hoặc gặp lỗi tạm thời. Vui lòng thử lại sau!",
                request.getRequestURI()
        );
        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(error);
    }
}
