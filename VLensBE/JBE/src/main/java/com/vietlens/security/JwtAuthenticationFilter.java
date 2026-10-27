package com.vietlens.security;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.util.StringUtils;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * Filter chặn mọi HTTP request để kiểm tra và xác thực JWT token từ header 'Authorization: Bearer <token>'.
 */
@Slf4j
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    private final JwtUtils jwtUtils;

    public JwtAuthenticationFilter(JwtUtils jwtUtils) {
        this.jwtUtils = jwtUtils;
    }

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        try {
            String jwt = parseJwt(request);

            if (jwt != null) {
                com.nimbusds.jwt.JWTClaimsSet claims = jwtUtils.parseAndValidate(jwt);

                if (claims != null) {
                    String sub = jwtUtils.extractSubject(claims);
                    UUID userId = jwtUtils.extractUserId(claims);
                    String email = jwtUtils.extractEmail(claims);
                    String role = jwtUtils.extractRole(claims);
                    String fullName = jwtUtils.extractFullName(claims);
                    String avatarUrl = jwtUtils.extractAvatarUrl(claims);
                    boolean isAnonymous = jwtUtils.isAnonymous(claims);

                    // Gán quyền dựa trên role của Supabase (mặc định 'authenticated' -> ROLE_AUTHENTICATED hoặc ROLE_USER)
                    String roleAuthority = (role != null && !role.isBlank())
                            ? "ROLE_" + role.toUpperCase()
                            : "ROLE_USER";

                    List<SimpleGrantedAuthority> authorities = Collections.singletonList(
                            new SimpleGrantedAuthority(roleAuthority)
                    );

                    UserPrincipal principal = UserPrincipal.builder()
                            .id(userId)
                            .email(email)
                            .role(role)
                            .fullName(fullName)
                            .avatarUrl(avatarUrl)
                            .isAnonymous(isAnonymous)
                            .authorities(authorities)
                            .build();

                UsernamePasswordAuthenticationToken authentication =
                        new UsernamePasswordAuthenticationToken(
                                principal,
                                null,
                                principal.getAuthorities()
                        );

                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // Thiết lập thông tin người dùng vào SecurityContextHolder
                SecurityContextHolder.getContext().setAuthentication(authentication);
                log.debug("Đã xác thực thành công người dùng Supabase sub: {}, email: {}", sub, email);
                }
            }
        } catch (Exception e) {
            log.error("Không thể thiết lập xác thực người dùng trong SecurityContext: {}", e.getMessage(), e);
        }

        filterChain.doFilter(request, response);
    }

    /**
     * Lấy JWT token từ header 'Authorization: Bearer <token>'
     */
    private String parseJwt(HttpServletRequest request) {
        String headerAuth = request.getHeader("Authorization");
        if (StringUtils.hasText(headerAuth) && headerAuth.startsWith("Bearer ")) {
            return headerAuth.substring(7);
        }
        return null;
    }
}
