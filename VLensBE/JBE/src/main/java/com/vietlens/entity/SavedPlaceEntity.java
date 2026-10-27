package com.vietlens.entity;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entity bảng trung gian lưu địa danh yêu thích của người dùng (Saved / Bookmark Place).
 */
@Getter
@Setter
@Entity
@Builder
@Table(name = "saved_places", uniqueConstraints = {
        @UniqueConstraint(name = "uk_saved_place_user_heritage", columnNames = {"user_id", "heritage_id"})
})
public class SavedPlaceEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(name = "user_id", nullable = false)
    private UUID userId;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "heritage_id", nullable = false)
    private HeritageInfo heritage;

    @CreationTimestamp
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    public SavedPlaceEntity() {
    }

    public SavedPlaceEntity(UUID id, UUID userId, HeritageInfo heritage, LocalDateTime createdAt) {
        this.id = id;
        this.userId = userId;
        this.heritage = heritage;
        this.createdAt = createdAt;
    }
}
