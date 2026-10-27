package com.vietlens.security;

import com.nimbusds.jose.JWSAlgorithm;
import com.nimbusds.jose.crypto.MACVerifier;
import com.nimbusds.jose.jwk.source.JWKSource;
import com.nimbusds.jose.jwk.source.RemoteJWKSet;
import com.nimbusds.jose.proc.JWSKeySelector;
import com.nimbusds.jose.proc.JWSVerificationKeySelector;
import com.nimbusds.jose.proc.SecurityContext;
import com.nimbusds.jose.util.DefaultResourceRetriever;
import com.nimbusds.jwt.JWTClaimsSet;
import com.nimbusds.jwt.SignedJWT;
import com.nimbusds.jwt.proc.ConfigurableJWTProcessor;
import com.nimbusds.jwt.proc.DefaultJWTClaimsVerifier;
import com.nimbusds.jwt.proc.DefaultJWTProcessor;
import jakarta.annotation.PostConstruct;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.net.URI;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.Date;
import java.util.Set;
import java.util.UUID;

/**
 * Tiện ích xác thực và giải mã Supabase JWT bằng JWKS (hỗ trợ ES256 / ECC P-256 hiện tại của Supabase,
 * tự động xoay khóa và hỗ trợ fallback HS256 nếu cần).
 */
@Slf4j
@Component
public class JwtUtils {

    @Value("${supabase.jwt.jwks-uri:https://fjqgblqepphurmyyiusq.supabase.co/auth/v1/.well-known/jwks.json}")
    private String jwksUri;

    @Value("${supabase.jwt.issuer:https://fjqgblqepphurmyyiusq.supabase.co/auth/v1}")
    private String expectedIssuer;

    @Value("${supabase.jwt.secret:}")
    private String legacySecret;

    private ConfigurableJWTProcessor<SecurityContext> jwtProcessor;

    @SuppressWarnings("deprecation")
    @PostConstruct
    public void init() {
        try {
            jwtProcessor = new DefaultJWTProcessor<>();

            // 1. Tự động tải và cache public keys qua JWKS endpoint (timeout connect & read: 5000ms)
            URL jwkSetUrl = URI.create(jwksUri).toURL();
            JWKSource<SecurityContext> jwkSource = new RemoteJWKSet<>(
                    jwkSetUrl,
                    new DefaultResourceRetriever(5000, 5000)
            );

            // 2. Chấp nhận các thuật toán khóa bất đối xứng của Supabase (ES256 - P-256 và RS256)
            Set<JWSAlgorithm> expectedAlgorithms = Set.of(
                    JWSAlgorithm.ES256,
                    JWSAlgorithm.RS256
            );

            JWSKeySelector<SecurityContext> keySelector =
                    new JWSVerificationKeySelector<>(expectedAlgorithms, jwkSource);
            jwtProcessor.setJWSKeySelector(keySelector);

            // 3. Kiểm tra Claims: Issuer, Expiration (cho phép clock skew 60 giây)
            JWTClaimsSet exactClaims = new JWTClaimsSet.Builder()
                    .issuer(expectedIssuer)
                    .build();

            Set<String> requiredClaims = Set.of("sub", "exp");

            DefaultJWTClaimsVerifier<SecurityContext> claimsVerifier =
                    new DefaultJWTClaimsVerifier<>(exactClaims, requiredClaims);
            claimsVerifier.setMaxClockSkew(60); // 60 giây dung sai lệch đồng hồ

            jwtProcessor.setJWTClaimsSetVerifier(claimsVerifier);

            log.info("✅ JwtUtils đã sẵn sàng xác thực chữ ký qua Supabase JWKS: {}", jwksUri);
        } catch (Exception e) {
            log.error("❌ Không thể khởi tạo JWKS processor: {}", e.getMessage(), e);
        }
    }

    /**
     * Xác thực chữ ký và tính hợp lệ của token trong 1 lần xử lý duy nhất.
     * Trả về JWTClaimsSet nếu token hợp lệ, ngược lại trả về null.
     */
    public JWTClaimsSet parseAndValidate(String token) {
        if (token == null || token.isBlank()) {
            return null;
        }

        try {
            SignedJWT signedJWT = SignedJWT.parse(token);
            JWSAlgorithm algorithm = signedJWT.getHeader().getAlgorithm();

            // 1. ES256, RS256: Xác thực qua JWKS của Supabase
            if (JWSAlgorithm.ES256.equals(algorithm) || JWSAlgorithm.RS256.equals(algorithm)) {
                if (jwtProcessor == null) {
                    log.error("JWKS Processor chưa được khởi tạo!");
                    return null;
                }
                return jwtProcessor.process(signedJWT, null);
            }

            // 2. HS256: Fallback nếu cấu hình legacy secret
            if (JWSAlgorithm.HS256.equals(algorithm)) {
                if (legacySecret != null && !legacySecret.isBlank()) {
                    boolean verified = signedJWT.verify(new MACVerifier(legacySecret.getBytes(StandardCharsets.UTF_8)));
                    if (!verified) {
                        log.warn("Chữ ký HS256 không hợp lệ");
                        return null;
                    }
                    JWTClaimsSet claims = signedJWT.getJWTClaimsSet();
                    Date expirationTime = claims.getExpirationTime();
                    if (expirationTime != null && new Date().after(expirationTime)) {
                        log.warn("Token HS256 đã hết hạn");
                        return null;
                    }
                    return claims;
                } else {
                    log.warn("Token dùng HS256 nhưng chưa cấu hình supabase.jwt.secret fallback");
                    return null;
                }
            }

            log.warn("Thuật toán JWT không được hỗ trợ: {}", algorithm);
            return null;
        } catch (Exception e) {
            log.warn("Xác thực JWT thất bại: {}", e.getMessage());
            return null;
        }
    }

