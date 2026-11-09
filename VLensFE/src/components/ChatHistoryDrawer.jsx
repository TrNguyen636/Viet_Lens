import React, { useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  ScrollView,
  Animated,
  Dimensions,
  TouchableWithoutFeedback,
  Platform,
  Modal,
  ActivityIndicator,
  Alert,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import { useTheme } from '../utils/theme';

const { width } = Dimensions.get('window');
const DRAWER_WIDTH = Math.min(width * 0.82, 330);

export default function ChatHistoryDrawer({
  visible = false,
  onClose,
  sessions = [],
  currentSessionId = null,
  onSelectSession,
  onNewChat,
  onDeleteSession,
  isLoading = false,
}) {
  const { t } = useTranslation();
  const { theme, isDark } = useTheme();
  const slideAnim = useRef(new Animated.Value(0)).current;
  const [renderDrawer, setRenderDrawer] = React.useState(visible);

  useEffect(() => {
    if (visible) {
      setRenderDrawer(true);
      Animated.timing(slideAnim, {
        toValue: 1,
        duration: 260,
        useNativeDriver: true,
      }).start();
    } else {
      Animated.timing(slideAnim, {
        toValue: 0,
        duration: 220,
        useNativeDriver: true,
      }).start(({ finished }) => {
        if (finished) {
          setRenderDrawer(false);
        }
      });
    }
  }, [visible]);

  if (!renderDrawer) return null;

  const translateX = slideAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [-DRAWER_WIDTH, 0],
  });

  const backdropOpacity = slideAnim.interpolate({
    inputRange: [0, 1],
    outputRange: [0, 0.6],
  });

  return (
    <Modal
      visible={renderDrawer}
      transparent={true}
      animationType="none"
      onRequestClose={onClose}
      statusBarTranslucent={true}
    >
      <View style={styles.modalRoot}>
        {/* 1. Lớp phủ nền mờ toàn màn hình (Full Screen Backdrop) */}
        <TouchableWithoutFeedback onPress={onClose}>
          <Animated.View
            style={[
              styles.backdrop,
              {
                opacity: backdropOpacity,
              },
            ]}
          />
        </TouchableWithoutFeedback>

        {/* 2. Thanh Slide Bar trượt từ cạnh trái chiếm toàn bộ chiều cao (100% height) */}
        <Animated.View
          style={[
            styles.drawerContainer,
            {
              width: DRAWER_WIDTH,
              backgroundColor: theme.colors.card,
              borderRightColor: theme.colors.border,
              transform: [{ translateX }],
            },
          ]}
        >
          {/* Header Slide Bar */}
          <View style={[styles.header, { borderBottomColor: theme.colors.border }]}>
            <View style={styles.headerTitleRow}>
              <Ionicons name="time-outline" size={20} color={theme.colors.amber} />
              <Text style={[styles.headerTitle, { color: theme.colors.ink }]}>
                {t('chat.historyTitle', 'Lịch sử trò chuyện')}
              </Text>
            </View>
            <TouchableOpacity
              style={[
                styles.closeBtn,
                { backgroundColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)' },
              ]}
              onPress={onClose}
              activeOpacity={0.7}
              hitSlop={{ top: 12, bottom: 12, left: 12, right: 12 }}
            >
              <Ionicons name="close" size={20} color={theme.colors.inkMuted} />
            </TouchableOpacity>
          </View>

          {/* Nút Cuộc trò chuyện mới (+ New Chat) */}
          <View style={styles.actionSection}>
            <TouchableOpacity
              style={[
                styles.newChatBtn,
                {
                  backgroundColor: isDark ? '#2A241E' : '#FFF8EE',
                  borderColor: theme.colors.amber,
                },
              ]}
              onPress={() => {
                if (onNewChat) onNewChat();
                if (onClose) onClose();
              }}
              activeOpacity={0.8}
            >
              <Ionicons name="add-circle" size={20} color={theme.colors.amber} />
              <Text style={[styles.newChatText, { color: theme.colors.amber }]}>
                {t('chat.newChat', 'Cuộc trò chuyện mới')}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Phần nội dung: Đang tải / Danh sách hoặc Màn hình trống */}
          {isLoading ? (
            <View style={styles.emptyContainer}>
              <ActivityIndicator size="large" color={theme.colors.amber} />
              <Text style={[styles.emptySubtitle, { color: theme.colors.inkMuted, marginTop: 14 }]}>
                {t('chat.loadingHistory', 'Đang tải lịch sử trò chuyện...')}
              </Text>
            </View>
          ) : sessions.length === 0 ? (
            <View style={styles.emptyContainer}>
              <View style={[styles.emptyIconCircle, { backgroundColor: isDark ? '#26221D' : '#F5EFE6' }]}>
                <Ionicons name="chatbubbles-outline" size={38} color={theme.colors.amber} />
              </View>

              <Text style={[styles.emptyTitle, { color: theme.colors.ink }]}>
                {t('chat.emptyHistoryTitle', 'Chưa có lịch sử trò chuyện')}
              </Text>

              <Text style={[styles.emptySubtitle, { color: theme.colors.inkMuted }]}>
                {t(
                  'chat.emptyHistoryDesc',
                  'Các cuộc đàm đạo và nhận diện di tích của bạn sẽ được lưu giữ tại đây.'
                )}
              </Text>

              {/* Thông báo trạng thái kết nối / mạng */}
              <View
                style={[
                  styles.connectionNoticeBox,
                  {
                    backgroundColor: isDark ? '#1C1917' : '#F9FAFB',
                    borderColor: theme.colors.border,
                  },
                ]}
              >
                <Ionicons name="information-circle-outline" size={17} color={theme.colors.inkLight} />
                <Text style={[styles.connectionNoticeText, { color: theme.colors.inkLight }]}>
                  {t(
                    'chat.syncNotice',
                    'Không có lịch sử chat hoặc không thể tải dữ liệu khi mất kết nối.'
                  )}
                </Text>
              </View>

              {/* Nút Bắt đầu cuộc trò chuyện mới */}
              <TouchableOpacity
                style={[styles.emptyActionBtn, { backgroundColor: theme.colors.red }]}
                onPress={() => {
                  if (onNewChat) onNewChat();
                  if (onClose) onClose();
                }}
                activeOpacity={0.85}
              >
                <Ionicons name="sparkles" size={16} color="#FFF" />
                <Text style={styles.emptyActionText}>
                  {t('chat.startNewChat', 'Bắt đầu cuộc trò chuyện mới')}
                </Text>
              </TouchableOpacity>
            </View>
          ) : (
            <ScrollView
              style={styles.sessionList}
              contentContainerStyle={styles.sessionListContent}
              showsVerticalScrollIndicator={false}
            >
              {sessions.map((session) => {
                const isActive = session.id === currentSessionId;
                const hasPhoto = Boolean(session.hasPhoto);

                return (
                  <TouchableOpacity
                    key={session.id}
                    style={[
                      styles.sessionItem,
                      {
                        backgroundColor: isActive
                          ? isDark
                            ? '#2C2214'
                            : '#FEF3C7'
                          : isDark
                          ? '#221F1C'
                          : '#F9FAFB',
                        borderColor: isActive ? theme.colors.amber : theme.colors.border,
                      },
                    ]}
                    onPress={() => {
                      if (onSelectSession) onSelectSession(session);
                      if (onClose) onClose();
                    }}
                    activeOpacity={0.75}
                  >
                    <View style={styles.sessionIconBox}>
                      {hasPhoto ? (
                        <Ionicons name="camera" size={17} color={theme.colors.red} />
                      ) : session.siteName ? (
                        <Ionicons name="sparkles" size={16} color={theme.colors.amber} />
                      ) : (
                        <Ionicons
                          name="chatbubble-ellipses-outline"
                          size={16}
                          color={theme.colors.inkMuted}
                        />
                      )}
                    </View>

                    <View style={styles.sessionInfo}>
                      <View style={styles.sessionTopRow}>
                        <Text
                          style={[
                            styles.sessionTitle,
                            {
                              color: theme.colors.ink,
                              fontWeight: isActive ? '700' : '600',
                            },
                          ]}
                          numberOfLines={1}
                        >
                          {session.title || 'Cuộc trò chuyện'}
                        </Text>
                      </View>

                      <Text
                        style={[styles.sessionPreview, { color: theme.colors.inkMuted }]}
                        numberOfLines={1}
                      >
                        {session.lastMessage || 'Bắt đầu đàm đạo di sản...'}
                      </Text>

                      <View style={styles.sessionMetaRow}>
                        <Text style={[styles.sessionDate, { color: theme.colors.inkLight }]}>
                          {session.updatedAt || session.date || 'Gần đây'}
                        </Text>
                        {session.siteName && (
                          <View
                            style={[
                              styles.siteBadge,
                              { backgroundColor: isDark ? '#3D311F' : '#FEF3C7' },
                            ]}
                          >
                            <Text
                              style={[
                                styles.siteBadgeText,
                                { color: isDark ? '#FBBF24' : '#92400E' },
                              ]}
                              numberOfLines={1}
                            >
                              {session.siteName}
                            </Text>
                          </View>
                        )}
                      </View>
                    </View>

                    {/* Nút Xóa phiên */}
                    {onDeleteSession && (
                      <TouchableOpacity
                        style={styles.deleteBtn}
                        onPress={() => {
                          Alert.alert(
                            t('chat.confirmDeleteTitle', 'Xác nhận xóa'),
                            t(
                              'chat.confirmDeleteDesc',
                              'Bạn có chắc chắn muốn xóa cuộc trò chuyện này không?'
                            ),
                            [
                              {
                                text: t('common.cancel', 'Hủy'),
                                style: 'cancel',
                              },
                              {
                                text: t('common.delete', 'Xóa'),
                                style: 'destructive',
                                onPress: () => onDeleteSession(session.id),
                              },
                            ]
                          );
                        }}
                        hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
                      >
                        <Ionicons name="trash-outline" size={16} color={theme.colors.inkLight} />
                      </TouchableOpacity>
                    )}
                  </TouchableOpacity>
                );
              })}
            </ScrollView>
          )}

          {/* Footer Slide Bar */}
          <View style={[styles.footer, { borderTopColor: theme.colors.border }]}>
            <View style={styles.footerBrandRow}>
              <MaterialCommunityIcons name="robot" size={16} color={theme.colors.amber} />
              <Text style={[styles.footerBrandText, { color: theme.colors.inkMuted }]}>
                VietLens AI • Heritage History
              </Text>
            </View>
          </View>
        </Animated.View>
      </View>
    </Modal>
  );
}

