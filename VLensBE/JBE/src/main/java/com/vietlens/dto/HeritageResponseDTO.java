package com.vietlens.dto;

import com.vietlens.entity.HeritageInfo;
import com.vietlens.repository.HeritageDistanceProjection;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * DTO đại diện cho thông tin di sản trả về cho Frontend,
 * có bổ sung thêm trường 'distance' (khoảng cách tính bằng km) cho màn hình bản đồ/carousel.
 */
@Data
@Builder
public class HeritageResponseDTO {
    private UUID id;
    private String name;
    private String description;
    private String category;
    private String province;
    private String address;
    private Double latitude;
    private Double longitude;
    private String imageUrl;
    private Double distance; // Khoảng cách tính bằng km (làm tròn 2 chữ số thập phân)

    public HeritageResponseDTO() {
    }

    public HeritageResponseDTO(UUID id, String name, String description, String category, String province, String address, Double latitude, Double longitude, String imageUrl, Double distance) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.category = category;
        this.province = province;
        this.address = address;
        this.latitude = latitude;
        this.longitude = longitude;
        this.imageUrl = imageUrl;
        this.distance = distance;
    }

    public static HeritageResponseDTO fromEntity(HeritageInfo entity) {
        if (entity == null) {
            return null;
        }
        return HeritageResponseDTO.builder()
                .id(entity.getId())
                .name(entity.getName())
                .description(entity.getDescription())
                .category(entity.getCategory())
                .province(entity.getProvince())
                .address(entity.getAddress())
                .latitude(entity.getLatitude())
                .longitude(entity.getLongitude())
                .imageUrl(entity.getImageUrl())
                .distance(null)
                .build();
    }

    public static HeritageResponseDTO fromProjection(HeritageDistanceProjection p) {
        if (p == null) {
            return null;
        }
        Double dist = p.getDistance();
        Double roundedDistance = (dist != null) ? Math.round(dist * 100.0) / 100.0 : null;

        return HeritageResponseDTO.builder()
                .id(p.getId())
                .name(p.getName())
                .description(p.getDescription())
                .category(p.getCategory())
                .province(p.getProvince())
                .address(p.getAddress())
                .latitude(p.getLatitude())
                .longitude(p.getLongitude())
                .imageUrl(p.getImageUrl())
                .distance(roundedDistance)
                .build();
    }

    public static HeritageResponseDTO fromEntityAndTranslation(HeritageInfo entity, com.vietlens.entity.HeritageTranslation translation) {
        if (entity == null) {
            return null;
        }
        return HeritageResponseDTO.builder()
                .id(entity.getId())
                .name(translation != null && translation.getName() != null && !translation.getName().isBlank() ? translation.getName() : entity.getName())
                .description(translation != null && translation.getDescription() != null && !translation.getDescription().isBlank() ? translation.getDescription() : entity.getDescription())
                .category(translation != null && translation.getCategory() != null && !translation.getCategory().isBlank() ? translation.getCategory() : entity.getCategory())
                .province(translation != null && translation.getProvince() != null && !translation.getProvince().isBlank() ? translation.getProvince() : entity.getProvince())
                .address(translation != null && translation.getAddress() != null && !translation.getAddress().isBlank() ? translation.getAddress() : entity.getAddress())
                .latitude(entity.getLatitude())
                .longitude(entity.getLongitude())
                .imageUrl(entity.getImageUrl())
                .distance(null)
                .build();
    }

    public static HeritageResponseDTO fromProjectionAndTranslation(HeritageDistanceProjection p, com.vietlens.entity.HeritageTranslation translation) {
        if (p == null) {
            return null;
        }
        Double dist = p.getDistance();
        Double roundedDistance = (dist != null) ? Math.round(dist * 100.0) / 100.0 : null;

        return HeritageResponseDTO.builder()
                .id(p.getId())
                .name(translation != null && translation.getName() != null && !translation.getName().isBlank() ? translation.getName() : p.getName())
                .description(translation != null && translation.getDescription() != null && !translation.getDescription().isBlank() ? translation.getDescription() : p.getDescription())
                .category(translation != null && translation.getCategory() != null && !translation.getCategory().isBlank() ? translation.getCategory() : p.getCategory())
                .province(translation != null && translation.getProvince() != null && !translation.getProvince().isBlank() ? translation.getProvince() : p.getProvince())
                .address(translation != null && translation.getAddress() != null && !translation.getAddress().isBlank() ? translation.getAddress() : p.getAddress())
                .latitude(p.getLatitude())
                .longitude(p.getLongitude())
                .imageUrl(p.getImageUrl())
                .distance(roundedDistance)
                .build();
    }
}

