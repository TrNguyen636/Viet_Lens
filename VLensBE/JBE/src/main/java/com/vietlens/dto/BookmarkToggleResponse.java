package com.vietlens.dto;

import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * DTO trả về kết quả sau khi bật/tắt yêu thích (Bookmark) địa danh.
 */
@Data
@Builder
public class BookmarkToggleResponse {
    private UUID heritageId;
    private boolean bookmarked; // true: đã lưu vào danh sách, false: đã bỏ lưu
    private String message;

    public BookmarkToggleResponse() {
    }

    public BookmarkToggleResponse(UUID heritageId, boolean bookmarked, String message) {
        this.heritageId = heritageId;
        this.bookmarked = bookmarked;
        this.message = message;
    }
}
