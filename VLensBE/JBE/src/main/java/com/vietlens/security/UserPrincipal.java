package com.vietlens.security;

import lombok.Builder;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.UUID;

/**
 * Lớp đại diện cho thông tin người dùng được trích xuất từ Supabase JWT.
 * 'sub' trong token chính là UUID của user trong Supabase auth.users.
 */
@Getter
@Builder
public class UserPrincipal implements UserDetails {

    private final UUID id;
    private final String email;
    private final String role;
    private final String fullName;
    private final String avatarUrl;
    private final boolean isAnonymous;
    private final Collection<? extends GrantedAuthority> authorities;

    public UserPrincipal(
            UUID id,
            String email,
            String role,
            String fullName,
            String avatarUrl,
            boolean isAnonymous,
            Collection<? extends GrantedAuthority> authorities
    ) {
        this.id = id;
        this.email = email;
        this.role = role;
        this.fullName = fullName;
        this.avatarUrl = avatarUrl;
        this.isAnonymous = isAnonymous;
        this.authorities = authorities;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getPassword() {
        return null; // JWT stateless authentication, không lưu mật khẩu
    }

    /**
     * Trả về sub (UUID string) làm username chính cho Principal.
     */
    @Override
    public String getUsername() {
        return id != null ? id.toString() : email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
