import React, { useRef, useImperativeHandle, forwardRef, useMemo, useState } from 'react';
import { View, StyleSheet, ActivityIndicator } from 'react-native';
import { WebView } from 'react-native-webview';

function generateGoogleMapsWebGLHTML() {
  return `
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
  <link rel="stylesheet" href="https://unpkg.com/maplibre-gl@4.7.1/dist/maplibre-gl.css" />
  <script src="https://unpkg.com/maplibre-gl@4.7.1/dist/maplibre-gl.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
    html, body, #map {
      width: 100%;
      height: 100%;
      position: fixed;
      inset: 0;
      background-color: #E8EAED;
      overflow: hidden;
    }
    .maplibregl-ctrl-attrib, .maplibregl-ctrl-logo {
      display: none !important;
    }
    .gm-badge {
      position: absolute;
      bottom: 8px;
      left: 10px;
      background: rgba(255, 255, 255, 0.88);
      padding: 2px 7px;
      border-radius: 4px;
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      font-size: 10px;
      font-weight: 700;
      color: #3C4043;
      box-shadow: 0 1px 3px rgba(0,0,0,0.2);
      z-index: 5;
      pointer-events: none;
    }
    .maplibregl-popup-content {
      border-radius: 12px;
      padding: 10px 12px;
      box-shadow: 0 4px 14px rgba(0,0,0,0.22);
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
    }
    .popup-title {
      font-size: 13px;
      font-weight: 800;
      color: #1C1917;
      margin-bottom: 2px;
    }
    .popup-sub {
      font-size: 11px;
      color: #78716C;
    }

    /* Chấm xanh GPS Người dùng (Live Blue Dot - Tính năng 1) */
    .user-gps-container {
      position: relative;
      width: 48px;
      height: 48px;
      display: flex;
      align-items: center;
      justify-content: center;
      pointer-events: none;
    }
    .user-gps-pulse {
      position: absolute;
      width: 44px;
      height: 44px;
      border-radius: 50%;
      background: rgba(26, 115, 232, 0.28);
      animation: pulse-ring 2s cubic-bezier(0.215, 0.61, 0.355, 1) infinite;
    }
    @keyframes pulse-ring {
      0% { transform: scale(0.35); opacity: 0.95; }
      75%, 100% { transform: scale(1.6); opacity: 0; }
    }
    .user-gps-heading {
      position: absolute;
      width: 0;
      height: 0;
      border-left: 7px solid transparent;
      border-right: 7px solid transparent;
      border-bottom: 16px solid #1A73E8;
      top: 1px;
      opacity: 0.85;
      transform-origin: center 23px;
      transition: transform 0.3s ease;
    }
    .user-gps-dot {
      width: 17px;
      height: 17px;
      border-radius: 50%;
      background-color: #1A73E8;
      border: 3px solid #FFFFFF;
      box-shadow: 0 0 10px rgba(26, 115, 232, 0.8);
      z-index: 2;
    }
  </style>
</head>
<body>
  <div id="map"></div>
  <div class="gm-badge">Google Maps • VN</div>
  <script>
    var map = null;
    var isFirstLoad = true;
    var startInitTime = performance.now();
    var currentSitesMap = {};
    var activePopup = null;
    var userMarker = null;
    var userHeadingEl = null;
    var isNavigatingMode = false;
    var currentNavBearing = 0;

    function postToNative(data) {
      if (window.ReactNativeWebView) {
        window.ReactNativeWebView.postMessage(JSON.stringify(data));
      }
    }

    function createGoogleMapStyle() {
      return {
        version: 8,
        glyphs: 'https://demotiles.maplibre.org/font/{fontstack}/{range}.pbf',
        sources: {
          'google-roadmap': {
            type: 'raster',
            tiles: [
              'https://mt0.google.com/vt/lyrs=m&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt1.google.com/vt/lyrs=m&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt2.google.com/vt/lyrs=m&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt3.google.com/vt/lyrs=m&hl=vi&gl=VN&x={x}&y={y}&z={z}'
            ],
            tileSize: 256,
            maxzoom: 20
          },
          'google-hybrid': {
            type: 'raster',
            tiles: [
              'https://mt0.google.com/vt/lyrs=y&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt1.google.com/vt/lyrs=y&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt2.google.com/vt/lyrs=y&hl=vi&gl=VN&x={x}&y={y}&z={z}',
              'https://mt3.google.com/vt/lyrs=y&hl=vi&gl=VN&x={x}&y={y}&z={z}'
            ],
            tileSize: 256,
            maxzoom: 20
          },
          'heritage-clusters': {
            type: 'geojson',
            data: { type: 'FeatureCollection', features: [] },
            cluster: true,
            clusterMaxZoom: 14,
            clusterRadius: 46
          },
          'route-source': {
            type: 'geojson',
            data: { type: 'FeatureCollection', features: [] }
          },
          'radius-source': {
            type: 'geojson',
            data: { type: 'FeatureCollection', features: [] }
          }
        },
        layers: [
          {
            id: 'google-roadmap-layer',
            type: 'raster',
            source: 'google-roadmap',
            layout: { visibility: 'visible' }
          },
          {
            id: 'google-hybrid-layer',
            type: 'raster',
            source: 'google-hybrid',
            layout: { visibility: 'none' }
          },
          // Vòng tròn quét bán kính 2km
          {
            id: 'radius-fill',
            type: 'fill',
            source: 'radius-source',
            paint: {
              'fill-color': '#C62828',
              'fill-opacity': 0.12
            }
          },
          {
            id: 'radius-line',
            type: 'line',
            source: 'radius-source',
            paint: {
              'line-color': '#C62828',
              'line-width': 2,
              'line-dasharray': [3, 2]
            }
          },
          // Tuyến đường Polyline (Viền trắng + Ruột đỏ)
          {
            id: 'route-casing',
            type: 'line',
            source: 'route-source',
            layout: { 'line-join': 'round', 'line-cap': 'round' },
            paint: {
              'line-color': '#FFFFFF',
              'line-width': 9,
              'line-opacity': 0.95
            }
          },
          {
            id: 'route-line',
            type: 'line',
            source: 'route-source',
            layout: { 'line-join': 'round', 'line-cap': 'round' },
            paint: {
              'line-color': '#C62828',
              'line-width': 5.5,
              'line-opacity': 0.95
            }
          },
          // Vòng tròn Gom cụm (Clustering)
          {
            id: 'clusters-circle',
            type: 'circle',
            source: 'heritage-clusters',
            filter: ['has', 'point_count'],
            paint: {
              'circle-color': [
                'step',
                ['get', 'point_count'],
                '#C62828',
                10, '#B91C1C',
                30, '#991B1B'
              ],
              'circle-radius': [
                'step',
                ['get', 'point_count'],
                18,
                10, 22,
                30, 26
              ],
              'circle-stroke-width': 3,
              'circle-stroke-color': '#FFFFFF'
            }
          },
          // Số lượng điểm trong Cụm
          {
            id: 'clusters-count',
            type: 'symbol',
            source: 'heritage-clusters',
            filter: ['has', 'point_count'],
            layout: {
              'text-field': '{point_count_abbreviated}',
              'text-font': ['Open Sans Bold'],
              'text-size': 13
            },
            paint: {
              'text-color': '#FFFFFF'
            }
          },
          // Điểm Marker đơn lẻ (Unclustered Pin)
          {
            id: 'unclustered-point-halo',
            type: 'circle',
            source: 'heritage-clusters',
            filter: ['!', ['has', 'point_count']],
            paint: {
              'circle-color': 'rgba(198, 40, 40, 0.25)',
              'circle-radius': 15
            }
          },
          {
            id: 'unclustered-point',
            type: 'circle',
            source: 'heritage-clusters',
            filter: ['!', ['has', 'point_count']],
            paint: {
              'circle-color': '#C62828',
              'circle-radius': 8.5,
              'circle-stroke-width': 2.5,
              'circle-stroke-color': '#FFFFFF'
            }
          },
          // Nhãn tên địa danh dưới chấm đỏ
          {
            id: 'unclustered-label',
            type: 'symbol',
            source: 'heritage-clusters',
            filter: ['!', ['has', 'point_count']],
            minzoom: 11,
            layout: {
              'text-field': ['get', 'name'],
              'text-font': ['Open Sans Bold'],
              'text-size': 11,
              'text-offset': [0, 1.3],
              'text-anchor': 'top',
              'text-max-width': 12
            },
            paint: {
              'text-color': '#1C1917',
              'text-halo-color': '#FFFFFF',
              'text-halo-width': 2
            }
          }
        ]
      };
    }

    function emitCameraIdle() {
      if (!map) return;
      var b = map.getBounds();
      var c = map.getCenter();
      postToNative({
        type: 'CAMERA_IDLE',
        bounds: {
          minLat: b.getSouth(),
          minLng: b.getWest(),
          maxLat: b.getNorth(),
          maxLng: b.getEast()
        },
        zoom: map.getZoom(),
        center: { lat: c.lat, lng: c.lng }
      });
    }

    function initMap() {
      map = new maplibregl.Map({
        container: 'map',
        style: createGoogleMapStyle(),
        center: [108.2022, 16.0544], // Đà Nẵng / Miền Trung (Bước 2)
        zoom: 12.2,
        minZoom: 4.5,
        maxZoom: 20,
        pitch: 0,
        bearing: 0,
        maxPitch: 65,
        maxBounds: [[100.0, 5.5], [119.5, 24.5]], // Khung giới hạn lãnh thổ & biển đảo Việt Nam
        attributionControl: false
      });

      map.on('load', function() {
        var duration = Math.round(performance.now() - startInitTime);
        map.resize();
        postToNative({ type: 'MAP_READY' });
        postToNative({ type: 'MAP_LOADED', durationMs: duration, isFirst: isFirstLoad });
        isFirstLoad = false;
        emitCameraIdle();
      });

      window.addEventListener('resize', function() {
        if (map) map.resize();
      });

      map.on('moveend', function() {
        emitCameraIdle();
      });

      // Lắng nghe khi người dùng kéo bản đồ trong lúc đang dẫn đường
      map.on('dragstart', function() {
        if (isNavigatingMode) {
          postToNative({ type: 'USER_PANNED_DURING_NAV' });
        }
      });

      // Bấm vào Cụm (Cluster) -> Tự động phóng to mở cụm
      map.on('click', 'clusters-circle', function(e) {
        var features = map.queryRenderedFeatures(e.point, { layers: ['clusters-circle'] });
        if (!features.length) return;
        var clusterId = features[0].properties.cluster_id;
        var coords = features[0].geometry.coordinates;
        map.getSource('heritage-clusters').getClusterExpansionZoom(clusterId).then(function(zoom) {
          map.easeTo({ center: coords, zoom: zoom, duration: 500 });
        }).catch(function() {
          map.easeTo({ center: coords, zoom: map.getZoom() + 2, duration: 500 });
        });
      });

      // Bấm vào từng Marker đơn lẻ -> Mở Popup & chọn địa danh
      map.on('click', 'unclustered-point', function(e) {
        if (!e.features || !e.features.length) return;
        var feat = e.features[0];
        var props = feat.properties || {};
        var coords = feat.geometry.coordinates.slice();
        var siteObj = currentSitesMap[props.id] || {
          id: props.id,
          name: props.name,
          category: props.category,
          province: props.province,
          latitude: coords[1],
          longitude: coords[0]
        };

        if (activePopup) activePopup.remove();
        activePopup = new maplibregl.Popup({ offset: 14, closeButton: false })
          .setLngLat(coords)
          .setHTML(
            '<div class="popup-title">' + (siteObj.name || '') + '</div>' +
            '<div class="popup-sub">' + (siteObj.category || 'Di sản') + ' • ' + (siteObj.province || 'Việt Nam') + '</div>'
          )
          .addTo(map);

        postToNative({ type: 'SELECT_SITE', site: siteObj });
      });

      map.on('click', function(e) {
        var hit = map.queryRenderedFeatures(e.point, { layers: ['clusters-circle', 'unclustered-point'] });
        if (!hit.length) {
          postToNative({ type: 'MAP_CLICK', lat: e.lngLat.lat, lng: e.lngLat.lng });
        }
      });
    }

    // Chuyển đổi NORMAL (roadmap) ↔ HYBRID (vệ tinh + nhãn đường)
    window.setMapType = function(type) {
      if (!map) return;
      var isHyb = type === 'hybrid';
      if (map.getLayer('google-roadmap-layer')) {
        map.setLayoutProperty('google-roadmap-layer', 'visibility', isHyb ? 'none' : 'visible');
      }
      if (map.getLayer('google-hybrid-layer')) {
        map.setLayoutProperty('google-hybrid-layer', 'visibility', isHyb ? 'visible' : 'none');
      }
    };

    // Bật / tắt góc nghiêng 3D (tilt / bearing)
    window.set3DMode = function(enabled) {
      if (!map) return;
      map.easeTo({
        pitch: enabled ? 52 : 0,
        bearing: enabled ? -20 : 0,
        duration: 800
      });
    };

    // Bay mượt đến tọa độ địa điểm
    window.flyTo = function(lat, lng, zoom, tilt, heading) {
      if (!map || lat == null || lng == null) return;
      map.flyTo({
        center: [Number(lng), Number(lat)],
        zoom: zoom || 15.5,
        pitch: tilt !== undefined ? tilt : map.getPitch(),
        bearing: heading !== undefined ? heading : map.getBearing(),
        duration: 1400,
        essential: true
      });
    };

    // Cập nhật danh sách Marker và tự động gom cụm (Clustering)
    window.updateMarkers = function(sites) {
      if (!map || !map.getSource('heritage-clusters')) return;
      currentSitesMap = {};
      var features = [];

      if (Array.isArray(sites)) {
        sites.forEach(function(site) {
          var lat = Number(site.latitude !== undefined ? site.latitude : site.lat);
          var lng = Number(site.longitude !== undefined ? site.longitude : site.lng);
          if (isNaN(lat) || isNaN(lng)) return;

          var idStr = String(site.id || (lat + '_' + lng));
          currentSitesMap[idStr] = site;

          features.push({
            type: 'Feature',
            geometry: {
              type: 'Point',
              coordinates: [lng, lat]
            },
            properties: {
              id: idStr,
              name: site.name || 'Di sản',
              category: site.category || 'Di sản văn hóa',
              province: site.province || site.locationName || 'Việt Nam'
            }
          });
        });
      }

      map.getSource('heritage-clusters').setData({
        type: 'FeatureCollection',
        features: features
      });
    };

    // Vẽ tuyến đường Polyline (từ dữ liệu đã nén Douglas-Peucker) + animateCamera tới bounds
    window.drawRoute = function(points, color) {
      if (!map || !map.getSource('route-source')) return;
      if (!Array.isArray(points) || points.length === 0) {
        window.clearRoute();
        return;
      }

      var coords = [];
      var bounds = new maplibregl.LngLatBounds();

      points.forEach(function(p) {
        var lat = Number(p.latitude !== undefined ? p.latitude : p.lat);
        var lng = Number(p.longitude !== undefined ? p.longitude : p.lng);
        if (!isNaN(lat) && !isNaN(lng)) {
          coords.push([lng, lat]);
          bounds.extend([lng, lat]);
        }
      });

      if (color && map.getLayer('route-line')) {
        map.setPaintProperty('route-line', 'line-color', color);
      }

      map.getSource('route-source').setData({
        type: 'FeatureCollection',
        features: [{
          type: 'Feature',
          geometry: {
            type: 'LineString',
            coordinates: coords
          }
        }]
      });

      if (coords.length > 1) {
        map.fitBounds(bounds, { padding: { top: 100, bottom: 180, left: 50, right: 50 }, duration: 1200 });
      }
    };

    window.clearRoute = function() {
      if (!map || !map.getSource('route-source')) return;
      map.getSource('route-source').setData({
        type: 'FeatureCollection',
        features: []
      });
    };

    // Vẽ vòng tròn quét bán kính 2km
    window.drawRadiusCircle = function(centerLng, centerLat, radiusKm) {
      if (!map || !map.getSource('radius-source')) return;
      var points = 64;
      var coords = [];
      var distanceX = radiusKm / (111.32 * Math.cos((centerLat * Math.PI) / 180));
      var distanceY = radiusKm / 110.574;

      for (var i = 0; i <= points; i++) {
        var theta = (i / points) * (2 * Math.PI);
        var x = distanceX * Math.cos(theta);
        var y = distanceY * Math.sin(theta);
        coords.push([centerLng + x, centerLat + y]);
      }

      map.getSource('radius-source').setData({
        type: 'FeatureCollection',
        features: [{
          type: 'Feature',
          geometry: { type: 'Polygon', coordinates: [coords] }
        }]
      });

      map.flyTo({ center: [centerLng, centerLat], zoom: 13.5, duration: 1000 });
    };

    window.clearRadiusCircle = function() {
      if (!map || !map.getSource('radius-source')) return;
      map.getSource('radius-source').setData({
        type: 'FeatureCollection',
        features: []
      });
    };

    // Cập nhật vị trí Chấm xanh GPS người dùng (Tính năng 1)
    window.updateUserLocation = function(lat, lng, heading, isNavigating) {
      if (!map || lat == null || lng == null) return;
      isNavigatingMode = !!isNavigating;

      if (!userMarker) {
        var el = document.createElement('div');
        el.className = 'user-gps-container';
        el.innerHTML = '<div class="user-gps-pulse"></div><div class="user-gps-heading"></div><div class="user-gps-dot"></div>';
        userHeadingEl = el.querySelector('.user-gps-heading');

        userMarker = new maplibregl.Marker({ element: el, anchor: 'center' })
          .setLngLat([lng, lat])
          .addTo(map);
      } else {
        userMarker.setLngLat([lng, lat]);
      }

      if (userHeadingEl && heading != null) {
        userHeadingEl.style.transform = 'rotate(' + (heading || 0) + 'deg)';
      }

      // Nếu đang trong chế độ dẫn đường: tự động lướt camera bám theo vị trí
      if (isNavigatingMode) {
        map.easeTo({
          center: [lng, lat],
          duration: 700,
          essential: true
        });
      }
    };

    // Bắt đầu chế độ Dẫn đường thực tế 3D (Navigation Mode - Tính năng 8)
    window.startNavigation = function(lat, lng, bearing) {
      isNavigatingMode = true;
      currentNavBearing = bearing || 0;
      if (!map) return;
      map.flyTo({
        center: [lng, lat],
        zoom: 17.5,
        pitch: 58,
        bearing: currentNavBearing,
        duration: 1000,
        essential: true
      });
    };

    // Cập nhật góc xoay camera khi rẽ trong chế độ dẫn đường
    window.updateNavBearing = function(bearing) {
      currentNavBearing = bearing || 0;
      if (map && isNavigatingMode) {
        map.easeTo({
          bearing: currentNavBearing,
          duration: 500
        });
      }
    };

    // Kết thúc chế độ Dẫn đường
    window.stopNavigation = function(lastLat, lastLng) {
      isNavigatingMode = false;
      if (!map) return;
      map.easeTo({
        center: [lastLng, lastLat],
        zoom: 15.5,
        pitch: 0,
        bearing: 0,
        duration: 800
      });
    };

    initMap();
  </script>
</body>
</html>
  `;
}

