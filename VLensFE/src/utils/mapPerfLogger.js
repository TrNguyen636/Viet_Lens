/**
 * MapPerfLogger (JS Version cho Expo Go - Bước 6)
 * Ghi log thời gian khởi tạo, tải map lần 1 & lần 2, độ trễ API BBox và Douglas-Peucker.
 */
class MapPerfLogger {
  constructor() {
    this.mapOpenTime = 0;
    this.loadCount = 0;
    this.firstLoadDuration = 0;
    this.secondLoadDuration = 0;
  }

  recordMapOpen() {
    this.mapOpenTime = Date.now();
    console.log(`[MapPerfLogger] [MAP_OPEN] Map mounted at ${this.mapOpenTime} (count=${this.loadCount})`);
  }

  recordMapLoaded(durationMs) {
    this.loadCount++;
    const duration = durationMs || (Date.now() - this.mapOpenTime);
    if (this.loadCount === 1) {
      this.firstLoadDuration = Math.round(duration);
      console.log(`%c[MapPerfLogger] [MAP_LOAD_1ST] First map load completed in ${this.firstLoadDuration}ms`, 'color: #10b981; font-weight: bold;');
    } else {
      this.secondLoadDuration = Math.round(duration);
      console.log(`%c[MapPerfLogger] [MAP_LOAD_2ND] Subsequent map load (#${this.loadCount}) completed in ${this.secondLoadDuration}ms`, 'color: #3b82f6; font-weight: bold;');
    }
  }

  logBBoxApiLatency(durationMs, isCacheHit, markerCount, bboxStr) {
    const source = isCacheHit ? 'LOCAL_CACHE' : 'BACKEND_NETWORK';
    console.log(
      `%c[MapPerfLogger] [BBOX_API] Source: ${source} | Latency: ${durationMs}ms | Markers: ${markerCount} | BBox: ${bboxStr}`,
      isCacheHit ? 'color: #8b5cf6;' : 'color: #f59e0b;'
    );
  }

  logRouteSimplify(pointsBefore, pointsAfter, durationMs) {
    const reduction = pointsBefore > 0 ? (((pointsBefore - pointsAfter) / pointsBefore) * 100).toFixed(1) : 0;
    console.log(
      `%c[MapPerfLogger] [ROUTE_SIMPLIFY] Douglas-Peucker: ${pointsBefore} -> ${pointsAfter} pts (reduced ${reduction}%) in ${durationMs}ms`,
      'color: #ec4899; font-weight: bold;'
    );
  }

  getSummary() {
    return {
      firstLoadDuration: this.firstLoadDuration,
      secondLoadDuration: this.secondLoadDuration,
      loadCount: this.loadCount,
    };
  }
}

export const mapPerfLogger = new MapPerfLogger();
export default mapPerfLogger;
