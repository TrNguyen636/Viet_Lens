package com.vietlens.controller;

import com.vietlens.dto.SyncUserRequest;
import com.vietlens.dto.UserResponse;
import com.vietlens.security.SecurityUtils;
import com.vietlens.security.UserPrincipal;
import com.vietlens.service.UserService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.UUID;

@Slf4j
@RestController
@RequestMapping("/api/users")
public class UserController {

    private final UserService userService;

    public UserController(UserService userService) {
        this.userService = userService;
    }

    /**
     * API đồng bộ user từ Supabase vào bảng users trong DB:
     * - Frontend gửi JWT token qua header: 'Authorization: Bearer <token>'
     * - Hoặc gửi token/thông tin bổ sung qua RequestBody
     */
    @PostMapping("/sync")
    public ResponseEntity<UserResponse> syncUser(
            @AuthenticationPrincipal UserPrincipal principal,
            @RequestHeader(value = "Authorization", required = false) String authHeader,
            @RequestBody(required = false) SyncUserRequest request
    ) {
        String token = null;
        if (StringUtils.hasText(authHeader) && authHeader.startsWith("Bearer ")) {
            token = authHeader.substring(7);
        } else if (request != null && StringUtils.hasText(request.getToken())) {
            token = request.getToken();
        }

        UUID userId = (principal != null) ? principal.getId() : null;

        UserResponse response = userService.syncUser(userId, token, request);
        return ResponseEntity.ok(response);
    }

    /**
     * API lấy thông tin cá nhân của người dùng đang đăng nhập:
     * - Yêu cầu header: 'Authorization: Bearer <token>'
     */
    @GetMapping("/profile")
    public ResponseEntity<UserResponse> getProfile(@AuthenticationPrincipal UserPrincipal principal) {
        UserPrincipal currentPrincipal = principal != null
                ? principal
                : SecurityUtils.getCurrentUser().orElse(null);

        UserResponse response = userService.getUserProfile(currentPrincipal);
        return ResponseEntity.ok(response);
    }
}
