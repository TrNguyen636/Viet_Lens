package com.vietlens.service;

import com.vietlens.dto.HeritageResponseDTO;
import com.vietlens.entity.HeritageInfo;
import com.vietlens.repository.HeritageDistanceProjection;
import com.vietlens.repository.HeritageInfoRepository;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.server.ResponseStatusException;

import java.util.Collections;
import java.util.List;
import java.util.UUID;

/**
 * Service xử lý nghiệp vụ tra cứu, tìm kiếm và định vị di sản.
 */
@Slf4j
@Service
public class HeritageService {

    private final HeritageInfoRepository repository;
    private final com.vietlens.repository.HeritageTranslationRepository translationRepository;
    private final com.vietlens.repository.HeritageImageRepository imageRepository;

    public HeritageService(HeritageInfoRepository repository,
                           com.vietlens.repository.HeritageTranslationRepository translationRepository,
                           com.vietlens.repository.HeritageImageRepository imageRepository) {
        this.repository = repository;
        this.translationRepository = translationRepository;
        this.imageRepository = imageRepository;
    }

    private String normalizeLanguage(String lang) {
        if (lang != null) {
            String l = lang.trim().toLowerCase();
            if (l.startsWith("en")) {
                return "en";
            }
            if (l.startsWith("ja")) {
                return "ja";
            }
        }
        return "vi";
    }

    private java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> getTranslationsMap(java.util.Collection<UUID> ids, String lang) {
        if (ids == null || ids.isEmpty()) {
            return Collections.emptyMap();
        }
        String targetLang = normalizeLanguage(lang);
        try {
            return translationRepository.findByHeritageIdInAndLanguageCode(ids, targetLang)
                    .stream()
                    .collect(java.util.stream.Collectors.toMap(
                            com.vietlens.entity.HeritageTranslation::getHeritageId,
                            t -> t,
                            (existing, replacing) -> existing
                    ));
        } catch (Exception e) {
            log.warn("Chưa tải được bản dịch heritage_translations (dùng fallback tiếng Việt): {}", e.getMessage());
            return Collections.emptyMap();
        }
    }

