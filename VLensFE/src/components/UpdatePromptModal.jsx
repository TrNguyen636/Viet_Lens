import React from 'react';
import { Modal, View, Text, TouchableOpacity, StyleSheet, ScrollView } from 'react-native';
import { Ionicons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../utils/theme';

/**
 * Hộp thoại thông báo khi GitHub Releases có phiên bản APK mới hơn bản đang cài
 */
export default function UpdatePromptModal({ visible, updateInfo, onUpdate, onLater }) {
  const { t } = useTranslation();
  const { theme } = useTheme();

  if (!visible || !updateInfo) return null;

  return (
    <Modal visible={visible} transparent animationType="fade" onRequestClose={onLater}>
      <View style={styles.backdrop}>
        <View
          style={[
            styles.card,
            {
              backgroundColor: theme.colors.surface || theme.colors.bg,
              borderColor: theme.colors.border,
            },
          ]}
        >
          <View style={[styles.iconBadge, { backgroundColor: theme.colors.amber + '20' }]}>
            <Ionicons name="cloud-download-outline" size={28} color={theme.colors.amber} />
          </View>

          <Text style={[styles.title, { color: theme.colors.ink }]}>
            {t('update.title')}
          </Text>

          <Text style={[styles.versionText, { color: theme.colors.inkMuted }]}>
            {t('update.versionSubtitle', {
              current: updateInfo.currentVersion,
              latest: updateInfo.latestVersion,
            })}
          </Text>

          {!!updateInfo.releaseNotes && (
            <ScrollView
              style={[styles.notesBox, { borderColor: theme.colors.border }]}
              showsVerticalScrollIndicator={false}
            >
              <Text style={[styles.notesText, { color: theme.colors.ink }]}>
                {updateInfo.releaseNotes}
              </Text>
            </ScrollView>
          )}

          <View style={styles.actionsRow}>
            <TouchableOpacity
              style={[styles.secondaryBtn, { borderColor: theme.colors.border }]}
              onPress={onLater}
              activeOpacity={0.75}
            >
              <Text style={[styles.secondaryBtnText, { color: theme.colors.inkMuted }]}>
                {t('update.later')}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[styles.primaryBtn, { backgroundColor: theme.colors.amber }]}
              onPress={onUpdate}
              activeOpacity={0.85}
            >
              <Ionicons name="download-outline" size={18} color="#FFFFFF" />
              <Text style={styles.primaryBtnText}>{t('update.updateNow')}</Text>
            </TouchableOpacity>
          </View>
        </View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  backdrop: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.55)',
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 24,
  },
  card: {
    width: '100%',
    maxWidth: 380,
    borderRadius: 20,
    padding: 22,
    borderWidth: 1,
    elevation: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 6 },
    shadowOpacity: 0.2,
    shadowRadius: 12,
  },
  iconBadge: {
    width: 54,
    height: 54,
    borderRadius: 27,
    alignItems: 'center',
    justifyContent: 'center',
    alignSelf: 'center',
    marginBottom: 14,
  },
  title: {
    fontSize: 18,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: 6,
  },
  versionText: {
    fontSize: 13,
    textAlign: 'center',
    marginBottom: 14,
  },
  notesBox: {
    maxHeight: 130,
    borderWidth: 1,
    borderRadius: 12,
    padding: 12,
    marginBottom: 16,
  },
  notesText: {
    fontSize: 13,
    lineHeight: 19,
  },
  actionsRow: {
    flexDirection: 'row',
    gap: 10,
  },
  secondaryBtn: {
    flex: 1,
    paddingVertical: 12,
    borderRadius: 12,
    borderWidth: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  secondaryBtnText: {
    fontSize: 14,
    fontWeight: '600',
  },
  primaryBtn: {
    flex: 1.3,
    paddingVertical: 12,
    borderRadius: 12,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 6,
  },
  primaryBtnText: {
    color: '#FFFFFF',
    fontSize: 14,
    fontWeight: '700',
  },
});
