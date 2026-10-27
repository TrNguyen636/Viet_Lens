package com.vietlens.entity;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.time.OffsetDateTime;
import java.util.UUID;

/**
 * Entity lưu trữ bản dịch đa ngôn ngữ cho di sản (heritage_translations).
 */
@Getter
@Setter
@Entity
@Table(
        name = "heritage_translations",
        uniqueConstraints = {
                @UniqueConstraint(name = "uq_heritage_language", columnNames = {"heritage_id", "language_code"})
        }
)
public class HeritageTranslation {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    @Column(name = "heritage_id", nullable = false)
    private UUID heritageId;

    @Column(name = "language_code", nullable = false, length = 10)
    private String languageCode;

    @Column(nullable = false)
    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String category;
    private String province;
    private String address;

    @Column(name = "created_at")
    private OffsetDateTime createdAt;

    @Column(name = "updated_at")
    private OffsetDateTime updatedAt;

    public HeritageTranslation() {
    }

    public HeritageTranslation(UUID id, UUID heritageId, String languageCode, String name,
                               String description, String category, String province, String address,
                               OffsetDateTime createdAt, OffsetDateTime updatedAt) {
        this.id = id;
        this.heritageId = heritageId;
        this.languageCode = languageCode;
        this.name = name;
        this.description = description;
        this.category = category;
        this.province = province;
        this.address = address;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }
}
