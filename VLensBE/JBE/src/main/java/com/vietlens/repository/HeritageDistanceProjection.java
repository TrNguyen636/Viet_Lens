package com.vietlens.repository;

import java.util.UUID;

/**
 * Projection hứng kết quả trả về từ Native Query tính khoảng cách Haversine.
 */
public interface HeritageDistanceProjection {
    UUID getId();
    String getName();
    String getDescription();
    String getCategory();
    String getProvince();
    String getAddress();
    Double getLatitude();
    Double getLongitude();
    String getImageUrl();
    Double getDistance();
}
