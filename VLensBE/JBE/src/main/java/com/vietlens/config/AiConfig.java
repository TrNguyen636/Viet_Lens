package com.vietlens.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.client.SimpleClientHttpRequestFactory;
import org.springframework.web.client.RestTemplate;

/**
 * Cấu hình RestTemplate để kết nối Groq AI API.
 * Spring Boot tự động cung cấp ObjectMapper đã tích hợp sẵn hỗ trợ LocalDateTime và ISO-8601.
 */
@Configuration
public class AiConfig {

    @Bean
    public RestTemplate restTemplate() {
        SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
        factory.setConnectTimeout(15000); // 15 giây kết nối
        factory.setReadTimeout(45000);    // 45 giây chờ phản hồi từ Groq
        return new RestTemplate(factory);
    }
}
