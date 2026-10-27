package com.vietlens.repository;

import com.vietlens.entity.HeritageTranslation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Collection;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

@Repository
public interface HeritageTranslationRepository extends JpaRepository<HeritageTranslation, UUID> {

    /**
     * Tìm bản dịch theo mã di sản và mã ngôn ngữ (vd: 'vi', 'en')
     */
    Optional<HeritageTranslation> findByHeritageIdAndLanguageCode(UUID heritageId, String languageCode);

    /**
     * Tìm tập hợp bản dịch cho danh sách mã di sản theo mã ngôn ngữ
     */
    List<HeritageTranslation> findByHeritageIdInAndLanguageCode(Collection<UUID> heritageIds, String languageCode);
}
