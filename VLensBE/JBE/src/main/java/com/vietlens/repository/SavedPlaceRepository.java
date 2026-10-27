package com.vietlens.repository;

import com.vietlens.entity.HeritageInfo;
import com.vietlens.entity.SavedPlaceEntity;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface SavedPlaceRepository extends JpaRepository<SavedPlaceEntity, UUID> {

    Optional<SavedPlaceEntity> findByUserIdAndHeritageId(UUID userId, UUID heritageId);

    boolean existsByUserIdAndHeritageId(UUID userId, UUID heritageId);

    void deleteByUserIdAndHeritageId(UUID userId, UUID heritageId);

    /**
     * Lấy toàn bộ danh sách di sản mà user đã bookmark (sắp xếp mới nhất lên đầu).
     */
    @Query("SELECT s.heritage FROM SavedPlaceEntity s WHERE s.userId = :userId ORDER BY s.createdAt DESC")
    List<HeritageInfo> findSavedHeritagesByUserId(@Param("userId") UUID userId);

    long countByUserId(UUID userId);
}
