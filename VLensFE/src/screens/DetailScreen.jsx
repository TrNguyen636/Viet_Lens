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
  Modal,
  TextInput,
  Alert,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import { useTranslation } from 'react-i18next';
import { THEME } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritage, DEFAULT_HERITAGE_IMAGE } from '../utils/heritageAdapter';

const { width } = Dimensions.get('window');

export default function DetailScreen({ site: initialSite, onBack, onNavigateToChat }) {
  const { t, i18n } = useTranslation();
  const [site, setSite] = useState(adaptHeritage(initialSite));
  const [isPlayingAudio, setIsPlayingAudio] = useState(false);

  // Bookmark state
  const [isBookmarked, setIsBookmarked] = useState(false);
  const [isTogglingBookmark, setIsTogglingBookmark] = useState(false);

  // 1. Kiểm tra trạng thái đã lưu & lấy chi tiết mới nhất từ Backend
  useEffect(() => {
    let isMounted = true;

    const checkBookmarkAndDetail = async () => {
      if (!initialSite?.id) return;

      try {
        // Tải chi tiết mới nhất từ backend nếu là UUID thật
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

  // 3. Audio Guide TTS
  const toggleAudioGuide = () => {
    if (isPlayingAudio) {
      Speech.stop();
      setIsPlayingAudio(false);
    } else {
      setIsPlayingAudio(true);
      const isEnglish = (i18n.language || 'vi').startsWith('en');
      const textToRead = isEnglish
        ? `${site.name}. Located in ${site.locationName}. ${site.description || site.summary}`
        : `${site.name}. Tọa lạc tại ${site.locationName}. ${site.description || site.summary}`;

      Speech.speak(textToRead, {
        language: isEnglish ? 'en-US' : 'vi-VN',
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
      // Optimistic UI update
      const previousState = isBookmarked;
      setIsBookmarked(!previousState);

      const res = await appService.toggleBookmark(site.id);
      if (res && typeof res.bookmarked === 'boolean') {
        setIsBookmarked(res.bookmarked);
      }
    } catch (err) {
      console.warn('[DetailScreen] Lỗi bookmark:', err.message);
      // Revert if error
      setIsBookmarked((prev) => !prev);
      if (err.response?.status === 401) {
        Alert.alert('Chưa đăng nhập', 'Vui lòng đăng nhập tài khoản để lưu di tích yêu thích!');
      } else {
        Alert.alert('Thông báo', 'Không thể cập nhật danh sách yêu thích lúc này. Vui lòng thử lại sau!');
      }
    } finally {
      setIsTogglingBookmark(false);
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
    if (onNavigateToChat) onNavigateToChat(targetSite);
  };

  return (
    <View style={styles.container}>
      <ScrollView showsVerticalScrollIndicator={false}>
        {/* Full-width Cover Image từ Supabase Storage */}
        <View style={styles.coverWrapper}>
          <Image
            source={{ uri: site?.imageUrl || site?.image || DEFAULT_HERITAGE_IMAGE }}
            style={styles.coverImg}
          />

          {/* Floating Top Bar Buttons */}
          <View style={styles.floatingTopBar}>
            <TouchableOpacity style={styles.iconCircleBtn} onPress={handleBack}>
              <Ionicons name="arrow-back" size={20} color="#FFF" />
            </TouchableOpacity>

            <View style={{ flexDirection: 'row', gap: 10 }}>
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
                    color={isBookmarked ? THEME.colors.yellow : '#FFF'}
                  />
                )}
              </TouchableOpacity>

              <TouchableOpacity style={styles.iconCircleBtn} onPress={() => {}}>
                <Ionicons name="share-social-outline" size={20} color="#FFF" />
              </TouchableOpacity>
            </View>
          </View>

          {/* Cover Overlay Info */}
          <View style={styles.coverGradient}>
            <View style={styles.badgeRow}>
              <View style={styles.dynastyPill}>
                <Text style={styles.dynastyPillText}>{site?.dynasty || site?.category}</Text>
              </View>
              <Text style={styles.eraText}>{site?.era || 'Di sản văn hóa Việt Nam'}</Text>
            </View>
            <Text style={styles.coverTitle}>{site?.name}</Text>
            <Text style={styles.coverLocation}>
              <Ionicons name="location-sharp" size={13} color={THEME.colors.yellow} />{' '}
              {site?.address || site?.locationName}
            </Text>
          </View>
        </View>

        {/* Audio Guide Play Button */}
        <View style={styles.audioGuideCard}>
          <View style={styles.audioLeft}>
            <View style={styles.audioIconCircle}>
              <Ionicons
                name={isPlayingAudio ? 'pause' : 'volume-high'}
                size={22}
                color="#FFF"
              />
            </View>
            <View style={{ flex: 1, marginLeft: 12 }}>
              <Text style={styles.audioTitle}>{t('detail.audioGuideTitle')}</Text>
              <Text style={styles.audioSub}>
                {isPlayingAudio
                  ? t('detail.audioGuidePlaying')
                  : t('detail.audioGuideSub')}
              </Text>
            </View>
          </View>
          <TouchableOpacity
            style={[styles.audioPlayBtn, isPlayingAudio && styles.audioPlayBtnActive]}
            onPress={toggleAudioGuide}
          >
            <Text style={styles.audioPlayBtnText}>
              {isPlayingAudio ? t('detail.audioPause') : t('detail.audioPlay')}
            </Text>
          </TouchableOpacity>
        </View>

        {/* Giới thiệu di sản (Mô tả chi tiết bách khoa) */}
        <View style={styles.descriptionSection}>
          <View style={styles.descriptionHeaderRow}>
            <Ionicons name="book-outline" size={18} color={THEME.colors.red} />
            <Text style={styles.descriptionSectionTitle}>{t('detail.aboutSection')}</Text>
          </View>
          <Text style={styles.contentParagraph}>
            {site?.description || site?.summary || t('detail.aboutDefault')}
          </Text>

          {site?.keyFigures && site.keyFigures.length > 0 && (
            <>
              <Text style={styles.subSectionTitle}>{t('detail.keyFigures')}</Text>
              <View style={styles.chipsRow}>
                {site.keyFigures.map((fig, idx) => (
                  <View key={idx} style={styles.figureChip}>
                    <Ionicons name="person" size={12} color={THEME.colors.amber} />
                    <Text style={styles.figureText}>{fig}</Text>
                  </View>
                ))}
              </View>
            </>
          )}
        </View>

        <View style={{ height: 110 }} />
      </ScrollView>

      {/* Sticky Bottom Bar: Hỏi AI */}
      <View style={styles.bottomBarSticky}>
        <TouchableOpacity
          style={styles.askAiStickyBtn}
          onPress={() => handleNavigateToChat(site)}
        >
          <MaterialCommunityIcons name="robot-outline" size={20} color="#FFF" />
          <Text style={styles.askAiStickyBtnText}>{t('detail.askAi')}</Text>
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
    top: 50,
    left: 20,
    right: 20,
    flexDirection: 'row',
    justifyContent: 'space-between',
    zIndex: 10,
  },
  iconCircleBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(0,0,0,0.5)',
    alignItems: 'center',
    justifyContent: 'center',
  },
  iconCircleBtnActive: {
    backgroundColor: 'rgba(198, 40, 40, 0.9)',
  },
  coverGradient: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    padding: 20,
    backgroundColor: 'rgba(28, 25, 23, 0.65)',
  },
  badgeRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 6,
  },
  dynastyPill: {
    backgroundColor: THEME.colors.amber,
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 6,
  },
  dynastyPillText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '700',
  },
  eraText: {
    color: '#FEF3C7',
    fontSize: 12,
  },
  coverTitle: {
    fontSize: 22,
    fontWeight: '800',
    color: '#FFF',
    marginBottom: 4,
  },
  coverLocation: {
    fontSize: 13,
    color: '#E5E7EB',
  },
  audioGuideCard: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    backgroundColor: '#FFF',
    marginHorizontal: 20,
    marginTop: -20,
    padding: 14,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 4,
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
    backgroundColor: THEME.colors.red,
    alignItems: 'center',
    justifyContent: 'center',
  },
  audioTitle: {
    fontSize: 14,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  audioSub: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
    marginTop: 2,
  },
  audioPlayBtn: {
    backgroundColor: THEME.colors.parchment,
    paddingHorizontal: 14,
    paddingVertical: 8,
    borderRadius: 10,
    borderWidth: 1,
    borderColor: THEME.colors.amber,
  },
  audioPlayBtnActive: {
    backgroundColor: THEME.colors.red,
    borderColor: THEME.colors.red,
  },
  audioPlayBtnText: {
    fontSize: 12,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  descriptionSection: {
    marginHorizontal: 20,
    marginTop: 18,
    backgroundColor: '#FFF',
    padding: 18,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.05,
    shadowRadius: 3,
  },
  descriptionHeaderRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 12,
    paddingBottom: 8,
    borderBottomWidth: 1,
    borderBottomColor: '#F3F4F6',
  },
  descriptionSectionTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  contentParagraph: {
    fontSize: 14.5,
    lineHeight: 23,
    color: THEME.colors.ink,
    textAlign: 'justify',
  },
  subSectionTitle: {
    fontSize: 14,
    fontWeight: '700',
    color: THEME.colors.ink,
    marginTop: 16,
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
    backgroundColor: THEME.colors.parchment,
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    gap: 4,
  },
  figureText: {
    fontSize: 12,
    color: THEME.colors.ink,
    fontWeight: '600',
  },
  bulletRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    marginTop: 8,
  },
  bulletDot: {
    width: 6,
    height: 6,
    borderRadius: 3,
    backgroundColor: THEME.colors.red,
    marginTop: 7,
    marginRight: 8,
  },
  bulletText: {
    fontSize: 13,
    color: THEME.colors.ink,
    lineHeight: 20,
    flex: 1,
  },
  infoRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  infoRowTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  infoRowDesc: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 1,
  },
  reviewsSection: {
    marginHorizontal: 20,
    marginTop: 20,
  },
  reviewHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    marginBottom: 12,
  },
  reviewsHeading: {
    fontSize: 16,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  writeReviewText: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.red,
  },
  emptyReviewBox: {
    backgroundColor: '#FFF',
    padding: 20,
    borderRadius: 14,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  emptyReviewText: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
  },
  reviewCard: {
    backgroundColor: '#FFF',
    padding: 14,
    borderRadius: 14,
    marginBottom: 10,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  reviewerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 8,
  },
  reviewerAvatar: {
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: THEME.colors.parchment,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.amber,
  },
  avatarTxt: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  reviewerName: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  reviewDate: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
  },
  starsRow: {
    flexDirection: 'row',
    gap: 2,
  },
  reviewComment: {
    fontSize: 13,
    color: THEME.colors.inkLight,
    lineHeight: 18,
  },
  bottomBarSticky: {
    position: 'absolute',
    bottom: 0,
    left: 0,
    right: 0,
    backgroundColor: '#FFF',
    paddingHorizontal: 20,
    paddingTop: 12,
    paddingBottom: 24,
    borderTopWidth: 1,
    borderTopColor: THEME.colors.border,
  },
  askAiStickyBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: THEME.colors.red,
    paddingVertical: 14,
    borderRadius: 14,
    gap: 8,
    elevation: 3,
    shadowColor: THEME.colors.red,
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.3,
    shadowRadius: 4,
  },
  askAiStickyBtnText: {
    color: '#FFF',
    fontSize: 15,
    fontWeight: '700',
  },
  modalOverlay: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'flex-end',
  },
  modalContent: {
    backgroundColor: '#FFF',
    borderTopLeftRadius: 24,
    borderTopRightRadius: 24,
    padding: 24,
  },
  modalHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  modalTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  modalSub: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    marginTop: 4,
  },
  ratingPickerRow: {
    flexDirection: 'row',
    justifyContent: 'center',
    gap: 12,
    marginVertical: 18,
  },
  reviewInput: {
    backgroundColor: '#F9FAFB',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    borderRadius: 14,
    padding: 14,
    fontSize: 14,
    color: THEME.colors.ink,
    textAlignVertical: 'top',
    height: 100,
    marginBottom: 20,
  },
  submitReviewBtn: {
    backgroundColor: THEME.colors.red,
    paddingVertical: 14,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
  },
  submitReviewBtnText: {
    color: '#FFF',
    fontSize: 15,
    fontWeight: '700',
  },
});
