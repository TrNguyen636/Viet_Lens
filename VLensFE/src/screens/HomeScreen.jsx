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
import { THEME, useTheme } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritageList, DEFAULT_HERITAGE_IMAGE } from '../utils/heritageAdapter';
import useUserLocation from '../hooks/useUserLocation';

const { width } = Dimensions.get('window');
const CARD_WIDTH = width * 0.72;

export default function HomeScreen({ user, onSelectSite, onNavigateToCamera, onNavigateToMap, onNavigateToProfile }) {
  const { t, i18n } = useTranslation();
  const { theme, isDark } = useTheme();
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
  }, [userCoords, i18n?.language]);

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

  // Đảm bảo luôn có dữ liệu hiển thị cho Carousel "Di sản nổi bật quanh bạn"
  const displayNearbySites = useMemo(() => {
    if (nearbySites && nearbySites.length > 0) return nearbySites;
    if (allSites && allSites.length > 0) return allSites.slice(0, 6);
    return [];
  }, [nearbySites, allSites]);

  return (
    <ScrollView
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

      {/* Tiêu đề danh sách Di sản */}
      <View style={styles.sectionRow}>
        <Text style={[styles.sectionTitle, { color: theme.colors.ink }]}>
          {t('home.exploreSectionTitle')}
        </Text>
        <Text style={{ fontSize: 13, color: theme.colors.inkMuted }}>
          {filteredSites.length} {t('home.relicCountUnit')}
        </Text>
      </View>

      {/* Lưới Danh sách Tất cả Di sản Văn Hóa */}
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
          </View>
        ) : (
          filteredSites.map((site) => (
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
});
