import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Switch,
  Alert,
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
          onPress={() => Alert.alert('VietLens', t('profile.aboutProjectDesc'))}
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
});
