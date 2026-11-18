import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Switch,
  Alert,
  Modal,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { THEME, useTheme } from '../utils/theme';
import { changeAppLanguage } from '../locales/i18n';
import appService from '../api/appService';

const AUTOPLAY_STORAGE_KEY = '@vietlens_autoplay_audio';

export default function ProfileScreen({ user, onLogout }) {
  const { t, i18n } = useTranslation();
  const { theme, isDark, toggleTheme } = useTheme();
  const [showContactModal, setShowContactModal] = useState(false);
  const [showAboutModal, setShowAboutModal] = useState(false);
  const [savedCount, setSavedCount] = useState(0);
  const [autoPlayAudio, setAutoPlayAudio] = useState(false);

  // Khôi phục cài đặt Tự động phát Audio Guide từ AsyncStorage
  useEffect(() => {
    AsyncStorage.getItem(AUTOPLAY_STORAGE_KEY)
      .then((val) => {
        if (val !== null) {
          setAutoPlayAudio(val === 'true');
        }
      })
      .catch((err) => {
        console.warn('[ProfileScreen] Lỗi đọc autoplay setting:', err.message);
      });
  }, []);

  const handleToggleAutoPlay = async (value) => {
    setAutoPlayAudio(value);
    await AsyncStorage.setItem(AUTOPLAY_STORAGE_KEY, value ? 'true' : 'false').catch(() => {});
  };

  // Tải số lượng di sản đã lưu từ backend
  useEffect(() => {
    let isMounted = true;
    const fetchBookmarkCount = async () => {
      try {
        const bookmarks = await appService.getUserBookmarks();
        if (isMounted && Array.isArray(bookmarks)) {
          setSavedCount(bookmarks.length);
        }
      } catch (err) {
        console.log('[ProfileScreen] Chưa lấy được số bookmark:', err.message);
      }
    };
    fetchBookmarkCount();
    return () => {
      isMounted = false;
    };
  }, []);

  return (
    <ScrollView
      style={[styles.container, { backgroundColor: theme.colors.bg }]}
      showsVerticalScrollIndicator={false}
    >
      {/* Profile Header */}
      <View style={styles.header}>
        <View style={[styles.avatarCircle, { backgroundColor: theme.colors.amber, borderColor: theme.colors.card }]}>
          <Text style={styles.avatarInitial}>
            {(user?.fullName || user?.name || 'V')[0].toUpperCase()}
          </Text>
        </View>
        <Text style={[styles.userName, { color: theme.colors.ink }]}>
          {user?.fullName || user?.name || t('profile.defaultUserName')}
        </Text>
        <Text style={[styles.userEmail, { color: theme.colors.inkMuted }]}>
          {user?.email || t('profile.noEmail')}
        </Text>
        <View style={[styles.rankBadge, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
          <MaterialCommunityIcons name="seal" size={14} color={theme.colors.amber} />
          <Text style={[styles.rankBadgeText, { color: theme.colors.ink }]}>
            {user?.role || t('profile.defaultRole')}
          </Text>
        </View>
      </View>

      {/* Stats Counter Row: Chỉ hiển thị Di sản đã lưu thật */}
      <View style={[styles.statsCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
        <View style={styles.statCol}>
          <Ionicons name="bookmark" size={26} color={theme.colors.red} style={{ marginBottom: 4 }} />
          <Text style={[styles.statNumber, { color: theme.colors.amber }]}>{savedCount}</Text>
          <Text style={[styles.statLabel, { color: theme.colors.inkMuted }]}>{t('profile.savedCountLabel')}</Text>
        </View>
      </View>

      {/* Settings Section */}
      <View style={[styles.section, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
        <Text style={[styles.sectionHeader, { color: theme.colors.inkLight }]}>{t('profile.appSettingsHeader')}</Text>

        {/* Language */}
        <TouchableOpacity
          style={[styles.settingRow, { borderBottomColor: theme.colors.border }]}
          onPress={async () => {
            const nextLang = i18n.language === 'vi' ? 'en' : (i18n.language === 'en' ? 'ja' : 'vi');
            await changeAppLanguage(nextLang);
          }}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="language" size={20} color={theme.colors.amber} />
            <Text style={[styles.settingLabel, { color: theme.colors.ink }]}>{t('profile.language')}</Text>
          </View>
          <Text style={[styles.settingValue, { color: theme.colors.amber }]}>
            {i18n.language === 'ja' ? '🇯🇵 日本語' : (i18n.language === 'en' ? '🇬🇧 English' : '🇻🇳 Tiếng Việt')}
          </Text>
        </TouchableOpacity>

        {/* Dark Mode */}
        <View style={[styles.settingRow, { borderBottomColor: theme.colors.border }]}>
          <View style={styles.settingLeft}>
            <Ionicons name="moon-outline" size={20} color={theme.colors.amber} />
            <Text style={[styles.settingLabel, { color: theme.colors.ink }]}>{t('profile.darkMode')}</Text>
          </View>
          <Switch
            value={isDark}
            onValueChange={toggleTheme}
            trackColor={{ false: theme.colors.border, true: theme.colors.amber }}
            thumbColor="#FFF"
          />
        </View>

        {/* Audio auto-play */}
        <View style={[styles.settingRow, { borderBottomColor: theme.colors.border }]}>
          <View style={styles.settingLeft}>
            <Ionicons name="volume-high-outline" size={20} color={theme.colors.amber} />
            <Text style={[styles.settingLabel, { color: theme.colors.ink }]}>{t('profile.autoPlayAudio')}</Text>
          </View>
          <Switch
            value={autoPlayAudio}
            onValueChange={handleToggleAutoPlay}
            trackColor={{ false: theme.colors.border, true: theme.colors.amber }}
            thumbColor="#FFF"
          />
        </View>
      </View>

      {/* Support & About */}
      <View style={[styles.section, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
        <Text style={[styles.sectionHeader, { color: theme.colors.inkLight }]}>{t('profile.supportHeader')}</Text>

        <TouchableOpacity
          style={[styles.settingRow, { borderBottomColor: theme.colors.border }]}
          onPress={() => setShowAboutModal(true)}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="information-circle-outline" size={20} color={theme.colors.inkMuted} />
            <Text style={[styles.settingLabel, { color: theme.colors.ink }]}>{t('profile.aboutProject')}</Text>
          </View>
          <Ionicons name="chevron-forward" size={16} color={theme.colors.inkLight} />
        </TouchableOpacity>

        <TouchableOpacity
          style={[styles.settingRow, { borderBottomColor: theme.colors.border }]}
          onPress={() => setShowContactModal(true)}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="help-buoy-outline" size={20} color={theme.colors.amber} />
            <Text style={[styles.settingLabel, { color: theme.colors.ink }]}>{t('profile.contactFeedback')}</Text>
          </View>
          <Ionicons name="chevron-forward" size={16} color={theme.colors.inkLight} />
        </TouchableOpacity>

        {/* Logout */}
        <TouchableOpacity
          style={[styles.settingRow, { borderBottomWidth: 0 }]}
          onPress={() => {
            Alert.alert(
              t('profile.logoutConfirmTitle'),
              t('profile.logoutConfirmMsg'),
              [
                { text: t('common.cancel'), style: 'cancel' },
                {
                  text: t('profile.logoutBtn'),
                  style: 'destructive',
                  onPress: onLogout,
                },
              ]
            );
          }}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="log-out-outline" size={20} color={theme.colors.red} />
            <Text style={[styles.settingLabel, { color: theme.colors.red }]}>{t('profile.logoutBtn')}</Text>
          </View>
        </TouchableOpacity>
      </View>

      {/* Interactive Contact & Feedback Modal */}
      {showContactModal && (
        <View style={styles.modalBackdrop}>
          <View style={[styles.contactModalCard, { backgroundColor: theme.colors.card }]}>
            <View style={styles.modalHeaderRow}>
              <Text style={[styles.modalTitle, { color: theme.colors.ink }]}>{t('profile.contactModalTitle')}</Text>
              <TouchableOpacity onPress={() => setShowContactModal(false)}>
                <Ionicons name="close" size={22} color={theme.colors.inkMuted} />
              </TouchableOpacity>
            </View>
            <Text style={[styles.modalDesc, { color: theme.colors.inkMuted }]}>
              {t('profile.contactModalDesc')}
            </Text>

            <View style={[styles.contactInfoBox, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
              <View style={styles.contactRow}>
                <Ionicons name="call-outline" size={18} color={theme.colors.amber} />
                <Text style={[styles.contactRowText, { color: theme.colors.ink }]}>{t('profile.hotline')}</Text>
              </View>
              <View style={styles.contactRow}>
                <Ionicons name="mail-outline" size={18} color={theme.colors.red} />
                <Text style={[styles.contactRowText, { color: theme.colors.ink }]}>Email: contact@vietlens.vn</Text>
              </View>
              <View style={styles.contactRow}>
                <Ionicons name="location-outline" size={18} color={theme.colors.green} />
                <Text style={[styles.contactRowText, { color: theme.colors.ink }]}>{t('profile.office')}</Text>
              </View>
            </View>

            <TouchableOpacity
              style={[styles.sendFeedbackBtn, { backgroundColor: theme.colors.amber }]}
              onPress={() => {
                setShowContactModal(false);
                Alert.alert(t('profile.feedbackSuccessTitle'), t('profile.feedbackSuccessMsg'));
              }}
            >
              <Text style={styles.sendFeedbackBtnText}>{t('profile.sendFeedbackBtn')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      <Text style={[styles.versionFooter, { color: theme.colors.inkLight }]}>{t('profile.version')}</Text>
      <View style={{ height: 100 }} />

      {/* About VietLens Project Modal */}
      <Modal
        visible={showAboutModal}
        transparent
        animationType="fade"
        onRequestClose={() => setShowAboutModal(false)}
      >
        <View style={[styles.aboutBackdrop, { backgroundColor: theme.colors.overlay }]}>
          <View style={[styles.aboutModalCard, { backgroundColor: theme.colors.card, borderColor: theme.colors.border }]}>
            <View style={[styles.aboutHeader, { borderBottomColor: theme.colors.border }]}>
              <View style={styles.aboutBrandRow}>
                <View style={[styles.aboutLogoBadge, { backgroundColor: theme.colors.red }]}>
                  <MaterialCommunityIcons name="temple-buddhist" size={20} color="#FFF" />
                </View>
                <View style={{ flex: 1 }}>
                  <View style={{ flexDirection: 'row', alignItems: 'center', gap: 8 }}>
                    <Text style={[styles.aboutTitle, { color: theme.colors.ink }]}>VietLens</Text>
                    <View style={[styles.aboutVersionPill, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
                      <Text style={[styles.aboutVersionText, { color: theme.colors.amber }]}>v1.0.0</Text>
                    </View>
                  </View>
                  <Text style={[styles.aboutSubtitle, { color: theme.colors.inkMuted }]} numberOfLines={2}>
                    {t('profile.aboutModalSubtitle')}
                  </Text>
                </View>
              </View>
              <TouchableOpacity onPress={() => setShowAboutModal(false)} hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}>
                <Ionicons name="close" size={22} color={theme.colors.inkMuted} />
              </TouchableOpacity>
            </View>

            <ScrollView style={styles.aboutScroll} showsVerticalScrollIndicator={false}>
              {/* 1. Mission & Purpose */}
              <View style={[styles.aboutBlock, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
                <View style={styles.aboutBlockHeader}>
                  <Ionicons name="compass-outline" size={18} color={theme.colors.red} />
                  <Text style={[styles.aboutBlockTitle, { color: theme.colors.ink }]}>
                    {t('profile.aboutPurposeTitle')}
                  </Text>
                </View>
                <Text style={[styles.aboutBlockBody, { color: theme.colors.inkMuted }]}>
                  {t('profile.aboutPurposeBody')}
                </Text>
              </View>

              {/* 2. Core Goals */}
              <View style={[styles.aboutBlock, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border }]}>
                <View style={styles.aboutBlockHeader}>
                  <Ionicons name="flag-outline" size={18} color={theme.colors.amber} />
                  <Text style={[styles.aboutBlockTitle, { color: theme.colors.ink }]}>
                    {t('profile.aboutGoalsTitle')}
                  </Text>
                </View>

                {[
                  { icon: 'camera-outline', title: t('profile.aboutGoal1Title'), desc: t('profile.aboutGoal1Desc') },
                  { icon: 'map-outline', title: t('profile.aboutGoal2Title'), desc: t('profile.aboutGoal2Desc') },
                  { icon: 'chatbubbles-outline', title: t('profile.aboutGoal3Title'), desc: t('profile.aboutGoal3Desc') },
                ].map((goal, idx) => (
                  <View key={idx} style={styles.aboutGoalRow}>
                    <View style={[styles.aboutGoalIcon, { backgroundColor: theme.colors.card }]}>
                      <Ionicons name={goal.icon} size={15} color={theme.colors.amber} />
                    </View>
                    <View style={{ flex: 1 }}>
                      <Text style={[styles.aboutGoalTitle, { color: theme.colors.ink }]}>{goal.title}</Text>
                      <Text style={[styles.aboutGoalDesc, { color: theme.colors.inkMuted }]}>{goal.desc}</Text>
                    </View>
                  </View>
                ))}
              </View>

              {/* 3. Impact & Vision */}
              <View style={[styles.aboutBlock, { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border, marginBottom: 4 }]}>
                <View style={styles.aboutBlockHeader}>
                  <Ionicons name="sparkles-outline" size={18} color={theme.colors.green} />
                  <Text style={[styles.aboutBlockTitle, { color: theme.colors.ink }]}>
                    {t('profile.aboutImpactTitle')}
                  </Text>
                </View>
                <Text style={[styles.aboutBlockBody, { color: theme.colors.inkMuted }]}>
                  {t('profile.aboutImpactBody')}
                </Text>
              </View>
            </ScrollView>

            <TouchableOpacity
              style={[styles.aboutCloseBtn, { backgroundColor: theme.colors.red }]}
              onPress={() => setShowAboutModal(false)}
              activeOpacity={0.85}
            >
              <Text style={styles.aboutCloseBtnText}>{t('profile.aboutCloseBtn')}</Text>
            </TouchableOpacity>
          </View>
        </View>
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
    alignItems: 'center',
    paddingTop: 50,
    paddingBottom: 20,
  },
  avatarCircle: {
    width: 80,
    height: 80,
    borderRadius: 40,
    backgroundColor: THEME.colors.amber,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 4,
    borderWidth: 3,
    borderColor: '#FFF',
  },
  avatarInitial: {
    fontSize: 32,
    fontWeight: '700',
    color: '#FFF',
  },
  userName: {
    fontSize: 20,
    fontWeight: '700',
    color: THEME.colors.ink,
    marginTop: 10,
  },
  userEmail: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 2,
  },
  rankBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: THEME.colors.parchment,
    paddingHorizontal: 12,
    paddingVertical: 5,
    borderRadius: 14,
    gap: 6,
    marginTop: 10,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  rankBadgeText: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  statsCard: {
    backgroundColor: '#FFF',
    marginHorizontal: 20,
    borderRadius: 16,
    paddingVertical: 18,
    paddingHorizontal: 20,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 2,
  },
  statCol: {
    alignItems: 'center',
    justifyContent: 'center',
  },
  statNumber: {
    fontSize: 26,
    fontWeight: '800',
    color: THEME.colors.amber,
  },
  statLabel: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 4,
    fontWeight: '500',
  },
  section: {
    backgroundColor: '#FFF',
    marginHorizontal: 20,
    marginTop: 20,
    borderRadius: 16,
    paddingVertical: 8,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  sectionHeader: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.inkLight,
    paddingHorizontal: 16,
    paddingTop: 8,
    paddingBottom: 4,
    letterSpacing: 0.5,
  },
  settingRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderBottomWidth: 1,
    borderColor: '#F3F4F6',
  },
  settingLeft: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 12,
  },
  settingLabel: {
    fontSize: 13,
    fontWeight: '600',
    color: THEME.colors.ink,
  },
  settingValue: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  versionFooter: {
    textAlign: 'center',
    fontSize: 11,
    color: THEME.colors.inkLight,
    marginTop: 24,
  },
  modalBackdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
    zIndex: 999,
  },
  contactModalCard: {
    width: '100%',
    backgroundColor: '#FFF',
    borderRadius: 20,
    padding: 20,
    elevation: 8,
  },
  modalHeaderRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  modalTitle: {
    fontSize: 16,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  modalDesc: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 6,
    lineHeight: 18,
  },
  contactInfoBox: {
    backgroundColor: THEME.colors.parchment,
    borderRadius: 14,
    padding: 12,
    marginTop: 14,
    gap: 10,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  contactRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  contactRowText: {
    fontSize: 12,
    color: THEME.colors.ink,
    fontWeight: '600',
  },
  sendFeedbackBtn: {
    backgroundColor: THEME.colors.amber,
    borderRadius: 14,
    paddingVertical: 12,
    alignItems: 'center',
    marginTop: 16,
  },
  sendFeedbackBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
  aboutBackdrop: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 18,
  },
  aboutModalCard: {
    width: '100%',
    maxHeight: '82%',
    borderRadius: 20,
    borderWidth: 1,
    padding: 16,
    elevation: 10,
  },
  aboutHeader: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    justifyContent: 'space-between',
    paddingBottom: 12,
    borderBottomWidth: 1,
    gap: 10,
  },
  aboutBrandRow: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
  },
  aboutLogoBadge: {
    width: 40,
    height: 40,
    borderRadius: 12,
    alignItems: 'center',
    justifyContent: 'center',
  },
  aboutTitle: {
    fontSize: 18,
    fontWeight: '800',
  },
  aboutVersionPill: {
    paddingHorizontal: 8,
    paddingVertical: 2,
    borderRadius: 10,
    borderWidth: 1,
  },
  aboutVersionText: {
    fontSize: 10,
    fontWeight: '700',
  },
  aboutSubtitle: {
    fontSize: 12,
    marginTop: 2,
    lineHeight: 16,
  },
  aboutScroll: {
    marginTop: 12,
    marginBottom: 12,
  },
  aboutBlock: {
    borderRadius: 14,
    borderWidth: 1,
    padding: 12,
    marginBottom: 10,
  },
  aboutBlockHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    marginBottom: 6,
  },
  aboutBlockTitle: {
    fontSize: 14,
    fontWeight: '700',
  },
  aboutBlockBody: {
    fontSize: 12.5,
    lineHeight: 19,
  },
  aboutGoalRow: {
    flexDirection: 'row',
    alignItems: 'flex-start',
    gap: 10,
    marginTop: 8,
  },
  aboutGoalIcon: {
    width: 28,
    height: 28,
    borderRadius: 8,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 2,
  },
  aboutGoalTitle: {
    fontSize: 12.5,
    fontWeight: '700',
  },
  aboutGoalDesc: {
    fontSize: 12,
    lineHeight: 17,
    marginTop: 2,
  },
  aboutCloseBtn: {
    borderRadius: 12,
    paddingVertical: 12,
    alignItems: 'center',
  },
  aboutCloseBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
});
