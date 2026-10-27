package com.vietlens.service;

import com.vietlens.dto.SyncUserRequest;
import com.vietlens.dto.UserResponse;
import com.vietlens.entity.UserEntity;
import com.vietlens.entity.UserRole;
import com.vietlens.repository.UserRepository;
import com.vietlens.security.JwtUtils;
import com.vietlens.security.UserPrincipal;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.UUID;

/**
 * Service quản lý thông tin User và Profile.
 */
@Slf4j
@Service
public class UserService {

    private final UserRepository userRepository;
    private final JwtUtils jwtUtils;

    public UserService(UserRepository userRepository, JwtUtils jwtUtils) {
        this.userRepository = userRepository;
        this.jwtUtils = jwtUtils;
    }

    /**
     * Đồng bộ hoặc cập nhật thông tin User vào bảng users trong DB.
     * Hỗ trợ cả đăng nhập chính thức (USER) và tài khoản ẩn danh/khách (GUEST).
     */
    @Transactional
    public UserResponse syncUser(UUID authenticatedUserId, String token, SyncUserRequest request) {
        UUID userId = authenticatedUserId;
        String email = null;
        String fullName = null;
        String avatarUrl = null;
        boolean isAnonymous = false;

        // 1. Trích xuất thông tin từ JWT Token nếu có
        if (token != null && !token.isBlank()) {
            com.nimbusds.jwt.JWTClaimsSet claims = jwtUtils.parseAndValidate(token);
            if (claims != null) {
                if (userId == null) {
                    userId = jwtUtils.extractUserId(claims);
                }
                email = jwtUtils.extractEmail(claims);
                fullName = jwtUtils.extractFullName(claims);
                avatarUrl = jwtUtils.extractAvatarUrl(claims);
                isAnonymous = jwtUtils.isAnonymous(claims);
            }
        }

        if (userId == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Không tìm thấy User ID (sub) trong token!");
        }

        // 2. Ưu tiên thông tin do Client gửi kèm trong Request body nếu có
        if (request != null) {
            if (request.getFullName() != null && !request.getFullName().isBlank()) {
                fullName = request.getFullName();
            }
            if (request.getAvatarUrl() != null && !request.getAvatarUrl().isBlank()) {
                avatarUrl = request.getAvatarUrl();
            }
        }

        // 3. Xác định Role (GUEST vs USER) dựa trên thông tin đã xác thực từ Supabase JWT
        UserRole assignedRole;
        if (isAnonymous || email == null || email.isBlank()) {
            assignedRole = UserRole.GUEST;
        } else {
            assignedRole = UserRole.USER;
        }

        final UUID finalUserId = userId;
        final String finalEmail = email;
        final String finalFullName = fullName;
        final String finalAvatarUrl = avatarUrl;
        final UserRole finalRole = assignedRole;

        // 4. Lưu hoặc cập nhật vào database
        UserEntity user = userRepository.findById(userId)
                .map(existingUser -> {
                    if (finalEmail != null && !finalEmail.isBlank()) {
                        existingUser.setEmail(finalEmail);
                    }
                    if (finalFullName != null && !finalFullName.isBlank()) {
                        existingUser.setFullName(finalFullName);
                    }
                    if (finalAvatarUrl != null && !finalAvatarUrl.isBlank()) {
                        existingUser.setAvatarUrl(finalAvatarUrl);
                    }
                    // Nếu trước đó là GUEST và nay đăng nhập thành USER chính thức thì nâng cấp role
                    if (existingUser.getRole() == UserRole.GUEST && finalRole == UserRole.USER) {
                        existingUser.setRole(UserRole.USER);
                    }
                    return existingUser;
                })
                .orElseGet(() -> UserEntity.builder()
                        .id(finalUserId)
                        .email(finalEmail)
                        .fullName(finalFullName != null && !finalFullName.isBlank()
                                ? finalFullName
                                : (finalRole == UserRole.GUEST ? "Khách khám phá" : "Người dùng"))
                        .avatarUrl(finalAvatarUrl)
                        .role(finalRole)
                        .build()
                );

        UserEntity savedUser = userRepository.save(user);
        log.info("Đã đồng bộ user thành công: id={}, role={}, email={}", savedUser.getId(), savedUser.getRole(), savedUser.getEmail());
        return UserResponse.fromEntity(savedUser);
    }

    /**
     * Lấy thông tin cá nhân của người dùng đang đăng nhập.
     * Nếu user đã xác thực qua Supabase mà chưa gọi sync, tự động tạo hồ sơ mặc định.
     */
    @Transactional
    public UserResponse getUserProfile(UserPrincipal principal) {
        if (principal == null || principal.getId() == null) {
            throw new ResponseStatusException(HttpStatus.UNAUTHORIZED, "Người dùng chưa đăng nhập!");
        }

        UUID userId = principal.getId();
        return userRepository.findById(userId)
                .map(UserResponse::fromEntity)
                .orElseGet(() -> {
                    log.info("User {} chưa có trong bảng users, tự động tạo hồ sơ mặc định...", userId);
                    UserRole role = (principal.getEmail() != null && !principal.getEmail().isBlank())
                            ? UserRole.USER
                            : UserRole.GUEST;

                    UserEntity newUser = UserEntity.builder()
                            .id(userId)
                            .email(principal.getEmail())
                            .fullName(role == UserRole.GUEST ? "Khách khám phá" : "Người dùng")
                            .role(role)
                            .build();

                    return UserResponse.fromEntity(userRepository.save(newUser));
                });
    }
}
