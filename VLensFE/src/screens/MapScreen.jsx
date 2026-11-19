import React, { useState, useRef, useEffect, useMemo } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  ScrollView,
  ActivityIndicator,
  Keyboard,
  Platform,
  Image,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import { THEME, useTheme } from '../utils/theme';
import VietLensGoogleMapView from '../components/VietLensGoogleMapView';
import { MAP_CONFIG } from '../utils/mapConfig';
import appService from '../api/appService';
import { adaptHeritageList } from '../utils/heritageAdapter';
import useUserLocation, { DEFAULT_COORDS } from '../hooks/useUserLocation';
import useNetworkStatus from '../hooks/useNetworkStatus';
import { simplifyDouglasPeucker } from '../utils/douglasPeucker';
import { mapPerfLogger } from '../utils/mapPerfLogger';
import {
  getSeedHeritages,
  getOfflineHeritages,
  saveOfflineHeritages,
} from '../services/offlineStorageService';
import {
  snapToRoute,
  isOffRoute,
  getTurnInstruction,
  calculateBearing,
  haversineDistanceKm,
} from '../utils/dijkstraRouter';

export default function MapScreen({ onSelectSite, onNavigateToChat, focusedSite = null }) {
  const { t, i18n } = useTranslation();
  const { theme, isDark } = useTheme();
  const mapRef = useRef(null);
  const [search, setSearch] = useState('');
  const [showSearchResults, setShowSearchResults] = useState(false);
  const [selectedMarkerSite, setSelectedMarkerSite] = useState(null);

  const [is3D, setIs3D] = useState(false);
  const [isHybrid, setIsHybrid] = useState(false); // NORMAL ↔ HYBRID (Bước 2)
  const [isOffline, setIsOffline] = useState(false); // Trạng thái mất mạng (Bước 5)
  const [errorMessage, setErrorMessage] = useState(null);
  const [showQuickMenu, setShowQuickMenu] = useState(false);
  const [activeDestKey, setActiveDestKey] = useState('danang');
  const [selectedRegion, setSelectedRegion] = useState('Tất cả');

  // Cache BBox & Debounce Timer Refs (Bước 3)
  const bboxCacheRef = useRef({});
  const debounceTimerRef = useRef(null);
  const abortControllerRef = useRef(null);

  // Trạng thái Lộ trình & Dẫn đường Dijkstra (Tính năng 8)
  const [routeInfo, setRouteInfo] = useState(null);
  const [routeMode, setRouteMode] = useState('driving'); // 'driving' | 'walking' | 'cycling'
  const [isCalculatingRoute, setIsCalculatingRoute] = useState(false);
  const [isNavigating, setIsNavigating] = useState(false);
  const [isPannedDuringNav, setIsPannedDuringNav] = useState(false);
  const [navTurnInfo, setNavTurnInfo] = useState(null);
  const [navRemaining, setNavRemaining] = useState({ distanceKm: 0, durationMin: 0 });
  const [isRerouting, setIsRerouting] = useState(false);
  const [isSimulating, setIsSimulating] = useState(false);
  const [simCoords, setSimCoords] = useState(null);
  const simSegmentRef = useRef({ index: 0, progress: 0 });
  const lastRerouteTimeRef = useRef(0);

  // Ghi nhận mốc thời gian mở MapScreen (Bước 6)
  useEffect(() => {
    mapPerfLogger.recordMapOpen();
  }, []);

  // Trạng thái Quét bán kính 2km / 5km / 10km (Tính năng 1)
  const [isScanningRadius, setIsScanningRadius] = useState(false);
  const [scanRadiusKm, setScanRadiusKm] = useState(2.0);
  const [nearbyPois, setNearbyPois] = useState([]);
  const [showRadiusDrawer, setShowRadiusDrawer] = useState(false);

  const { coords: userCoords } = useUserLocation(isNavigating);
  const network = useNetworkStatus();
  const isNetworkOffline = !network.isConnected || !network.isInternetReachable;
  const prevOfflineRef = useRef(isNetworkOffline);

  // Tự động tải lại bản đồ và đồng bộ di sản khi mạng kết nối trở lại
  useEffect(() => {
    if (prevOfflineRef.current && !isNetworkOffline) {
      console.log('[MapScreen] Đã có mạng trở lại, tự động nạp lại bản đồ và di sản...');
      setIsOffline(false);
      setErrorMessage(null);
      mapRef.current?.reloadTiles();

      appService
        .getAllHeritage()
        .then((data) => {
          if (Array.isArray(data) && data.length > 0) {
            const adapted = adaptHeritageList(data).map((s) => ({
              id: s.id,
              name: s.name,
              locationName: s.locationName || s.province,
              latitude: s.latitude,
              longitude: s.longitude,
              category: s.category || 'Di sản văn hóa',
              image: s.imageUrl || s.image,
              description: s.description,
              icon: '🏛️',
              color: '#B91C1C',
            }));
            const valid = adapted.filter((s) => s.latitude && s.longitude);
            setDbSites(valid);
            saveOfflineHeritages(data).catch(() => {});
          }
        })
        .catch(() => {});
    }
    prevOfflineRef.current = isNetworkOffline;
  }, [isNetworkOffline]);

  // Điểm tọa độ người dùng / điểm bắt đầu (Ưu tiên GPS thực, fallback DEFAULT_COORDS)
  const defaultUserCoords = userCoords
    ? [userCoords.longitude, userCoords.latitude]
    : [DEFAULT_COORDS.longitude, DEFAULT_COORDS.latitude];

  const getRouteColor = (mode) => {
    if (mode === 'walking') return '#2E7D32';
    if (mode === 'cycling') return '#0284C7';
    return '#C62828';
  };

  // Tải danh sách di sản (Đồng bộ hạt giống -> Offline cache -> Backend Supabase)
  const [dbSites, setDbSites] = useState(() => {
    try {
      const seed = getSeedHeritages();
      if (Array.isArray(seed) && seed.length > 0) {
        return seed
          .map((s) => ({
            id: s.id,
            name: s.name,
            locationName: s.locationName || s.province,
            latitude: s.latitude,
            longitude: s.longitude,
            category: s.category || 'Di sản văn hóa',
            image: s.imageUrl || s.image,
            description: s.description,
            icon: '🏛️',
            color: '#B91C1C',
          }))
          .filter((s) => s.latitude && s.longitude);
      }
    } catch (_) {}
    return [];
  });

  useEffect(() => {
    let isMounted = true;

    // 1. Nạp nhanh từ AsyncStorage (nếu từng đồng bộ bản offline trước đó)
    getOfflineHeritages()
      .then((offlineData) => {
        if (isMounted && Array.isArray(offlineData) && offlineData.length > 0) {
          const adapted = offlineData
            .map((s) => ({
              id: s.id,
              name: s.name,
              locationName: s.locationName || s.province,
              latitude: s.latitude,
              longitude: s.longitude,
              category: s.category || 'Di sản văn hóa',
              image: s.imageUrl || s.image,
              description: s.description,
              icon: '🏛️',
              color: '#B91C1C',
            }))
            .filter((s) => s.latitude && s.longitude);
          setDbSites(adapted);
        }
      })
      .catch(() => {});

    // 2. Tải bản mới nhất từ backend online
    appService
      .getAllHeritage()
      .then((data) => {
        if (isMounted && Array.isArray(data) && data.length > 0) {
          const adapted = adaptHeritageList(data).map((s) => ({
            id: s.id,
            name: s.name,
            locationName: s.locationName || s.province,
            latitude: s.latitude,
            longitude: s.longitude,
            category: s.category || 'Di sản văn hóa',
            image: s.imageUrl || s.image,
            description: s.description,
            icon: '🏛️',
            color: '#B91C1C',
          }));
          const valid = adapted.filter((s) => s.latitude && s.longitude);
          setDbSites(valid);
          saveOfflineHeritages(data).catch(() => {});
        }
      })
      .catch((err) => {
        console.warn('[MapScreen] Đang dùng dữ liệu di sản offline/seed:', err.message);
      });
    return () => {
      isMounted = false;
    };
  }, [i18n.language]);

  // Xoá cache BBox khi đổi ngôn ngữ để marker tải lại đúng ngôn ngữ mới
  useEffect(() => {
    bboxCacheRef.current = {};
  }, [i18n.language]);

  // Kho dữ liệu tìm kiếm: Toàn bộ di sản thật tải từ Supabase
  const allSearchableSites = useMemo(() => {
    return dbSites;
  }, [dbSites]);

  // Lọc kết quả tìm kiếm thả xuống theo từ khóa gõ vào (tìm trong toàn bộ di sản Supabase)
  const searchResults = useMemo(() => {
    const q = search.trim().toLowerCase();
    if (!q) return [];
    return allSearchableSites
      .filter((s) => {
        const name = (s.name || '').toLowerCase();
        const loc = (s.locationName || s.province || '').toLowerCase();
        const cat = (s.category || '').toLowerCase();
        return name.includes(q) || loc.includes(q) || cat.includes(q);
      })
      .slice(0, 8);
  }, [search, allSearchableSites]);

  // Tự động bay ngay đến tọa độ địa danh khi chuyển hướng từ DetailScreen, Camera hoặc Chat
  const focusOnSite = (targetSite) => {
    if (!targetSite) return;
    const lat = Number(targetSite.latitude ?? targetSite.lat);
    const lng = Number(targetSite.longitude ?? targetSite.lng);
    if (isNaN(lat) || isNaN(lng) || lat === 0 || lng === 0) return;

    setIsNavigating(false);
    setNavTurnInfo(null);
    setIsPannedDuringNav(false);
    setRouteInfo(null);
    setShowRadiusDrawer(false);
    mapRef.current?.clearRoute();
    mapRef.current?.clearRadiusCircle();

    setSelectedMarkerSite(targetSite);

    // Cắm ghim ngay lập tức cho địa danh được chọn để hiển thị rõ ràng
    const siteMarker = {
      id: targetSite.id,
      name: targetSite.name,
      latitude: lat,
      longitude: lng,
      category: targetSite.category || 'Di sản',
      province: targetSite.province || targetSite.locationName || 'Việt Nam',
      imageUrl: targetSite.imageUrl || targetSite.image,
      color: '#C62828',
    };
    mapRef.current?.updateMarkers([siteMarker]);
    mapRef.current?.flyTo(lat, lng, 16.5, is3D ? 55 : 0, -20);
  };

  const handleMapReady = () => {
    if (userCoords?.latitude && userCoords?.longitude) {
      mapRef.current?.updateUserLocation(
        userCoords.latitude,
        userCoords.longitude,
        userCoords.heading || 0,
        isNavigating,
        routeMode
      );
    }
    if (focusedSite) {
      focusOnSite(focusedSite);
    }
  };

  useEffect(() => {
    if (focusedSite) {
      focusOnSite(focusedSite);
    }
  }, [focusedSite]);

  // Chuyển kiểu bản đồ: NORMAL (roadmap) ↔ HYBRID (hybrid) (Bước 2)
  const toggleMapType = () => {
    setIsHybrid((prev) => {
      const next = !prev;
      mapRef.current?.setMapType(next ? 'hybrid' : 'roadmap');
      return next;
    });
  };

  // Bật/tắt chế độ 3D Tilt 45 độ & Heading -20 độ (Bước 2)
  const toggle3D = () => {
    setIs3D((prev) => {
      const next = !prev;
      mapRef.current?.set3DMode(next);
      return next;
    });
  };

  // Xử lý camera dừng di chuyển (onCameraIdle): Debounce 400ms & Huỷ request cũ (Bước 3)
  const handleCameraIdle = (bounds, zoom, center) => {
    if (!bounds) return;

    if (debounceTimerRef.current) {
      clearTimeout(debounceTimerRef.current);
    }
    if (abortControllerRef.current) {
      abortControllerRef.current.abort();
    }

    debounceTimerRef.current = setTimeout(async () => {
      const gridKey = `${bounds.minLat.toFixed(2)}_${bounds.minLng.toFixed(2)}_${bounds.maxLat.toFixed(2)}_${bounds.maxLng.toFixed(2)}`;

      // Kiểm tra cache BBox trong RAM
      if (bboxCacheRef.current[gridKey]) {
        const cached = bboxCacheRef.current[gridKey];
        mapPerfLogger.logBBoxApiLatency(0, true, cached.length, gridKey);
        mapRef.current?.updateMarkers(cached);
        return;
      }

      const startReq = Date.now();
      const controller = new AbortController();
      abortControllerRef.current = controller;

      try {
        const data = await appService.getHeritageByBBox(
          bounds.minLat,
          bounds.minLng,
          bounds.maxLat,
          bounds.maxLng,
          150,
          controller.signal
        );

        const dur = Date.now() - startReq;
        if (Array.isArray(data) && data.length > 0) {
          const markers = data.map((s) => ({
            id: s.id,
            name: s.name,
            latitude: s.latitude,
            longitude: s.longitude,
            category: s.category || 'Di sản',
            province: s.province,
            imageUrl: s.imageUrl,
            color: '#C62828',
          }));

          bboxCacheRef.current[gridKey] = markers;
          mapPerfLogger.logBBoxApiLatency(dur, false, markers.length, gridKey);
          mapRef.current?.updateMarkers(markers);
          setIsOffline(false);
          setErrorMessage(null);
          return;
        }
      } catch (err) {
        if (err.name !== 'CanceledError' && err.name !== 'AbortError') {
          console.warn('[MapScreen] Lỗi tải BBox:', err.message);
          setIsOffline(true);
          setErrorMessage(t('map.offlineMsg'));
        }
      }

      // Offline / Fallback: Nếu BBox API lỗi hoặc rỗng, tự động lọc từ dbSites có sẵn trong tầm nhìn bounds
      if (Array.isArray(dbSites) && dbSites.length > 0) {
        const fallbackMarkers = dbSites
          .filter((s) => {
            const sLat = Number(s.latitude);
            const sLng = Number(s.longitude);
            return (
              !isNaN(sLat) &&
              !isNaN(sLng) &&
              sLat >= bounds.minLat &&
              sLat <= bounds.maxLat &&
              sLng >= bounds.minLng &&
              sLng <= bounds.maxLng
            );
          })
          .map((s) => ({
            id: s.id,
            name: s.name,
            latitude: Number(s.latitude),
            longitude: Number(s.longitude),
            category: s.category || 'Di sản',
            province: s.locationName || s.province,
            imageUrl: s.image,
            color: '#C62828',
          }));

        if (fallbackMarkers.length > 0) {
          bboxCacheRef.current[gridKey] = fallbackMarkers;
          mapRef.current?.updateMarkers(fallbackMarkers);
        }
      }
    }, 400); // Debounce 400ms (Bước 3)
  };

  // Xử lý khi người dùng CHỌN 1 ĐỊA DANH TỪ TÌM KIẾM -> BAY 3D MƯỢT MÀ, ĐẾN NƠI PIN MỚI XUẤT HIỆN
  const handleSelectSearchResult = (site) => {
    if (!site) return;
    setSearch(site.name);
    setShowSearchResults(false);
    Keyboard.dismiss();

    // 1. Tạm ẩn pin trong khi camera đang bay
    setSelectedMarkerSite(null);

    const lat = Number(site.latitude ?? site.lat);
    const lng = Number(site.longitude ?? site.lng);
    if (!isNaN(lat) && !isNaN(lng) && mapRef.current) {
      // 2. Kích hoạt camera bay 3D mượt mà
      mapRef.current.flyTo(lat, lng, 16.5, is3D ? 55 : 0, -20);
      // 3. Đúng khi camera vừa đáp xuống (~1300ms), Pin mới chính thức xuất hiện & nổi bật
      setTimeout(() => {
        setSelectedMarkerSite(site);
      }, 1300);
    } else {
      setSelectedMarkerSite(site);
    }
  };

  // Xử lý bay nhanh đến tọa độ địa danh khi chọn từ Menu
  const handleFlyToDestination = (destKey) => {
    setActiveDestKey(destKey);
    const dest = MAP_CONFIG.DESTINATIONS[destKey];
    if (dest && mapRef.current) {
      mapRef.current.flyTo(
        dest.center[1],
        dest.center[0],
        dest.zoom,
        is3D ? dest.pitch : 0,
        dest.bearing
      );
    }
    setShowQuickMenu(false);
  };

  // Nút GPS: Định vị lại trung tâm theo GPS thực tế của người dùng
  const handleRecenter = () => {
    if (userCoords && mapRef.current) {
      mapRef.current.flyTo(userCoords.latitude, userCoords.longitude, 16.0, is3D ? 45 : 0, 0);
    } else {
      handleFlyToDestination('danang');
    }
  };

  // Tính toán lộ trình đường đi qua Backend (POST /api/routes - Ràng buộc 1 & Bước 4: KHÔNG dùng Google Directions/Routes)
  const calculateRoute = async (destCoords, destName, mode = routeMode) => {
    setIsCalculatingRoute(true);
    setRouteMode(mode);
    const start = defaultUserCoords;

    try {
      const res = await appService.calculateRoute(start[1], start[0], destCoords[1], destCoords[0], mode);

      if (res && res.points && res.points.length > 0) {
        // Đơn giản hoá đa tuyến với thuật toán Douglas-Peucker (dung sai 5m) (Bước 4)
        const simplifyStart = Date.now();
        const simplified = simplifyDouglasPeucker(
          res.points.map((p) => ({ lat: p.latitude, lng: p.longitude })),
          5.0
        );
        const simplifyDur = Date.now() - simplifyStart;

        mapPerfLogger.logRouteSimplify(res.points.length, simplified.length, simplifyDur);

        setRouteInfo({
          destName,
          destCoords,
          distanceKm: res.distanceKm,
          durationMin: res.durationMin,
          points: simplified,
        });

        // Vẽ tuyến đường đa tuyến Polyline lên Google Maps theo màu & kiểu phương tiện
        mapRef.current?.drawRoute(simplified, getRouteColor(mode), mode);
        setShowRadiusDrawer(false);
      }
    } catch (err) {
      console.warn('[MapScreen] Lỗi tính tuyến đường nội bộ:', err.message);
      setErrorMessage(t('map.routeError'));
    } finally {
      setIsCalculatingRoute(false);
    }
  };

  const effectiveNavCoords = isNavigating && isSimulating && simCoords ? simCoords : userCoords;

  // Đồng bộ vị trí thực của người dùng hoặc vị trí mô phỏng phương tiện lên bản đồ
  useEffect(() => {
    const activeCoords = isNavigating && isSimulating && simCoords ? simCoords : userCoords;
    if (activeCoords?.latitude && activeCoords?.longitude && mapRef.current) {
      mapRef.current.updateUserLocation(
        activeCoords.latitude,
        activeCoords.longitude,
        activeCoords.heading || 0,
        isNavigating,
        routeMode
      );
    }
  }, [userCoords, simCoords, isNavigating, isSimulating, routeMode]);

  // Vòng lặp mô phỏng di chuyển mượt mà theo tuyến đường đã chọn (tốc độ tỷ lệ theo phương tiện)
  useEffect(() => {
    if (!isNavigating || !isSimulating || !routeInfo?.points || routeInfo.points.length < 2) {
      return;
    }

    const points = routeInfo.points;
    // Tốc độ mô phỏng (km/h) được nhân hệ số để người dùng thấy phương tiện di chuyển rõ trên bản đồ
    const simSpeedKmh = routeMode === 'walking' ? 18 : routeMode === 'cycling' ? 40 : 75;
    const tickMs = 500;
    const stepKm = (simSpeedKmh * tickMs) / 3600000;

    const timer = setInterval(() => {
      let { index, progress } = simSegmentRef.current;
      if (index >= points.length - 1) {
        clearInterval(timer);
        return;
      }

      let remainingStepKm = stepKm;
      while (remainingStepKm > 0 && index < points.length - 1) {
        const a = points[index];
        const b = points[index + 1];
        const aLat = Number(a.lat ?? a.latitude);
        const aLng = Number(a.lng ?? a.longitude);
        const bLat = Number(b.lat ?? b.latitude);
        const bLng = Number(b.lng ?? b.longitude);
        const segLenKm = Math.max(0.001, haversineDistanceKm(aLat, aLng, bLat, bLng));
        const remOnSegKm = segLenKm * (1 - progress);

        if (remainingStepKm < remOnSegKm) {
          progress += remainingStepKm / segLenKm;
          remainingStepKm = 0;
        } else {
          remainingStepKm -= remOnSegKm;
          index += 1;
          progress = 0;
        }
      }

      simSegmentRef.current = { index, progress };

      if (index >= points.length - 1) {
        const endPt = points[points.length - 1];
        setSimCoords({
          latitude: Number(endPt.lat ?? endPt.latitude),
          longitude: Number(endPt.lng ?? endPt.longitude),
          heading: 0,
        });
        return;
      }

      const p1 = points[index];
      const p2 = points[index + 1];
      const lat1 = Number(p1.lat ?? p1.latitude);
      const lng1 = Number(p1.lng ?? p1.longitude);
      const lat2 = Number(p2.lat ?? p2.latitude);
      const lng2 = Number(p2.lng ?? p2.longitude);

      const curLat = lat1 + (lat2 - lat1) * progress;
      const curLng = lng1 + (lng2 - lng1) * progress;
      const heading = calculateBearing(lat1, lng1, lat2, lng2);

      setSimCoords({
        latitude: curLat,
        longitude: curLng,
        heading,
      });
    }, tickMs);

    return () => clearInterval(timer);
  }, [isNavigating, isSimulating, routeInfo, routeMode]);

  // Vòng lặp giám sát dẫn đường thời gian thực với giải thuật Dijkstra (Tính năng 8)
  useEffect(() => {
    if (!isNavigating || !routeInfo?.points || routeInfo.points.length < 2 || !effectiveNavCoords) {
      return;
    }

    const userLat = effectiveNavCoords.latitude;
    const userLng = effectiveNavCoords.longitude;
    const points = routeInfo.points;

    // 1. Kiểm tra đã đến đích chưa (< 35 mét)
    const destPoint = points[points.length - 1];
    const destLat = Number(destPoint.lat ?? destPoint.latitude);
    const destLng = Number(destPoint.lng ?? destPoint.longitude);
    const distToDestMeters = haversineDistanceKm(userLat, userLng, destLat, destLng) * 1000;

    if (distToDestMeters < 35) {
      setNavTurnInfo({
        action: 'arrived',
        icon: 'flag',
        text: t('map.arrivedAt', { name: routeInfo.destName || '' }),
        distMeters: 0,
      });
      const timer = setTimeout(() => {
        handleStopNavigation();
      }, 4000);
      return () => clearTimeout(timer);
    }

    // 2. Map-Matching: Nắn khớp vị trí lên tim đường
    const snapped = snapToRoute(userLat, userLng, points);

    // 3. Off-Route Detection: Kiểm tra lệch đường (> 45 mét)
    const offRoute = isOffRoute(userLat, userLng, points, 45);
    const now = Date.now();

    if (offRoute && now - lastRerouteTimeRef.current > 6000) {
      lastRerouteTimeRef.current = now;
      setIsRerouting(true);
      // Tự động kích hoạt Dijkstra tìm lại đường từ vị trí thực tế đến đích
      appService
        .calculateRoute(userLat, userLng, routeInfo.destCoords[1], routeInfo.destCoords[0], routeMode)
        .then((res) => {
          if (res?.points?.length > 0) {
            const simplified = simplifyDouglasPeucker(
              res.points.map((p) => ({ lat: p.latitude, lng: p.longitude })),
              5.0
            );
            setRouteInfo((prev) => ({
              ...prev,
              distanceKm: res.distanceKm,
              durationMin: res.durationMin,
              points: simplified,
            }));
            mapRef.current?.drawRoute(simplified, getRouteColor(routeMode), routeMode);
          }
        })
        .catch((err) => {
          console.warn('[MapScreen] Lỗi tự động tính lại lộ trình Dijkstra:', err.message);
        })
        .finally(() => {
          setIsRerouting(false);
        });
      return;
    }

    // 4. Tính toán chỉ dẫn chuyển hướng & góc rẽ
    const currentSeg = snapped.segmentIndex;
    const nextPt = points[currentSeg + 1] || destPoint;
    const afterNextPt = points[currentSeg + 2] || nextPt;

    const nextLat = Number(nextPt.lat ?? nextPt.latitude);
    const nextLng = Number(nextPt.lng ?? nextPt.longitude);

    const distToNextMeters = haversineDistanceKm(userLat, userLng, nextLat, nextLng) * 1000;
    const bearingToNext = calculateBearing(userLat, userLng, nextLat, nextLng);

    const turn = getTurnInstruction(effectiveNavCoords.heading || bearingToNext, nextPt, afterNextPt);
    const turnTextMap = {
      straight: t('map.turnStraight'),
      right: t('map.turnRight'),
      left: t('map.turnLeft'),
      u_turn: t('map.turnUTurn'),
    };

    setNavTurnInfo({
      icon: turn.icon,
      text: turnTextMap[turn.action] || t('map.turnStraight'),
      action: turn.action,
      distMeters: Math.round(distToNextMeters),
    });

    // 5. Cập nhật góc camera bám theo chuyển động (chỉ khi không tự pan tay)
    if (!isPannedDuringNav) {
      mapRef.current?.updateNavBearing(bearingToNext);
    }

    // 6. Cập nhật cự ly và thời gian còn lại
    const remainingKm = Number((distToDestMeters / 1000).toFixed(1));
    const avgSpeedKmh = routeMode === 'walking' ? 4.5 : routeMode === 'cycling' ? 15 : 35;
    const remainingMin = Math.max(1, Math.round((remainingKm / avgSpeedKmh) * 60));

    setNavRemaining({
      distanceKm: remainingKm,
      durationMin: remainingMin,
    });
  }, [effectiveNavCoords, isNavigating, routeInfo, routeMode, isPannedDuringNav]);

  // Bắt đầu chế độ Dẫn đường thực tế 3D (Tính năng 8)
  const handleStartNavigation = () => {
    if (!routeInfo || !routeInfo.points || routeInfo.points.length < 2) return;
    setIsNavigating(true);
    setIsPannedDuringNav(false);
    setShowQuickMenu(false);
    setShowSearchResults(false);
    setShowRadiusDrawer(false);

    const startPt = routeInfo.points[0];
    const startLat = Number(startPt.lat ?? startPt.latitude ?? userCoords?.latitude ?? DEFAULT_COORDS.latitude);
    const startLng = Number(startPt.lng ?? startPt.longitude ?? userCoords?.longitude ?? DEFAULT_COORDS.longitude);
    const nextPt = routeInfo.points[1] || startPt;
    const initialBearing = calculateBearing(
      startLat,
      startLng,
      Number(nextPt.lat ?? nextPt.latitude),
      Number(nextPt.lng ?? nextPt.longitude)
    );

    simSegmentRef.current = { index: 0, progress: 0 };
    setSimCoords({ latitude: startLat, longitude: startLng, heading: initialBearing });
    setIsSimulating(true);

    mapRef.current?.startNavigation(startLat, startLng, initialBearing, routeMode);
  };

  // Dừng chế độ dẫn đường
  const handleStopNavigation = () => {
    setIsNavigating(false);
    setIsSimulating(false);
    setSimCoords(null);
    setNavTurnInfo(null);
    setIsPannedDuringNav(false);
    const lat = userCoords?.latitude ?? DEFAULT_COORDS.latitude;
    const lng = userCoords?.longitude ?? DEFAULT_COORDS.longitude;
    mapRef.current?.stopNavigation(lat, lng);
  };

  // Căn giữa lại camera trong chế độ dẫn đường
  const handleRecenterNav = () => {
    setIsPannedDuringNav(false);
    const target = isSimulating && simCoords ? simCoords : userCoords;
    if (target && mapRef.current) {
      mapRef.current.startNavigation(target.latitude, target.longitude, target.heading || 0, routeMode);
    }
  };

  // Hủy lộ trình đang chỉ đường
  const handleCancelRoute = () => {
    handleStopNavigation();
    setRouteInfo(null);
    mapRef.current?.clearRoute();
  };

  // Kích hoạt quét di tích bán kính quanh người dùng (2km, 5km, 10km) (Tính năng 1)
  const handleStartRadiusScan = (radiusKm = scanRadiusKm) => {
    setIsScanningRadius(true);
    setScanRadiusKm(radiusKm);
    handleCancelRoute();

    const userLat = userCoords ? userCoords.latitude : 16.0610;
    const userLng = userCoords ? userCoords.longitude : 108.2274;

    mapRef.current?.drawRadiusCircle(userLat, userLng, radiusKm);

    // Tính khoảng cách Haversine chính xác và lọc các di sản nằm trong bán kính
    const matched = allSearchableSites
      .map((site) => {
        const sLat = Number(site.latitude ?? site.lat);
        const sLng = Number(site.longitude ?? site.lng);
        if (isNaN(sLat) || isNaN(sLng) || sLat === 0) return null;
        const dist = haversineDistanceKm(userLat, userLng, sLat, sLng);
        return {
          ...site,
          distanceKm: dist,
        };
      })
      .filter((s) => s && s.distanceKm <= radiusKm)
      .sort((a, b) => a.distanceKm - b.distanceKm);

    setNearbyPois(matched);
    setShowRadiusDrawer(true);
    setIsScanningRadius(false);

    // Cập nhật marker trên bản đồ để làm nổi bật các điểm vừa quét
    if (matched.length > 0) {
      mapRef.current?.updateMarkers(matched);
    }
  };

  // Đóng bảng kết quả quét
  const handleCloseRadiusDrawer = () => {
    setShowRadiusDrawer(false);
    setIsScanningRadius(false);
    mapRef.current?.clearRadiusCircle();
  };

  // Khi bấm vào 1 Marker trên MapLibre
  const handleMarkerSelected = (siteOrId) => {
    const found =
      siteOrId && typeof siteOrId === 'object'
        ? siteOrId
        : allSearchableSites.find((s) => s.id === siteOrId);
    if (found) {
      setSelectedMarkerSite(found);
      const lat = Number(found.latitude ?? found.lat);
      const lng = Number(found.longitude ?? found.lng);
      if (!isNaN(lat) && !isNaN(lng) && mapRef.current) {
        mapRef.current.flyTo(lat, lng, 16.5, is3D ? 55 : 0, -20);
      }
    }
  };

  // Lọc danh sách điểm đến theo miền trong Menu nhanh
  const filteredDestinations = Object.entries(MAP_CONFIG.DESTINATIONS).filter(([_, d]) => {
    if (selectedRegion === 'Tất cả') return true;
    return d.region === selectedRegion;
  });

  return (
    <View style={styles.container}>
      {/* 1. Google Maps Engine (Tương thích 100% Expo Go và Android / Web - Ràng buộc 1, 2) */}
      <VietLensGoogleMapView
        ref={mapRef}
        style={StyleSheet.absoluteFillObject}
        onMapReady={handleMapReady}
        onSelectSite={(site) => {
          handleMarkerSelected(site);
        }}
        onCameraIdle={handleCameraIdle}
        onMapLoaded={(durationMs) => {
          mapPerfLogger.recordMapLoaded(durationMs);
        }}
        onMapClick={() => {
          if (showQuickMenu) setShowQuickMenu(false);
          if (showSearchResults) setShowSearchResults(false);
        }}
        onUserPannedNav={() => {
          setIsPannedDuringNav(true);
        }}
      />

      {/* Banner Cảnh Báo Ngoại Tuyến (Offline) */}
      {!isNavigating && (isNetworkOffline || isOffline || errorMessage) && (
        <View style={styles.offlineBanner}>
          <Ionicons name="cloud-offline" size={16} color="#B91C1C" />
          <Text style={styles.offlineBannerText} numberOfLines={1}>
            {isNetworkOffline
              ? t('map.offlineMsg')
              : errorMessage || t('map.offlineMsg')}
          </Text>
          <TouchableOpacity
            style={styles.btnRetry}
            onPress={() => {
              setIsOffline(false);
              setErrorMessage(null);
              mapRef.current?.reloadTiles();
            }}
          >
            <Text style={styles.btnRetryText}>{t('map.retry')}</Text>
          </TouchableOpacity>
        </View>
      )}

      {/* Floating Header: Thanh Tìm Kiếm Rộng Rãi Toàn Ngang */}
      {!isNavigating && (
        <View style={styles.topSearchWrapper}>
          <View style={styles.searchRow}>
            {/* Nút Menu Bay Nhanh Toàn Quốc */}
            <TouchableOpacity
              style={[
                styles.menuFab,
                {
                  backgroundColor: isDark ? 'rgba(38, 34, 30, 0.78)' : 'rgba(255, 255, 255, 0.78)',
                  borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(255, 255, 255, 0.65)',
                },
                showQuickMenu && styles.menuFabActive,
              ]}
              onPress={() => setShowQuickMenu((prev) => !prev)}
              activeOpacity={0.8}
            >
              <Ionicons
                name={showQuickMenu ? 'close' : 'menu'}
                size={22}
                color={showQuickMenu ? '#FFF' : theme.colors.ink}
              />
            </TouchableOpacity>

            {/* Thanh Tìm Kiếm Mở Rộng */}
            <View
              style={[
                styles.searchBar,
                {
                  backgroundColor: isDark ? 'rgba(30, 27, 24, 0.96)' : 'rgba(255, 255, 255, 0.96)',
                  borderColor: isDark ? 'rgba(255, 255, 255, 0.18)' : 'rgba(221, 214, 190, 0.9)',
                },
              ]}
            >
              <Ionicons name="search-outline" size={18} color={theme.colors.inkMuted} />
              <TextInput
                style={[styles.searchInput, { color: theme.colors.ink }]}
                placeholder={t('map.searchPlaceholder')}
                placeholderTextColor={isDark ? '#B8B2A6' : theme.colors.inkMuted}
                underlineColorAndroid="transparent"
                value={search}
                onChangeText={(text) => {
                  setSearch(text);
                  setShowSearchResults(true);
                }}
                onFocus={() => {
                  if (search.length > 0) setShowSearchResults(true);
                }}
                returnKeyType="search"
                onSubmitEditing={() => {
                  if (searchResults.length > 0) {
                    handleSelectSearchResult(searchResults[0]);
                  }
                }}
              />
              {search.length > 0 && (
                <TouchableOpacity
                  onPress={() => {
                    setSearch('');
                    setShowSearchResults(false);
                  }}
                >
                  <Ionicons name="close-circle" size={18} color={theme.colors.inkMuted} />
                </TouchableOpacity>
              )}
            </View>
          </View>

          {/* Dropdown Gợi Ý Kết Quả Tìm Kiếm Thả Xuống */}
          {showSearchResults && searchResults.length > 0 && (
            <View style={[styles.searchDropdown, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
              <ScrollView style={{ maxHeight: 220 }} keyboardShouldPersistTaps="handled">
                {searchResults.map((item) => (
                  <TouchableOpacity
                    key={item.id}
                    style={[styles.searchResultItem, { borderBottomColor: theme.colors.border }]}
                    onPress={() => handleSelectSearchResult(item)}
                    activeOpacity={0.7}
                  >
                    <View style={styles.searchResultIconBadge}>
                      <Text style={{ fontSize: 16 }}>{item.icon || '🏛️'}</Text>
                    </View>
                    <View style={styles.searchResultInfo}>
                      <Text style={[styles.searchResultName, { color: theme.colors.ink }]} numberOfLines={1}>
                        {item.name}
                      </Text>
                      <Text style={[styles.searchResultMeta, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                        {item.locationName || item.province} • {item.category}
                      </Text>
                    </View>
                    <Ionicons name="paper-plane-outline" size={16} color={theme.colors.amber} />
                  </TouchableOpacity>
                ))}
              </ScrollView>
            </View>
          )}
        </View>
      )}

      {/* Cụm Nút Điều Khiển Bản Đồ Xếp Dọc Cạnh Phải (Thoáng Mắt Như Google Maps) */}
      {!isNavigating && (
        <View style={styles.rightActionControls}>
          {/* Nút 3D / 2D (Bước 2) */}
          <TouchableOpacity
            style={[
              styles.floatingActionBtn,
              {
                backgroundColor: isDark ? 'rgba(38, 34, 30, 0.78)' : 'rgba(255, 255, 255, 0.78)',
                borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(255, 255, 255, 0.65)',
              },
              is3D && styles.floatingActionBtnActive,
            ]}
            onPress={toggle3D}
            activeOpacity={0.8}
          >
            <Text style={[styles.fabText, { color: theme.colors.ink }, is3D && styles.fabTextActive]}>3D</Text>
          </TouchableOpacity>

          {/* Nút Chuyển Kiểu Bản Đồ: NORMAL (roadmap) ↔ HYBRID (hybrid) (Bước 2) */}
          <TouchableOpacity
            style={[
              styles.floatingActionBtn,
              {
                backgroundColor: isDark ? 'rgba(38, 34, 30, 0.78)' : 'rgba(255, 255, 255, 0.78)',
                borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(255, 255, 255, 0.65)',
              },
              isHybrid && styles.floatingActionBtnActive,
            ]}
            onPress={toggleMapType}
            activeOpacity={0.8}
          >
            <Text style={[styles.fabText, { color: theme.colors.ink }, isHybrid && styles.fabTextActive]}>
              {isHybrid ? 'HYB' : 'MAP'}
            </Text>
          </TouchableOpacity>

          {/* Nút Quét di tích xung quanh (Tính năng 1: 2km/5km/10km) */}
          <TouchableOpacity
            style={[
              styles.floatingActionBtn,
              {
                backgroundColor: isDark ? 'rgba(38, 34, 30, 0.78)' : 'rgba(255, 255, 255, 0.78)',
                borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(255, 255, 255, 0.65)',
              },
              isScanningRadius && styles.floatingActionBtnActive,
            ]}
            onPress={() => handleStartRadiusScan(scanRadiusKm)}
            activeOpacity={0.8}
          >
            {isScanningRadius ? (
              <ActivityIndicator size="small" color="#C62828" />
            ) : (
              <MaterialCommunityIcons name="radar" size={20} color="#C62828" />
            )}
          </TouchableOpacity>

          {/* Nút GPS Định Vị Vị Trí Của Tôi */}
          <TouchableOpacity
            style={[
              styles.floatingActionBtn,
              {
                backgroundColor: isDark ? 'rgba(38, 34, 30, 0.78)' : 'rgba(255, 255, 255, 0.78)',
                borderColor: isDark ? 'rgba(255, 255, 255, 0.15)' : 'rgba(255, 255, 255, 0.65)',
              },
            ]}
            onPress={handleRecenter}
            activeOpacity={0.8}
          >
            <Ionicons name="locate" size={20} color={theme.colors.red} />
          </TouchableOpacity>
        </View>
      )}

      {/* Thông báo địa danh vừa chụp từ Camera */}
      {!isNavigating && focusedSite && focusedSite.name && !routeInfo && !selectedMarkerSite && (
        <View style={styles.focusedBanner}>
          <View style={styles.focusedBadge}>
            <Ionicons name="camera" size={14} color="#FFF" />
            <Text style={styles.focusedBadgeText}>{t('map.justRecognized')}</Text>
          </View>
          <Text style={styles.focusedName} numberOfLines={1}>
            {focusedSite.name}
          </Text>
          <TouchableOpacity
            style={styles.focusedRouteBtn}
            onPress={() => {
              const lat = Number(focusedSite.latitude ?? focusedSite.lat);
              const lng = Number(focusedSite.longitude ?? focusedSite.lng);
              calculateRoute([lng, lat], focusedSite.name);
            }}
          >
            <Ionicons name="navigate" size={12} color="#FFF" />
            <Text style={styles.focusedRouteText}>{t('map.directions')}</Text>
          </TouchableOpacity>
        </View>
      )}

      {/* Card Tóm Tắt Di Sản Đang Chọn (Preview Card Dưới Đáy Màn Hình) */}
      {!isNavigating && selectedMarkerSite && !routeInfo && (
        <View style={[styles.sitePreviewCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
          <View style={styles.sitePreviewHeader}>
            <View style={styles.sitePreviewThumbWrap}>
              {(selectedMarkerSite.userPhoto || selectedMarkerSite.image) ? (
                <Image
                  source={{ uri: selectedMarkerSite.userPhoto || selectedMarkerSite.image }}
                  style={styles.sitePreviewThumb}
                />
              ) : (
                <View style={styles.sitePreviewThumbFallback}>
                  <Text style={{ fontSize: 22 }}>{selectedMarkerSite.icon || '🏛️'}</Text>
                </View>
              )}
            </View>

            <View style={styles.sitePreviewInfo}>
              <Text style={[styles.sitePreviewTitle, { color: theme.colors.ink }]} numberOfLines={1}>
                {selectedMarkerSite.name}
              </Text>
              <Text style={[styles.sitePreviewSub, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                {selectedMarkerSite.locationName || selectedMarkerSite.province} • {selectedMarkerSite.category}
              </Text>
            </View>

            <TouchableOpacity
              style={styles.sitePreviewCloseBtn}
              onPress={() => setSelectedMarkerSite(null)}
            >
              <Ionicons name="close" size={18} color={theme.colors.inkMuted} />
            </TouchableOpacity>
          </View>

          <View style={styles.sitePreviewActions}>
            <TouchableOpacity
              style={styles.btnNavPrimary}
              onPress={() => {
                const lat = Number(selectedMarkerSite.latitude ?? selectedMarkerSite.lat);
                const lng = Number(selectedMarkerSite.longitude ?? selectedMarkerSite.lng);
                calculateRoute([lng, lat], selectedMarkerSite.name);
              }}
            >
              <Ionicons name="navigate" size={14} color="#FFF" style={{ flexShrink: 0 }} />
              <Text numberOfLines={1} adjustsFontSizeToFit minimumFontScale={0.8} style={[styles.btnNavPrimaryText, { flexShrink: 1 }]}>
                {t('map.directionsDijkstra')}
              </Text>
            </TouchableOpacity>

            {onSelectSite && (
              <TouchableOpacity
                style={[styles.btnDetailSecondary, { borderColor: theme.colors.red }]}
                onPress={() => onSelectSite(selectedMarkerSite)}
              >
                <Ionicons name="information-circle-outline" size={15} color={theme.colors.red} style={{ flexShrink: 0 }} />
                <Text numberOfLines={1} adjustsFontSizeToFit minimumFontScale={0.8} style={[styles.btnDetailSecondaryText, { color: theme.colors.red, flexShrink: 1 }]}>
                  {t('map.exploreDetails')}
                </Text>
              </TouchableOpacity>
            )}
          </View>
        </View>
      )}

      {/* Menu Bay Nhanh Toàn Quốc (Miền Bắc, Miền Trung, Miền Nam) */}
      {!isNavigating && showQuickMenu && (
        <View style={[styles.quickMenuDrawer, { backgroundColor: theme.colors.card }]}>
          <View style={styles.drawerHeader}>
            <View style={styles.drawerTitleRow}>
              <Ionicons name="navigate-circle-outline" size={18} color="#C62828" />
              <Text style={[styles.drawerTitle, { color: theme.colors.ink }]}>{t('map.quickFlyTitle')}</Text>
            </View>
            <TouchableOpacity onPress={() => setShowQuickMenu(false)}>
              <Ionicons name="close" size={18} color={theme.colors.inkMuted} />
            </TouchableOpacity>
          </View>

          {/* Tab Chọn Vùng Miền */}
          <View style={styles.regionTabs}>
            {[
              { id: 'Tất cả', label: t('map.regionAll') },
              { id: 'Miền Bắc', label: t('map.regionNorth') },
              { id: 'Miền Trung', label: t('map.regionCentral') },
              { id: 'Miền Nam', label: t('map.regionSouth') },
            ].map((reg) => (
              <TouchableOpacity
                key={reg.id}
                style={[styles.regionChip, { backgroundColor: theme.colors.parchment }, selectedRegion === reg.id && styles.regionChipActive]}
                onPress={() => setSelectedRegion(reg.id)}
              >
                <Text
                  numberOfLines={1}
                  style={[
                    styles.regionChipText,
                    { color: theme.colors.ink },
                    selectedRegion === reg.id && styles.regionChipTextActive,
                  ]}
                >
                  {reg.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Danh Sách Điểm Đến */}
          <ScrollView style={styles.destinationList} showsVerticalScrollIndicator={false}>
            {filteredDestinations.map(([key, item]) => {
              const isActive = activeDestKey === key;
              return (
                <TouchableOpacity
                  key={key}
                  style={[styles.destinationItem, { borderBottomColor: theme.colors.border }, isActive && styles.destinationItemActive]}
                  onPress={() => handleFlyToDestination(key)}
                  activeOpacity={0.7}
                >
                  <Text style={styles.destEmoji}>{item.emoji}</Text>
                  <View style={styles.destInfo}>
                    <Text style={[styles.destName, { color: theme.colors.ink }, isActive && styles.destNameActive]}>
                      {item.name}
                    </Text>
                    <Text style={[styles.destRegion, { color: theme.colors.inkMuted }]}>{item.region}</Text>
                  </View>
                  <Ionicons
                    name={isActive ? 'radio-button-on' : 'chevron-forward'}
                    size={16}
                    color={isActive ? '#C62828' : theme.colors.inkLight}
                  />
                </TouchableOpacity>
              );
            })}
          </ScrollView>
        </View>
      )}

      {/* Thẻ Lộ Trình Thực Tế (Routing Preview Card với Nút Bắt Đầu Dijkstra) */}
      {!isNavigating && routeInfo && (
        <View style={[styles.routeCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
          <View style={styles.routeHeader}>
            <View style={styles.routeTitleWrap}>
              <View style={styles.badgeRouteRow}>
                <Ionicons name="navigate" size={12} color="#C62828" />
                <Text style={styles.badgeRoute}>{t('map.routeBadge')}</Text>
              </View>
              <Text style={[styles.routeDestTitle, { color: theme.colors.ink }]} numberOfLines={1}>
                {routeInfo.destName}
              </Text>
            </View>
            <TouchableOpacity style={styles.btnCloseRoute} onPress={handleCancelRoute}>
              <Ionicons name="close" size={18} color={theme.colors.inkMuted} />
            </TouchableOpacity>
          </View>

          {/* Chế độ phương tiện */}
          <View style={styles.routeModes}>
            {[
              { id: 'driving', label: t('map.modeDriving'), icon: 'motorbike' },
              { id: 'walking', label: t('map.modeWalking'), icon: 'walk' },
              { id: 'cycling', label: t('map.modeCycling'), icon: 'bicycle' },
            ].map((m) => {
              const activeColor = getRouteColor(m.id);
              const isActive = routeMode === m.id;
              return (
                <TouchableOpacity
                  key={m.id}
                  style={[
                    styles.modeTab,
                    { backgroundColor: theme.colors.parchment },
                    isActive && { backgroundColor: activeColor },
                  ]}
                  onPress={() => calculateRoute(routeInfo.destCoords, routeInfo.destName, m.id)}
                >
                  <MaterialCommunityIcons
                    name={m.icon}
                    size={16}
                    color={isActive ? '#FFF' : theme.colors.ink}
                    style={{ flexShrink: 0 }}
                  />
                  <Text
                    numberOfLines={1}
                    adjustsFontSizeToFit
                    minimumFontScale={0.8}
                    style={[styles.modeTabText, { color: theme.colors.ink, flexShrink: 1 }, isActive && styles.modeTabTextActive]}
                  >
                    {m.label}
                  </Text>
                </TouchableOpacity>
              );
            })}
          </View>

          {/* Thống kê km và phút */}
          <View style={[styles.routeStats, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
            <View style={styles.statBox}>
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('map.distance')}</Text>
              <Text style={[styles.statVal, { color: theme.colors.ink }]}>{routeInfo.distanceKm} km</Text>
            </View>
            <View style={[styles.statDivider, { backgroundColor: theme.colors.border }]} />
            <View style={styles.statBox}>
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('map.estimatedTime')}</Text>
              <Text style={[styles.statVal, { color: theme.colors.ink }]}>{routeInfo.durationMin} {t('map.minuteUnit')}</Text>
            </View>
          </View>

          {/* Nút Bắt Đầu Dẫn Đường Thực Tế 3D bằng Dijkstra */}
          <TouchableOpacity
            style={[styles.btnStartNavigation, { backgroundColor: getRouteColor(routeMode) }]}
            onPress={handleStartNavigation}
            activeOpacity={0.8}
          >
            <MaterialCommunityIcons
              name={routeMode === 'walking' ? 'walk' : routeMode === 'cycling' ? 'bicycle' : 'motorbike'}
              size={19}
              color="#FFF"
              style={{ flexShrink: 0 }}
            />
            <Text numberOfLines={1} adjustsFontSizeToFit minimumFontScale={0.85} style={[styles.btnStartNavigationText, { flexShrink: 1 }]}>
              {t('map.startNav', {
                mode: routeMode === 'walking' ? t('map.modeWalking') : routeMode === 'cycling' ? t('map.modeCycling') : t('map.modeDriving'),
              })}
            </Text>
          </TouchableOpacity>
        </View>
      )}

      {/* 🧭 GIAO DIỆN DẪN ĐƯỜNG THỰC TẾ 3D (NAVIGATION COCKPIT - TÍNH NĂNG 8) */}
      {isNavigating && (
        <>
          {/* Top Turn-by-Turn Card HUD */}
          <View style={styles.navHeaderCard}>
            <View style={styles.navIconWrap}>
              <Ionicons
                name={navTurnInfo?.icon || 'navigate'}
                size={26}
                color="#FDE047"
              />
            </View>
            <View style={styles.navInstructionWrap}>
              <Text style={styles.navDistText}>
                {navTurnInfo?.distMeters != null ? `${navTurnInfo.distMeters} m` : '--'}
              </Text>
              <Text style={styles.navActionText} numberOfLines={2}>
                {navTurnInfo?.text || t('map.continueStraight')}
              </Text>
              {isRerouting ? (
                <View style={styles.reroutingBadge}>
                  <ActivityIndicator size="small" color="#FDE047" style={{ marginRight: 4 }} />
                  <Text style={styles.reroutingText}>{t('map.rerouting')}</Text>
                </View>
              ) : (
                <Text style={styles.navAlgoBadge}>
                  {t('map.navMonitoring')}
                </Text>
              )}
            </View>
            <TouchableOpacity
              style={styles.navCloseBtn}
              onPress={handleStopNavigation}
              activeOpacity={0.8}
            >
              <Ionicons name="close" size={20} color="#FFF" />
            </TouchableOpacity>
          </View>

          {/* Nút Nổi Định Vị Lại Giữa Màn Hình Khi Bị Kéo Lệch */}
          {isPannedDuringNav && (
            <TouchableOpacity
              style={styles.navRecenterFloatingBtn}
              onPress={handleRecenterNav}
              activeOpacity={0.8}
            >
              <Ionicons name="locate" size={18} color="#FFF" />
              <Text style={styles.navRecenterText}>{t('map.recenter')}</Text>
            </TouchableOpacity>
          )}

          {/* Bottom Navigation Status Bar HUD */}
          <View style={styles.navBottomCard}>
            <View style={styles.navStatsRow}>
              <View style={styles.navStatCol}>
                <Text style={styles.navStatVal}>{navRemaining.distanceKm}</Text>
                <Text style={styles.navStatUnit}>{t('map.kmRemaining')}</Text>
              </View>
              <View style={styles.navStatDivider} />
              <View style={styles.navStatCol}>
                <Text style={styles.navStatVal}>{navRemaining.durationMin}</Text>
                <Text style={styles.navStatUnit}>{t('map.minuteUnit')}</Text>
              </View>
              <View style={styles.navStatDivider} />
              <View style={[styles.navStatCol, { flex: 1.4, alignItems: 'flex-start' }]}>
                <Text style={styles.navDestName} numberOfLines={1}>
                  {routeInfo?.destName || ''}
                </Text>
                <Text style={styles.navModeLabel} numberOfLines={1}>
                  {routeMode === 'driving' ? `🏍️ ${t('map.modeDriving')}` : routeMode === 'walking' ? `🚶 ${t('map.modeWalking')}` : `🚲 ${t('map.modeCycling')}`}
                  {isSimulating ? ` • ${t('map.simulatingTag')}` : ` • ${t('map.liveGpsTag')}`}
                </Text>
              </View>
            </View>

            <View style={{ flexDirection: 'row', gap: 8 }}>
              <TouchableOpacity
                style={[
                  styles.btnStopNav,
                  { flex: 1, paddingHorizontal: 8, backgroundColor: isSimulating ? '#0284C7' : '#44403C' },
                ]}
                onPress={() => setIsSimulating((prev) => !prev)}
                activeOpacity={0.8}
              >
                <Ionicons name={isSimulating ? 'pause-circle' : 'play-circle'} size={18} color="#FFF" style={{ flexShrink: 0 }} />
                <Text numberOfLines={1} adjustsFontSizeToFit minimumFontScale={0.8} style={[styles.btnStopNavText, { flexShrink: 1 }]}>
                  {isSimulating ? t('map.useLiveGps') : t('map.simulate')}
                </Text>
              </TouchableOpacity>

              <TouchableOpacity
                style={[styles.btnStopNav, { flex: 1, paddingHorizontal: 8 }]}
                onPress={handleStopNavigation}
                activeOpacity={0.8}
              >
                <Ionicons name="stop-circle" size={18} color="#FFF" style={{ flexShrink: 0 }} />
                <Text numberOfLines={1} adjustsFontSizeToFit minimumFontScale={0.8} style={[styles.btnStopNavText, { flexShrink: 1 }]}>
                  {t('map.stopNav')}
                </Text>
              </TouchableOpacity>
            </View>
          </View>
        </>
      )}

      {/* Drawer: Kết Quả Quét Di Tích Bán Kính (2km / 5km / 10km - Tính năng 1) */}
      {!isNavigating && showRadiusDrawer && (
        <View style={[styles.radiusDrawer, { backgroundColor: theme.colors.card }]}>
          <View style={styles.drawerHeader}>
            <View style={styles.drawerTitleRow}>
              <MaterialCommunityIcons name="radar" size={18} color="#C62828" />
              <Text style={[styles.drawerTitle, { color: theme.colors.ink }]}>
                {t('map.nearbyTitle', { count: nearbyPois.length })}
              </Text>
            </View>
            <TouchableOpacity onPress={handleCloseRadiusDrawer}>
              <Ionicons name="close" size={18} color={theme.colors.inkMuted} />
            </TouchableOpacity>
          </View>

          {/* Bộ chọn bán kính: 2km, 5km, 10km */}
          <View style={styles.radiusChipsRow}>
            {[2.0, 5.0, 10.0].map((r) => (
              <TouchableOpacity
                key={r}
                style={[
                  styles.radiusFilterChip,
                  { backgroundColor: theme.colors.parchment },
                  scanRadiusKm === r && styles.radiusFilterChipActive,
                ]}
                onPress={() => handleStartRadiusScan(r)}
              >
                <Text
                  numberOfLines={1}
                  adjustsFontSizeToFit
                  minimumFontScale={0.8}
                  style={[
                    styles.radiusFilterText,
                    { color: theme.colors.ink },
                    scanRadiusKm === r && styles.radiusFilterTextActive,
                  ]}
                >
                  {t('map.radiusChip', { radius: r })}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          <ScrollView style={styles.radiusList} contentContainerStyle={{ gap: 8 }}>
            {nearbyPois.length === 0 ? (
              <View style={{ paddingVertical: 18, alignItems: 'center' }}>
                <Text style={{ fontSize: 12, color: theme.colors.inkMuted, textAlign: 'center' }}>
                  {t('map.noNearbyFound', { radius: scanRadiusKm })}
                </Text>
              </View>
            ) : (
              nearbyPois.map((poi, idx) => (
                <View key={poi.id || idx} style={[styles.radiusItem, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
                  <View style={styles.radiusItemIconWrap}>
                    <Text style={{ fontSize: 18 }}>{poi.icon || '🏛️'}</Text>
                  </View>
                  <View style={{ flex: 1 }}>
                    <Text style={[styles.radiusItemName, { color: theme.colors.ink }]} numberOfLines={1}>
                      {poi.name}
                    </Text>
                    <Text style={[styles.radiusItemType, { color: theme.colors.inkMuted }]}>
                      {poi.category} • {t('map.distanceAway', { distance: poi.distanceKm?.toFixed(1) })}
                    </Text>
                  </View>
                  <TouchableOpacity
                    style={styles.btnNavMini}
                    onPress={() => {
                      setShowRadiusDrawer(false);
                      calculateRoute([poi.longitude, poi.latitude], poi.name);
                    }}
                  >
                    <Ionicons name="navigate" size={12} color="#FFF" />
                    <Text style={styles.btnNavMiniText}>{t('map.directions')}</Text>
                  </TouchableOpacity>
                </View>
              ))
            )}
          </ScrollView>
        </View>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#F5F5DC',
  },

  // Banner Ngoại Tuyến (Offline)
  offlineBanner: {
    position: 'absolute',
    top: 68,
    left: 14,
    right: 14,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FEF2F2',
    borderWidth: 1,
    borderColor: '#FCA5A5',
    borderRadius: 12,
    paddingHorizontal: 12,
    paddingVertical: 8,
    gap: 8,
    zIndex: 25,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  offlineBannerText: {
    flex: 1,
    fontSize: 11,
    color: '#991B1B',
    fontWeight: '600',
  },
  btnRetry: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    backgroundColor: '#EF4444',
    borderRadius: 6,
  },
  btnRetryText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
  },

  // Thanh Tìm Kiếm Rộng Rãi Toàn Ngang
  topSearchWrapper: {
    position: 'absolute',
    top: 14,
    left: 14,
    right: 14,
    zIndex: 30,
  },
  searchRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  menuFab: {
    width: 46,
    height: 46,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  menuFabActive: {
    backgroundColor: '#C62828',
    borderColor: '#C62828',
  },
  searchBar: {
    flex: 1,
    height: 46,
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    borderRadius: 14,
    borderWidth: 1,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  searchInput: {
    flex: 1,
    marginLeft: 8,
    fontSize: 14,
    color: THEME.colors.ink,
    paddingVertical: 0,
  },

  // Dropdown Gợi Ý Tìm Kiếm
  searchDropdown: {
    marginTop: 8,
    backgroundColor: '#FFF',
    borderRadius: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 8,
    overflow: 'hidden',
  },
  searchResultItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#F5F5F4',
    gap: 10,
  },
  searchResultIconBadge: {
    width: 32,
    height: 32,
    borderRadius: 8,
    backgroundColor: '#FEF3C7',
    alignItems: 'center',
    justifyContent: 'center',
  },
  searchResultInfo: {
    flex: 1,
  },
  searchResultName: {
    fontSize: 13,
    fontWeight: '700',
    color: '#1C1917',
  },
  searchResultMeta: {
    fontSize: 11,
    color: '#78716C',
    marginTop: 2,
  },

  // Cụm Nút Điều Khiển Bản Đồ Dọc Bên Phải
  rightActionControls: {
    position: 'absolute',
    top: 72,
    right: 14,
    gap: 10,
    zIndex: 25,
  },
  floatingActionBtn: {
    width: 44,
    height: 44,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
  },
  floatingActionBtnActive: {
    backgroundColor: 'rgba(254, 243, 199, 0.92)',
    borderColor: '#C62828',
  },
  fabText: {
    fontSize: 12,
    fontWeight: '800',
    color: THEME.colors.ink,
  },
  fabTextActive: {
    color: '#C62828',
  },

  // Banner Địa Danh Vừa Nhận Diện Từ Camera
  focusedBanner: {
    position: 'absolute',
    top: 72,
    left: 14,
    right: 70,
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(245, 245, 220, 0.95)',
    borderWidth: 1,
    borderColor: '#C62828',
    borderRadius: 14,
    paddingHorizontal: 10,
    paddingVertical: 8,
    zIndex: 20,
    gap: 8,
  },
  focusedBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: '#C62828',
    paddingHorizontal: 7,
    paddingVertical: 3,
    borderRadius: 8,
  },
  focusedBadgeText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
  },
  focusedName: {
    flex: 1,
    fontSize: 12,
    fontWeight: '700',
    color: '#1C1917',
  },
  focusedRouteBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: '#C62828',
    paddingHorizontal: 8,
    paddingVertical: 5,
    borderRadius: 8,
  },
  focusedRouteText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
  },

  // Card Tóm Tắt Di Sản Đang Chọn
  sitePreviewCard: {
    position: 'absolute',
    bottom: 20,
    left: 14,
    right: 14,
    backgroundColor: '#FFFFFF',
    borderRadius: 18,
    padding: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.16,
    shadowRadius: 8,
    zIndex: 28,
  },
  sitePreviewHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  sitePreviewThumbWrap: {
    width: 48,
    height: 48,
    borderRadius: 12,
    overflow: 'hidden',
  },
  sitePreviewThumb: {
    width: '100%',
    height: '100%',
    resizeMode: 'cover',
  },
  sitePreviewThumbFallback: {
    width: '100%',
    height: '100%',
    backgroundColor: '#FEF3C7',
    alignItems: 'center',
    justifyContent: 'center',
  },
  sitePreviewInfo: {
    flex: 1,
  },
  sitePreviewTitle: {
    fontSize: 14,
    fontWeight: '800',
    color: '#1C1917',
  },
  sitePreviewSub: {
    fontSize: 11,
    color: '#78716C',
    marginTop: 2,
  },
  sitePreviewCloseBtn: {
    padding: 4,
  },
  sitePreviewActions: {
    flexDirection: 'row',
    gap: 10,
    marginTop: 12,
  },
  btnNavPrimary: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#C62828',
    paddingVertical: 10,
    borderRadius: 10,
    gap: 6,
  },
  btnNavPrimaryText: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: '700',
  },
  btnDetailSecondary: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#FEF2F2',
    borderWidth: 1,
    borderColor: '#FECACA',
    paddingVertical: 10,
    borderRadius: 10,
    gap: 6,
  },
  btnDetailSecondaryText: {
    color: '#C62828',
    fontSize: 12,
    fontWeight: '700',
  },

  // Drawer Menu Điểm Bay Nhanh Toàn Quốc
  quickMenuDrawer: {
    position: 'absolute',
    top: 105,
    left: 14,
    right: 70,
    backgroundColor: 'rgba(255, 255, 255, 0.98)',
    borderRadius: 16,
    padding: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.16,
    shadowRadius: 8,
    zIndex: 29,
    maxHeight: 380,
  },
  drawerHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  drawerTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  drawerTitle: {
    fontSize: 13,
    fontWeight: '800',
    color: '#1C1917',
  },
  regionTabs: {
    flexDirection: 'row',
    gap: 6,
    marginBottom: 10,
  },
  regionChip: {
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
    backgroundColor: '#F5F5F4',
  },
  regionChipActive: {
    backgroundColor: '#FEF3C7',
    borderWidth: 1,
    borderColor: '#C62828',
  },
  regionChipText: {
    fontSize: 10,
    fontWeight: '600',
    color: '#78716C',
  },
  regionChipTextActive: {
    color: '#C62828',
    fontWeight: '700',
  },
  destinationList: {
    maxHeight: 260,
  },
  destinationItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 8,
    paddingHorizontal: 8,
    borderRadius: 10,
    marginBottom: 4,
    gap: 10,
  },
  destinationItemActive: {
    backgroundColor: '#FEF2F2',
  },
  destEmoji: {
    fontSize: 18,
  },
  destInfo: {
    flex: 1,
  },
  destName: {
    fontSize: 12,
    fontWeight: '700',
    color: '#1C1917',
  },
  destNameActive: {
    color: '#C62828',
  },
  destRegion: {
    fontSize: 10,
    color: '#A8A29E',
    marginTop: 1,
  },

  // Thẻ Lộ Trình (Route Card)
  routeCard: {
    position: 'absolute',
    bottom: 20,
    left: 14,
    right: 14,
    backgroundColor: '#FFFFFF',
    borderRadius: 18,
    padding: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.16,
    shadowRadius: 8,
    zIndex: 28,
  },
  routeHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 10,
  },
  routeTitleWrap: {
    flex: 1,
  },
  badgeRouteRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginBottom: 2,
  },
  badgeRoute: {
    fontSize: 9,
    fontWeight: '800',
    color: '#C62828',
    letterSpacing: 0.5,
  },
  routeDestTitle: {
    fontSize: 14,
    fontWeight: '800',
    color: '#1C1917',
  },
  btnCloseRoute: {
    padding: 4,
  },
  routeModes: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 10,
  },
  modeTab: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 7,
    borderRadius: 10,
    backgroundColor: '#F5F5F4',
    gap: 5,
  },
  modeTabActive: {
    backgroundColor: '#C62828',
  },
  modeTabText: {
    fontSize: 11,
    fontWeight: '700',
    color: '#57534E',
  },
  modeTabTextActive: {
    color: '#FFF',
  },
  routeStats: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: THEME.colors.parchment,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    paddingVertical: 8,
    paddingHorizontal: 12,
    borderRadius: 10,
  },
  statBox: {
    flex: 1,
    alignItems: 'center',
  },
  statLabel: {
    fontSize: 10,
    color: '#78716C',
  },
  statVal: {
    fontSize: 13,
    fontWeight: '800',
    color: '#C62828',
    marginTop: 2,
  },
  statDivider: {
    width: 1,
    height: 24,
    backgroundColor: '#E7E5E4',
  },

  // Drawer Quét 2km
  radiusDrawer: {
    position: 'absolute',
    bottom: 20,
    left: 14,
    right: 14,
    maxHeight: 260,
    backgroundColor: '#FFF',
    borderRadius: 18,
    padding: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.16,
    shadowRadius: 8,
    zIndex: 28,
  },
  radiusList: {
    marginTop: 8,
  },
  radiusItem: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 6,
    borderBottomWidth: 1,
    borderBottomColor: '#F5F5F4',
  },
  radiusItemName: {
    fontSize: 12,
    fontWeight: '700',
    color: '#1C1917',
  },
  radiusItemType: {
    fontSize: 10,
    color: '#78716C',
  },
  btnNavMini: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
    backgroundColor: '#C62828',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 6,
  },
  btnNavMiniText: {
    fontSize: 10,
    fontWeight: '700',
    color: '#FFF',
  },

  // Nút Bắt Đầu Dẫn Đường
  btnStartNavigation: {
    marginTop: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#C62828',
    paddingVertical: 11,
    borderRadius: 12,
    gap: 8,
    elevation: 3,
    shadowColor: '#C62828',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
  },
  btnStartNavigationText: {
    color: '#FFF',
    fontSize: 13,
    fontWeight: '800',
    letterSpacing: 0.3,
  },

  // 🧭 Navigation HUD (Tính năng 8)
  navHeaderCard: {
    position: 'absolute',
    top: 50,
    left: 14,
    right: 14,
    backgroundColor: 'rgba(15, 23, 42, 0.95)',
    borderRadius: 16,
    padding: 12,
    flexDirection: 'row',
    alignItems: 'center',
    borderWidth: 1,
    borderColor: '#334155',
    elevation: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.3,
    shadowRadius: 8,
    zIndex: 40,
  },
  navIconWrap: {
    width: 44,
    height: 44,
    borderRadius: 12,
    backgroundColor: '#1E293B',
    alignItems: 'center',
    justifyContent: 'center',
  },
  navInstructionWrap: {
    flex: 1,
    marginLeft: 10,
    justifyContent: 'center',
  },
  navDistText: {
    fontSize: 20,
    fontWeight: '900',
    color: '#FDE047',
    lineHeight: 22,
  },
  navActionText: {
    fontSize: 13,
    fontWeight: '700',
    color: '#F8FAFC',
    marginTop: 2,
  },
  reroutingBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 3,
  },
  reroutingText: {
    fontSize: 10,
    color: '#FDE047',
    fontWeight: '700',
  },
  navAlgoBadge: {
    fontSize: 9,
    color: '#94A3B8',
    fontWeight: '600',
    marginTop: 3,
  },
  navCloseBtn: {
    width: 32,
    height: 32,
    borderRadius: 8,
    backgroundColor: 'rgba(255, 255, 255, 0.15)',
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 8,
  },
  navRecenterFloatingBtn: {
    position: 'absolute',
    bottom: 150,
    right: 16,
    backgroundColor: '#0F172A',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 14,
    paddingVertical: 9,
    borderRadius: 22,
    borderWidth: 1,
    borderColor: '#334155',
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.3,
    shadowRadius: 5,
    zIndex: 40,
  },
  navRecenterText: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: '700',
  },
  navBottomCard: {
    position: 'absolute',
    bottom: 20,
    left: 14,
    right: 14,
    backgroundColor: '#FFFFFF',
    borderRadius: 18,
    padding: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
    zIndex: 40,
  },
  navStatsRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 10,
  },
  navStatCol: {
    alignItems: 'center',
    minWidth: 60,
  },
  navStatVal: {
    fontSize: 18,
    fontWeight: '800',
    color: '#1E293B',
  },
  navStatUnit: {
    fontSize: 10,
    color: '#64748B',
    marginTop: 1,
  },
  navStatDivider: {
    width: 1,
    height: 28,
    backgroundColor: '#E2E8F0',
    marginHorizontal: 10,
  },
  navDestName: {
    fontSize: 13,
    fontWeight: '800',
    color: '#0F172A',
  },
  navModeLabel: {
    fontSize: 10,
    color: '#64748B',
    marginTop: 2,
    fontWeight: '600',
  },
  btnStopNav: {
    backgroundColor: '#EF4444',
    paddingVertical: 9,
    borderRadius: 10,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },
  btnStopNavText: {
    color: '#FFF',
    fontSize: 12,
    fontWeight: '700',
  },

  // Bộ lọc bán kính quét (Tính năng 1)
  radiusChipsRow: {
    flexDirection: 'row',
    gap: 8,
    marginBottom: 10,
  },
  radiusFilterChip: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    backgroundColor: '#F5F5F4',
    borderWidth: 1,
    borderColor: '#E7E5E4',
  },
  radiusFilterChipActive: {
    backgroundColor: '#C62828',
    borderColor: '#C62828',
  },
  radiusFilterText: {
    fontSize: 11,
    fontWeight: '600',
    color: '#78716C',
  },
  radiusFilterTextActive: {
    color: '#FFF',
    fontWeight: '700',
  },
  radiusItemIconWrap: {
    width: 34,
    height: 34,
    borderRadius: 8,
    backgroundColor: '#FEF3C7',
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 10,
  },
});
