package com.vietlens.controller;

import com.vietlens.dto.HeritageResponseDTO;
import com.vietlens.service.HeritageService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/heritage")
public class HeritageController {

    private final HeritageService service;

    public HeritageController(HeritageService service) {
        this.service = service;
    }

    /**
     * API lấy toàn bộ danh sách địa danh / di sản (hỗ trợ đa ngôn ngữ qua Accept-Language)
     * GET /api/heritage/all
     * - Hỗ trợ tham số phân trang tùy chọn ?page=0&size=20 (hoặc trả về List nếu không truyền)
     */
    @GetMapping("/all")
    public ResponseEntity<?> getAllHeritage(
            @RequestParam(value = "page", required = false) Integer page,
            @RequestParam(value = "size", required = false) Integer size,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang
    ) {
        if (page != null || size != null) {
            int p = (page != null && page >= 0) ? page : 0;
            int s = (size != null && size > 0) ? Math.min(size, 100) : 20;
            return ResponseEntity.ok(service.getAllHeritage(org.springframework.data.domain.PageRequest.of(p, s), lang));
        }
        return ResponseEntity.ok(service.getAllHeritage(lang));
    }

    /**
     * API Tìm kiếm: theo tên, địa chỉ hoặc mô tả (hỗ trợ đa ngôn ngữ)
     * GET /api/heritage/search?keyword=...
     * - Hỗ trợ phân trang tùy chọn ?keyword=...&page=0&size=20
     */
    @GetMapping("/search")
    public ResponseEntity<?> searchHeritage(
            @RequestParam(value = "keyword", required = false) String keyword,
            @RequestParam(value = "page", required = false) Integer page,
            @RequestParam(value = "size", required = false) Integer size,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang
    ) {
        if (page != null || size != null) {
            int p = (page != null && page >= 0) ? page : 0;
            int s = (size != null && size > 0) ? Math.min(size, 100) : 20;
            return ResponseEntity.ok(service.searchHeritage(keyword, org.springframework.data.domain.PageRequest.of(p, s), lang));
        }
        return ResponseEntity.ok(service.searchHeritage(keyword, lang));
    }


    /**
     * API Lấy di sản lân cận cho Carousel Bản đồ
     * GET /api/heritage/nearby?lat=...&lng=...&radius=10&limit=20
     * - lat, lng: bắt buộc
     * - radius: mặc định 10.0 (km)
     * - limit: mặc định 20 kết quả
     */
    @GetMapping("/nearby")
    public ResponseEntity<List<HeritageResponseDTO>> getNearby(
            @RequestParam("lat") Double lat,
            @RequestParam("lng") Double lng,
            @RequestParam(value = "radius", defaultValue = "10.0") Double radius,
            @RequestParam(value = "limit", defaultValue = "20") Integer limit,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang
    ) {
        return ResponseEntity.ok(service.getNearby(lat, lng, radius, limit, lang));
    }

    /**
     * API Lấy chi tiết 1 di sản theo UUID
     * GET /api/heritage/{id}
     */
    @GetMapping("/{id}")
    public ResponseEntity<HeritageResponseDTO> getById(
            @PathVariable("id") String id,
            @RequestHeader(value = "Accept-Language", defaultValue = "vi") String lang
    ) {
        try {
            UUID uuid = UUID.fromString(id);
            return ResponseEntity.ok(service.getById(uuid, lang));
        } catch (IllegalArgumentException e) {
            throw new org.springframework.web.server.ResponseStatusException(
                    org.springframework.http.HttpStatus.BAD_REQUEST, "ID di sản không đúng định dạng UUID: " + id);
        }
    }
}