    /**
     * Kiểm tra tính hợp lệ của token
     */
    public boolean validateToken(String token) {
        return parseAndValidate(token) != null;
    }

    /**
     * Trích xuất JWTClaimsSet đã được xác thực an toàn (tuyệt đối không parse unverified)
     */
    public JWTClaimsSet getClaims(String token) {
        return parseAndValidate(token);
    }

    // ========================================================
    // CÁC HÀM TRÍCH XUẤT NHANH TỪ JWTClaimsSet (Zero-overhead)
    // ========================================================

    public String extractSubject(JWTClaimsSet claims) {
        return claims != null ? claims.getSubject() : null;
    }

    public UUID extractUserId(JWTClaimsSet claims) {
        String sub = extractSubject(claims);
        if (sub != null && !sub.isBlank()) {
            try {
                return UUID.fromString(sub);
            } catch (IllegalArgumentException e) {
                log.warn("Claim 'sub' trong token không phải là UUID hợp lệ: {}", sub);
            }
        }
        return null;
    }

    public String extractEmail(JWTClaimsSet claims) {
        if (claims != null) {
            try {
                return claims.getStringClaim("email");
            } catch (Exception e) {
                log.warn("Không thể lấy email từ claim: {}", e.getMessage());
            }
        }
        return null;
    }

    public String extractRole(JWTClaimsSet claims) {
        if (claims != null) {
            try {
                return claims.getStringClaim("role");
            } catch (Exception e) {
                log.warn("Không thể lấy role từ claim: {}", e.getMessage());
            }
        }
        return null;
    }

    public java.util.Map<String, Object> extractUserMetadata(JWTClaimsSet claims) {
        if (claims != null) {
            try {
                java.util.Map<String, Object> metadata = claims.getJSONObjectClaim("user_metadata");
                return metadata != null ? metadata : java.util.Collections.emptyMap();
            } catch (Exception e) {
                log.warn("Không thể lấy user_metadata từ claim: {}", e.getMessage());
            }
        }
        return java.util.Collections.emptyMap();
    }

    public String extractFullName(JWTClaimsSet claims) {
        java.util.Map<String, Object> metadata = extractUserMetadata(claims);
        if (metadata != null) {
            if (metadata.get("full_name") != null) return metadata.get("full_name").toString();
            if (metadata.get("name") != null) return metadata.get("name").toString();
        }
        return null;
    }

    public String extractAvatarUrl(JWTClaimsSet claims) {
        java.util.Map<String, Object> metadata = extractUserMetadata(claims);
        if (metadata != null) {
            if (metadata.get("avatar_url") != null) return metadata.get("avatar_url").toString();
            if (metadata.get("picture") != null) return metadata.get("picture").toString();
        }
        return null;
    }

    public boolean isAnonymous(JWTClaimsSet claims) {
        if (claims != null) {
            try {
                Boolean isAnon = claims.getBooleanClaim("is_anonymous");
                return Boolean.TRUE.equals(isAnon);
            } catch (Exception e) {
                return false;
            }
        }
        return false;
    }

    // ========================================================
    // OVERLOAD HỖ TRỢ TRUYỀN TOKEN TRỰC TIẾP
    // ========================================================

    public String extractSubject(String token) {
        return extractSubject(getClaims(token));
    }

    public UUID extractUserId(String token) {
        return extractUserId(getClaims(token));
    }

    public String extractEmail(String token) {
        return extractEmail(getClaims(token));
    }

    public String extractRole(String token) {
        return extractRole(getClaims(token));
    }

    public java.util.Map<String, Object> extractUserMetadata(String token) {
        return extractUserMetadata(getClaims(token));
    }

    public String extractFullName(String token) {
        return extractFullName(getClaims(token));
    }

    public String extractAvatarUrl(String token) {
        return extractAvatarUrl(getClaims(token));
    }

    public boolean isAnonymous(String token) {
        return isAnonymous(getClaims(token));
    }
}
