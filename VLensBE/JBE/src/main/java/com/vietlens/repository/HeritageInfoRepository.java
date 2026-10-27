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

    /**
     * Lấy toàn bộ danh sách di sản hợp lệ (đã lọc trực tiếp trên SQL)
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " +
           "(h.category IS NULL OR (" +
           "LOWER(h.category) NOT LIKE '%ẩm thực%' AND " +
           "LOWER(h.category) NOT LIKE '%am thuc%' AND " +
           "LOWER(h.category) NOT LIKE '%lễ hội%' AND " +
           "LOWER(h.category) NOT LIKE '%le hoi%'))")
    List<HeritageInfo> findAllAllowed();

    /**
     * Lấy danh sách di sản hợp lệ có hỗ trợ phân trang Pageable (Chống nghẽn RAM Heap)
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " +
           "(h.category IS NULL OR (" +
           "LOWER(h.category) NOT LIKE '%ẩm thực%' AND " +
           "LOWER(h.category) NOT LIKE '%am thuc%' AND " +
           "LOWER(h.category) NOT LIKE '%lễ hội%' AND " +
           "LOWER(h.category) NOT LIKE '%le hoi%'))")
    Page<HeritageInfo> findAllAllowed(Pageable pageable);

    /**
     * Tìm kiếm địa danh hợp lệ theo từ khóa (tên, địa chỉ, mô tả, tỉnh thành)
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " +
           "((h.category IS NULL OR (" +
           "LOWER(h.category) NOT LIKE '%ẩm thực%' AND " +
           "LOWER(h.category) NOT LIKE '%am thuc%' AND " +
           "LOWER(h.category) NOT LIKE '%lễ hội%' AND " +
           "LOWER(h.category) NOT LIKE '%le hoi%'))) AND (" +
           "LOWER(h.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.address) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.province) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    List<HeritageInfo> searchAllowedByKeyword(@Param("keyword") String keyword);

    /**
     * Tìm kiếm địa danh có phân trang
     */
    @Query("SELECT h FROM HeritageInfo h WHERE " +
           "((h.category IS NULL OR (" +
           "LOWER(h.category) NOT LIKE '%ẩm thực%' AND " +
           "LOWER(h.category) NOT LIKE '%am thuc%' AND " +
           "LOWER(h.category) NOT LIKE '%lễ hội%' AND " +
           "LOWER(h.category) NOT LIKE '%le hoi%'))) AND (" +
           "LOWER(h.name) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.address) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.description) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
           "LOWER(h.province) LIKE LOWER(CONCAT('%', :keyword, '%')))")
    Page<HeritageInfo> searchAllowedByKeyword(@Param("keyword") String keyword, Pageable pageable);


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
}