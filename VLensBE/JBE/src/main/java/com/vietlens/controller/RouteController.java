package com.vietlens.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.client.RestTemplate;

import java.util.*;

/**
 * RouteController: Cung cấp API định tuyến nội bộ cho VietLens (Bước 4)
 * Endpoint: POST /api/routes
 * Ràng buộc: Toàn bộ do Backend cung cấp, KHÔNG dùng Google Directions/Routes API.
 */
@RestController
@RequestMapping("/api/routes")
public class RouteController {

    private final RestTemplate restTemplate;

    public RouteController(RestTemplate restTemplate) {
        this.restTemplate = restTemplate;
    }

    public record RouteRequest(
            Double originLat,
            Double originLng,
            Double destLat,
            Double destLng,
            String mode
    ) {}

    public record RoutePoint(Double latitude, Double longitude) {}

    public record RouteResponse(
            Double distanceKm,
            Integer durationMin,
            List<RoutePoint> points,
            String geometryPolyline,
            String source
    ) {}

    @PostMapping
    public ResponseEntity<RouteResponse> calculateRoute(@RequestBody RouteRequest request) {
        if (request.originLat() == null || request.originLng() == null ||
            request.destLat() == null || request.destLng() == null) {
            return ResponseEntity.badRequest().build();
        }

        String mode = (request.mode() != null && !request.mode().isBlank()) ? request.mode() : "driving";

        // 1. Thử gọi OSRM server nội bộ / công cộng từ Backend
        try {
            String osrmUrl = String.format(
                    Locale.US,
                    "https://router.project-osrm.org/route/v1/%s/%.6f,%.6f;%.6f,%.6f?overview=full&geometries=geojson",
                    mode, request.originLng(), request.originLat(), request.destLng(), request.destLat()
            );

            Map<?, ?> osrmResponse = restTemplate.getForObject(osrmUrl, Map.class);
            if (osrmResponse != null && osrmResponse.containsKey("routes")) {
                List<?> routes = (List<?>) osrmResponse.get("routes");
                if (!routes.isEmpty()) {
                    Map<?, ?> firstRoute = (Map<?, ?>) routes.get(0);
                    double distKm = Math.round(((Number) firstRoute.get("distance")).doubleValue() / 100.0) / 10.0;
                    int durMin = (int) Math.round(((Number) firstRoute.get("duration")).doubleValue() / 60.0);

                    Map<?, ?> geometry = (Map<?, ?>) firstRoute.get("geometry");
                    List<?> coordinates = (List<?>) geometry.get("coordinates");
                    List<RoutePoint> points = new ArrayList<>();

                    for (Object coordObj : coordinates) {
                        List<?> pair = (List<?>) coordObj;
                        double lng = ((Number) pair.get(0)).doubleValue();
                        double lat = ((Number) pair.get(1)).doubleValue();
                        points.add(new RoutePoint(lat, lng));
                    }

                    return ResponseEntity.ok(new RouteResponse(distKm, durMin, points, null, "OSRM_ENGINE"));
                }
            }
        } catch (Exception e) {
            // Log fallback nếu OSRM timeout / sandbox không có internet
            System.err.println("[RouteController] OSRM engine fallback: " + e.getMessage());
        }

        // 2. Dự phòng thuật toán nội suy Haversine nội bộ nếu OSRM không khả dụng
        double dLat = Math.toRadians(request.destLat() - request.originLat());
        double dLng = Math.toRadians(request.destLng() - request.originLng());
        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(Math.toRadians(request.originLat())) * Math.cos(Math.toRadians(request.destLat())) *
                Math.sin(dLng / 2) * Math.sin(dLng / 2);
        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        double distKm = Math.round((6371.0 * c) * 10.0) / 10.0;

        // Dự kiến 35 km/h lái xe, 4.5 km/h đi bộ
        double speed = "walking".equalsIgnoreCase(mode) ? 4.5 : ("cycling".equalsIgnoreCase(mode) ? 15.0 : 35.0);
        int durMin = Math.max(1, (int) Math.round((distKm / speed) * 60.0));

        // Tạo 10 điểm trung gian thẳng mượt
        List<RoutePoint> points = new ArrayList<>();
        int steps = 10;
        for (int i = 0; i <= steps; i++) {
            double frac = (double) i / steps;
            double lat = request.originLat() + (request.destLat() - request.originLat()) * frac;
            double lng = request.originLng() + (request.destLng() - request.originLng()) * frac;
            points.add(new RoutePoint(lat, lng));
        }

        return ResponseEntity.ok(new RouteResponse(distKm, durMin, points, null, "INTERNAL_FALLBACK_ENGINE"));
    }
}
