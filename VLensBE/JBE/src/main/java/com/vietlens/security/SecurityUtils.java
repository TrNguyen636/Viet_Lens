package com.vietlens.security;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.util.Optional;
import java.util.UUID;

/**
 * Tiện ích truy xuất nhanh thông tin User đang đăng nhập từ SecurityContextHolder.
 */
public final class SecurityUtils {

    private SecurityUtils() {
    }

    /**
     * Lấy UserPrincipal của người dùng hiện tại
     */
    public static Optional<UserPrincipal> getCurrentUser() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.getPrincipal() instanceof UserPrincipal principal) {
            return Optional.of(principal);
        }
        return Optional.empty();
    }

    /**
     * Lấy Supabase User UUID (sub) của người dùng hiện tại
     */
    public static Optional<UUID> getCurrentUserId() {
        return getCurrentUser().map(UserPrincipal::getId);
    }

    /**
     * Lấy email của người dùng hiện tại
     */
    public static Optional<String> getCurrentUserEmail() {
        return getCurrentUser().map(UserPrincipal::getEmail);
    }
}
