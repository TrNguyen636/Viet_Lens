import React, {
  useRef,
  useState,
  useEffect,
  useMemo,
  useCallback,
  forwardRef,
  useImperativeHandle,
} from 'react';
import { View, StyleSheet, ActivityIndicator } from 'react-native';
import { WebView } from 'react-native-webview';
import { THEME } from '../utils/theme';
import { MAP_CONFIG, getCategoryMeta } from '../utils/mapConfig';

/**
 * Tạo mã HTML động chứa MapLibre GL JS, PMTiles Protocol, OSRM Routing và POI Di tích OSM
 */
function generateMapHTML(pmtilesUrl, fallbackUrl, initialTheme = 'vietlens', is3D = true) {
  return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <link rel="stylesheet" href="https://unpkg.com/maplibre-gl@4.7.1/dist/maplibre-gl.css" />
  <script src="https://unpkg.com/maplibre-gl@4.7.1/dist/maplibre-gl.js"></script>
  <script src="https://unpkg.com/pmtiles@3.2.0/dist/pmtiles.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body, html, #map { width: 100%; height: 100%; overflow: hidden; -webkit-tap-highlight-color: transparent; }
    
    /* Neo cố định tọa độ MapLibre (Không có transition trên transform để chống trôi dạt) */
    .map-marker-anchor {
      width: 0;
      height: 0;
      position: absolute;
      cursor: pointer;
    }
    
    /* Đồ họa Ghim Di sản (Hình giọt nước xoay, cắm mỏ nhọn chính xác vào tọa độ) */
    .supabase-marker-pin {
      width: 32px;
      height: 32px;
      border-radius: 50% 50% 50% 0%;
      transform: translate(-50%, -100%) rotate(-45deg);
      transform-origin: bottom center;
      box-shadow: 0 4px 12px rgba(0, 0, 0, 0.35);
      display: flex;
      align-items: center;
      justify-content: center;
      border: 2.5px solid #FFFFFF;
      position: absolute;
      left: 0;
      top: 0;
      transition: box-shadow 0.2s ease, border-color 0.2s ease;
    }
    .marker-inner {
      transform: rotate(45deg);
      font-size: 14px;
      line-height: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      user-select: none;
    }
    .marker-pulse {
      position: absolute;
      width: 100%;
      height: 100%;
      border-radius: 50%;
      border: 2.5px solid #FFD700;
      animation: pulseRadar 1.8s infinite;
      pointer-events: none;
      top: 0;
      left: 0;
    }
    @keyframes pulseRadar {
      0% { transform: scale(1); opacity: 0.9; }
      100% { transform: scale(2.4); opacity: 0; }
    }
    .supabase-marker-pin.selected {
      border-color: #FFD700;
      box-shadow: 0 0 22px rgba(255, 215, 0, 0.95), 0 8px 18px rgba(0,0,0,0.4);
      transform: translate(-50%, -100%) rotate(-45deg) scale(1.25);
      z-index: 1000 !important;
    }

    /* Popup MapLibre Glassmorphism */
    .maplibregl-popup-content {
      background: rgba(245, 245, 220, 0.96) !important;
      backdrop-filter: blur(12px) !important;
      -webkit-backdrop-filter: blur(12px) !important;
      border: 1px solid rgba(198, 40, 40, 0.3) !important;
      color: #1C1917 !important;
      border-radius: 14px !important;
      padding: 10px 14px !important;
      box-shadow: 0 8px 32px rgba(0,0,0,0.25) !important;
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
      max-width: 240px !important;
    }
    .dark-popup .maplibregl-popup-content {
      background: rgba(15, 23, 42, 0.94) !important;
      color: #f1f5f9 !important;
      border-color: rgba(255, 255, 255, 0.18) !important;
    }
    .popup-title {
      font-weight: 800;
      color: #C62828;
      font-size: 13px;
      margin-bottom: 2px;
    }
    .dark-popup .popup-title {
      color: #00f2fe;
    }
    .popup-sub {
      color: #57534E;
      font-size: 10px;
      margin-bottom: 8px;
    }
    .dark-popup .popup-sub {
      color: #94a3b8;
    }
    .popup-route-btn {
      width: 100%;
      background: #C62828;
      color: #FFF;
      border: none;
      padding: 6px 10px;
      border-radius: 8px;
      font-size: 11px;
      font-weight: 700;
      cursor: pointer;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 5px;
    }
    .popup-route-btn:active {
      opacity: 0.85;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <script>
    let map = null;
    let markerInstances = {};
    let currentSelectedId = null;
    let currentTheme = '${initialTheme}';
    let is3DMode = ${is3D ? 'true' : 'false'};
    let currentPmtilesUrl = '${pmtilesUrl}';
    const fallbackUrl = '${fallbackUrl}';

    function getLayerColors(theme) {
      if (theme === 'dark') {
        return {
          background: '#090d16',
          water: '#0c2238',
          waterLine: '#0284c7',
          landusePark: '#062d22',
          building: '#1e293b',
          buildingTop: '#334155',
          roadMotorway: '#ea580c',
          roadPrimary: '#d97706',
          roadSecondary: '#334155',
          roadLocal: '#1e293b',
          text: '#f1f5f9',
          textHalo: '#090d16',
          poiColor: '#00f2fe'
        };
      } else if (theme === 'light') {
        return {
          background: '#f8fafc',
          water: '#bae6fd',
          waterLine: '#0284c7',
          landusePark: '#dcfce7',
          building: '#cbd5e1',
          buildingTop: '#94a3b8',
          roadMotorway: '#f97316',
          roadPrimary: '#fbbf24',
          roadSecondary: '#ffffff',
          roadLocal: '#ffffff',
          text: '#0f172a',
          textHalo: '#ffffff',
          poiColor: '#C62828'
        };
      }

      // VietLens Heritage Vintage Parchment (Mặc định)
      return {
        background: '#F5F5DC',        // Giấy dó vintage beige
        water: '#CADCE5',             // Nước xanh lam ngọc nhạt cổ điển
        waterLine: '#7FA8BD',         // Viền sông ngòi
        landusePark: '#E2E8D5',       // Rừng cây / công viên rêu mốc
        building: '#E7DFCC',          // Khối nhà 3D màu vôi cổ
        buildingTop: '#D6CBB4',       // Nóc khối nhà
        roadMotorway: '#C62828',      // Cao tốc màu đỏ son VietLens
        roadPrimary: '#E65100',       // Trục chính cam gạch
        roadSecondary: '#FFFFFF',     // Đường nhánh viền trắng sạch
        roadLocal: '#EDE7D4',         // Đường nội bộ hài hòa nền giấy
        text: '#1C1917',              // Mực tàu đậm
        textHalo: '#F5F5DC',          // Viền chữ màu giấy dó
        poiColor: '#C62828'           // Điểm di tích đỏ son
      };
    }

    function createMapStyle(pmUrl, theme) {
      const c = getLayerColors(theme);
      const isDark = theme === 'dark';

      return {
        version: 8,
        name: 'VietLens Vector Map Style',
        glyphs: 'https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf',
        sources: {
          openmaptiles: {
            type: 'vector',
            url: 'pmtiles://' + pmUrl
          }
        },
        layers: [
          { id: 'background', type: 'background', paint: { 'background-color': c.background } },
          { id: 'park', type: 'fill', source: 'openmaptiles', 'source-layer': 'park', paint: { 'fill-color': c.landusePark, 'fill-opacity': 0.7 } },
          { id: 'water', type: 'fill', source: 'openmaptiles', 'source-layer': 'water', paint: { 'fill-color': c.water } },
          { id: 'waterway', type: 'line', source: 'openmaptiles', 'source-layer': 'waterway', paint: { 'line-color': c.waterLine, 'line-width': 1.5 } },
          { id: 'road-minor', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['in', 'class', 'minor', 'service', 'track', 'path'], paint: { 'line-color': c.roadLocal, 'line-width': ['interpolate', ['linear'], ['zoom'], 12, 0.8, 16, 2.5] } },
          { id: 'road-secondary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['in', 'class', 'secondary', 'tertiary'], paint: { 'line-color': c.roadSecondary, 'line-width': ['interpolate', ['linear'], ['zoom'], 10, 1.5, 16, 4] } },
          { id: 'road-primary', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['in', 'class', 'primary', 'trunk'], paint: { 'line-color': c.roadPrimary, 'line-width': ['interpolate', ['linear'], ['zoom'], 8, 1.8, 16, 6] } },
          { id: 'road-motorway', type: 'line', source: 'openmaptiles', 'source-layer': 'transportation', filter: ['==', 'class', 'motorway'], paint: { 'line-color': c.roadMotorway, 'line-width': ['interpolate', ['linear'], ['zoom'], 6, 1.5, 16, 7] } },
          {
            id: 'buildings-3d',
            type: 'fill-extrusion',
            source: 'openmaptiles',
            'source-layer': 'building',
            minzoom: 13,
            paint: {
              'fill-extrusion-color': ['interpolate', ['linear'], ['zoom'], 13, c.building, 16, c.buildingTop],
              'fill-extrusion-height': ['interpolate', ['linear'], ['zoom'], 13, 0, 14.5, ['coalesce', ['get', 'render_height'], 12]],
              'fill-extrusion-base': ['coalesce', ['get', 'render_min_height'], 0],
              'fill-extrusion-opacity': isDark ? 0.85 : 0.88
            }
          },
          { id: 'boundary', type: 'line', source: 'openmaptiles', 'source-layer': 'boundary', paint: { 'line-color': isDark ? '#a855f7' : '#C62828', 'line-dasharray': [2, 2], 'line-width': 1.5 } },
          { id: 'road-names', type: 'symbol', source: 'openmaptiles', 'source-layer': 'transportation_name', minzoom: 13, layout: { 'symbol-placement': 'line', 'text-field': '{name}', 'text-size': 11 }, paint: { 'text-color': c.text, 'text-halo-color': c.textHalo, 'text-halo-width': 1.5 } },
          { id: 'place-labels', type: 'symbol', source: 'openmaptiles', 'source-layer': 'place', layout: { 'text-field': '{name}', 'text-size': ['interpolate', ['linear'], ['zoom'], 6, 12, 14, 18] }, paint: { 'text-color': c.text, 'text-halo-color': c.textHalo, 'text-halo-width': 2 } }
        ]
      };
    }

    try {
      const protocol = new pmtiles.Protocol();
      maplibregl.addProtocol('pmtiles', protocol.tile);

      map = new maplibregl.Map({
        container: 'map',
        style: createMapStyle(currentPmtilesUrl, currentTheme),
        center: [${MAP_CONFIG.DEFAULT_CENTER[0]}, ${MAP_CONFIG.DEFAULT_CENTER[1]}],
        zoom: ${MAP_CONFIG.DEFAULT_ZOOM},
        pitch: is3DMode ? ${MAP_CONFIG.DEFAULT_PITCH} : 0,
        bearing: is3DMode ? ${MAP_CONFIG.DEFAULT_BEARING} : 0,
        maxPitch: 70,
        minZoom: 3,
        maxZoom: 22,
        attributionControl: false
      });

      map.on('load', function() {
        if (window.ReactNativeWebView) {
          window.ReactNativeWebView.postMessage(JSON.stringify({ type: 'MAP_READY' }));
        }
      });

      // Nhận diện click trên nền bản đồ
      map.on('click', function(e) {
        if (window.ReactNativeWebView) {
          window.ReactNativeWebView.postMessage(JSON.stringify({ type: 'MAP_CLICK', lngLat: e.lngLat }));
        }
      });

      // Cơ chế tự động fallback thông minh sang bản đồ Cloud Supabase
      let hasTriedFallback = false;
      function triggerFallback(reason) {
        if (!hasTriedFallback && fallbackUrl && currentPmtilesUrl !== fallbackUrl) {
          hasTriedFallback = true;
          console.warn('[MapLibre] Chuyển đổi sang bản đồ dự phòng Cloud Supabase:', reason, fallbackUrl);
          currentPmtilesUrl = fallbackUrl;
          if (map) {
            map.setStyle(createMapStyle(currentPmtilesUrl, currentTheme));
          }
        }
      }

      // 1. Kiểm tra nhanh tính khả dụng của máy chủ nội bộ (cổng 8000)
      // Nếu cổng 8000 chưa bật (hoặc dùng 3G không truy cập được), chuyển ngay sang link Supabase
      if (currentPmtilesUrl && currentPmtilesUrl !== fallbackUrl) {
        try {
          const probeController = new AbortController();
          const probeTimeout = setTimeout(function() { probeController.abort(); }, 1800);
          fetch(currentPmtilesUrl, { method: 'HEAD', signal: probeController.signal })
            .then(function(res) {
              clearTimeout(probeTimeout);
              if (!res.ok && res.status !== 206) {
                triggerFallback('Máy chủ phản hồi trạng thái: ' + res.status);
              }
            })
            .catch(function(e) {
              clearTimeout(probeTimeout);
              triggerFallback('Máy chủ cổng 8000 không hoạt động (' + e.message + ')');
            });
        } catch (_) {}
      }

      // 2. Bắt lỗi trong quá trình MapLibre tải tiles / vector layers
      map.on('error', function(err) {
        console.warn('MapLibre error:', err);
        const isTileOrSourceError = err && (
          err.sourceId === 'openmaptiles' ||
          err.sourceId === 'pmtiles-vietnam' ||
          !err.sourceId ||
          (err.error && (err.error.status === 404 || err.error.status === 0 || err.error.status === 500)) ||
          (err.message && (err.message.toLowerCase().includes('fetch') || err.message.toLowerCase().includes('source') || err.message.toLowerCase().includes('pmtiles') || err.message.toLowerCase().includes('header')))
        );
        if (isTileOrSourceError) {
          triggerFallback(err.message || 'Lỗi tải vector tiles');
        }
      });

      // 3. Watchdog: Nếu sau 2.5s mà source vector vẫn chưa load thành công
      setTimeout(function() {
        if (!hasTriedFallback && map && !map.isSourceLoaded('openmaptiles')) {
          triggerFallback('Watchdog: openmaptiles chưa sẵn sàng sau 2.5s');
        }
      }, 2500);
    } catch (e) {
      console.error('Error init MapLibre:', e);
    }

    // Popup gọi chỉ đường sang React Native
    window.requestRouteFromPopup = function(lng, lat, name) {
      if (window.ReactNativeWebView) {
        window.ReactNativeWebView.postMessage(JSON.stringify({
          type: 'REQUEST_ROUTE',
          dest: { latitude: lat, longitude: lng, name: name }
        }));
      }
    };

    // Vẽ tuyến đường OSRM lên bản đồ
    window.drawRoute = function(geojsonGeometry, color) {
      if (!map) return;
      window.clearRoute();

      const routeColor = color || (currentTheme === 'dark' ? '#00f2fe' : '#C62828');

      map.addSource('route-source', {
        type: 'geojson',
        data: {
          type: 'Feature',
          properties: {},
          geometry: geojsonGeometry
        }
      });

      map.addLayer({
        id: 'route-line-casing',
        type: 'line',
        source: 'route-source',
        layout: { 'line-join': 'round', 'line-cap': 'round' },
        paint: {
          'line-color': '#FFFFFF',
          'line-width': 8,
          'line-opacity': 0.95
        }
      });

      map.addLayer({
        id: 'route-line',
        type: 'line',
        source: 'route-source',
        layout: { 'line-join': 'round', 'line-cap': 'round' },
        paint: {
          'line-color': routeColor,
          'line-width': 5,
          'line-opacity': 0.95
        }
      });

      // Fit bounds bao phủ toàn bộ lộ trình
      const coords = geojsonGeometry.coordinates;
      if (coords && coords.length > 0) {
        const bounds = coords.reduce(function(b, coord) {
          return b.extend(coord);
        }, new maplibregl.LngLatBounds(coords[0], coords[0]));
        map.fitBounds(bounds, { padding: 60, maxZoom: 16.5 });
      }
    };

    // Xóa tuyến đường OSRM
    window.clearRoute = function() {
      if (!map) return;
      if (map.getLayer('route-line')) map.removeLayer('route-line');
      if (map.getLayer('route-line-casing')) map.removeLayer('route-line-casing');
      if (map.getSource('route-source')) map.removeSource('route-source');
    };

    // Vẽ vòng tròn Quét 2 km
    window.drawRadiusCircle = function(centerLng, centerLat, radiusKm) {
      if (!map) return;
      window.clearRadiusCircle();

      const points = 64;
      const coords = { latitude: centerLat, longitude: centerLng };
      const ret = [];
      const distanceX = radiusKm / (111.320 * Math.cos((coords.latitude * Math.PI) / 180));
      const distanceY = radiusKm / 110.574;

      for (let i = 0; i < points; i++) {
        const theta = (i / points) * (2 * Math.PI);
        const x = distanceX * Math.cos(theta);
        const y = distanceY * Math.sin(theta);
        ret.push([coords.longitude + x, coords.latitude + y]);
      }
      ret.push(ret[0]);

      map.addSource('radius-source', {
        type: 'geojson',
        data: {
          type: 'Feature',
          geometry: { type: 'Polygon', coordinates: [ret] }
        }
      });

      map.addLayer({
        id: 'radius-fill',
        type: 'fill',
        source: 'radius-source',
        paint: { 'fill-color': '#FF8F00', 'fill-opacity': 0.15 }
      });

      map.addLayer({
        id: 'radius-line',
        type: 'line',
        source: 'radius-source',
        paint: { 'line-color': '#C62828', 'line-width': 2, 'line-dasharray': [3, 2] }
      });

      map.flyTo({ center: [centerLng, centerLat], zoom: 14.2, duration: 1200 });

      // Quét các di tích trong bán kính và gửi về React Native
      setTimeout(function() {
        const rendered = map.queryRenderedFeatures({
          layers: ['poi-heritage-points', 'poi-heritage-labels', 'place-labels']
        });
        const results = [];
        const seen = {};

        rendered.forEach(function(f) {
          const name = f.properties.name || f.properties.name_en;
          if (!name || seen[name]) return;
          if (f.geometry && f.geometry.type === 'Point') {
            seen[name] = true;
            results.push({
              name: name,
              category: (f.properties.class || f.properties.subclass || 'Di tích').toUpperCase(),
              longitude: f.geometry.coordinates[0],
              latitude: f.geometry.coordinates[1]
            });
          }
        });

        if (window.ReactNativeWebView) {
          window.ReactNativeWebView.postMessage(JSON.stringify({
            type: 'NEARBY_POIS_RESULT',
            pois: results.slice(0, 15)
          }));
        }
      }, 500);
    };

    // Xóa vòng tròn Quét
    window.clearRadiusCircle = function() {
      if (!map) return;
      if (map.getLayer('radius-line')) map.removeLayer('radius-line');
      if (map.getLayer('radius-fill')) map.removeLayer('radius-fill');
      if (map.getSource('radius-source')) map.removeSource('radius-source');
    };

    // Cập nhật ghim
    window.updateMarkers = function(sitesData, selectedId) {
      if (!map) return;
      currentSelectedId = selectedId || null;

      Object.keys(markerInstances).forEach(function(id) {
        markerInstances[id].remove();
      });
      markerInstances = {};

      if (!Array.isArray(sitesData) || sitesData.length === 0) return;

      sitesData.forEach(function(site) {
        if (site.lat == null || site.lng == null) return;
        const isSelected = site.id === currentSelectedId;
        const color = site.color || '#C62828';
        const icon = site.icon || '📍';

        const anchorEl = document.createElement('div');
        anchorEl.className = 'map-marker-anchor';

        const pinEl = document.createElement('div');
        pinEl.className = 'supabase-marker-pin' + (isSelected ? ' selected' : '');
        pinEl.style.background = color;
        pinEl.innerHTML = '<span class="marker-inner">' + icon + '</span>' + (isSelected ? '<div class="marker-pulse"></div>' : '');
        anchorEl.appendChild(pinEl);

        const popup = new maplibregl.Popup({ offset: [0, -38], closeButton: false }).setHTML(
          '<div class="popup-title">' + (site.name || '') + '</div>' +
          '<div class="popup-sub">' + (site.category || '') + ' • ' + (site.locationName || '') + '</div>'
        );

        const marker = new maplibregl.Marker({ element: anchorEl, anchor: 'center' })
          .setLngLat([site.lng, site.lat])
          .setPopup(popup)
          .addTo(map);

        anchorEl.addEventListener('click', function(e) {
          e.stopPropagation();
          if (window.ReactNativeWebView) {
            window.ReactNativeWebView.postMessage(JSON.stringify({ type: 'SELECT_SITE', siteId: site.id }));
          }
        });

        markerInstances[site.id] = marker;
      });
    };

    // Bay mượt mà đến bất kỳ tọa độ địa lý nào
    window.flyToSite = function(lat, lng, zoom, pitch, bearing) {
      if (!map || lat == null || lng == null) return;
      map.flyTo({
        center: [lng, lat],
        zoom: zoom || 15.5,
        pitch: pitch !== undefined ? pitch : (is3DMode ? 55 : 0),
        bearing: bearing !== undefined ? bearing : -20,
        duration: 1800,
        essential: true
      });
    };

    // Đổi chế độ 3D / 2D
    window.set3D = function(enabled) {
      is3DMode = !!enabled;
      if (!map) return;
      map.easeTo({
        pitch: is3DMode ? 55 : 0,
        bearing: is3DMode ? -20 : 0,
        duration: 1000
      });
    };

    // Đổi giao diện VietLens / Tối / Sáng
    window.setTheme = function(theme) {
      currentTheme = theme;
      if (!map) return;
      map.setStyle(createMapStyle(currentPmtilesUrl, currentTheme));
    };
  </script>
</body>
</html>
  `;
}

const InteractiveHeritageMap = forwardRef(function InteractiveHeritageMap(
  {
    sites = [],
    selectedSite,
    onSelectSite,
    onSelectOsmPoi,
    onRequestRoute,
    onNearbyPois,
    onMapClick,
    is3D = true,
    theme = 'vietlens',
    pmtilesUrl = MAP_CONFIG.PMTILES_URL,
    fallbackUrl = MAP_CONFIG.FALLBACK_PMTILES_URL,
  },
  ref
) {
  const webViewRef = useRef(null);
  const [isMapReady, setIsMapReady] = useState(false);

  // Cung cấp các phương thức điều khiển camera, lộ trình, quét ra ngoài qua ref
  useImperativeHandle(ref, () => ({
    flyTo: (lat, lng, zoom = 15.5, pitch, bearing) => {
      if (webViewRef.current && isMapReady) {
        const p = pitch !== undefined ? pitch : (is3D ? 55 : 0);
        const b = bearing !== undefined ? bearing : -20;
        const script = `
          if (typeof window.flyToSite === 'function') {
            window.flyToSite(${lat}, ${lng}, ${zoom}, ${p}, ${b});
          }
          true;
        `;
        webViewRef.current.injectJavaScript(script);
      }
    },
    drawRoute: (geojsonGeometry, color) => {
      if (webViewRef.current && isMapReady && geojsonGeometry) {
        const script = `
          if (typeof window.drawRoute === 'function') {
            window.drawRoute(${JSON.stringify(geojsonGeometry)}, ${JSON.stringify(color || null)});
          }
          true;
        `;
        webViewRef.current.injectJavaScript(script);
      }
    },
    clearRoute: () => {
      if (webViewRef.current && isMapReady) {
        webViewRef.current.injectJavaScript('if (typeof window.clearRoute === "function") { window.clearRoute(); } true;');
      }
    },
    drawRadiusCircle: (lat, lng, radiusKm = 2.0) => {
      if (webViewRef.current && isMapReady) {
        const script = `
          if (typeof window.drawRadiusCircle === 'function') {
            window.drawRadiusCircle(${lng}, ${lat}, ${radiusKm});
          }
          true;
        `;
        webViewRef.current.injectJavaScript(script);
      }
    },
    clearRadiusCircle: () => {
      if (webViewRef.current && isMapReady) {
        webViewRef.current.injectJavaScript('if (typeof window.clearRadiusCircle === "function") { window.clearRadiusCircle(); } true;');
      }
    },
  }));

  const mapSource = useMemo(() => {
    return {
      html: generateMapHTML(pmtilesUrl, fallbackUrl, theme, is3D),
      baseUrl: 'https://localhost',
    };
  }, [pmtilesUrl, fallbackUrl]);

  // Đồng bộ danh sách ghim
  useEffect(() => {
    if (!isMapReady || !webViewRef.current) return;

    const payload = (sites || []).map((s) => {
      const meta = getCategoryMeta(s.category);
      return {
        id: s.id,
        name: s.name,
        locationName: s.locationName || s.province,
        lat: Number(s.latitude ?? s.lat),
        lng: Number(s.longitude ?? s.lng),
        category: s.category,
        icon: meta.icon,
        color: meta.color,
      };
    });

    const script = `
      if (typeof window.updateMarkers === 'function') {
        window.updateMarkers(${JSON.stringify(payload)}, ${JSON.stringify(selectedSite?.id || null)});
      }
      true;
    `;
    webViewRef.current.injectJavaScript(script);
  }, [sites, selectedSite, isMapReady]);

  // Đồng bộ chế độ 3D
  useEffect(() => {
    if (!isMapReady || !webViewRef.current) return;
    const script = `
      if (typeof window.set3D === 'function') {
        window.set3D(${is3D ? 'true' : 'false'});
      }
      true;
    `;
    webViewRef.current.injectJavaScript(script);
  }, [is3D, isMapReady]);

  // Đồng bộ theme
  useEffect(() => {
    if (!isMapReady || !webViewRef.current) return;
    const script = `
      if (typeof window.setTheme === 'function') {
        window.setTheme(${JSON.stringify(theme)});
      }
      true;
    `;
    webViewRef.current.injectJavaScript(script);
  }, [theme, isMapReady]);

  const handleMessage = useCallback(
    (event) => {
      try {
        const data = JSON.parse(event.nativeEvent.data);
        if (data.type === 'MAP_READY') {
          setIsMapReady(true);
        } else if (data.type === 'SELECT_SITE') {
          const found = sites.find((s) => s.id === data.siteId);
          if (found && onSelectSite) {
            onSelectSite(found);
          }
        } else if (data.type === 'SELECT_OSM_POI') {
          if (onSelectOsmPoi) onSelectOsmPoi(data.poi);
        } else if (data.type === 'REQUEST_ROUTE') {
          if (onRequestRoute) onRequestRoute(data.dest);
        } else if (data.type === 'NEARBY_POIS_RESULT') {
          if (onNearbyPois) onNearbyPois(data.pois);
        } else if (data.type === 'MAP_CLICK') {
          if (onMapClick) onMapClick(data.lngLat);
        }
      } catch (e) {
        console.warn('[InteractiveHeritageMap] Message parse error:', e);
      }
    },
    [sites, onSelectSite, onSelectOsmPoi, onRequestRoute, onNearbyPois, onMapClick]
  );

  return (
    <View style={styles.container}>
      <WebView
        ref={webViewRef}
        originWhitelist={['*']}
        source={mapSource}
        style={styles.webview}
        javaScriptEnabled={true}
        domStorageEnabled={true}
        mixedContentMode="always"
        allowFileAccess={true}
        allowFileAccessFromFileURLs={true}
        allowUniversalAccessFromFileURLs={true}
        onMessage={handleMessage}
        startInLoadingState={true}
        renderLoading={() => (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="large" color={THEME.colors.amber} />
          </View>
        )}
      />
    </View>
  );
});

export default InteractiveHeritageMap;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5DC',
  },
  webview: {
    flex: 1,
    backgroundColor: 'transparent',
  },
  loadingContainer: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: '#F5F5DC',
    alignItems: 'center',
    justifyContent: 'center',
  },
});
