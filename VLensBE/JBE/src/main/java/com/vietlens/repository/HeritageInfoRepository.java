package com.vietlens.repository;

import com.vietlens.entity.HeritageInfo;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface HeritageInfoRepository extends JpaRepository<HeritageInfo, UUID> {

    String ALLOWED_CATEGORY_CONDITION = """
        (h.category IS NULL OR (
            LOWER(h.category) NOT LIKE '%ẩm thực%' AND
            LOWER(h.category) NOT LIKE '%am thuc%' AND
            LOWER(h.category) NOT LIKE '%lễ hội%' AND
            LOWER(h.category) NOT LIKE '%le hoi%'
        ))
    """;

    String KEYWORD_LANG_CONDITION = """
        (
            LOWER(h.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
            LOWER(h.address) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
            LOWER(h.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
            LOWER(h.province) LIKE LOWER(CONCAT('%', :keyword, '%')) OR
            (ht.name IS NOT NULL AND LOWER(ht.name) LIKE LOWER(CONCAT('%', :keyword, '%'))) OR
            (ht.description IS NOT NULL AND LOWER(ht.description) LIKE LOWER(CONCAT('%', :keyword, '%')))
        )
    """;

    /**
     * Lấy toàn bộ danh sách di sản hợp lệ (đã lọc trực tiếp trên SQL)
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " + ALLOWED_CATEGORY_CONDITION)
    List<HeritageInfo> findAllAllowed();

    /**
     * Lấy danh sách di sản hợp lệ có hỗ trợ phân trang Pageable (Chống nghẽn RAM Heap)
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " + ALLOWED_CATEGORY_CONDITION)
    Page<HeritageInfo> findAllAllowed(Pageable pageable);

    /**
     * Tìm kiếm địa danh đa ngôn ngữ (tìm kiếm trên cả heritage_info và heritage_translations)
     */
    @Query("SELECT DISTINCT h FROM HeritageInfo h " +
           "LEFT JOIN HeritageTranslation ht ON ht.heritageId = h.id AND ht.languageCode = :lang " +
           "WHERE " + ALLOWED_CATEGORY_CONDITION + " AND " + KEYWORD_LANG_CONDITION)
    List<HeritageInfo> searchAllowedByKeywordAndLang(@Param("keyword") String keyword, @Param("lang") String lang);

    /**
     * Tìm kiếm địa danh đa ngôn ngữ có phân trang
     */
    @Query(
        value = "SELECT DISTINCT h FROM HeritageInfo h " +
                "LEFT JOIN HeritageTranslation ht ON ht.heritageId = h.id AND ht.languageCode = :lang " +
                "WHERE " + ALLOWED_CATEGORY_CONDITION + " AND " + KEYWORD_LANG_CONDITION,
        countQuery = "SELECT COUNT(DISTINCT h) FROM HeritageInfo h " +
                     "LEFT JOIN HeritageTranslation ht ON ht.heritageId = h.id AND ht.languageCode = :lang " +
                     "WHERE " + ALLOWED_CATEGORY_CONDITION + " AND " + KEYWORD_LANG_CONDITION
    )
    Page<HeritageInfo> searchAllowedByKeywordAndLang(@Param("keyword") String keyword, @Param("lang") String lang, Pageable pageable);


    /**
     * Tính khoảng cách đường chim bay bằng công thức Haversine (Native Query PostgreSQL)
     * ĐÃ TỐI ƯU HÓA: Sử dụng Bounding Box Pre-filter (minLat/maxLat, minLng/maxLng)
     * để loại bỏ 90-95% số dòng không thuộc phạm vi trước khi tính hàm lượng giác đắt đỏ acos.
     */
    @Query(value = """
        SELECT 
            h.id AS id, 
            h.name AS name, 
            h.description AS description, 
            h.category AS category, 
            h.province AS province, 
            h.address AS address, 
            h.latitude AS latitude, 
            h.longitude AS longitude, 
            h.image_url AS "imageUrl", 
            (6371 * acos(
                LEAST(1.0, GREATEST(-1.0, 
                    cos(radians(:lat)) * cos(radians(h.latitude)) * cos(radians(h.longitude) - radians(:lng)) +
                    sin(radians(:lat)) * sin(radians(h.latitude))
                ))
            )) AS distance
        FROM heritage_info h
        WHERE h.latitude BETWEEN :minLat AND :maxLat
          AND h.longitude BETWEEN :minLng AND :maxLng
          AND (h.category IS NULL OR (
              LOWER(h.category) NOT LIKE '%ẩm thực%'
              AND LOWER(h.category) NOT LIKE '%am thuc%'
              AND LOWER(h.category) NOT LIKE '%lễ hội%'
              AND LOWER(h.category) NOT LIKE '%le hoi%'
          ))
          AND (6371 * acos(
                LEAST(1.0, GREATEST(-1.0, 
                    cos(radians(:lat)) * cos(radians(h.latitude)) * cos(radians(h.longitude) - radians(:lng)) +
                    sin(radians(:lat)) * sin(radians(h.latitude))
                ))
          )) <= :radius
        ORDER BY distance ASC
        LIMIT :limit
        """, nativeQuery = true)
    List<HeritageDistanceProjection> findNearbyWithBoundingBox(
            @Param("lat") double lat,
            @Param("lng") double lng,
            @Param("minLat") double minLat,
            @Param("maxLat") double maxLat,
            @Param("minLng") double minLng,
            @Param("maxLng") double maxLng,
            @Param("radius") double radius,
            @Param("limit") int limit
    );

    /**
     * Lấy danh sách địa danh trong khung nhìn Bounding Box phục vụ Google Maps (Bước 3)
     */
    @Query(value = """
        SELECT h.* FROM heritage_info h
        WHERE h.latitude BETWEEN :minLat AND :maxLat
          AND h.longitude BETWEEN :minLng AND :maxLng
          AND (h.category IS NULL OR (
              LOWER(h.category) NOT LIKE '%ẩm thực%'
              AND LOWER(h.category) NOT LIKE '%am thuc%'
              AND LOWER(h.category) NOT LIKE '%lễ hội%'
              AND LOWER(h.category) NOT LIKE '%le hoi%'
          ))
        LIMIT :limit
        """, nativeQuery = true)
    List<HeritageInfo> findByBoundingBox(
            @Param("minLat") double minLat,
            @Param("minLng") double minLng,
            @Param("maxLat") double maxLat,
            @Param("maxLng") double maxLng,
            @Param("limit") int limit
    );
}