const VietLensGoogleMapView = forwardRef(function VietLensGoogleMapView(
  {
    onSelectSite,
    onCameraIdle,
    onMapLoaded,
    onMapClick,
    onMapReady,
    onUserPannedNav,
    style,
  },
  ref
) {
  const webViewRef = useRef(null);
  const pendingMarkersRef = useRef(null);

  useImperativeHandle(ref, () => ({
    flyTo: (lat, lng, zoom = 15.5, tilt, heading) => {
      const script = `if (typeof window.flyTo === 'function') { window.flyTo(${lat}, ${lng}, ${zoom}, ${tilt !== undefined ? tilt : 0}, ${heading !== undefined ? heading : 0}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    updateUserLocation: (lat, lng, heading, isNavigating) => {
      const script = `if (typeof window.updateUserLocation === 'function') { window.updateUserLocation(${lat}, ${lng}, ${heading !== undefined ? heading : 0}, ${isNavigating ? 'true' : 'false'}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    startNavigation: (lat, lng, bearing) => {
      const script = `if (typeof window.startNavigation === 'function') { window.startNavigation(${lat}, ${lng}, ${bearing !== undefined ? bearing : 0}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    updateNavBearing: (bearing) => {
      const script = `if (typeof window.updateNavBearing === 'function') { window.updateNavBearing(${bearing !== undefined ? bearing : 0}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    stopNavigation: (lat, lng) => {
      const script = `if (typeof window.stopNavigation === 'function') { window.stopNavigation(${lat}, ${lng}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    setMapType: (type) => {
      const script = `if (typeof window.setMapType === 'function') { window.setMapType('${type}'); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    set3DMode: (enabled) => {
      const script = `if (typeof window.set3DMode === 'function') { window.set3DMode(${enabled ? 'true' : 'false'}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    updateMarkers: (sites) => {
      pendingMarkersRef.current = sites;
      const script = `if (typeof window.updateMarkers === 'function') { window.updateMarkers(${JSON.stringify(sites || [])}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    drawRoute: (points, color = '#C62828') => {
      const script = `if (typeof window.drawRoute === 'function') { window.drawRoute(${JSON.stringify(points || [])}, '${color}'); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    clearRoute: () => {
      const script = `if (typeof window.clearRoute === 'function') { window.clearRoute(); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    drawRadiusCircle: (lat, lng, radiusKm = 2.0) => {
      const script = `if (typeof window.drawRadiusCircle === 'function') { window.drawRadiusCircle(${lng}, ${lat}, ${radiusKm}); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
    clearRadiusCircle: () => {
      const script = `if (typeof window.clearRadiusCircle === 'function') { window.clearRadiusCircle(); } true;`;
      webViewRef.current?.injectJavaScript(script);
    },
  }));

  const htmlSource = useMemo(() => {
    return {
      html: generateGoogleMapsWebGLHTML(),
      baseUrl: 'https://localhost',
    };
  }, []);

  const handleMessage = (event) => {
    try {
      const data = JSON.parse(event.nativeEvent.data);
      if (data.type === 'MAP_READY') {
        if (pendingMarkersRef.current) {
          const script = `if (typeof window.updateMarkers === 'function') { window.updateMarkers(${JSON.stringify(pendingMarkersRef.current)}); } true;`;
          webViewRef.current?.injectJavaScript(script);
        }
        if (onMapReady) onMapReady();
      } else if (data.type === 'MAP_LOADED') {
        if (onMapLoaded) onMapLoaded(data.durationMs, data.isFirst);
      } else if (data.type === 'CAMERA_IDLE') {
        if (onCameraIdle) onCameraIdle(data.bounds, data.zoom, data.center);
      } else if (data.type === 'SELECT_SITE') {
        if (onSelectSite) onSelectSite(data.site);
      } else if (data.type === 'USER_PANNED_DURING_NAV') {
        if (onUserPannedNav) onUserPannedNav();
      } else if (data.type === 'MAP_CLICK') {
        if (onMapClick) onMapClick(data);
      }
    } catch (e) {
      console.warn('[VietLensGoogleMapView] Message error:', e);
    }
  };

  return (
    <View style={[styles.container, style]}>
      <WebView
        ref={webViewRef}
        originWhitelist={['*']}
        source={htmlSource}
        style={styles.webview}
        javaScriptEnabled={true}
        domStorageEnabled={true}
        mixedContentMode="always"
        onMessage={handleMessage}
        startInLoadingState={true}
        renderLoading={() => (
          <View style={styles.loadingContainer}>
            <ActivityIndicator size="large" color="#C62828" />
          </View>
        )}
      />
    </View>
  );
});

export default VietLensGoogleMapView;

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#E8EAED',
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
