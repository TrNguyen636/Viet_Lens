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
  Image,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { THEME } from '../utils/theme';
import InteractiveHeritageMap from '../components/InteractiveHeritageMap';
import { MAP_CONFIG } from '../utils/mapConfig';
import appService from '../api/appService';
import { adaptHeritageList } from '../utils/heritageAdapter';
import useUserLocation from '../hooks/useUserLocation';

export default function MapScreen({ onSelectSite, onNavigateToChat, focusedSite = null }) {
  const mapRef = useRef(null);
  const [search, setSearch] = useState('');
  const [showSearchResults, setShowSearchResults] = useState(false);
  const [selectedMarkerSite, setSelectedMarkerSite] = useState(null);

  const [is3D, setIs3D] = useState(true);
  const [theme, setTheme] = useState('vietlens'); // 'vietlens' | 'dark' | 'light'
  const [showQuickMenu, setShowQuickMenu] = useState(false);
  const [activeDestKey, setActiveDestKey] = useState('danang');
  const [selectedRegion, setSelectedRegion] = useState('Tất cả');

  // Trạng thái Lộ trình OSRM (Routing Card)
  const [routeInfo, setRouteInfo] = useState(null);
  const [routeMode, setRouteMode] = useState('driving'); // 'driving' | 'walking' | 'cycling'
  const [isCalculatingRoute, setIsCalculatingRoute] = useState(false);

  // Trạng thái Quét bán kính 2km (Radius Search)
  const [isScanningRadius, setIsScanningRadius] = useState(false);
  const [nearbyPois, setNearbyPois] = useState([]);
  const [showRadiusDrawer, setShowRadiusDrawer] = useState(false);

  const { coords: userCoords } = useUserLocation();

  // Điểm tọa độ người dùng / điểm bắt đầu (Ưu tiên GPS thực, fallback Đà Nẵng)
  const defaultUserCoords = userCoords
    ? [userCoords.longitude, userCoords.latitude]
    : [108.2274, 16.0610];

  // Tải toàn bộ danh sách di sản từ Backend Supabase/Spring Boot
  const [dbSites, setDbSites] = useState([]);
  useEffect(() => {
    let isMounted = true;
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
          setDbSites(adapted.filter((s) => s.latitude && s.longitude));
        }
      })
      .catch((err) => {
        console.warn('[MapScreen] Lỗi tải di sản:', err.message);
      });
    return () => {
      isMounted = false;
    };
  }, []);

  // Kho dữ liệu tìm kiếm: Toàn bộ di sản thật tải từ Supabase
  const allSearchableSites = useMemo(() => {
    return dbSites;
  }, [dbSites]);

  // CƠ CHẾ ON-DEMAND PINNING: Chỉ hiển thị DUY NHẤT Pin khi người dùng search hoặc vừa quét Camera
  // Mặc định: RỖNG (0 Pin), bản đồ hoàn toàn sạch sẽ, không dồn cục
  const displayedPins = useMemo(() => {
    if (selectedMarkerSite && (selectedMarkerSite.latitude || selectedMarkerSite.lat)) {
      return [{
        id: selectedMarkerSite.id || 'selected-search-site',
        name: selectedMarkerSite.name,
        locationName: selectedMarkerSite.locationName || selectedMarkerSite.province,
        latitude: Number(selectedMarkerSite.latitude ?? selectedMarkerSite.lat),
        longitude: Number(selectedMarkerSite.longitude ?? selectedMarkerSite.lng),
        category: selectedMarkerSite.category || 'Di sản văn hóa',
        image: selectedMarkerSite.image || selectedMarkerSite.imageUrl,
        icon: '📍',
        color: '#C62828',
      }];
    }
    if (focusedSite && (focusedSite.latitude || focusedSite.lat)) {
      return [{
        id: focusedSite.id || 'focused-camera-site',
        name: focusedSite.name,
        locationName: focusedSite.locationName || focusedSite.province,
        latitude: Number(focusedSite.latitude ?? focusedSite.lat),
        longitude: Number(focusedSite.longitude ?? focusedSite.lng),
        category: focusedSite.category || 'Di tích khám phá',
        image: focusedSite.image || focusedSite.imageUrl,
        icon: '📍',
        color: '#C62828',
      }];
    }
    return [];
  }, [selectedMarkerSite, focusedSite]);

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

  // Tự động bay đến tọa độ địa danh nếu được chuyển hướng từ Camera
  useEffect(() => {
    if (focusedSite && mapRef.current) {
      const lat = Number(focusedSite.latitude ?? focusedSite.lat);
      const lng = Number(focusedSite.longitude ?? focusedSite.lng);
      if (!isNaN(lat) && !isNaN(lng) && lat !== 0 && lng !== 0) {
        const timer = setTimeout(() => {
          mapRef.current?.flyTo(lat, lng, 16.5, is3D ? 55 : 0, -20);
          setTimeout(() => {
            setSelectedMarkerSite(focusedSite);
          }, 1300);
        }, 500);
        return () => clearTimeout(timer);
      }
    }
  }, [focusedSite]);

  // Luân chuyển 3 Theme: VietLens Heritage -> Dark -> Light
  const cycleTheme = () => {
    setTheme((current) => {
      if (current === 'vietlens') return 'dark';
      if (current === 'dark') return 'light';
      return 'vietlens';
    });
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

  // Tính toán lộ trình đường đi OSRM
  const calculateRoute = async (destCoords, destName, mode = routeMode) => {
    setIsCalculatingRoute(true);
    setRouteMode(mode);
    const start = defaultUserCoords;

    const url = `${MAP_CONFIG.OSRM_BASE_URL}/route/v1/${mode}/${start[0]},${start[1]};${destCoords[0]},${destCoords[1]}?overview=full&geometries=geojson`;

    try {
      const res = await fetch(url);
      const data = await res.json();

      if (data.routes && data.routes.length > 0) {
        const route = data.routes[0];
        const distKm = (route.distance / 1000).toFixed(1);
        const durMin = Math.round(route.duration / 60);

        setRouteInfo({
          destName,
          destCoords,
          distanceKm: distKm,
          durationMin: durMin,
          geometry: route.geometry,
        });

        // Vẽ đường lên MapLibre
        mapRef.current?.drawRoute(route.geometry, theme === 'dark' ? '#00f2fe' : '#C62828');
        setShowRadiusDrawer(false);
      }
    } catch (err) {
      console.warn('[MapScreen] OSRM route error:', err.message);
    } finally {
      setIsCalculatingRoute(false);
    }
  };

  // Hủy lộ trình đang chỉ đường
  const handleCancelRoute = () => {
    setRouteInfo(null);
    mapRef.current?.clearRoute();
  };

  // Kích hoạt quét di tích bán kính 2km quanh người dùng
  const handleStartRadiusScan = () => {
    setIsScanningRadius(true);
    handleCancelRoute();
    mapRef.current?.drawRadiusCircle(defaultUserCoords[0], defaultUserCoords[1], 2.0);
  };

  // Đóng bảng kết quả quét
  const handleCloseRadiusDrawer = () => {
    setShowRadiusDrawer(false);
    setIsScanningRadius(false);
    mapRef.current?.clearRadiusCircle();
  };

  // Tiếp nhận kết quả quét di tích từ WebView
  const handleNearbyPoisReceived = (pois) => {
    setIsScanningRadius(false);
    if (Array.isArray(pois) && pois.length > 0) {
      setNearbyPois(pois);
      setShowRadiusDrawer(true);
    }
  };

  // Khi bấm vào 1 Marker trên MapLibre
  const handleMarkerSelected = (siteOrId) => {
    const found =
      siteOrId && typeof siteOrId === 'object'
        ? siteOrId
        : displayedPins.find((s) => s.id === siteOrId) ||
          allSearchableSites.find((s) => s.id === siteOrId);
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
      {/* Interactive MapLibre GL Vector Engine (PMTiles) */}
      <InteractiveHeritageMap
        ref={mapRef}
        sites={displayedPins}
        selectedSite={selectedMarkerSite}
        is3D={is3D}
        theme={theme}
        onRequestRoute={(dest) => {
          calculateRoute([dest.longitude, dest.latitude], dest.name);
        }}
        onNearbyPois={handleNearbyPoisReceived}
        onSelectSite={handleMarkerSelected}
        onMapClick={() => {
          if (showQuickMenu) setShowQuickMenu(false);
          if (showSearchResults) setShowSearchResults(false);
        }}
      />

      {/* Floating Header: Thanh Tìm Kiếm Rộng Rãi Toàn Ngang */}
      <View style={styles.topSearchWrapper}>
        <View style={styles.searchRow}>
          {/* Nút Menu Bay Nhanh Toàn Quốc */}
          <TouchableOpacity
            style={[styles.menuFab, showQuickMenu && styles.menuFabActive]}
            onPress={() => setShowQuickMenu((prev) => !prev)}
            activeOpacity={0.8}
          >
            <Ionicons
              name={showQuickMenu ? 'close' : 'menu'}
              size={22}
              color={showQuickMenu ? '#FFF' : THEME.colors.ink}
            />
          </TouchableOpacity>

          {/* Thanh Tìm Kiếm Mở Rộng */}
          <View style={styles.searchBar}>
            <Ionicons name="search-outline" size={18} color={THEME.colors.inkMuted} />
            <TextInput
              style={styles.searchInput}
              placeholder="Tìm di sản, địa danh, tỉnh thành..."
              placeholderTextColor={THEME.colors.inkLight}
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
                <Ionicons name="close-circle" size={18} color={THEME.colors.inkMuted} />
              </TouchableOpacity>
            )}
          </View>
        </View>

        {/* Dropdown Gợi Ý Kết Quả Tìm Kiếm Thả Xuống */}
        {showSearchResults && searchResults.length > 0 && (
          <View style={styles.searchDropdown}>
            <ScrollView style={{ maxHeight: 220 }} keyboardShouldPersistTaps="handled">
              {searchResults.map((item) => (
                <TouchableOpacity
                  key={item.id}
                  style={styles.searchResultItem}
                  onPress={() => handleSelectSearchResult(item)}
                  activeOpacity={0.7}
                >
                  <View style={styles.searchResultIconBadge}>
                    <Text style={{ fontSize: 16 }}>{item.icon || '🏛️'}</Text>
                  </View>
                  <View style={styles.searchResultInfo}>
                    <Text style={styles.searchResultName} numberOfLines={1}>
                      {item.name}
                    </Text>
                    <Text style={styles.searchResultMeta} numberOfLines={1}>
                      {item.locationName || item.province} • {item.category}
                    </Text>
                  </View>
                  <Ionicons name="paper-plane-outline" size={16} color={THEME.colors.amber} />
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        )}
      </View>

      {/* Cụm Nút Điều Khiển Bản Đồ Xếp Dọc Cạnh Phải (Thoáng Mắt Như Google Maps) */}
      <View style={styles.rightActionControls}>
        {/* Nút 3D / 2D */}
        <TouchableOpacity
          style={[styles.floatingActionBtn, is3D && styles.floatingActionBtnActive]}
          onPress={() => setIs3D((prev) => !prev)}
          activeOpacity={0.8}
        >
          <Text style={[styles.fabText, is3D && styles.fabTextActive]}>3D</Text>
        </TouchableOpacity>

        {/* Nút Đổi Theme */}
        <TouchableOpacity
          style={styles.floatingActionBtn}
          onPress={cycleTheme}
          activeOpacity={0.8}
        >
          {theme === 'vietlens' && (
            <MaterialCommunityIcons name="book-open-page-variant" size={18} color="#C62828" />
          )}
          {theme === 'dark' && <Ionicons name="moon" size={18} color="#00f2fe" />}
          {theme === 'light' && <Ionicons name="sunny" size={18} color="#d97706" />}
        </TouchableOpacity>

        {/* Nút Quét 2 km di tích xung quanh */}
        <TouchableOpacity
          style={[styles.floatingActionBtn, isScanningRadius && styles.floatingActionBtnActive]}
          onPress={handleStartRadiusScan}
          activeOpacity={0.8}
        >
          {isScanningRadius ? (
            <ActivityIndicator size="small" color="#090d16" />
          ) : (
            <MaterialCommunityIcons name="radar" size={20} color="#C62828" />
          )}
        </TouchableOpacity>

        {/* Nút GPS Định Vị Vị Trí Của Tôi */}
        <TouchableOpacity
          style={styles.floatingActionBtn}
          onPress={handleRecenter}
          activeOpacity={0.8}
        >
          <Ionicons name="locate" size={20} color={THEME.colors.red} />
        </TouchableOpacity>
      </View>

      {/* Thông báo địa danh vừa chụp từ Camera */}
      {focusedSite && focusedSite.name && !routeInfo && !selectedMarkerSite && (
        <View style={styles.focusedBanner}>
          <View style={styles.focusedBadge}>
            <Ionicons name="camera" size={14} color="#FFF" />
            <Text style={styles.focusedBadgeText}>Vừa nhận diện</Text>
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
            <Text style={styles.focusedRouteText}>Chỉ đường</Text>
          </TouchableOpacity>
        </View>
      )}

      {/* Card Tóm Tắt Di Sản Đang Chọn (Preview Card Dưới Đáy Màn Hình) */}
      {selectedMarkerSite && !routeInfo && (
        <View style={styles.sitePreviewCard}>
          <View style={styles.sitePreviewHeader}>
            <View style={styles.sitePreviewThumbWrap}>
              {selectedMarkerSite.image ? (
                <Image
                  source={{ uri: selectedMarkerSite.image }}
                  style={styles.sitePreviewThumb}
                />
              ) : (
                <View style={styles.sitePreviewThumbFallback}>
                  <Text style={{ fontSize: 22 }}>{selectedMarkerSite.icon || '🏛️'}</Text>
                </View>
              )}
            </View>

            <View style={styles.sitePreviewInfo}>
              <Text style={styles.sitePreviewTitle} numberOfLines={1}>
                {selectedMarkerSite.name}
              </Text>
              <Text style={styles.sitePreviewSub} numberOfLines={1}>
                {selectedMarkerSite.locationName || selectedMarkerSite.province} • {selectedMarkerSite.category}
              </Text>
            </View>

            <TouchableOpacity
              style={styles.sitePreviewCloseBtn}
              onPress={() => setSelectedMarkerSite(null)}
            >
              <Ionicons name="close" size={18} color="#78716C" />
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
              <Ionicons name="navigate" size={14} color="#FFF" />
              <Text style={styles.btnNavPrimaryText}>Chỉ đường OSRM</Text>
            </TouchableOpacity>

            {onSelectSite && (
              <TouchableOpacity
                style={styles.btnDetailSecondary}
                onPress={() => onSelectSite(selectedMarkerSite)}
              >
                <Ionicons name="information-circle-outline" size={15} color="#C62828" />
                <Text style={styles.btnDetailSecondaryText}>Khám phá chi tiết</Text>
              </TouchableOpacity>
            )}
          </View>
        </View>
      )}

      {/* Menu Bay Nhanh Toàn Quốc (Miền Bắc, Miền Trung, Miền Nam) */}
      {showQuickMenu && (
        <View style={styles.quickMenuDrawer}>
          <View style={styles.drawerHeader}>
            <View style={styles.drawerTitleRow}>
              <Ionicons name="navigate-circle-outline" size={18} color="#C62828" />
              <Text style={styles.drawerTitle}>Điểm Bay Nhanh Toàn Quốc</Text>
            </View>
            <TouchableOpacity onPress={() => setShowQuickMenu(false)}>
              <Ionicons name="close" size={18} color="#94a3b8" />
            </TouchableOpacity>
          </View>

          {/* Tab Chọn Vùng Miền */}
          <View style={styles.regionTabs}>
            {['Tất cả', 'Miền Bắc', 'Miền Trung', 'Miền Nam'].map((reg) => (
              <TouchableOpacity
                key={reg}
                style={[styles.regionChip, selectedRegion === reg && styles.regionChipActive]}
                onPress={() => setSelectedRegion(reg)}
              >
                <Text
                  style={[
                    styles.regionChipText,
                    selectedRegion === reg && styles.regionChipTextActive,
                  ]}
                >
                  {reg}
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
                  style={[styles.destinationItem, isActive && styles.destinationItemActive]}
                  onPress={() => handleFlyToDestination(key)}
                  activeOpacity={0.7}
                >
                  <Text style={styles.destEmoji}>{item.emoji}</Text>
                  <View style={styles.destInfo}>
                    <Text style={[styles.destName, isActive && styles.destNameActive]}>
                      {item.name}
                    </Text>
                    <Text style={styles.destRegion}>{item.region}</Text>
                  </View>
                  <Ionicons
                    name={isActive ? 'radio-button-on' : 'chevron-forward'}
                    size={16}
                    color={isActive ? '#C62828' : '#cbd5e1'}
                  />
                </TouchableOpacity>
              );
            })}
          </ScrollView>
        </View>
      )}

      {/* Thẻ Lộ Trình Thực Tế (OSRM Routing Card) */}
      {routeInfo && (
        <View style={styles.routeCard}>
          <View style={styles.routeHeader}>
            <View style={styles.routeTitleWrap}>
              <View style={styles.badgeRouteRow}>
                <Ionicons name="navigate" size={12} color="#C62828" />
                <Text style={styles.badgeRoute}>LỘ TRÌNH THỰC TẾ OSRM</Text>
              </View>
              <Text style={styles.routeDestTitle} numberOfLines={1}>
                {routeInfo.destName}
              </Text>
            </View>
            <TouchableOpacity style={styles.btnCloseRoute} onPress={handleCancelRoute}>
              <Ionicons name="close" size={18} color="#57534E" />
            </TouchableOpacity>
          </View>

          {/* Chế độ phương tiện */}
          <View style={styles.routeModes}>
            {[
              { id: 'driving', label: 'Lái xe', icon: 'car' },
              { id: 'walking', label: 'Đi bộ', icon: 'walk' },
              { id: 'cycling', label: 'Xe đạp', icon: 'bicycle' },
            ].map((m) => (
              <TouchableOpacity
                key={m.id}
                style={[styles.modeTab, routeMode === m.id && styles.modeTabActive]}
                onPress={() => calculateRoute(routeInfo.destCoords, routeInfo.destName, m.id)}
              >
                <Ionicons
                  name={m.icon}
                  size={14}
                  color={routeMode === m.id ? '#FFF' : '#57534E'}
                />
                <Text style={[styles.modeTabText, routeMode === m.id && styles.modeTabTextActive]}>
                  {m.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>

          {/* Thống kê km và phút */}
          <View style={styles.routeStats}>
            <View style={styles.statBox}>
              <Text style={styles.statLabel}>Khoảng cách</Text>
              <Text style={styles.statVal}>{routeInfo.distanceKm} km</Text>
            </View>
            <View style={styles.statDivider} />
            <View style={styles.statBox}>
              <Text style={styles.statLabel}>Thời gian dự kiến</Text>
              <Text style={styles.statVal}>{routeInfo.durationMin} phút</Text>
            </View>
          </View>
        </View>
      )}

      {/* Drawer: Kết Quả Quét Di Tích Bán Kính 2 km */}
      {showRadiusDrawer && (
        <View style={styles.radiusDrawer}>
          <View style={styles.drawerHeader}>
            <View style={styles.drawerTitleRow}>
              <MaterialCommunityIcons name="radar" size={18} color="#C62828" />
              <Text style={styles.drawerTitle}>Di tích trong bán kính 2 km</Text>
            </View>
            <TouchableOpacity onPress={handleCloseRadiusDrawer}>
              <Ionicons name="close" size={18} color="#57534E" />
            </TouchableOpacity>
          </View>

          <ScrollView style={styles.radiusList} contentContainerStyle={{ gap: 8 }}>
            {nearbyPois.map((poi, idx) => (
              <View key={idx} style={styles.radiusItem}>
                <View style={{ flex: 1 }}>
                  <Text style={styles.radiusItemName} numberOfLines={1}>
                    {poi.name}
                  </Text>
                  <Text style={styles.radiusItemType}>{poi.category}</Text>
                </View>
                <TouchableOpacity
                  style={styles.btnNavMini}
                  onPress={() => calculateRoute([poi.longitude, poi.latitude], poi.name)}
                >
                  <Ionicons name="navigate" size={12} color="#FFF" />
                  <Text style={styles.btnNavMiniText}>Chỉ đường</Text>
                </TouchableOpacity>
              </View>
            ))}
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

  // Thanh Tìm Kiếm Rộng Rãi Toàn Ngang
  topSearchWrapper: {
    position: 'absolute',
    top: 50,
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
    backgroundColor: '#FFF',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.12,
    shadowRadius: 5,
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
    backgroundColor: '#FFF',
    paddingHorizontal: 12,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.12,
    shadowRadius: 5,
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
    top: 112,
    right: 14,
    gap: 10,
    zIndex: 25,
  },
  floatingActionBtn: {
    width: 44,
    height: 44,
    borderRadius: 14,
    backgroundColor: '#FFF',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.12,
    shadowRadius: 5,
  },
  floatingActionBtnActive: {
    backgroundColor: '#FEF3C7',
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
    top: 110,
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
    backgroundColor: '#F5F5DC',
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
});
