import React, { useState, useEffect, useCallback } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Image,
  ScrollView,
  TouchableOpacity,
  Dimensions,
  ActivityIndicator,
  Alert,
  Share,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import { useSafeAreaInsets } from 'react-native-safe-area-context';
import { useTranslation } from 'react-i18next';
import { THEME, useTheme } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritage, adaptHeritageList, DEFAULT_HERITAGE_IMAGE } from '../utils/heritageAdapter';

const { width } = Dimensions.get('window');

export default function DetailScreen({ site: initialSite, onBack, onNavigateToChat, onNavigateToMap }) {
  const { t, i18n } = useTranslation();
  const { theme, isDark } = useTheme();
  const insets = useSafeAreaInsets();

  const [site, setSite] = useState(adaptHeritage(initialSite));
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);
  const [isDescriptionExpanded, setIsDescriptionExpanded] = useState(false);

  // Bookmark state
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [isTogglingBookmark, setIsTogglingBookmark] = useState(false);

  // Nearby sites state
  const [nearbySites, setNearbySites] = useState([]);
  const [isLoadingNearby, setIsLoadingNearby] = useState(false);

  // 1. Kiểm tra trạng thái đã lưu & lấy chi tiết mới nhất từ Backend
  useEffect(() => {
    let isMounted = true;

    const checkBookmarkAndDetail = async () => {
      if (!initialSite?.id) return;

      try {
        const detailPromise = appService.getHeritageById(initialSite.id).catch(() => null);
        const bookmarksPromise = appService.getUserBookmarks().catch(() => []);

        const [freshDetail, bookmarks] = await Promise.all([detailPromise, bookmarksPromise]);

        if (isMounted) {
          if (freshDetail) {
            setSite(adaptHeritage(freshDetail));
          }
          if (Array.isArray(bookmarks)) {
            const hasBookmarked = bookmarks.some((b) => b.id === initialSite.id);
            setIsBookmarked(hasBookmarked);
          }
        }
      } catch (e) {
        console.warn('[DetailScreen] Lỗi khởi tạo:', e.message);
      }
    };

    checkBookmarkAndDetail();

    return () => {
      isMounted = false;
      Speech.stop();
    };
  }, [initialSite]);

  // 2. Tải danh sách di sản gợi ý cùng khu vực (Lân cận toạ độ)
  useEffect(() => {
    let isMounted = true;
    if (site?.latitude && site?.longitude) {
      setIsLoadingNearby(true);
      appService
        .getNearbyHeritage(site.latitude, site.longitude, 40.0, 5)
        .then((res) => {
          if (isMounted && Array.isArray(res)) {
            const adapted = adaptHeritageList(res).filter((s) => s.id !== site.id);
            setNearbySites(adapted.slice(0, 4));
          }
        })
        .catch((err) => {
          console.warn('[DetailScreen] Không tải được di sản lân cận:', err.message);
        })
        .finally(() => {
          if (isMounted) setIsLoadingNearby(false);
        });
    }
    return () => {
      isMounted = false;
    };
  }, [site?.id, site?.latitude, site?.longitude]);

  // 3. Audio Guide TTS
  const toggleAudioGuide = () => {
    if (isPlayingAudio) {
      Speech.stop();
      setIsPlayingAudio(false);
    } else {
      setIsPlayingAudio(true);
      const currentLang = i18n.language || 'vi';
      const isJapanese = currentLang.startsWith('ja');
      const isEnglish = currentLang.startsWith('en');
      const textToRead = isJapanese
        ? `${site.name}。所在地は${site.locationName || site.province || ''}。${site.description || site.summary || ''}`
        : isEnglish
        ? `${site.name}. Located in ${site.locationName}. ${site.description || site.summary}`
        : `${site.name}. Tọa lạc tại ${site.locationName}. ${site.description || site.summary}`;

      Speech.speak(textToRead, {
        language: isJapanese ? 'ja-JP' : (isEnglish ? 'en-US' : 'vi-VN'),
        rate: 0.95,
        onDone: () => setIsPlayingAudio(false),
        onError: () => setIsPlayingAudio(false),
      });
    }
  };

  // 4. Xử lý Toggle Bookmark
  const handleToggleBookmark = async () => {
    if (isTogglingBookmark) return;
    try {
      setIsTogglingBookmark(true);
      const previousState = isBookmarked;
      setIsBookmarked(!previousState);

      const res = await appService.toggleBookmark(site.id);
      if (res && typeof res.bookmarked === 'boolean') {
        setIsBookmarked(res.bookmarked);
      }
    } catch (err) {
      console.warn('[DetailScreen] Lỗi bookmark:', err.message);
      setIsBookmarked((prev) => !prev);
      if (err.response?.status === 401) {
        Alert.alert(t('common.unauthorized'), t('common.guestNotice'));
      } else {
        Alert.alert(t('common.notice'), 'Không thể cập nhật danh sách yêu thích lúc này.');
      }
    } finally {
      setIsTogglingBookmark(false);
    }
  };

  // 5. Chia sẻ thông tin di sản
  const handleShare = async () => {
    try {
      await Share.share({
        title: site?.name || 'VietLens - Di sản Việt Nam',
        message: `${site?.name}\n📍 ${site?.address || site?.locationName}\n\n${site?.summary || site?.shortDescription || site?.description}\n\nKhám phá Di sản Văn hóa Việt Nam cùng ứng dụng VietLens!`,
      });
    } catch (err) {
      console.warn('[DetailScreen] Share error:', err.message);
    }
  };

  const handleBack = () => {
    Speech.stop();
    setIsPlayingAudio(false);
    if (onBack) onBack();
  };

  const handleNavigateToChat = (targetSite) => {
    Speech.stop();
    setIsPlayingAudio(false);
    if (onNavigateToChat) onNavigateToChat(targetSite || site);
  };

  const handleNavigateToMapDirect = () => {
    Speech.stop();
    setIsPlayingAudio(false);
    if (onNavigateToMap) {
      onNavigateToMap(site);
    }
  };

  const handleSelectRelated = (relatedSite) => {
    Speech.stop();
    setIsPlayingAudio(false);
    setIsDescriptionExpanded(false);
    setSite(adaptHeritage(relatedSite));
  };

  const fullDescription = site?.description || site?.summary || t('detail.aboutDefault');
  const shouldTruncate = fullDescription.length > 280;
  const displayDescription =
    shouldTruncate && !isDescriptionExpanded
      ? `${fullDescription.substring(0, 280).trim()}...`
      : fullDescription;

  return (
    <View style={[styles.container, { backgroundColor: theme.colors.bg }]}>
      <ScrollView showsVerticalScrollIndicator={false} contentContainerStyle={styles.scrollContent}>
        {/* ======================================================== */}
        {/* 1. HERO COVER IMAGE & FLOATING SAFE BAR                   */}
        {/* ======================================================== */}
        <View style={styles.coverWrapper}>
          <Image
            source={{ uri: site?.imageUrl || site?.image || DEFAULT_HERITAGE_IMAGE }}
            style={styles.coverImg}
            resizeMode="cover"
          />

          {/* Floating Top Navigation Bar */}
          <View style={[styles.floatingTopBar, { top: Math.max(insets.top, 16) }]}>
            <TouchableOpacity
              style={styles.iconCircleBtn}
              onPress={handleBack}
              activeOpacity={0.8}
            >
              <Ionicons name="arrow-back" size={22} color="#FFF" />
            </TouchableOpacity>

            <View style={styles.floatingTopRight}>
              <TouchableOpacity
                style={styles.iconCircleBtn}
                onPress={handleShare}
                activeOpacity={0.8}
              >
                <Ionicons name="share-social-outline" size={20} color="#FFF" />
              </TouchableOpacity>

              <TouchableOpacity
                style={[styles.iconCircleBtn, isBookmarked && styles.iconCircleBtnActive]}
                onPress={handleToggleBookmark}
                activeOpacity={0.8}
              >
                {isTogglingBookmark ? (
                  <ActivityIndicator size="small" color="#FFF" />
                ) : (
                  <Ionicons
                    name={isBookmarked ? 'bookmark' : 'bookmark-outline'}
                    size={20}
                    color={isBookmarked ? theme.colors.yellow : '#FFF'}
                  />
                )}
              </TouchableOpacity>
            </View>
          </View>

          {/* Cover Bottom Gradient & Title Overlay */}
          <View style={styles.coverGradient}>
            <View style={styles.badgeRow}>
              <View style={[styles.dynastyPill, { backgroundColor: theme.colors.amber }]}>
                <Text style={styles.dynastyPillText}>{site?.dynasty || site?.category}</Text>
              </View>
              <View style={styles.categoryPill}>
                <Text style={styles.categoryPillText}>{site?.category || 'Di sản văn hóa'}</Text>
              </View>
            </View>

            <Text style={styles.coverTitle} numberOfLines={2}>
              {site?.name}
            </Text>

            <View style={styles.coverLocationRow}>
              <Ionicons name="location-sharp" size={14} color={theme.colors.yellow} />
              <Text style={styles.coverLocation} numberOfLines={1}>
                {site?.address || site?.locationName}
              </Text>
            </View>
          </View>
        </View>

        {/* ======================================================== */}
        {/* 2. QUICK FACTS GRID (THÔNG SỐ NHANH)                     */}
        {/* ======================================================== */}
        <View style={styles.sectionContainer}>
          <View style={styles.statsGrid}>
            {/* Stat 1: Niên đại */}
            <View style={[styles.statBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
              <Ionicons name="hourglass-outline" size={18} color={theme.colors.amber} />
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('detail.era')}</Text>
              <Text style={[styles.statValue, { color: theme.colors.ink }]} numberOfLines={1}>
                {site?.dynasty || 'Cổ truyền'}
              </Text>
            </View>

            {/* Stat 2: Phân loại */}
            <View style={[styles.statBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
              <Ionicons name="ribbon-outline" size={18} color={theme.colors.red} />
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('detail.category')}</Text>
              <Text style={[styles.statValue, { color: theme.colors.ink }]} numberOfLines={1}>
                {site?.category || 'Văn hóa'}
              </Text>
            </View>

            {/* Stat 3: Địa phương */}
            <View style={[styles.statBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
              <Ionicons name="map-outline" size={18} color={theme.colors.green || '#2E7D32'} />
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('detail.province')}</Text>
              <Text style={[styles.statValue, { color: theme.colors.ink }]} numberOfLines={1}>
                {site?.province || site?.locationName || 'Việt Nam'}
              </Text>
            </View>

            {/* Stat 4: Khoảng cách GPS */}
            <View style={[styles.statBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
              <Ionicons name="navigate-outline" size={18} color={theme.colors.yellow} />
              <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('detail.distance')}</Text>
              <Text style={[styles.statValue, { color: theme.colors.ink }]} numberOfLines={1}>
                {site?.distance != null ? `~${site.distance} km` : t('home.locating')}
              </Text>
            </View>
          </View>
        </View>

        {/* ======================================================== */}
        {/* 3. QUICK ACTION TOOLBAR (THANH TÁC VỤ TIỆN ÍCH)           */}
        {/* ======================================================== */}
        <View style={styles.sectionContainer}>
          <View style={[styles.actionsToolbar, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
            <TouchableOpacity
              style={styles.actionBtnItem}
              onPress={toggleAudioGuide}
              activeOpacity={0.7}
            >
              <View style={[styles.actionIconCircle, { backgroundColor: isPlayingAudio ? theme.colors.red : '#FFF3E0' }]}>
                <Ionicons
                  name={isPlayingAudio ? 'pause' : 'volume-high'}
                  size={20}
                  color={isPlayingAudio ? '#FFF' : theme.colors.amber}
                />
              </View>
              <Text style={[styles.actionBtnLabel, { color: theme.colors.ink }]}>
                {isPlayingAudio ? t('detail.audioPause') : 'Audio Guide'}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.actionBtnItem}
              onPress={handleNavigateToMapDirect}
              activeOpacity={0.7}
            >
              <View style={[styles.actionIconCircle, { backgroundColor: '#E8F5E9' }]}>
                <Ionicons name="navigate" size={19} color="#2E7D32" />
              </View>
              <Text style={[styles.actionBtnLabel, { color: theme.colors.ink }]}>
                {t('detail.directions')}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.actionBtnItem}
              onPress={() => handleNavigateToChat(site)}
              activeOpacity={0.7}
            >
              <View style={[styles.actionIconCircle, { backgroundColor: '#FFEBEE' }]}>
                <MaterialCommunityIcons name="robot-outline" size={20} color={theme.colors.red} />
              </View>
              <Text style={[styles.actionBtnLabel, { color: theme.colors.ink }]}>
                Cố vấn AI
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={styles.actionBtnItem}
              onPress={handleShare}
              activeOpacity={0.7}
            >
              <View style={[styles.actionIconCircle, { backgroundColor: '#EDE7F6' }]}>
                <Ionicons name="share-social" size={19} color="#5E35B1" />
              </View>
              <Text style={[styles.actionBtnLabel, { color: theme.colors.ink }]}>
                {t('detail.share')}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* ======================================================== */}
        {/* 4. AUDIO GUIDE PLAYER CARD (TRÌNH THUYẾT MINH AI)         */}
        {/* ======================================================== */}
        <View style={styles.sectionContainer}>
          <View style={[styles.audioGuideCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
            <View style={styles.audioLeft}>
              <View style={[styles.audioIconCircle, { backgroundColor: isPlayingAudio ? theme.colors.red : theme.colors.amber }]}>
                <Ionicons
                  name={isPlayingAudio ? 'volume-high' : 'headset-outline'}
                  size={22}
                  color="#FFF"
                />
              </View>
              <View style={{ flex: 1, marginLeft: 12 }}>
                <View style={styles.audioTitleRow}>
                  <Text style={[styles.audioTitle, { color: theme.colors.ink }]}>{t('detail.audioGuideTitle')}</Text>
                  {isPlayingAudio && (
                    <View style={styles.liveAudioBadge}>
                      <View style={styles.liveAudioDot} />
                      <Text style={styles.liveAudioText}>PLAYING</Text>
                    </View>
                  )}
                </View>
                <Text style={[styles.audioSub, { color: theme.colors.inkMuted }]}>
                  {isPlayingAudio
                    ? t('detail.audioGuidePlaying')
                    : t('detail.audioGuideSub')}
                </Text>
              </View>
            </View>

            <TouchableOpacity
              style={[
                styles.audioPlayBtn,
                { backgroundColor: theme.colors.parchment, borderColor: theme.colors.amber },
                isPlayingAudio && { backgroundColor: theme.colors.red, borderColor: theme.colors.red },
              ]}
              onPress={toggleAudioGuide}
              activeOpacity={0.8}
            >
              <Ionicons
                name={isPlayingAudio ? 'pause' : 'play'}
                size={14}
                color={isPlayingAudio ? '#FFF' : theme.colors.amber}
                style={{ marginRight: 4 }}
              />
              <Text
                style={[
                  styles.audioPlayBtnText,
                  { color: isPlayingAudio ? '#FFF' : theme.colors.amber },
                ]}
              >
                {isPlayingAudio ? t('detail.audioPause') : t('detail.audioPlay')}
              </Text>
            </TouchableOpacity>
          </View>
        </View>

        {/* ======================================================== */}
        {/* 5. CÂU CHUYỆN VĂN HÓA & LỊCH SỬ (STORY & DESCRIPTION)     */}
        {/* ======================================================== */}
        <View style={styles.sectionContainer}>
          <View style={[styles.cardBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
            <View style={[styles.cardHeaderRow, { borderBottomColor: theme.colors.border }]}>
              <View style={styles.cardHeaderLeft}>
                <Ionicons name="book-outline" size={18} color={theme.colors.red} />
                <Text style={[styles.cardSectionTitle, { color: theme.colors.ink }]}>
                  {t('detail.storySection')}
                </Text>
              </View>
            </View>

            {/* Trích dẫn tóm tắt nổi bật (Highlight Quote) */}
            {site?.summary && (
              <View style={[styles.highlightBox, { backgroundColor: isDark ? '#26231F' : '#FBF7EE', borderColor: theme.colors.border }]}>
                <Ionicons name="quote" size={18} color={theme.colors.amber} style={{ marginBottom: 4 }} />
                <Text style={[styles.highlightText, { color: theme.colors.ink }]}>
                  {site.summary}
                </Text>
              </View>
            )}

            {/* Nội dung chi tiết với tính năng Xem thêm / Thu gọn */}
            <Text style={[styles.contentParagraph, { color: theme.colors.ink }]}>
              {displayDescription}
            </Text>

            {shouldTruncate && (
              <TouchableOpacity
                style={styles.expandToggleBtn}
                onPress={() => setIsDescriptionExpanded(!isDescriptionExpanded)}
                activeOpacity={0.7}
              >
                <Text style={[styles.expandToggleText, { color: theme.colors.red }]}>
                  {isDescriptionExpanded ? t('detail.readLess') : t('detail.readMore')}
                </Text>
                <Ionicons
                  name={isDescriptionExpanded ? 'chevron-up' : 'chevron-down'}
                  size={14}
                  color={theme.colors.red}
                />
              </TouchableOpacity>
            )}

            {/* Danh sách Nhân vật lịch sử gắn liền */}
            {site?.keyFigures && site.keyFigures.length > 0 && (
              <View style={styles.keyFiguresContainer}>
                <Text style={[styles.subSectionTitle, { color: theme.colors.ink }]}>
                  {t('detail.keyFigures')}
                </Text>
                <View style={styles.chipsRow}>
                  {site.keyFigures.map((fig, idx) => (
                    <View
                      key={idx}
                      style={[styles.figureChip, { backgroundColor: isDark ? '#2E2A25' : theme.colors.parchment }]}
                    >
                      <Ionicons name="person" size={12} color={theme.colors.amber} />
                      <Text style={[styles.figureText, { color: theme.colors.ink }]}>{fig}</Text>
                    </View>
                  ))}
                </View>
              </View>
            )}
          </View>
        </View>

        {/* ======================================================== */}
        {/* 6. VỊ TRÍ & THÔNG TIN THAM QUAN (LOCATION & MAP ACCESS)  */}
        {/* ======================================================== */}
        <View style={styles.sectionContainer}>
          <View style={[styles.cardBox, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
            <View style={[styles.cardHeaderRow, { borderBottomColor: theme.colors.border }]}>
              <View style={styles.cardHeaderLeft}>
                <Ionicons name="location-outline" size={18} color={theme.colors.red} />
                <Text style={[styles.cardSectionTitle, { color: theme.colors.ink }]}>
                  {t('detail.locationSection')}
                </Text>
              </View>
            </View>

            <View style={styles.locationDetailBlock}>
              <View style={styles.locationItemRow}>
                <Ionicons name="business-outline" size={16} color={theme.colors.amber} style={styles.locIcon} />
                <View style={{ flex: 1 }}>
                  <Text style={[styles.locItemTitle, { color: theme.colors.inkMuted }]}>Địa chỉ di tích</Text>
                  <Text style={[styles.locItemValue, { color: theme.colors.ink }]}>
                    {site?.address || site?.locationName || 'Đang cập nhật'}
                  </Text>
                </View>
              </View>

              <View style={styles.locationItemRow}>
                <Ionicons name="compass-outline" size={16} color={theme.colors.amber} style={styles.locIcon} />
                <View style={{ flex: 1 }}>
                  <Text style={[styles.locItemTitle, { color: theme.colors.inkMuted }]}>{t('detail.coordinates')}</Text>
                  <Text style={[styles.locItemValue, { color: theme.colors.ink }]}>
                    {site?.latitude != null && site?.longitude != null
                      ? `${site.latitude.toFixed(5)}° N, ${site.longitude.toFixed(5)}° E`
                      : 'Đang xác định'}
                  </Text>
                </View>
              </View>
            </View>

            {/* Nút chỉ đường trực tiếp */}
            <TouchableOpacity
              style={[styles.mapShortcutBtn, { backgroundColor: isDark ? '#2C2720' : theme.colors.parchment, borderColor: theme.colors.amber }]}
              onPress={handleNavigateToMapDirect}
              activeOpacity={0.8}
            >
              <Ionicons name="map" size={18} color={theme.colors.amber} />
              <Text style={[styles.mapShortcutText, { color: theme.colors.amber }]}>
                {t('detail.openMapDirect')}
              </Text>
              <Ionicons name="arrow-forward" size={16} color={theme.colors.amber} />
            </TouchableOpacity>
          </View>
        </View>

        {/* ======================================================== */}
        {/* 7. DI SẢN CÙNG KHU VỰC (NEARBY / RELATED HERITAGES)      */}
        {/* ======================================================== */}
        {nearbySites.length > 0 && (
          <View style={styles.sectionContainer}>
            <View style={styles.nearbySectionHeader}>
              <Ionicons name="sparkles" size={16} color={theme.colors.red} />
              <Text style={[styles.cardSectionTitle, { color: theme.colors.ink }]}>
                {t('detail.nearbyHeritages')}
              </Text>
            </View>

            <ScrollView
              horizontal
              showsHorizontalScrollIndicator={false}
              contentContainerStyle={styles.nearbyScroll}
            >
              {nearbySites.map((item) => (
                <TouchableOpacity
                  key={`related-${item.id}`}
                  style={[styles.nearbyCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}
                  onPress={() => handleSelectRelated(item)}
                  activeOpacity={0.88}
                >
                  <Image
                    source={{ uri: item.imageUrl || item.image || DEFAULT_HERITAGE_IMAGE }}
                    style={styles.nearbyCardImg}
                    resizeMode="cover"
                  />
                  <View style={styles.nearbyCardInfo}>
                    <Text style={[styles.nearbyCardTitle, { color: theme.colors.ink }]} numberOfLines={1}>
                      {item.name}
                    </Text>
                    <Text style={[styles.nearbyCardLoc, { color: theme.colors.inkMuted }]} numberOfLines={1}>
                      {item.locationName}
                      {item.distance != null ? ` • ~${item.distance} km` : ''}
                    </Text>
                  </View>
                </TouchableOpacity>
              ))}
            </ScrollView>
          </View>
        )}

        <View style={{ height: 120 }} />
      </ScrollView>

      {/* ======================================================== */}
      {/* 8. STICKY DUAL-ACTION BOTTOM BAR                         */}
      {/* ======================================================== */}
      <View
        style={[
          styles.bottomBarSticky,
          {
            backgroundColor: theme.colors.card,
            borderTopColor: theme.colors.border,
            paddingBottom: Math.max(insets.bottom, 16),
          },
        ]}
      >
        <TouchableOpacity
          style={[styles.directionsBtn, { borderColor: theme.colors.amber, backgroundColor: isDark ? '#27221C' : '#FFF9F0' }]}
          onPress={handleNavigateToMapDirect}
          activeOpacity={0.8}
        >
          <Ionicons name="navigate" size={18} color={theme.colors.amber} />
          <Text style={[styles.directionsBtnText, { color: theme.colors.amber }]}>
            {t('detail.directions')}
          </Text>
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.askAiStickyBtn, { backgroundColor: theme.colors.red }]}
          onPress={() => handleNavigateToChat(site)}
          activeOpacity={0.85}
        >
          <MaterialCommunityIcons name="robot-outline" size={20} color="#FFF" />
          <Text style={styles.askAiStickyBtnText}>
            {t('detail.askAi')}
          </Text>
        </TouchableOpacity>
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  scrollContent: {
    paddingBottom: 20,
  },
  coverWrapper: {
    width: width,
    height: 330,
    position: 'relative',
  },
  coverImg: {
    width: '100%',
    height: '100%',
    backgroundColor: '#EAE5D9',
  },
  floatingTopBar: {
    position: 'absolute',
    left: 20,
    right: 20,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    zIndex: 10,
  },
  floatingTopRight: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  iconCircleBtn: {
    width: 42,
    height: 42,
    borderRadius: 21,
    backgroundColor: 'rgba(28, 25, 23, 0.65)',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.25)',
  },
  iconCircleBtnActive: {
    backgroundColor: 'rgba(198, 40, 40, 0.95)',
    borderColor: 'rgba(255, 255, 255, 0.5)',
  },
  coverGradient: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    paddingHorizontal: 20,
    paddingTop: 40,
    paddingBottom: 18,
    backgroundColor: 'rgba(20, 18, 16, 0.72)',
  },
  badgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 6,
  },
  dynastyPill: {
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  dynastyPillText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '700',
  },
  categoryPill: {
    backgroundColor: 'rgba(255, 255, 255, 0.22)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  categoryPillText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '500',
  },
  coverTitle: {
    fontSize: 23,
    fontWeight: '800',
    color: '#FFF',
    marginBottom: 4,
    lineHeight: 30,
    textShadowColor: 'rgba(0, 0, 0, 0.5)',
    textShadowOffset: { width: 0, height: 1 },
    textShadowRadius: 3,
  },
  coverLocationRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  coverLocation: {
    fontSize: 13,
    color: '#F3F4F6',
    flex: 1,
  },
  sectionContainer: {
    paddingHorizontal: 20,
    marginTop: 14,
  },
  statsGrid: {
    flexDirection: 'row',
    gap: 8,
  },
  statBox: {
    flex: 1,
    borderRadius: 14,
    paddingVertical: 10,
    paddingHorizontal: 6,
    alignItems: 'center',
    borderWidth: 1,
    elevation: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.04,
    shadowRadius: 2,
  },
  statLabel: {
    fontSize: 10,
    marginTop: 4,
    fontWeight: '500',
  },
  statValue: {
    fontSize: 12,
    fontWeight: '700',
    marginTop: 2,
    textAlign: 'center',
  },
  actionsToolbar: {
    flexDirection: 'row',
    justifyContent: 'space-around',
    alignItems: 'center',
    borderRadius: 16,
    paddingVertical: 12,
    paddingHorizontal: 8,
    borderWidth: 1,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  actionBtnItem: {
    alignItems: 'center',
    flex: 1,
  },
  actionIconCircle: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 5,
  },
  actionBtnLabel: {
    fontSize: 11,
    fontWeight: '600',
  },
  audioGuideCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    padding: 14,
    borderRadius: 16,
    borderWidth: 1,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.06,
    shadowRadius: 3,
  },
  audioLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    flex: 1,
  },
  audioIconCircle: {
    width: 44,
    height: 44,
    borderRadius: 22,
    alignItems: 'center',
    justifyContent: 'center',
  },
  audioTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  audioTitle: {
    fontSize: 13.5,
    fontWeight: '700',
  },
  liveAudioBadge: {
    backgroundColor: '#FFEBEE',
    paddingHorizontal: 5,
    paddingVertical: 2,
    borderRadius: 4,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 3,
  },
  liveAudioDot: {
    width: 5,
    height: 5,
    borderRadius: 2.5,
    backgroundColor: '#C62828',
  },
  liveAudioText: {
    fontSize: 8.5,
    fontWeight: '800',
    color: '#C62828',
  },
  audioSub: {
    fontSize: 11,
    marginTop: 2,
  },
  audioPlayBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 12,
    paddingVertical: 8,
    borderRadius: 10,
    borderWidth: 1,
    marginLeft: 8,
  },
  audioPlayBtnText: {
    fontSize: 11.5,
    fontWeight: '700',
  },
  cardBox: {
    padding: 16,
    borderRadius: 16,
    borderWidth: 1,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  cardHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingBottom: 10,
    marginBottom: 12,
    borderBottomWidth: 1,
  },
  cardHeaderLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  cardSectionTitle: {
    fontSize: 15.5,
    fontWeight: '700',
  },
  highlightBox: {
    padding: 12,
    borderRadius: 10,
    borderLeftWidth: 3,
    marginBottom: 12,
  },
  highlightText: {
    fontSize: 13,
    lineHeight: 19,
    fontStyle: 'italic',
  },
  contentParagraph: {
    fontSize: 14,
    lineHeight: 22,
    textAlign: 'justify',
  },
  expandToggleBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 8,
    paddingVertical: 6,
    gap: 4,
  },
  expandToggleText: {
    fontSize: 12.5,
    fontWeight: '700',
  },
  keyFiguresContainer: {
    marginTop: 14,
    paddingTop: 12,
    borderTopWidth: 1,
    borderTopColor: 'rgba(0, 0, 0, 0.06)',
  },
  subSectionTitle: {
    fontSize: 13,
    fontWeight: '700',
    marginBottom: 8,
  },
  chipsRow: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  figureChip: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 9,
    paddingVertical: 4.5,
    borderRadius: 8,
    gap: 4,
  },
  figureText: {
    fontSize: 12,
    fontWeight: '600',
  },
  locationDetailBlock: {
    gap: 10,
    marginBottom: 12,
  },
  locationItemRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: 8,
  },
  locIcon: {
    marginTop: 2,
  },
  locItemTitle: {
    fontSize: 11,
    fontWeight: '500',
  },
  locItemValue: {
    fontSize: 13,
    fontWeight: '600',
    marginTop: 1,
  },
  mapShortcutBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 10,
    borderRadius: 12,
    borderWidth: 1,
    gap: 6,
  },
  mapShortcutText: {
    fontSize: 13,
    fontWeight: '700',
  },
  nearbySectionHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginBottom: 10,
  },
  nearbyScroll: {
    gap: 12,
  },
  nearbyCard: {
    width: 170,
    borderRadius: 14,
    borderWidth: 1,
    overflow: 'hidden',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  nearbyCardImg: {
    width: '100%',
    height: 95,
    backgroundColor: '#EAE5D9',
  },
  nearbyCardInfo: {
    padding: 8,
  },
  nearbyCardTitle: {
    fontSize: 13,
    fontWeight: '700',
  },
  nearbyCardLoc: {
    fontSize: 11,
    marginTop: 2,
  },
  bottomBarSticky: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    flexDirection: 'row',
    paddingHorizontal: 16,
    paddingTop: 12,
    borderTopWidth: 1,
    gap: 10,
  },
  directionsBtn: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 13,
    borderRadius: 14,
    borderWidth: 1.5,
    gap: 6,
  },
  directionsBtnText: {
    fontSize: 14,
    fontWeight: '700',
  },
  askAiStickyBtn: {
    flex: 1.3,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 13,
    borderRadius: 14,
    gap: 6,
    elevation: 3,
    shadowColor: '#C62828',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
  },
  askAiStickyBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
});
