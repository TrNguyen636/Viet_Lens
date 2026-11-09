/**
 * 🗺️ THUẬT TOÁN TÌM ĐƯỜNG DIJKSTRA & HỆ THỐNG DẪN ĐƯỜNG THỰC TẾ VIETLENS
 * 
 * Module này cung cấp:
 * 1. Cài đặt chuẩn giải thuật Dijkstra với Hàng đợi ưu tiên (Min-Priority Queue).
 * 2. Thuật toán Nắn khớp tọa độ GPS lên tim đường (Map-Matching / Orthogonal Projection).
 * 3. Thuật toán Phát hiện lệch lộ trình (Off-Route Detection) để tự động kích hoạt Dijkstra tìm lại đường mới.
 * 4. Thuật toán Tính góc rẽ & Chỉ dẫn chuyển hướng (Turn-by-turn Vector Bearing).
 */

// 1. Tính khoảng cách địa lý Haversine (km) giữa 2 tọa độ
export function haversineDistanceKm(lat1, lon1, lat2, lon2) {
  const R = 6371.0;
  const dLat = ((lat2 - lat1) * Math.PI) / 180.0;
  const dLon = ((lon2 - lon1) * Math.PI) / 180.0;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180.0) *
      Math.cos((lat2 * Math.PI) / 180.0) *
      Math.sin(dLon / 2) *
      Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

// 2. Tính khoảng cách vuông góc (mét) từ điểm P đến đoạn thẳng AB
export function perpendicularDistanceMeters(p, a, b) {
  const latMid = ((a.lat + b.lat) / 2.0) * (Math.PI / 180.0);
  const mPerDegLat = 111132.92;
  const mPerDegLng = 111412.84 * Math.cos(latMid);

  const xA = a.lng * mPerDegLng;
  const yA = a.lat * mPerDegLat;
  const xB = b.lng * mPerDegLng;
  const yB = b.lat * mPerDegLat;
  const xP = p.lng * mPerDegLng;
  const yP = p.lat * mPerDegLat;

  const dx = xB - xA;
  const dy = yB - yA;

  if (dx === 0 && dy === 0) {
    return Math.hypot(xP - xA, yP - yA);
  }

  // Chiếu điểm P lên đoạn thẳng AB với hệ số t clamped trong [0, 1]
  const t = Math.max(0, Math.min(1, ((xP - xA) * dx + (yP - yA) * dy) / (dx * dx + dy * dy)));
  const xProj = xA + t * dx;
  const yProj = yA + t * dy;

  return Math.hypot(xP - xProj, yP - yProj);
}

// 3. Tính góc phương vị (Bearing) giữa 2 điểm (0° - 360°)
export function calculateBearing(lat1, lon1, lat2, lon2) {
  const φ1 = (lat1 * Math.PI) / 180;
  const φ2 = (lat2 * Math.PI) / 180;
  const Δλ = ((lon2 - lon1) * Math.PI) / 180;

  const y = Math.sin(Δλ) * Math.cos(φ2);
  const x = Math.cos(φ1) * Math.sin(φ2) - Math.sin(φ1) * Math.cos(φ2) * Math.cos(Δλ);
  const θ = Math.atan2(y, x);
  return ((θ * 180) / Math.PI + 360) % 360;
}

/**
 * 4. Thuật toán Nắn Khớp Tọa Độ (Map-Matching / Snapping)
 * Tìm điểm chiếu vuông góc của vị trí người dùng lên tuyến đường gần nhất
 */
export function snapToRoute(userLat, userLng, routePoints) {
  if (!Array.isArray(routePoints) || routePoints.length === 0) {
    return { snappedLat: userLat, snappedLng: userLng, distanceMeters: 0, segmentIndex: 0 };
  }

  const p = { lat: userLat, lng: userLng };
  let minDistanceMeters = Infinity;
  let bestPoint = { lat: userLat, lng: userLng };
  let bestSegmentIndex = 0;

  for (let i = 0; i < routePoints.length - 1; i++) {
    const a = { lat: Number(routePoints[i].lat ?? routePoints[i].latitude), lng: Number(routePoints[i].lng ?? routePoints[i].longitude) };
    const b = { lat: Number(routePoints[i + 1].lat ?? routePoints[i + 1].latitude), lng: Number(routePoints[i + 1].lng ?? routePoints[i + 1].longitude) };

    const distMeters = perpendicularDistanceMeters(p, a, b);
    if (distMeters < minDistanceMeters) {
      minDistanceMeters = distMeters;
      bestSegmentIndex = i;

      // Tính điểm chiếu
      const latMid = ((a.lat + b.lat) / 2.0) * (Math.PI / 180.0);
      const mPerDegLat = 111132.92;
      const mPerDegLng = 111412.84 * Math.cos(latMid);

      const dx = (b.lng - a.lng) * mPerDegLng;
      const dy = (b.lat - a.lat) * mPerDegLat;
      const t = Math.max(0, Math.min(1, (((p.lng - a.lng) * mPerDegLng) * dx + ((p.lat - a.lat) * mPerDegLat) * dy) / (dx * dx + dy * dy)));

      bestPoint = {
        lat: a.lat + (t * dy) / mPerDegLat,
        lng: a.lng + (t * dx) / mPerDegLng,
      };
    }
  }

  return {
    snappedLat: bestPoint.lat,
    snappedLng: bestPoint.lng,
    distanceMeters: minDistanceMeters,
    segmentIndex: bestSegmentIndex,
  };
}

/**
 * 7. Kiểm tra người dùng có đang đi chệch khỏi tuyến đường không (Off-Route)
 * Ngưỡng mặc định 35 mét
 */
export function isOffRoute(userLat, userLng, routePoints, thresholdMeters = 35) {
  if (!Array.isArray(routePoints) || routePoints.length < 2) return false;
  const { distanceMeters } = snapToRoute(userLat, userLng, routePoints);
  return distanceMeters > thresholdMeters;
}

/**
 * 8. Thuật toán Chỉ Dẫn Chuyển Hướng (Turn Guidance)
 * Dựa vào độ lệch góc phương vị Delta Theta để xác định: Đi thẳng, Rẽ trái, Rẽ phải, Vòng đầu xe
 */
export function getTurnInstruction(currentHeading, nextPoint, afterNextPoint) {
  if (!nextPoint || !afterNextPoint) {
    return { icon: 'navigate', text: 'Tiếp tục đi thẳng', action: 'straight' };
  }

  const targetBearing = calculateBearing(
    Number(nextPoint.lat ?? nextPoint.latitude),
    Number(nextPoint.lng ?? nextPoint.longitude),
    Number(afterNextPoint.lat ?? afterNextPoint.latitude),
    Number(afterNextPoint.lng ?? afterNextPoint.longitude)
  );

  let deltaAngle = (targetBearing - currentHeading + 540) % 360 - 180;

  if (Math.abs(deltaAngle) <= 22) {
    return { icon: 'arrow-up', text: 'Đi thẳng', action: 'straight', deltaAngle };
  } else if (deltaAngle > 22 && deltaAngle <= 125) {
    return { icon: 'arrow-forward', text: 'Chuẩn bị rẽ phải', action: 'right', deltaAngle };
  } else if (deltaAngle < -22 && deltaAngle >= -125) {
    return { icon: 'arrow-back', text: 'Chuẩn bị rẽ trái', action: 'left', deltaAngle };
  } else {
    return { icon: 'return-up-back', text: 'Vòng đầu xe khi có thể', action: 'u_turn', deltaAngle };
  }
}
