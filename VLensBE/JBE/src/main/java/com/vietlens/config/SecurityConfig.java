package com.vietlens.config;

import com.vietlens.security.JwtAuthenticationEntryPoint;
import com.vietlens.security.JwtAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

/**
 * Cấu hình Spring Security:
 * - Tắt CSRF (cho RESTful stateless API)
 * - Cấu hình CORS mở rộng cho Frontend (Expo, React, Mobile app)
 * - Session Management: Stateless
 * - Ủy quyền truy cập API (permitAll cho public & Swagger, authenticated cho interactions, users, passport)
 * - Đăng ký JwtAuthenticationFilter để xác thực Supabase JWT
 */
@Configuration
@EnableWebSecurity
@EnableMethodSecurity
public class SecurityConfig {

    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final JwtAuthenticationEntryPoint unauthorizedHandler;

    public SecurityConfig(JwtAuthenticationFilter jwtAuthenticationFilter,
                          JwtAuthenticationEntryPoint unauthorizedHandler) {
        this.jwtAuthenticationFilter = jwtAuthenticationFilter;
        this.unauthorizedHandler = unauthorizedHandler;
    }

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            // 1. Tắt CSRF vì ứng dụng sử dụng JWT Token (Stateless)
            .csrf(AbstractHttpConfigurer::disable)

            // 2. Cấu hình CORS để Frontend gọi API không bị chặn
            .cors(cors -> cors.configurationSource(corsConfigurationSource()))

            // 3. Xử lý ngoại lệ khi chưa xác thực (401 Unauthorized JSON)
            .exceptionHandling(ex -> ex.authenticationEntryPoint(unauthorizedHandler))

            // 4. Quản lý phiên làm việc ở chế độ STATELESS
            .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))

            // 5. Phân quyền các endpoint
            .authorizeHttpRequests(auth -> auth
                // Cho phép preflight requests (CORS OPTIONS)
                .requestMatchers(HttpMethod.OPTIONS, "/**").permitAll()

                // Public APIs: Tra cứu di sản và chỉ đường bản đồ (hỗ trợ cả khách vãng lai Guest)
                .requestMatchers(HttpMethod.GET, "/api/heritage/**").permitAll()
                .requestMatchers(HttpMethod.POST, "/api/routes").permitAll()

                // Swagger / OpenAPI documentation
                .requestMatchers(
                    "/v3/api-docs/**",
                    "/swagger-ui/**",
                    "/swagger-ui.html",
                    "/swagger-resources/**",
                    "/webjars/**"
                ).permitAll()

                // Endpoints hệ thống cơ bản
                .requestMatchers("/error").permitAll()

                // Private APIs: Tương tác, người dùng, AI Chatbot, Lịch sử chat (Bắt buộc xác thực)
                .requestMatchers(
                    "/api/interactions/**",
                    "/api/users/**",
                    "/api/ai/**",
                    "/api/chat/**"
                ).authenticated()

                // Mọi request còn lại bắt buộc phải xác thực
                .anyRequest().authenticated()
            );

        // 6. Thêm JwtAuthenticationFilter vào trước UsernamePasswordAuthenticationFilter
        http.addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    /**
     * Cấu hình CORS an toàn cho Frontend (hỗ trợ localhost, Expo LAN, Emulator)
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        // Cho phép các nguồn gốc phát triển và production cụ thể
        configuration.setAllowedOriginPatterns(List.of(
                "http://localhost:[*]",
                "http://127.0.0.1:[*]",
                "http://10.0.2.2:[*]",
                "http://192.168.*:[*]",
                "http://172.*:[*]",
                "http://10.*:[*]",
                "https://*.supabase.co",
                "https://*.vercel.app"
        ));
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "PATCH", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Content-Type", "Accept", "X-Requested-With", "Origin"));
        configuration.setExposedHeaders(List.of("Authorization"));
        configuration.setAllowCredentials(true);
        configuration.setMaxAge(3600L); // Cache preflight response 1 giờ

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }
}
