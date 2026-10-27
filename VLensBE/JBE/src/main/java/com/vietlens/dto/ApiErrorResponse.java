package com.vietlens.dto;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.Builder;
import lombok.Data;

import java.time.Instant;
import java.util.Map;

/**
 * DTO chuẩn hóa cho toàn bộ lỗi phản hồi từ Spring Boot Backend về Mobile App.
 */
@Data
@Builder
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiErrorResponse {
    private String timestamp;
    private int status;
    private String error;
    private String message;
    private String path;
    private Map<String, String> details;

    public ApiErrorResponse() {
    }

    public ApiErrorResponse(String timestamp, int status, String error, String message, String path, Map<String, String> details) {
        this.timestamp = timestamp;
        this.status = status;
        this.error = error;
        this.message = message;
        this.path = path;
        this.details = details;
    }

    public static ApiErrorResponse of(int status, String error, String message, String path) {
        return ApiErrorResponse.builder()
                .timestamp(Instant.now().toString())
                .status(status)
                .error(error)
                .message(message)
                .path(path)
                .build();
    }
}
