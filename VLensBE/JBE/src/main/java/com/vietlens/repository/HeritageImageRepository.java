package com.vietlens.repository;

import com.vietlens.entity.HeritageImage;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.UUID;

@Repository
public interface HeritageImageRepository extends JpaRepository<HeritageImage, UUID> {
    List<HeritageImage> findByHeritageIdOrderByDisplayOrderAsc(UUID heritageId);
    List<HeritageImage> findByHeritageIdIn(List<UUID> heritageIds);
}
