package com.vietlens.controller;

import com.vietlens.dto.BookmarkToggleResponse;
import com.vietlens.dto.HeritageResponseDTO;
import com.vietlens.security.SecurityUtils;
import com.vietlens.security.UserPrincipal;
import com.vietlens.service.SavedPlaceService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/interactions")
public class SavedPlaceController {

    private final SavedPlaceService savedPlaceService;

    public SavedPlaceController(SavedPlaceService savedPlaceService) {
        this.savedPlaceService = savedPlaceService;
    }

    /**
     * API Lưu / Bỏ lưu di sản yêu thích (Toggle Bookmark):
     * POST /api/interactions/bookmark/{heritageId}
     */
    @PostMapping("/bookmark/{heritageId}")
    public ResponseEntity<BookmarkToggleResponse> toggleBookmark(
            @PathVariable("heritageId") UUID heritageId,
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        UUID userId = (principal != null)
                ? principal.getId()
                : SecurityUtils.getCurrentUserId().orElse(null);

        BookmarkToggleResponse response = savedPlaceService.toggleBookmark(userId, heritageId);
        return ResponseEntity.ok(response);
    }

    /**
     * API Lấy danh sách các di sản đã lưu của User hiện tại:
     * GET /api/interactions/bookmarks
     */
    @GetMapping("/bookmarks")
    public ResponseEntity<List<HeritageResponseDTO>> getBookmarks(
            @AuthenticationPrincipal UserPrincipal principal
    ) {
        UUID userId = (principal != null)
                ? principal.getId()
                : SecurityUtils.getCurrentUserId().orElse(null);

        List<HeritageResponseDTO> bookmarks = savedPlaceService.getUserBookmarks(userId);
        return ResponseEntity.ok(bookmarks);
    }
}
