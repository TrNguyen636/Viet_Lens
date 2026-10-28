import React, { useState } from 'react';
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
import { THEME } from '../utils/theme';
import { changeAppLanguage } from '../locales/i18n';
import appService from '../api/appService';

export default function ProfileScreen({ user, onLogout }) {
  const { t, i18n } = useTranslation();
  const [isDarkMode, setIsDarkMode] = useState(false);
  const [showContactModal, setShowContactModal] = useState(false);
  const [savedCount, setSavedCount] = useState(0);

  // Tải số lượng di sản đã lưu từ backend
  React.useEffect(() => {
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
    <ScrollView style={styles.container} showsVerticalScrollIndicator={false}>
      {/* Profile Header */}
      <View style={styles.header}>
        <View style={styles.avatarCircle}>
          <Text style={styles.avatarInitial}>
            {(user?.fullName || user?.name || 'V')[0].toUpperCase()}
          </Text>
        </View>
        <Text style={styles.userName}>{user?.fullName || user?.name || 'Người dùng VietLens'}</Text>
        <Text style={styles.userEmail}>{user?.email || 'Chưa liên kết email'}</Text>
        <View style={styles.rankBadge}>
          <MaterialCommunityIcons name="seal" size={14} color={THEME.colors.amber} />
          <Text style={styles.rankBadgeText}>
            {user?.role || 'Nhà Thám Hiểm Văn Hóa'}
          </Text>
        </View>
      </View>

      {/* Stats Counter Row */}
      <View style={styles.statsCard}>
        <View style={styles.statCol}>
          <Text style={styles.statNumber}>{savedCount}</Text>
          <Text style={styles.statLabel}>Di sản đã lưu</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statCol}>
          <Text style={styles.statNumber}>{savedCount > 0 ? 3 : 1}</Text>
          <Text style={styles.statLabel}>Huy hiệu Tem</Text>
        </View>
        <View style={styles.statDivider} />
        <View style={styles.statCol}>
          <Text style={styles.statNumber}>{savedCount * 100 + 500}</Text>
          <Text style={styles.statLabel}>Điểm văn hóa</Text>
        </View>
      </View>

      {/* Settings Section */}
      <View style={styles.section}>
        <Text style={styles.sectionHeader}>CÀI ĐẶT ỨNG DỤNG</Text>

        {/* Language */}
        <TouchableOpacity
          style={styles.settingRow}
          onPress={async () => {
            const nextLang = i18n.language === 'vi' ? 'en' : 'vi';
            await changeAppLanguage(nextLang);
          }}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="language" size={20} color={THEME.colors.amber} />
            <Text style={styles.settingLabel}>{t('profile.language')}</Text>
          </View>
          <Text style={styles.settingValue}>
            {i18n.language === 'en' ? '🇬🇧 English' : '🇻🇳 Tiếng Việt'}
          </Text>
        </TouchableOpacity>

        {/* Dark Mode */}
        <View style={styles.settingRow}>
          <View style={styles.settingLeft}>
            <Ionicons name="moon-outline" size={20} color={THEME.colors.amber} />
            <Text style={styles.settingLabel}>Giao diện Tối (Dark Mode)</Text>
          </View>
          <Switch
            value={isDarkMode}
            onValueChange={setIsDarkMode}
            trackColor={{ false: THEME.colors.border, true: THEME.colors.amber }}
            thumbColor="#FFF"
          />
        </View>

        {/* Audio auto-play */}
        <View style={styles.settingRow}>
          <View style={styles.settingLeft}>
            <Ionicons name="volume-high-outline" size={20} color={THEME.colors.amber} />
            <Text style={styles.settingLabel}>Tự động phát Audio Guide khi quét</Text>
          </View>
          <Switch
            value={true}
            trackColor={{ false: THEME.colors.border, true: THEME.colors.amber }}
            thumbColor="#FFF"
          />
        </View>
      </View>

      {/* Support & About */}
      <View style={styles.section}>
        <Text style={styles.sectionHeader}>THÔNG TIN & HỖ TRỢ</Text>

        <TouchableOpacity style={styles.settingRow} onPress={() => Alert.alert('VietLens', 'Dự án Bảo tồn Di sản Văn hóa Việt Nam')}>
          <View style={styles.settingLeft}>
            <Ionicons name="information-circle-outline" size={20} color={THEME.colors.inkMuted} />
            <Text style={styles.settingLabel}>Về dự án VietLens</Text>
          </View>
          <Ionicons name="chevron-forward" size={16} color={THEME.colors.inkLight} />
        </TouchableOpacity>

        <TouchableOpacity style={styles.settingRow} onPress={() => setShowContactModal(true)}>
          <View style={styles.settingLeft}>
            <Ionicons name="help-buoy-outline" size={20} color={THEME.colors.amber} />
            <Text style={styles.settingLabel}>Liên hệ hỗ trợ & Góp ý di sản</Text>
          </View>
          <Ionicons name="chevron-forward" size={16} color={THEME.colors.inkLight} />
        </TouchableOpacity>

        {/* Logout */}
        <TouchableOpacity
          style={[styles.settingRow, { borderBottomWidth: 0 }]}
          onPress={() => {
            Alert.alert(
              'Xác nhận đăng xuất',
              'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản VietLens?',
              [
                { text: 'Hủy', style: 'cancel' },
                {
                  text: 'Đăng xuất',
                  style: 'destructive',
                  onPress: onLogout,
                },
              ]
            );
          }}
        >
          <View style={styles.settingLeft}>
            <Ionicons name="log-out-outline" size={20} color={THEME.colors.red} />
            <Text style={[styles.settingLabel, { color: THEME.colors.red }]}>Đăng xuất tài khoản</Text>
          </View>
        </TouchableOpacity>
      </View>

      {/* Interactive Contact & Feedback Modal */}
      {showContactModal && (
        <View style={styles.modalBackdrop}>
          <View style={styles.contactModalCard}>
            <View style={styles.modalHeaderRow}>
              <Text style={styles.modalTitle}>Liên hệ Ban Quản Trị VietLens</Text>
              <TouchableOpacity onPress={() => setShowContactModal(false)}>
                <Ionicons name="close" size={22} color={THEME.colors.inkMuted} />
              </TouchableOpacity>
            </View>
            <Text style={styles.modalDesc}>
              Đội ngũ nghiên cứu văn hóa luôn sẵn sàng lắng nghe mọi phản hồi và đóng góp tư liệu di sản.
            </Text>

            <View style={styles.contactInfoBox}>
              <View style={styles.contactRow}>
                <Ionicons name="call-outline" size={18} color={THEME.colors.amber} />
                <Text style={styles.contactRowText}>Hotline: 1900 8866 (08:00 - 20:00)</Text>
              </View>
              <View style={styles.contactRow}>
                <Ionicons name="mail-outline" size={18} color={THEME.colors.red} />
                <Text style={styles.contactRowText}>Email: contact@vietlens.vn</Text>
              </View>
              <View style={styles.contactRow}>
                <Ionicons name="location-outline" size={18} color={THEME.colors.green} />
                <Text style={styles.contactRowText}>Văn phòng: Trung tâm Bảo tồn Di sản, Hà Nội</Text>
              </View>
            </View>

            <TouchableOpacity
              style={styles.sendFeedbackBtn}
              onPress={() => {
                setShowContactModal(false);
                Alert.alert('Thành công', 'Cảm ơn bạn! Lời nhắn đóng góp di sản đã được gửi đến ban quản trị.');
              }}
            >
              <Text style={styles.sendFeedbackBtnText}>Gửi Tin Nhắn Nhanh</Text>
            </TouchableOpacity>
          </View>
        </View>
      )}

      <Text style={styles.versionFooter}>VietLens Phiên bản 1.0.0 (Expo React Native)</Text>
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
    flexDirection: 'row',
    backgroundColor: '#FFF',
    marginHorizontal: 20,
    borderRadius: 16,
    paddingVertical: 16,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    elevation: 2,
  },
  statCol: {
    flex: 1,
    alignItems: 'center',
  },
  statNumber: {
    fontSize: 18,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  statLabel: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
    marginTop: 2,
  },
  statDivider: {
    width: 1,
    backgroundColor: THEME.colors.border,
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

