package com.vietlens.entity;

import jakarta.persistence.*;
import lombok.Data;
import java.util.UUID;

@Data // Anotation của Lombok giúp tự động tạo Get/Set
@Entity
@Table(name = "heritage_info")
public class HeritageInfo {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;

    private String name;

    @Column(columnDefinition = "TEXT")
    private String description;

    private String category;
    private String province;
    private String address;
    private Double latitude;
    private Double longitude;

    @Column(name = "image_url")
    private String imageUrl;
}