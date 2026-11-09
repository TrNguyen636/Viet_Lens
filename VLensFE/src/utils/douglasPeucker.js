import { perpendicularDistanceMeters } from './dijkstraRouter';

/**
 * Thuật toán đơn giản hoá đa tuyến Douglas-Peucker (RDP) cho React Native (Bước 4)
 * Nén số lượng đỉnh toạ độ trước khi vẽ Polyline trên Google Maps.
 */
export function simplifyDouglasPeucker(points, toleranceMeters = 5.0) {
  if (!Array.isArray(points) || points.length <= 2) {
    return points || [];
  }

  let maxDistance = 0.0;
  let maxIndex = 0;

  const first = points[0];
  const last = points[points.length - 1];

  for (let i = 1; i < points.length - 1; i++) {
    const dist = perpendicularDistanceMeters(points[i], first, last);
    if (dist > maxDistance) {
      maxDistance = dist;
      maxIndex = i;
    }
  }

  if (maxDistance > toleranceMeters) {
    const left = simplifyDouglasPeucker(points.slice(0, maxIndex + 1), toleranceMeters);
    const right = simplifyDouglasPeucker(points.slice(maxIndex), toleranceMeters);
    return left.slice(0, -1).concat(right);
  } else {
    return [first, last];
  }
}

export default simplifyDouglasPeucker;
