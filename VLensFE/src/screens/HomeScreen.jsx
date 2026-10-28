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
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import { THEME } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritageList, DEFAULT_HERITAGE_IMAGE } from '../utils/heritageAdapter';
import LanguageSwitcher from '../components/LanguageSwitcher';
import useUserLocation from '../hooks/useUserLocation';

const { width } = Dimensions.get('window');
const CARD_WIDTH = width * 0.72;

export default function HomeScreen({ user, onSelectSite, onNavigateToCamera, onNavigateToMap }) {
  const { t } = useTranslation();
  const [search, setSearch] = useState('');
  const { coords: userCoords } = useUserLocation();

  // Backend state
  const [allSites, setAllSites] = useState([]);
  const [nearbySites, setNearbySites] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isRefreshing, setIsRefreshing] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const [failedImageIds, setFailedImageIds] = useState(new Set());
  const masterSitesRef = useRef([]);

  // 1. Tải danh sách di sản & di sản lân cận từ Backend
  const loadHeritageData = useCallback(async () => {
    try {
      setFailedImageIds(new Set());
      const lat = userCoords?.latitude || 16.0544;
      const lng = userCoords?.longitude || 108.2022;

      const [allRes, nearbyRes] = await Promise.allSettled([
        appService.getAllHeritage(),
        appService.getNearbyHeritage(lat, lng, 50.0, 10),
      ]);

      if (allRes.status === 'fulfilled' && Array.isArray(allRes.value) && allRes.value.length > 0) {
        console.log(`[HomeScreen] Tải thành công ${allRes.value.length} di sản từ Spring Boot Backend!`);
        const adapted = adaptHeritageList(allRes.value);
        masterSitesRef.current = adapted;
        setAllSites(adapted);

        if (nearbyRes.status === 'fulfilled' && Array.isArray(nearbyRes.value) && nearbyRes.value.length > 0) {
          setNearbySites(adaptHeritageList(nearbyRes.value));
        } else {
          // Lấy 4 địa danh đầu tiên từ dữ liệu thật
          setNearbySites(adapted.slice(0, 4));
        }
      } else {
        masterSitesRef.current = [];
        setAllSites([]);
        setNearbySites([]);
      }
    } catch (err) {
      console.warn('[HomeScreen] Lỗi kết nối Backend:', err.message);
      masterSitesRef.current = [];
      setAllSites([]);
      setNearbySites([]);
    } finally {
      setIsLoading(false);
      setIsRefreshing(false);
    }
  }, [userCoords]);

  useEffect(() => {
    loadHeritageData();
  }, [loadHeritageData]);

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

  // Lọc theo từ khóa tìm kiếm trên client
  const filteredSites = useMemo(() => {
    if (!search.trim()) return allSites;
    const query = search.trim().toLowerCase();
    return allSites.filter((site) => {
      return (
        site.name?.toLowerCase().includes(query) ||
        site.locationName?.toLowerCase().includes(query) ||
        site.province?.toLowerCase().includes(query) ||
        site.dynasty?.toLowerCase().includes(query)
      );
    });
  }, [allSites, search]);

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

  return (
    <ScrollView
      style={styles.container}
      showsVerticalScrollIndicator={false}
      refreshControl={
        <RefreshControl
          refreshing={isRefreshing}
          onRefresh={onRefresh}
          colors={[THEME.colors.red]}
          tintColor={THEME.colors.red}
        />
      }
    >
      {/* Header Chào mừng Người dùng */}
      <View style={styles.header}>
        <View style={styles.headerLeft}>
          <Text style={styles.greetingSub}>{t('home.greetingMorning')}</Text>
          <Text style={styles.greetingName}>
            {user?.fullName || user?.name || t('home.greetingDefault')} 👋
          </Text>
        </View>
        <View style={{ flexDirection: 'row', alignItems: 'center', gap: 10 }}>
          <LanguageSwitcher onLanguageChanged={() => loadHeritageData()} />
          <TouchableOpacity style={styles.avatarBtn} onPress={() => {}}>
            <MaterialCommunityIcons name="account-circle" size={40} color={THEME.colors.amber} />
          </TouchableOpacity>
        </View>
      </View>

      {/* Thanh Tìm Kiếm */}
      <View style={styles.searchContainer}>
        {isSearching ? (
          <ActivityIndicator size="small" color={THEME.colors.red} style={styles.searchIcon} />
        ) : (
          <Ionicons name="search-outline" size={20} color={THEME.colors.inkMuted} style={styles.searchIcon} />
        )}
        <TextInput
          style={styles.searchInput}
          placeholder={t('home.searchPlaceholder')}
          placeholderTextColor={THEME.colors.inkLight}
          value={search}
          onChangeText={setSearch}
        />
        {search.length > 0 && (
          <TouchableOpacity onPress={() => setSearch('')} style={{ padding: 4 }}>
            <Ionicons name="close-circle" size={18} color={THEME.colors.inkMuted} />
          </TouchableOpacity>
        )}
        <TouchableOpacity
          onPress={onNavigateToCamera}
          style={styles.searchCameraBtn}
          activeOpacity={0.7}
        >
          <Ionicons name="camera-outline" size={20} color={THEME.colors.red} />
        </TouchableOpacity>
      </View>

      {/* GPS Featured Carousel: Di sản nổi bật quanh bạn */}
      <View style={styles.sectionRow}>
        <View style={styles.sectionHeader}>
          <Ionicons name="navigate-circle" size={20} color={THEME.colors.red} />
          <Text style={styles.sectionTitle}>{t('home.nearbySectionTitle')}</Text>
        </View>
        <TouchableOpacity onPress={onNavigateToMap}>
          <Text style={styles.seeAllText}>{t('home.openMap')}</Text>
        </TouchableOpacity>
      </View>

      {isLoading ? (
        <View style={styles.loadingCarousel}>
          <ActivityIndicator size="small" color={THEME.colors.red} />
          <Text style={styles.loadingText}>{t('home.loadingData')}</Text>
        </View>
      ) : (
        <ScrollView
          horizontal
          showsHorizontalScrollIndicator={false}
          contentContainerStyle={styles.carouselContainer}
          snapToInterval={CARD_WIDTH + 14}
          decelerationRate="fast"
        >
          {nearbySites.map((site) => (
            <TouchableOpacity
              key={`nearby-${site.id}`}
              style={styles.carouselCard}
              activeOpacity={0.9}
              onPress={() => onSelectSite(site)}
            >
              <Image
                source={{ uri: getImageUri(site) }}
                style={styles.carouselImage}
                onError={() => handleImageError(site.id)}
              />
              <View style={styles.carouselBadge}>
                <Text style={styles.carouselBadgeText}>{site.dynasty || site.category}</Text>
              </View>
              <View style={styles.carouselContent}>
                <Text style={styles.carouselTitle} numberOfLines={1}>
                  {site.name}
                </Text>
                <View style={styles.locationRow}>
                  <Ionicons name="location-sharp" size={13} color={THEME.colors.amber} />
                  <Text style={styles.locationText} numberOfLines={1}>
                    {site.locationName}
                    {site.distance != null ? ` • ~${site.distance} km` : ' • Đang định vị'}
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
          <Text style={styles.bannerTag}>AI VISION CAMERA</Text>
          <Text style={styles.bannerHeading}>Đang đứng trước một di tích?</Text>
          <Text style={styles.bannerSub}>Mở máy ảnh nhận diện và nghe thuyết minh ngay</Text>
        </View>
        <View style={styles.bannerIconCircle}>
          <Ionicons name="scan-outline" size={30} color="#FFF" />
        </View>
      </TouchableOpacity>

      {/* Tiêu đề danh sách Di sản */}
      <View style={styles.sectionRow}>
        <Text style={styles.sectionTitle}>Khám phá di sản</Text>
        <Text style={{ fontSize: 13, color: THEME.colors.inkMuted }}>
          {filteredSites.length} di tích
        </Text>
      </View>

      {/* Lưới Danh sách Tất cả Di sản Văn Hóa */}
      <View style={styles.listContainer}>
        {isLoading ? (
          <View style={styles.loadingBox}>
            <ActivityIndicator size="large" color={THEME.colors.red} />
            <Text style={styles.loadingBoxText}>Đang nạp hình ảnh và dữ liệu di sản...</Text>
          </View>
        ) : filteredSites.length === 0 ? (
          <View style={styles.emptyContainer}>
            <Ionicons name="search" size={44} color={THEME.colors.inkMuted} />
            <Text style={styles.emptyTitle}>Không tìm thấy di tích phù hợp</Text>
            <Text style={styles.emptySub}>Thử tìm kiếm với từ khóa khác hoặc chuyển danh mục</Text>
          </View>
        ) : (
          filteredSites.map((site) => (
            <TouchableOpacity
              key={`site-${site.id}`}
              style={styles.siteCard}
              activeOpacity={0.9}
              onPress={() => onSelectSite(site)}
            >
              <Image
                source={{ uri: getImageUri(site) }}
                style={styles.siteCardImg}
                onError={() => handleImageError(site.id)}
              />
              <View style={styles.siteCardInfo}>
                <View style={styles.siteTopRow}>
                  <Text style={styles.siteDynasty}>{site.dynasty || site.category}</Text>
                  <View style={styles.ratingBadge}>
                    <Ionicons name="star" size={11} color="#FFF" />
                    <Text style={styles.ratingText}>4.9</Text>
                  </View>
                </View>
                <Text style={styles.siteName}>{site.name}</Text>
                <Text style={styles.siteLocation}>
                  <Ionicons name="location-outline" size={12} color={THEME.colors.inkMuted} /> {site.locationName}
                </Text>
                <Text style={styles.siteBrief} numberOfLines={2}>
                  {site.shortDescription || site.description}
                </Text>
              </View>
            </TouchableOpacity>
          ))
        )}
      </View>

      <View style={{ height: 100 }} />
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
    height: 190,
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
  carouselImage: {
    width: '100%',
    height: 118,
    backgroundColor: '#EAE5D9',
  },
  carouselBadge: {
    position: 'absolute',
    top: 10,
    left: 10,
    backgroundColor: 'rgba(28, 25, 23, 0.75)',
    paddingHorizontal: 8,
    paddingVertical: 4,
    borderRadius: 8,
  },
  carouselBadgeText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '600',
  },
  carouselContent: {
    padding: 10,
  },
  carouselTitle: {
    fontSize: 15,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  locationRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    marginTop: 4,
  },
  locationText: {
    fontSize: 12,
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
  catList: {
    paddingLeft: 20,
    paddingRight: 10,
    paddingVertical: 4,
  },
  catChip: {
    paddingHorizontal: 16,
    paddingVertical: 9,
    borderRadius: 20,
    backgroundColor: '#FFF',
    marginRight: 10,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  catChipActive: {
    backgroundColor: THEME.colors.red,
    borderColor: THEME.colors.red,
  },
  catText: {
    fontSize: 13,
    color: THEME.colors.ink,
    fontWeight: '500',
  },
  catTextActive: {
    color: '#FFF',
    fontWeight: '700',
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
  siteCardImg: {
    width: 105,
    height: 105,
    backgroundColor: '#EAE5D9',
  },
  siteCardInfo: {
    flex: 1,
    padding: 10,
    justifyContent: 'center',
  },
  siteTopRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  siteDynasty: {
    fontSize: 11,
    color: THEME.colors.amber,
    fontWeight: '600',
  },
  ratingBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: THEME.colors.amber,
    paddingHorizontal: 5,
    paddingVertical: 2,
    borderRadius: 6,
    gap: 2,
  },
  ratingText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '700',
  },
  siteName: {
    fontSize: 15,
    fontWeight: '700',
    color: THEME.colors.ink,
    marginTop: 2,
  },
  siteLocation: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 2,
  },
  siteBrief: {
    fontSize: 12,
    color: THEME.colors.inkLight,
    marginTop: 4,
    lineHeight: 16,
  },
});