    /**
     * Lấy toàn bộ danh sách di sản (hỗ trợ đa ngôn ngữ)
     */
    @Transactional(readOnly = true)
    public List<HeritageResponseDTO> getAllHeritage(String lang) {
        List<HeritageInfo> list = repository.findAllAllowed();
        List<UUID> ids = list.stream().map(HeritageInfo::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return list.stream()
                .map(h -> HeritageResponseDTO.fromEntityAndTranslation(h, transMap.get(h.getId())))
                .toList();
    }

    /**
     * Lấy danh sách di sản có hỗ trợ phân trang Pageable và đa ngôn ngữ
     */
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<HeritageResponseDTO> getAllHeritage(org.springframework.data.domain.Pageable pageable, String lang) {
        org.springframework.data.domain.Page<HeritageInfo> page = repository.findAllAllowed(pageable);
        List<UUID> ids = page.getContent().stream().map(HeritageInfo::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return page.map(h -> HeritageResponseDTO.fromEntityAndTranslation(h, transMap.get(h.getId())));
    }

    /**
     * Tìm kiếm di sản theo từ khóa và đa ngôn ngữ (hỗ trợ cả tiếng Việt, tiếng Nhật, tiếng Anh)
     */
    @Transactional(readOnly = true)
    public List<HeritageResponseDTO> searchHeritage(String keyword, String lang) {
        if (keyword == null || keyword.trim().isBlank()) {
            return Collections.emptyList();
        }
        String targetLang = normalizeLanguage(lang);
        List<HeritageInfo> list = repository.searchAllowedByKeywordAndLang(keyword.trim(), targetLang);
        List<UUID> ids = list.stream().map(HeritageInfo::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return list.stream()
                .map(h -> HeritageResponseDTO.fromEntityAndTranslation(h, transMap.get(h.getId())))
                .toList();
    }

    /**
     * Tìm kiếm di sản có hỗ trợ phân trang Pageable và đa ngôn ngữ
     */
    @Transactional(readOnly = true)
    public org.springframework.data.domain.Page<HeritageResponseDTO> searchHeritage(String keyword, org.springframework.data.domain.Pageable pageable, String lang) {
        if (keyword == null || keyword.trim().isBlank()) {
            return org.springframework.data.domain.Page.empty(pageable);
        }
        String targetLang = normalizeLanguage(lang);
        org.springframework.data.domain.Page<HeritageInfo> page = repository.searchAllowedByKeywordAndLang(keyword.trim(), targetLang, pageable);
        List<UUID> ids = page.getContent().stream().map(HeritageInfo::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return page.map(h -> HeritageResponseDTO.fromEntityAndTranslation(h, transMap.get(h.getId())));
    }

    /**
     * Lấy chi tiết 1 di sản theo UUID và đa ngôn ngữ
     */
    @Transactional(readOnly = true)
    public HeritageResponseDTO getById(UUID id, String lang) {
        HeritageInfo heritage = repository.findById(id)
                .orElseThrow(() -> new ResponseStatusException(
                        HttpStatus.NOT_FOUND, "Không tìm thấy di sản với ID: " + id));

        String targetLang = normalizeLanguage(lang);
        com.vietlens.entity.HeritageTranslation translation = null;
        try {
            translation = translationRepository.findByHeritageIdAndLanguageCode(id, targetLang).orElse(null);
        } catch (Exception e) {
            log.warn("Chưa tìm thấy bản dịch cho di sản {}: {}", id, e.getMessage());
        }

        HeritageResponseDTO dto = HeritageResponseDTO.fromEntityAndTranslation(heritage, translation);
        try {
            List<String> gallery = imageRepository.findByHeritageIdOrderByDisplayOrderAsc(id)
                    .stream()
                    .map(com.vietlens.entity.HeritageImage::getImageUrl)
                    .filter(url -> url != null && !url.isBlank())
                    .toList();
            dto.setGalleryImages(gallery);
        } catch (Exception e) {
            log.warn("Chưa tải được gallery images cho di sản {}: {}", id, e.getMessage());
        }

        return dto;
    }

    /**
     * Lấy các di sản lân cận cho Carousel Bản đồ (kèm đa ngôn ngữ)
     */
    @Transactional(readOnly = true)
    public List<HeritageResponseDTO> getNearby(Double lat, Double lng, Double radius, Integer limit, String lang) {
        if (lat == null || lng == null) {
            throw new ResponseStatusException(HttpStatus.BAD_REQUEST, "Tọa độ lat và lng là bắt buộc!");
        }

        double safeRadius = (radius != null && radius > 0) ? Math.min(radius, 200.0) : 10.0;
        int safeLimit = (limit != null && limit > 0) ? Math.min(limit, 100) : 20;

        double degLat = safeRadius / 111.0;
        double cosLat = Math.max(0.1, Math.cos(Math.toRadians(lat)));
        double degLng = safeRadius / (111.0 * cosLat);

        double minLat = lat - degLat;
        double maxLat = lat + degLat;
        double minLng = lng - degLng;
        double maxLng = lng + degLng;

        List<HeritageDistanceProjection> results = repository.findNearbyWithBoundingBox(
                lat, lng, minLat, maxLat, minLng, maxLng, safeRadius, safeLimit
        );

        List<UUID> ids = results.stream().map(HeritageDistanceProjection::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return results.stream()
                .map(p -> HeritageResponseDTO.fromProjectionAndTranslation(p, transMap.get(p.getId())))
                .toList();
    }

    /**
     * Lấy danh sách di sản theo khung nhìn Bounding Box cho Google Maps (Bước 3)
     */
    @Transactional(readOnly = true)
    public List<HeritageResponseDTO> getByBoundingBox(Double minLat, Double minLng, Double maxLat, Double maxLng, Integer limit, String lang) {
        if (minLat == null || minLng == null || maxLat == null || maxLng == null) {
            return List.of();
        }
        int safeLimit = (limit != null && limit > 0) ? Math.min(limit, 300) : 100;
        double actualMinLat = Math.min(minLat, maxLat);
        double actualMaxLat = Math.max(minLat, maxLat);
        double actualMinLng = Math.min(minLng, maxLng);
        double actualMaxLng = Math.max(minLng, maxLng);

        List<HeritageInfo> entities = repository.findByBoundingBox(actualMinLat, actualMinLng, actualMaxLat, actualMaxLng, safeLimit);
        List<UUID> ids = entities.stream().map(HeritageInfo::getId).toList();
        java.util.Map<UUID, com.vietlens.entity.HeritageTranslation> transMap = getTranslationsMap(ids, lang);

        return entities.stream()
                .map(e -> HeritageResponseDTO.fromEntityAndTranslation(e, transMap.get(e.getId())))
                .toList();
    }
}