const styles = StyleSheet.create({
  modalRoot: {
    flex: 1,
    position: 'relative',
    backgroundColor: 'transparent',
  },
  backdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: '#000',
    zIndex: 1,
  },
  drawerContainer: {
    position: 'absolute',
    top: 0,
    bottom: 0,
    left: 0,
    height: '100%',
    zIndex: 2,
    borderRightWidth: 1,
    paddingTop: Platform.OS === 'ios' ? 52 : 36,
    shadowColor: '#000',
    shadowOffset: { width: 4, height: 0 },
    shadowOpacity: 0.25,
    shadowRadius: 14,
    elevation: 24,
  },
  header: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
    paddingHorizontal: 16,
    paddingBottom: 14,
    borderBottomWidth: 1,
  },
  headerTitleRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  headerTitle: {
    fontSize: 16,
    fontWeight: '700',
  },
  closeBtn: {
    width: 32,
    height: 32,
    borderRadius: 16,
    alignItems: 'center',
    justifyContent: 'center',
  },
  actionSection: {
    paddingHorizontal: 14,
    paddingVertical: 12,
  },
  newChatBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    gap: 8,
    paddingVertical: 10,
    borderRadius: 12,
    borderWidth: 1.5,
  },
  newChatText: {
    fontSize: 14,
    fontWeight: '700',
  },
  sessionList: {
    flex: 1,
  },
  sessionListContent: {
    paddingHorizontal: 14,
    paddingBottom: 20,
  },
  emptyContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 22,
    paddingBottom: 40,
  },
  emptyIconCircle: {
    width: 72,
    height: 72,
    borderRadius: 36,
    alignItems: 'center',
    justifyContent: 'center',
    marginBottom: 16,
  },
  emptyTitle: {
    fontSize: 16,
    fontWeight: '700',
    textAlign: 'center',
    marginBottom: 8,
  },
  emptySubtitle: {
    fontSize: 12,
    lineHeight: 18,
    textAlign: 'center',
    marginBottom: 18,
  },
  connectionNoticeBox: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 12,
    paddingVertical: 9,
    borderRadius: 10,
    borderWidth: 1,
    marginBottom: 20,
  },
  connectionNoticeText: {
    fontSize: 11,
    lineHeight: 16,
    flex: 1,
  },
  emptyActionBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
    paddingHorizontal: 16,
    paddingVertical: 10,
    borderRadius: 20,
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.15,
    shadowRadius: 4,
  },
  emptyActionText: {
    color: '#FFF',
    fontSize: 13,
    fontWeight: '700',
  },
  sessionItem: {
    flexDirection: 'row',
    alignItems: 'center',
    padding: 11,
    borderRadius: 12,
    marginBottom: 8,
    borderWidth: 1,
  },
  sessionIconBox: {
    marginRight: 10,
    alignItems: 'center',
    justifyContent: 'center',
  },
  sessionInfo: {
    flex: 1,
    marginRight: 6,
  },
  sessionTopRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'space-between',
  },
  sessionTitle: {
    fontSize: 13,
    marginBottom: 2,
  },
  sessionPreview: {
    fontSize: 11,
    lineHeight: 15,
  },
  sessionMetaRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginTop: 4,
  },
  sessionDate: {
    fontSize: 10,
  },
  siteBadge: {
    paddingHorizontal: 6,
    paddingVertical: 1.5,
    borderRadius: 6,
    maxWidth: 120,
  },
  siteBadgeText: {
    fontSize: 9,
    fontWeight: '700',
  },
  deleteBtn: {
    padding: 4,
  },
  footer: {
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderTopWidth: 1,
  },
  footerBrandRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
  },
  footerBrandText: {
    fontSize: 11,
    fontWeight: '600',
  },
});
