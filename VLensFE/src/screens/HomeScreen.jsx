import React, { useState, useEffect, useMemo, useCallback, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  ScrollView,
  TouchableOpacity,
  Image,
  Dimensions,
  ActivityIndicator,
  RefreshControl,
  Modal,
  FlatList,
  TouchableWithoutFeedback,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import { THEME, useTheme } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritageList, DEFAULT_HERITAGE_IMAGE } from '../utils/heritageAdapter';
import { haversineDistanceKm } from '../utils/dijkstraRouter';
import useUserLocation from '../hooks/useUserLocation';
import useNetworkStatus from '../hooks/useNetworkStatus';
import { getOfflineHeritages } from '../services/offlineStorageService';

const { width } = Dimensions.get('window');
const CARD_WIDTH = width * 0.72;
const PAGE_SIZE = 12;

export default function HomeScreen({ user, onSelectSite, onNavigateToCamera, onNavigateToMap, onNavigateToProfile }) {
  const { t, i18n } = useTranslation();
  const { theme, isDark } = useTheme();
  const [search, setSearch] = useState('');
  const { coords: userCoords } = useUserLocation();
  const { isConnected } = useNetworkStatus();

  // Backend state
  const [allSites, setAllSites] = useState(() => getOfflineHeritages(i18n.language));
  const [nearbySites, setNearbySites] = useState([]);
  const [isLoading, setIsLoading] = useState(false);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const [failedImageIds, setFailedImageIds] = useState(new Set());
  const masterSitesRef = useRef([]);
  const userCoordsRef = useRef(userCoords);
  const lastNearbyCoordsRef = useRef(null);
  const scrollRef = useRef(null);

  // Bộ lọc Tỉnh/Thành phố & Phân trang
  const [selectedProvince, setSelectedProvince] = useState('all');
  const [isProvinceModalVisible, setIsProvinceModalVisible] = useState(false);
  const [provinceSearchQuery, setProvinceSearchQuery] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [viewMode, setViewMode] = useState('paged'); // 'paged' (theo trang) | 'continuous' (xem thêm nối tiếp)
  const [continuousCount, setContinuousCount] = useState(PAGE_SIZE);

  useEffect(() => {
    userCoordsRef.current = userCoords;
  }, [userCoords]);

  // Khởi tạo ngay lập tức dữ liệu hạt giống (0ms)
  useEffect(() => {
    getOfflineHeritages(i18n.language).then((localData) => {
      if (Array.isArray(localData) && localData.length > 0) {
        masterSitesRef.current = localData;
        setAllSites(localData);
        setNearbySites(localData.slice(0, 6));
      }
    });
  }, [i18n.language]);

  // 1. Tải danh sách di sản & di sản lân cận từ Backend (dự phòng Supabase / Offline Storage)
  const loadHeritageData = useCallback(async () => {
    try {
      setFailedImageIds(new Set());
      const coords = userCoordsRef.current;
      const lat = coords?.latitude || 16.0544;
      const lng = coords?.longitude || 108.2022;
      lastNearbyCoordsRef.current = { latitude: lat, longitude: lng };

      const [allRes, nearbyRes] = await Promise.allSettled([
        appService.getAllHeritage(),
        appService.getNearbyHeritage(lat, lng, 50.0, 10),
      ]);

      if (allRes.status === 'fulfilled' && Array.isArray(allRes.value) && allRes.value.length > 0) {
        console.log(`[HomeScreen] Tải thành công ${allRes.value.length} di sản!`);
        const adapted = adaptHeritageList(allRes.value);
        masterSitesRef.current = adapted;
        setAllSites(adapted);

        let nearby = [];
        if (nearbyRes.status === 'fulfilled' && Array.isArray(nearbyRes.value) && nearbyRes.value.length > 0) {
          nearby = adaptHeritageList(nearbyRes.value);
        }
        // Luôn đảm bảo mục nổi bật có tối thiểu 4-6 địa danh, kể cả khi GPS không nằm trong bán kính di tích
        if (nearby.length === 0 && adapted.length > 0) {
          nearby = adapted.slice(0, 6);
        }
        setNearbySites(nearby);
      } else {
        // Nếu không kết nối được backend, nạp từ offline storage
        const local = await getOfflineHeritages(i18n.language);
        masterSitesRef.current = local;
        setAllSites(local);
        setNearbySites(local.slice(0, 6));
      }
    } catch (err) {
      console.warn('[HomeScreen] Lỗi kết nối Backend:', err.message);
      const local = await getOfflineHeritages(i18n.language);
      masterSitesRef.current = local;
      setAllSites(local);
      setNearbySites(local.slice(0, 6));
    } finally {
      setIsLoading(false);
      setIsRefreshing(false);
    }
  }, [i18n?.language]);

  // Tự động kích hoạt đồng bộ khi có kết nối mạng trở lại
  useEffect(() => {
    if (isConnected) {
      loadHeritageData();
    }
  }, [isConnected, loadHeritageData]);

  // Chỉ cập nhật danh sách lân cận khi người dùng thực sự di chuyển > 0.5km (tránh tải lại toàn bộ CSDL mỗi 3s)
  useEffect(() => {
    if (!userCoords || masterSitesRef.current.length === 0) return;
    const prev = lastNearbyCoordsRef.current;
    if (
      prev &&
      haversineDistanceKm(prev.latitude, prev.longitude, userCoords.latitude, userCoords.longitude) < 0.5
    ) {
      return;
    }

    lastNearbyCoordsRef.current = {
      latitude: userCoords.latitude,
      longitude: userCoords.longitude,
    };

    let cancelled = false;
    (async () => {
      try {
        const nearbyRes = await appService.getNearbyHeritage(
          userCoords.latitude,
          userCoords.longitude,
          50.0,
          10
        );
        if (!cancelled && Array.isArray(nearbyRes) && nearbyRes.length > 0) {
          setNearbySites(adaptHeritageList(nearbyRes));
        }
      } catch {
        // Giữ nguyên danh sách nổi bật hiện tại nếu cập nhật GPS thất bại
      }
    })();

    return () => {
      cancelled = true;
    };
  }, [userCoords]);

  // Pull-to-refresh
  const onRefresh = useCallback(() => {
    setIsRefreshing(true);
    loadHeritageData();
  }, [loadHeritageData]);

  // 2. Debounce tìm kiếm với Backend API & phục hồi danh sách gốc khi xoá từ khóa
  useEffect(() => {
    if (!search.trim()) {
      setIsSearching(false);
      if (masterSitesRef.current.length > 0) {
        setAllSites(masterSitesRef.current);
      }
      return;
    }

    let isActive = true;
    setIsSearching(true);

    const timer = setTimeout(async () => {
      try {
        const searchResults = await appService.searchHeritage(search.trim());
        if (isActive && Array.isArray(searchResults)) {
          setAllSites(adaptHeritageList(searchResults));
        }
      } catch (err) {
        console.warn('[HomeScreen] Tìm kiếm backend lỗi, chuyển sang lọc client:', err.message);
      } finally {
        if (isActive) {
          setIsSearching(false);
        }
      }
    }, 400);

    return () => {
      isActive = false;
      clearTimeout(timer);
    };
  }, [search]);

  // Danh sách các Tỉnh / Thành phố được trích xuất tự động từ CSDL
  const provinceList = useMemo(() => {
    const map = new Map();
    allSites.forEach((site) => {
      const p = site.province?.trim() || site.locationName?.trim();
      if (p) {
        map.set(p, (map.get(p) || 0) + 1);
      }
    });

    const list = Array.from(map.entries())
      .map(([name, count]) => ({ name, count }))
      .sort((a, b) => b.count - a.count || a.name.localeCompare(b.name));

    return [
      { name: 'all', label: t('home.allProvinces'), count: allSites.length },
      ...list,
    ];
  }, [allSites, t]);

  // Lọc danh sách tỉnh thành trong modal tìm kiếm
  const filteredProvinceList = useMemo(() => {
    if (!provinceSearchQuery.trim()) return provinceList;
    const q = provinceSearchQuery.trim().toLowerCase();
    return provinceList.filter((item) => {
      const name = item.name === 'all' ? t('home.allProvinces').toLowerCase() : item.name.toLowerCase();
      return name.includes(q);
    });
  }, [provinceList, provinceSearchQuery, t]);

  // Lọc theo từ khóa tìm kiếm và theo Tỉnh/Thành phố
  const filteredSites = useMemo(() => {
    let result = allSites;

    // 1. Lọc theo tỉnh thành đã chọn
    if (selectedProvince && selectedProvince !== 'all') {
      result = result.filter((site) => {
        const p = site.province?.trim() || site.locationName?.trim() || '';
        return p.toLowerCase() === selectedProvince.toLowerCase();
      });
    }

    // 2. Lọc theo từ khóa tìm kiếm
    if (search.trim()) {
      const query = search.trim().toLowerCase();
      result = result.filter((site) => {
        return (
          site.name?.toLowerCase().includes(query) ||
          site.locationName?.toLowerCase().includes(query) ||
          site.province?.toLowerCase().includes(query) ||
          site.dynasty?.toLowerCase().includes(query)
        );
      });
    }

    return result;
  }, [allSites, selectedProvince, search]);

  // Reset trang và số lượng hiển thị khi đổi bộ lọc
  useEffect(() => {
    setCurrentPage(1);
    setContinuousCount(PAGE_SIZE);
  }, [selectedProvince, search]);

  // Tính toán phân trang
  const totalItems = filteredSites.length;
  const totalPages = Math.max(1, Math.ceil(totalItems / PAGE_SIZE));

  // Danh sách di tích thực tế được hiển thị trên giao diện
  const displayedSites = useMemo(() => {
    if (viewMode === 'paged') {
      const start = (currentPage - 1) * PAGE_SIZE;
      return filteredSites.slice(start, start + PAGE_SIZE);
    } else {
      return filteredSites.slice(0, continuousCount);
    }
  }, [filteredSites, viewMode, currentPage, continuousCount]);

  // Chuyển trang mượt mà
  const handleSelectPage = (pageNumber) => {
    if (pageNumber < 1 || pageNumber > totalPages || pageNumber === currentPage) return;
    setCurrentPage(pageNumber);
  };

  // Nút xem thêm trong chế độ nối tiếp
  const handleLoadMore = () => {
    setContinuousCount((prev) => Math.min(prev + PAGE_SIZE, totalItems));
  };

  const handleCollapse = () => {
    setContinuousCount(PAGE_SIZE);
  };

  // Tạo dải số trang dạng [ 1 ] [ 2 ] [ 3 ] ... [ N ]
  const paginationRange = useMemo(() => {
    if (totalPages <= 7) {
      return Array.from({ length: totalPages }, (_, i) => i + 1);
    }
    const pages = [];
    if (currentPage <= 4) {
      pages.push(1, 2, 3, 4, 5, '...', totalPages);
    } else if (currentPage >= totalPages - 3) {
      pages.push(1, '...', totalPages - 4, totalPages - 3, totalPages - 2, totalPages - 1, totalPages);
    } else {
      pages.push(1, '...', currentPage - 1, currentPage, currentPage + 1, '...', totalPages);
    }
    return pages;
  }, [totalPages, currentPage]);

  // Xử lý lỗi load ảnh: ghi nhận ID để fallback sang placeholder
  const handleImageError = (siteId) => {
    setFailedImageIds((prev) => new Set(prev).add(siteId));
  };

  const getImageUri = (site) => {
    if (failedImageIds.has(site.id)) {
      return DEFAULT_HERITAGE_IMAGE;
    }
    return site.imageUrl || site.image || DEFAULT_HERITAGE_IMAGE;
  };

  // Đảm bảo luôn có dữ liệu hiển thị cho Carousel "Di sản nổi bật quanh bạn"
  const displayNearbySites = useMemo(() => {
    if (nearbySites && nearbySites.length > 0) return nearbySites;
    if (allSites && allSites.length > 0) return allSites.slice(0, 6);
    return [];
  }, [nearbySites, allSites]);

  return (
    <ScrollView
      ref={scrollRef}
      style={[styles.container, { backgroundColor: theme.colors.bg }]}
      showsVerticalScrollIndicator={false}
      refreshControl={
        <RefreshControl
          refreshing={isRefreshing}
          onRefresh={onRefresh}
          colors={[theme.colors.red]}
          tintColor={theme.colors.red}
        />
      }
    >
      {/* Header Chào mừng Người dùng */}
      <View style={styles.header}>
        <View style={styles.headerLeft}>
          <Text style={[styles.greetingSub, { color: theme.colors.inkMuted }]}>{t('home.greetingMorning')}</Text>
          <Text style={[styles.greetingName, { color: theme.colors.ink }]}>
            {user?.fullName || user?.name || t('home.greetingDefault')} 👋
          </Text>
        </View>
        <TouchableOpacity
          style={styles.avatarBtn}
          onPress={onNavigateToProfile}
          activeOpacity={0.7}
        >
          <MaterialCommunityIcons name="account-circle" size={40} color={theme.colors.amber} />
        </TouchableOpacity>
      </View>

      {/* Thanh Thông Báo Trạng Thái Ngoại Tuyến (Offline Pill Banner) */}
      {!isConnected && (
        <View style={[styles.offlineBanner, { backgroundColor: isDark ? '#3E2723' : '#FEF3C7', borderColor: theme.colors.amber }]}>
          <Ionicons name="cloud-offline" size={15} color={theme.colors.amber} />
          <Text style={[styles.offlineBannerText, { color: theme.colors.ink }]}>
            {t('home.offlineNotice')}
          </Text>
        </View>
      )}

      {/* Thanh Tìm Kiếm */}
      <View style={[styles.searchContainer, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
        {isSearching ? (
          <ActivityIndicator size="small" color={theme.colors.red} style={styles.searchIcon} />
        ) : (
          <Ionicons name="search-outline" size={20} color={theme.colors.inkMuted} style={styles.searchIcon} />
        )}
        <TextInput
          style={[styles.searchInput, { color: theme.colors.ink }]}
          placeholder={t('home.searchPlaceholder')}
          placeholderTextColor={theme.colors.inkLight}
          value={search}
          onChangeText={setSearch}
        />
        {search.length > 0 && (
          <TouchableOpacity onPress={() => setSearch('')} style={{ padding: 4 }}>
            <Ionicons name="close-circle" size={18} color={theme.colors.inkMuted} />
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={onNavigateToCamera}
          style={[styles.searchCameraBtn, { borderLeftColor: theme.colors.border }]}
          activeOpacity={0.7}
        >
          <Ionicons name="camera-outline" size={20} color={theme.colors.red} />
        </TouchableOpacity>
      </View>

      {/* GPS Featured Carousel: Di sản nổi bật quanh bạn */}
      <View style={styles.sectionRow}>
        <View style={styles.sectionHeader}>
          <Ionicons name="navigate-circle" size={20} color={theme.colors.red} />
          <Text style={[styles.sectionTitle, { color: theme.colors.ink }]}>{t('home.nearbySectionTitle')}</Text>
        </View>
        <TouchableOpacity onPress={onNavigateToMap}>
          <Text style={[styles.seeAllText, { color: theme.colors.red }]}>{t('home.openMap')}</Text>
        </TouchableOpacity>
      </View>

      {isLoading ? (
        <View style={styles.loadingCarousel}>
          <ActivityIndicator size="small" color={theme.colors.red} />
          <Text style={[styles.loadingText, { color: theme.colors.inkMuted }]}>{t('home.loadingData')}</Text>
        </View>
      ) : (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.carouselContainer}
          snapToInterval={CARD_WIDTH + 14}
          decelerationRate="fast"
        >
          {displayNearbySites.map((site) => (
            <TouchableOpacity
              key={`nearby-${site.id}`}
              style={[styles.carouselCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}
              activeOpacity={0.9}
              onPress={() => onSelectSite(site)}
            >
              <View style={styles.carouselImgWrapper}>
                <Image
                  source={{ uri: getImageUri(site) }}
                  style={[styles.carouselImage, { backgroundColor: isDark ? '#26231F' : '#EAE5D9' }]}
                  resizeMode="cover"
                  onError={() => handleImageError(site.id)}
                />
                <View style={styles.carouselBadge}>
                  <Text style={styles.carouselBadgeText} numberOfLines={1}>
                    {site.dynasty || site.category}
                  </Text>
                </View>
                {site.distance != null && (
                  <View style={styles.carouselDistanceBadge}>
                    <Ionicons name="navigate" size={10} color="#FFF" />
                    <Text style={styles.carouselDistanceText}>~{site.distance} km</Text>
                  </View>
                )}
              </View>
              <View style={styles.carouselContent}>
                <Text style={[styles.carouselTitle, { color: theme.colors.ink }]} numberOfLines={1}>
                  {site.name}
                </Text>
                <View style={styles.locationRow}>
                  <Ionicons name="location-sharp" size={13} color={theme.colors.amber} />
                  <Text style={[styles.locationText, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                    {site.locationName || site.province || site.address}
                  </Text>
                </View>
              </View>
            </TouchableOpacity>
          ))}
        </ScrollView>
      )}

      {/* Quick Action: Quét AI Banner */}
      <TouchableOpacity
        style={styles.cameraBanner}
        activeOpacity={0.88}
        onPress={onNavigateToCamera}
      >
        <View style={styles.cameraBannerText}>
          <Text style={styles.bannerTag}>{t('home.cameraBannerTag')}</Text>
          <Text style={styles.bannerHeading}>{t('home.cameraBannerHeading')}</Text>
          <Text style={styles.bannerSub}>{t('home.cameraBannerSub')}</Text>
        </View>
        <View style={styles.bannerIconCircle}>
          <Ionicons name="sparkles" size={26} color="#FFF" />
        </View>
      </TouchableOpacity>

      {/* Tiêu đề danh sách Di sản & Bộ lọc Tỉnh/Thành phố */}
      <View style={styles.sectionRow}>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
          <Text style={[styles.sectionTitle, { color: theme.colors.ink }]}>
            {t('home.exploreSectionTitle')}
          </Text>
          <View style={[styles.countPill, { backgroundColor: isDark ? '#2D2820' : theme.colors.parchment }]}>
            <Text style={[styles.countPillText, { color: theme.colors.amber }]}>
              {filteredSites.length} {t('home.relicCountUnit')}
            </Text>
          </View>
        </View>

        {/* Nút chuyển chế độ: Phân trang (Tab 1 2 3) / Cuộn nối tiếp */}
        <View style={[styles.modeSwitchWrap, { backgroundColor: isDark ? '#26231F' : '#EFEAE1' }]}>
          <TouchableOpacity
            style={[styles.modeSwitchBtn, viewMode === 'paged' && [styles.modeSwitchBtnActive, { backgroundColor: theme.colors.card }]]}
            onPress={() => setViewMode('paged')}
            activeOpacity={0.8}
          >
            <Ionicons name="documents-outline" size={13} color={viewMode === 'paged' ? theme.colors.red : theme.colors.inkMuted} />
            <Text style={[styles.modeSwitchText, { color: viewMode === 'paged' ? theme.colors.red : theme.colors.inkMuted }]}>
              {t('home.modePaged')}
            </Text>
          </TouchableOpacity>
          <TouchableOpacity
            style={[styles.modeSwitchBtn, viewMode === 'continuous' && [styles.modeSwitchBtnActive, { backgroundColor: theme.colors.card }]]}
            onPress={() => setViewMode('continuous')}
            activeOpacity={0.8}
          >
            <Ionicons name="infinite-outline" size={14} color={viewMode === 'continuous' ? theme.colors.red : theme.colors.inkMuted} />
            <Text style={[styles.modeSwitchText, { color: viewMode === 'continuous' ? theme.colors.red : theme.colors.inkMuted }]}>
              {t('home.modeContinuous')}
            </Text>
          </TouchableOpacity>
        </View>
      </View>

      {/* Thanh Dropdown Chọn Tỉnh/Thành phố Hiện Đại */}
      <View style={styles.filterBarContainer}>
        <TouchableOpacity
          style={[styles.dropdownBar, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}
          onPress={() => {
            setProvinceSearchQuery('');
            setIsProvinceModalVisible(true);
          }}
          activeOpacity={0.8}
        >
          <View style={styles.dropdownLeft}>
            <View style={[styles.dropdownIconCircle, { backgroundColor: isDark ? '#3E2723' : '#FFEBEE' }]}>
              <Ionicons name="location" size={16} color={theme.colors.red} />
            </View>
            <View style={{ flex: 1, paddingRight: 6 }}>
              <Text style={[styles.dropdownSubLabel, { color: theme.colors.inkMuted }]}>
                {t('home.filterByProvince')}
              </Text>
              <Text style={[styles.dropdownMainValue, { color: theme.colors.ink }]} numberOfLines={1}>
                {selectedProvince === 'all'
                  ? t('home.allProvincesCount', { count: allSites.length })
                  : `${selectedProvince} (${filteredSites.length} ${t('home.relicCountUnit')})`}
              </Text>
            </View>
          </View>

          <View style={styles.dropdownRightAction}>
            {selectedProvince !== 'all' ? (
              <TouchableOpacity
                style={styles.clearFilterBadge}
                onPress={(e) => {
                  e.stopPropagation();
                  setSelectedProvince('all');
                }}
              >
                <Ionicons name="close-circle" size={18} color={theme.colors.red} />
                <Text style={[styles.clearFilterText, { color: theme.colors.red }]}>
                  {t('home.clearFilter')}
                </Text>
              </TouchableOpacity>
            ) : (
              <Ionicons name="chevron-down" size={18} color={theme.colors.inkMuted} />
            )}
          </View>
        </TouchableOpacity>
      </View>

      {/* Lưới Danh sách Di sản Văn Hóa (Được phân trang/giới hạn) */}
      <View style={styles.listContainer}>
        {isLoading ? (
          <View style={styles.loadingBox}>
            <ActivityIndicator size="large" color={theme.colors.red} />
            <Text style={[styles.loadingBoxText, { color: theme.colors.inkMuted }]}>
              {t('home.loadingData')}
            </Text>
          </View>
        ) : filteredSites.length === 0 ? (
          <View style={styles.emptyContainer}>
            <Ionicons name="search" size={44} color={theme.colors.inkMuted} />
            <Text style={[styles.emptyTitle, { color: theme.colors.ink }]}>
              {t('home.emptySearchTitle')}
            </Text>
            <Text style={[styles.emptySub, { color: theme.colors.inkMuted }]}>
              {t('home.emptySearchSub')}
            </Text>
            {selectedProvince !== 'all' && (
              <TouchableOpacity
                style={[styles.resetFilterBtn, { borderColor: theme.colors.red }]}
                onPress={() => setSelectedProvince('all')}
              >
                <Text style={{ color: theme.colors.red, fontWeight: '700', fontSize: 13 }}>
                  {t('home.allProvinces')}
                </Text>
              </TouchableOpacity>
            )}
          </View>
        ) : (
          displayedSites.map((site) => (
            <TouchableOpacity
              key={`site-${site.id}`}
              style={[styles.siteCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}
              activeOpacity={0.88}
              onPress={() => onSelectSite(site)}
            >
              {/* Cột trái: Khung ảnh khớp khít 100% chiều cao của thẻ */}
              <View style={styles.siteCardImgContainer}>
                <Image
                  source={{ uri: getImageUri(site) }}
                  style={[styles.siteCardImg, { backgroundColor: isDark ? '#26231F' : '#EAE5D9' }]}
                  resizeMode="cover"
                  onError={() => handleImageError(site.id)}
                />
                {site.distance != null && (
                  <View style={styles.siteDistanceBadge}>
                    <Ionicons name="navigate" size={9} color="#FFF" />
                    <Text style={styles.siteDistanceText}>~{site.distance} km</Text>
                  </View>
                )}
              </View>

              {/* Cột giữa: Thông tin thẻ bố trí thoáng đãng */}
              <View style={styles.siteCardInfo}>
                <View style={styles.siteTopRow}>
                  <View style={[styles.dynastyPillTag, { backgroundColor: isDark ? '#2D2820' : theme.colors.parchment }]}>
                    <Text style={[styles.siteDynasty, { color: theme.colors.amber }]} numberOfLines={1}>
                      {site.dynasty || site.category}
                    </Text>
                  </View>
                  {site.province ? (
                    <Text style={[styles.siteProvinceBadge, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                      {site.province}
                    </Text>
                  ) : null}
                </View>

                <Text style={[styles.siteName, { color: theme.colors.ink }]} numberOfLines={1}>
                  {site.name}
                </Text>

                <View style={styles.siteLocationRow}>
                  <Ionicons name="location-sharp" size={12} color={theme.colors.red} />
                  <Text style={[styles.siteLocation, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                    {site.locationName || site.address}
                  </Text>
                </View>

                <Text style={[styles.siteBrief, { color: theme.colors.inkLight }]} numberOfLines={2}>
                  {site.shortDescription || site.description}
                </Text>
              </View>

              {/* Cột phải: Mũi tên khám phá nhẹ nhàng */}
              <View style={styles.cardArrowCol}>
                <Ionicons name="chevron-forward" size={16} color={theme.colors.border} />
              </View>
            </TouchableOpacity>
          ))
        )}

        {/* Thanh Điều Hướng Phân Trang Hoặc Nút Xem Thêm */}
        {!isLoading && filteredSites.length > 0 && (
          <View style={styles.paginationSection}>
            {/* Chế độ 1: Phân trang dạng Tab 1 2 3 ... N */}
            {viewMode === 'paged' && totalPages > 1 && (
              <View style={styles.pagedControlsWrapper}>
                <Text style={[styles.pageStatusText, { color: theme.colors.inkMuted }]}>
                  {t('home.page')} {currentPage} / {totalPages} ({t('home.showingCount', { shown: displayedSites.length, total: totalItems })})
                </Text>

                <View style={styles.paginationRow}>
                  {/* Nút Trước */}
                  <TouchableOpacity
                    style={[
                      styles.pageNavBtn,
                      { backgroundColor: theme.colors.card, borderColor: theme.colors.border },
                      currentPage === 1 && styles.pageNavBtnDisabled,
                    ]}
                    disabled={currentPage === 1}
                    onPress={() => handleSelectPage(currentPage - 1)}
                    activeOpacity={0.7}
                  >
                    <Ionicons name="chevron-back" size={18} color={currentPage === 1 ? theme.colors.inkLight : theme.colors.ink} />
                  </TouchableOpacity>

                  {/* Dải số trang */}
                  <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.pageNumberScroll}>
                    {paginationRange.map((p, idx) => {
                      if (p === '...') {
                        return (
                          <View key={`dots-${idx}`} style={styles.pageEllipsis}>
                            <Text style={[styles.pageEllipsisText, { color: theme.colors.inkMuted }]}>...</Text>
                          </View>
                        );
                      }
                      const isActive = p === currentPage;
                      return (
                        <TouchableOpacity
                          key={`page-${p}`}
                          style={[
                            styles.pageNumberBtn,
                            { backgroundColor: theme.colors.card, borderColor: theme.colors.border },
                            isActive && [styles.pageNumberBtnActive, { backgroundColor: theme.colors.red, borderColor: theme.colors.red }],
                          ]}
                          onPress={() => handleSelectPage(p)}
                          activeOpacity={0.8}
                        >
                          <Text style={[styles.pageNumberText, { color: theme.colors.ink }, isActive && styles.pageNumberTextActive]}>
                            {p}
                          </Text>
                        </TouchableOpacity>
                      );
                    })}
                  </ScrollView>

                  {/* Nút Sau */}
                  <TouchableOpacity
                    style={[
                      styles.pageNavBtn,
                      { backgroundColor: theme.colors.card, borderColor: theme.colors.border },
                      currentPage === totalPages && styles.pageNavBtnDisabled,
                    ]}
                    disabled={currentPage === totalPages}
                    onPress={() => handleSelectPage(currentPage + 1)}
                    activeOpacity={0.7}
                  >
                    <Ionicons name="chevron-forward" size={18} color={currentPage === totalPages ? theme.colors.inkLight : theme.colors.ink} />
                  </TouchableOpacity>
                </View>
              </View>
            )}

            {/* Chế độ 2: Nút Xem Thêm Nối Tiếp */}
            {viewMode === 'continuous' && (
              <View style={styles.continuousControlsWrapper}>
                <Text style={[styles.pageStatusText, { color: theme.colors.inkMuted }]}>
                  {t('home.showingCount', { shown: displayedSites.length, total: totalItems })}
                </Text>

                {displayedSites.length < totalItems ? (
                  <TouchableOpacity
                    style={[styles.loadMoreBtn, { backgroundColor: theme.colors.card, borderColor: theme.colors.red }]}
                    onPress={handleLoadMore}
                    activeOpacity={0.8}
                  >
                    <Ionicons name="add-circle-outline" size={18} color={theme.colors.red} />
                    <Text style={[styles.loadMoreText, { color: theme.colors.red }]}>
                      {t('home.loadMore', { count: Math.min(PAGE_SIZE, totalItems - displayedSites.length) })}
                    </Text>
                  </TouchableOpacity>
                ) : totalItems > PAGE_SIZE ? (
                  <TouchableOpacity
                    style={[styles.loadMoreBtn, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}
                    onPress={handleCollapse}
                    activeOpacity={0.8}
                  >
                    <Ionicons name="chevron-up" size={18} color={theme.colors.inkMuted} />
                    <Text style={[styles.loadMoreText, { color: theme.colors.inkMuted }]}>
                      {t('home.collapse')}
                    </Text>
                  </TouchableOpacity>
                ) : null}
              </View>
            )}
          </View>
        )}
      </View>

      <View style={{ height: 100 }} />

      {/* Modal / Bottom Sheet Chọn Tỉnh / Thành Phố */}
      <Modal
        visible={isProvinceModalVisible}
        transparent={true}
        animationType="slide"
        onRequestClose={() => setIsProvinceModalVisible(false)}
      >
        <TouchableWithoutFeedback onPress={() => setIsProvinceModalVisible(false)}>
          <View style={styles.modalOverlay}>
            <TouchableWithoutFeedback onPress={() => {}}>
              <View style={[styles.provinceModalSheet, { backgroundColor: theme.colors.card }]}>
                {/* Thanh Kéo Sheet */}
                <View style={styles.sheetHandleWrap}>
                  <View style={[styles.sheetHandle, { backgroundColor: theme.colors.border }]} />
                </View>

                {/* Tiêu đề Modal */}
                <View style={styles.modalHeaderRow}>
                  <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
                    <Ionicons name="location" size={20} color={theme.colors.red} />
                    <Text style={[styles.modalTitle, { color: theme.colors.ink }]}>
                      {t('home.selectProvinceModalTitle')}
                    </Text>
                  </View>
                  <TouchableOpacity
                    onPress={() => setIsProvinceModalVisible(false)}
                    style={styles.modalCloseBtn}
                  >
                    <Ionicons name="close" size={22} color={theme.colors.inkMuted} />
                  </TouchableOpacity>
                </View>

                {/* Ô Tìm Tỉnh Nhanh */}
                <View style={[styles.modalSearchBox, { backgroundColor: isDark ? '#2D2820' : '#F5F2EB', borderColor: theme.colors.border }]}>
                  <Ionicons name="search" size={18} color={theme.colors.inkMuted} />
                  <TextInput
                    style={[styles.modalSearchInput, { color: theme.colors.ink }]}
                    placeholder={t('home.searchProvincePlaceholder')}
                    placeholderTextColor={theme.colors.inkLight}
                    value={provinceSearchQuery}
                    onChangeText={setProvinceSearchQuery}
                    autoCapitalize="none"
                  />
                  {provinceSearchQuery.length > 0 && (
                    <TouchableOpacity onPress={() => setProvinceSearchQuery('')}>
                      <Ionicons name="close-circle" size={16} color={theme.colors.inkMuted} />
                    </TouchableOpacity>
                  )}
                </View>

                {/* Danh Sách Tỉnh Thành */}
                <FlatList
                  data={filteredProvinceList}
                  keyExtractor={(item) => `prov-${item.name}`}
                  keyboardShouldPersistTaps="handled"
                  contentContainerStyle={{ paddingBottom: 24 }}
                  renderItem={({ item }) => {
                    const isSelected = selectedProvince === item.name;
                    return (
                      <TouchableOpacity
                        style={[
                          styles.provinceItemRow,
                          { borderBottomColor: theme.colors.border },
                          isSelected && [styles.provinceItemRowSelected, { backgroundColor: isDark ? '#3E2723' : '#FFEBEE' }],
                        ]}
                        onPress={() => {
                          setSelectedProvince(item.name);
                          setIsProvinceModalVisible(false);
                        }}
                        activeOpacity={0.7}
                      >
                        <View style={styles.provinceItemLeft}>
                          <Ionicons
                            name={item.name === 'all' ? 'globe-outline' : 'business-outline'}
                            size={18}
                            color={isSelected ? theme.colors.red : theme.colors.amber}
                          />
                          <Text
                            style={[
                              styles.provinceItemName,
                              { color: theme.colors.ink },
                              isSelected && { color: theme.colors.red, fontWeight: '700' },
                            ]}
                          >
                            {item.label || item.name}
                          </Text>
                        </View>

                        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 6 }}>
                          <View style={[styles.provinceCountBadge, { backgroundColor: isDark ? '#2D2820' : theme.colors.parchment }]}>
                            <Text style={[styles.provinceCountText, { color: theme.colors.inkMuted }]}>
                              {item.count} {t('home.relicCountUnit')}
                            </Text>
                          </View>
                          {isSelected && (
                            <Ionicons name="checkmark-circle" size={18} color={theme.colors.red} />
                          )}
                        </View>
                      </TouchableOpacity>
                    );
                  }}
                />
              </View>
            </TouchableWithoutFeedback>
          </View>
        </TouchableWithoutFeedback>
      </Modal>
    </ScrollView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    paddingTop: 16,
    paddingBottom: 10,
  },
  headerLeft: {},
  greetingSub: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    fontWeight: '500',
  },
  greetingName: {
    fontSize: 22,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  avatarBtn: {},
  offlineBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginHorizontal: 20,
    marginTop: 2,
    marginBottom: 8,
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: 10,
    borderWidth: 1,
  },
  offlineBannerText: {
    fontSize: 12,
    fontWeight: '600',
    flex: 1,
  },
  searchContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFF',
    marginHorizontal: 20,
    marginTop: 10,
    marginBottom: 16,
    paddingHorizontal: 14,
    paddingVertical: 11,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  searchIcon: {
    marginRight: 8,
  },
  searchInput: {
    flex: 1,
    fontSize: 14,
    color: THEME.colors.ink,
  },
  searchCameraBtn: {
    paddingLeft: 8,
    borderLeftWidth: 1,
    borderLeftColor: THEME.colors.border,
    marginLeft: 6,
  },
  sectionRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 20,
    marginTop: 12,
    marginBottom: 10,
  },
  sectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  sectionTitle: {
    fontSize: 17,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  seeAllText: {
    fontSize: 13,
    color: THEME.colors.red,
    fontWeight: '600',
  },
  loadingCarousel: {
    height: 180,
    justifyContent: 'center',
    alignItems: 'center',
    marginHorizontal: 20,
    gap: 8,
  },
  loadingText: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
  },
  carouselContainer: {
    paddingLeft: 20,
    paddingRight: 6,
    paddingBottom: 8,
  },
  carouselCard: {
    width: CARD_WIDTH,
    height: 195,
    borderRadius: 18,
    backgroundColor: '#FFF',
    marginRight: 14,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 4,
  },
  carouselImgWrapper: {
    width: '100%',
    height: 125,
    position: 'relative',
    overflow: 'hidden',
    backgroundColor: '#EAE5D9',
  },
  carouselImage: {
    width: '100%',
    height: 125,
    backgroundColor: '#EAE5D9',
  },
  carouselBadge: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: 'rgba(28, 25, 23, 0.78)',
    paddingHorizontal: 8,
    paddingVertical: 3.5,
    borderRadius: 7,
    maxWidth: '65%',
  },
  carouselBadgeText: {
    color: '#FFF',
    fontSize: 10.5,
    fontWeight: '600',
  },
  carouselDistanceBadge: {
    position: 'absolute',
    top: 8,
    right: 8,
    backgroundColor: 'rgba(198, 40, 40, 0.9)',
    paddingHorizontal: 6,
    paddingVertical: 3,
    borderRadius: 7,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  carouselDistanceText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
  },
  carouselContent: {
    height: 68,
    paddingHorizontal: 12,
    justifyContent: 'center',
  },
  carouselTitle: {
    fontSize: 14.5,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  locationRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 3,
  },
  locationText: {
    fontSize: 11.5,
    color: THEME.colors.inkMuted,
  },
  cameraBanner: {
    backgroundColor: THEME.colors.red,
    marginHorizontal: 20,
    marginVertical: 14,
    padding: 16,
    borderRadius: 18,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    elevation: 4,
    shadowColor: THEME.colors.red,
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.3,
    shadowRadius: 6,
  },
  cameraBannerText: {
    flex: 1,
    paddingRight: 12,
  },
  bannerTag: {
    fontSize: 10,
    fontWeight: '800',
    color: THEME.colors.yellow,
    letterSpacing: 0.8,
    marginBottom: 2,
  },
  bannerHeading: {
    fontSize: 16,
    fontWeight: '700',
    color: '#FFF',
  },
  bannerSub: {
    fontSize: 12,
    color: '#FEE2E2',
    marginTop: 2,
  },
  bannerIconCircle: {
    width: 48,
    height: 48,
    borderRadius: 24,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  listContainer: {
    paddingHorizontal: 20,
    marginTop: 14,
  },
  loadingBox: {
    paddingVertical: 40,
    alignItems: 'center',
    gap: 12,
  },
  loadingBoxText: {
    fontSize: 14,
    color: THEME.colors.inkMuted,
  },
  emptyContainer: {
    paddingVertical: 48,
    alignItems: 'center',
    gap: 8,
  },
  emptyTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  emptySub: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
  },
  siteCard: {
    flexDirection: 'row',
    height: 116,
    backgroundColor: '#FFF',
    borderRadius: 16,
    marginBottom: 12,
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  siteCardImgContainer: {
    width: 110,
    height: 116,
    position: 'relative',
    backgroundColor: '#EAE5D9',
    overflow: 'hidden',
  },
  siteCardImg: {
    width: 110,
    height: 116,
    backgroundColor: '#EAE5D9',
  },
  siteDistanceBadge: {
    position: 'absolute',
    bottom: 6,
    left: 6,
    backgroundColor: 'rgba(28, 25, 23, 0.78)',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 6,
  },
  siteDistanceText: {
    color: '#FFF',
    fontSize: 9.5,
    fontWeight: '700',
  },
  siteCardInfo: {
    flex: 1,
    height: 116,
    paddingVertical: 8,
    paddingHorizontal: 10,
    justifyContent: 'space-between',
  },
  siteTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  dynastyPillTag: {
    paddingHorizontal: 6,
    paddingVertical: 1.5,
    borderRadius: 4,
    maxWidth: '65%',
  },
  siteDynasty: {
    fontSize: 10,
    fontWeight: '700',
  },
  siteProvinceBadge: {
    fontSize: 11,
    fontWeight: '500',
  },
  siteName: {
    fontSize: 14.5,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  siteLocationRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  siteLocation: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
    flex: 1,
  },
  siteBrief: {
    fontSize: 11,
    color: THEME.colors.inkLight,
    lineHeight: 15,
  },
  cardArrowCol: {
    justifyContent: 'center',
    alignItems: 'center',
    paddingRight: 8,
  },
  // Bổ sung Styles cho Bộ Lọc Tỉnh & Phân Trang
  countPill: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 8,
  },
  countPillText: {
    fontSize: 11,
    fontWeight: '700',
  },
  modeSwitchWrap: {
    flexDirection: 'row',
    borderRadius: 10,
    padding: 3,
    gap: 2,
  },
  modeSwitchBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  modeSwitchBtnActive: {
    elevation: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.08,
    shadowRadius: 2,
  },
  modeSwitchText: {
    fontSize: 11,
    fontWeight: '600',
  },
  filterBarContainer: {
    paddingHorizontal: 20,
    marginBottom: 8,
  },
  dropdownBar: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 12,
    paddingVertical: 10,
    borderRadius: 14,
    borderWidth: 1,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  dropdownLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    flex: 1,
  },
  dropdownIconCircle: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  dropdownSubLabel: {
    fontSize: 10.5,
    fontWeight: '500',
    marginBottom: 1,
  },
  dropdownMainValue: {
    fontSize: 13.5,
    fontWeight: '700',
  },
  dropdownRightAction: {
    paddingLeft: 6,
  },
  clearFilterBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: '#FFEBEE',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  clearFilterText: {
    fontSize: 11,
    fontWeight: '700',
  },
  resetFilterBtn: {
    marginTop: 10,
    paddingHorizontal: 14,
    paddingVertical: 6,
    borderRadius: 8,
    borderWidth: 1,
  },
  paginationSection: {
    marginTop: 16,
    paddingBottom: 8,
  },
  pagedControlsWrapper: {
    alignItems: 'center',
    gap: 12,
  },
  pageStatusText: {
    fontSize: 12,
    fontWeight: '500',
    textAlign: 'center',
  },
  paginationRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
    width: '100%',
  },
  pageNavBtn: {
    width: 36,
    height: 36,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pageNavBtnDisabled: {
    opacity: 0.35,
  },
  pageNumberScroll: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 4,
  },
  pageNumberBtn: {
    minWidth: 36,
    height: 36,
    paddingHorizontal: 8,
    borderRadius: 10,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pageNumberBtnActive: {
    elevation: 2,
    shadowColor: '#C62828',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.3,
    shadowRadius: 2,
  },
  pageNumberText: {
    fontSize: 13,
    fontWeight: '700',
  },
  pageNumberTextActive: {
    color: '#FFF',
  },
  pageEllipsis: {
    width: 24,
    height: 36,
    alignItems: 'center',
    justifyContent: 'center',
  },
  pageEllipsisText: {
    fontSize: 14,
    fontWeight: '700',
  },
  continuousControlsWrapper: {
    alignItems: 'center',
    gap: 10,
  },
  loadMoreBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    width: '100%',
    paddingVertical: 12,
    borderRadius: 14,
    borderWidth: 1.5,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  loadMoreText: {
    fontSize: 13.5,
    fontWeight: '700',
  },
  // Styles Modal Sheet Chọn Tỉnh Thành
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.45)',
    justifyContent: 'flex-end',
  },
  provinceModalSheet: {
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    paddingTop: 10,
    paddingHorizontal: 20,
    maxHeight: '80%',
    elevation: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -4 },
    shadowOpacity: 0.2,
    shadowRadius: 8,
  },
  sheetHandleWrap: {
    alignItems: 'center',
    paddingVertical: 6,
  },
  sheetHandle: {
    width: 40,
    height: 4.5,
    borderRadius: 3,
  },
  modalHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 10,
  },
  modalTitle: {
    fontSize: 17,
    fontWeight: '700',
  },
  modalCloseBtn: {
    padding: 4,
  },
  modalSearchBox: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 9,
    borderRadius: 12,
    borderWidth: 1,
    marginVertical: 10,
    gap: 8,
  },
  modalSearchInput: {
    flex: 1,
    fontSize: 13.5,
  },
  provinceItemRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingVertical: 12,
    paddingHorizontal: 6,
    borderBottomWidth: 0.5,
    borderRadius: 10,
  },
  provinceItemRowSelected: {
    paddingHorizontal: 10,
  },
  provinceItemLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    flex: 1,
  },
  provinceItemName: {
    fontSize: 14,
    fontWeight: '600',
  },
  provinceCountBadge: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 8,
  },
  provinceCountText: {
    fontSize: 11,
    fontWeight: '600',
  },
});
