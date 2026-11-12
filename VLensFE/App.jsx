import React, { useState, useEffect } from 'react';
import {
  StyleSheet,
  View,
  Text,
  TouchableOpacity,
  StatusBar,
  Platform,
  Keyboard,
} from 'react-native';
import { SafeAreaProvider, SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { StatusBar as ExpoStatusBar } from 'expo-status-bar';

import OnboardingScreen from './src/screens/OnboardingScreen';
import AuthScreen from './src/screens/AuthScreen';
import HomeScreen from './src/screens/HomeScreen';
import MapScreen from './src/screens/MapScreen';
import ChatScreen from './src/screens/ChatScreen';
import ProfileScreen from './src/screens/ProfileScreen';
import DetailScreen from './src/screens/DetailScreen';
import { THEME, ThemeProvider, useTheme } from './src/utils/theme';
import { supabase } from './src/services/supabase';
import appService from './src/api/appService';
import './src/locales/i18n';
import { initLanguagePreference } from './src/locales/i18n';
import { useTranslation } from 'react-i18next';
import {
  checkForAppUpdate,
  skipUpdateBuild,
  openUpdateDownload,
} from './src/services/appUpdateService';
import UpdatePromptModal from './src/components/UpdatePromptModal';

function MainApp() {
  const { t } = useTranslation();
  const { theme, isDark } = useTheme();

  // Navigation Flow States:
  // 'onboarding' | 'auth' | 'main'
  const [appState, setAppState] = useState('onboarding');
  const [currentUser, setCurrentUser] = useState(null);

  // Active Bottom Tab: 'home' | 'camera' | 'map' | 'chat' | 'profile'
  const [activeTab, setActiveTab] = useState('home');

  const [selectedSite, setSelectedSite] = useState(null); // Khi mở màn hình Chi tiết (DetailScreen)
  const [chatSiteContext, setChatSiteContext] = useState(null); // Chỉ dùng cho Chat khi bấm nút đỏ 'Hỏi Trợ lý AI'
  const [mapFocusedSite, setMapFocusedSite] = useState(null);   // Chỉ dùng cho Map khi bấm điều hướng sang bản đồ
  const [hasVisitedMap, setHasVisitedMap] = useState(false);   // Duy trì một Map instance duy nhất (Bước 2)

  // Lắng nghe bàn phím ảo để tự động ẩn Bottom Navigation Bar khi gõ phím
  const [isKeyboardVisible, setIsKeyboardVisible] = useState(false);
  const [updateInfo, setUpdateInfo] = useState(null);

  useEffect(() => {
    if (activeTab === 'map') {
      setHasVisitedMap(true);
    }
  }, [activeTab]);

  useEffect(() => {
    initLanguagePreference();
  }, []);

  useEffect(() => {
    if (__DEV__ || Platform.OS !== 'android') return;
    let cancelled = false;
    checkForAppUpdate().then((info) => {
      if (!cancelled && info?.hasUpdate) {
        setUpdateInfo(info);
      }
    });
    return () => {
      cancelled = true;
    };
  }, []);

  useEffect(() => {
    const showSub = Keyboard.addListener(
      Platform.OS === 'ios' ? 'keyboardWillShow' : 'keyboardDidShow',
      () => setIsKeyboardVisible(true)
    );
    const hideSub = Keyboard.addListener(
      Platform.OS === 'ios' ? 'keyboardWillHide' : 'keyboardDidHide',
      () => setIsKeyboardVisible(false)
    );
    return () => {
      showSub.remove();
      hideSub.remove();
    };
  }, []);

  // Kiểm tra phiên đăng nhập Supabase đã lưu trước đó
  useEffect(() => {
    const checkUserSession = async () => {
      try {
        const { data: { session }, error } = await supabase.auth.getSession();
        if (session?.user && !error) {
          console.log('[App] Khôi phục phiên làm việc:', session.user.email);
          const initialUser = {
            id: session.user.id,
            name: session.user.user_metadata?.full_name || session.user.email?.split('@')[0],
            email: session.user.email,
            role: 'USER',
          };
          setCurrentUser(initialUser);
          setAppState('main');

          // Tải thông tin chi tiết từ Backend Spring Boot ở chế độ chạy ngầm
          appService
            .getUserProfile()
            .then((userProfile) => {
              if (userProfile) {
                setCurrentUser(userProfile);
              }
            })
            .catch(() => {
              console.log('[App] Chưa lấy được profile từ backend, tiếp tục dùng thông tin session');
            });
        }
      } catch (err) {
        console.error('[App] Lỗi kiểm tra session:', err);
      }
    };

    checkUserSession();

    // Lắng nghe sự kiện đăng nhập, đăng xuất hoặc cập nhật phiên
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        setCurrentUser(null);
        setAppState('auth');
      } else if (event === 'SIGNED_IN' && session?.user) {
        console.log('[App] onAuthStateChange SIGNED_IN:', session.user.email);
        const loggedUser = {
          id: session.user.id,
          name: session.user.user_metadata?.full_name || session.user.user_metadata?.name || session.user.email?.split('@')[0] || 'Du khách',
          email: session.user.email,
          role: 'USER',
        };
        setCurrentUser(loggedUser);
        setAppState('main');

        // Đồng bộ hồ sơ ngầm với Spring Boot backend
        appService
          .syncUserProfile({
            token: session.access_token,
            fullName: loggedUser.name,
          })
          .then((profile) => {
            if (profile) setCurrentUser(profile);
          })
          .catch(() => {});
      }
    });

    return () => {
      subscription?.unsubscribe();
    };
  }, []);

  // Auth Handlers
  const handleOnboardingFinish = () => {
    setAppState('auth');
  };

  const handleLoginSuccess = (user) => {
    setCurrentUser(user);
    setAppState('main');
  };

  const handleLogout = async () => {
    try {
      await supabase.auth.signOut();
    } catch (err) {
      console.warn('[App] Lỗi khi đăng xuất Supabase:', err.message);
    }
    setCurrentUser(null);
    setAppState('auth');
  };

  // Site Select & Deep Dive (Chỉ mở màn hình chi tiết, không can thiệp vào Chat hay Map)
  const handleSelectSite = (site) => {
    setSelectedSite(site);
  };

  // Điều hướng sang Chat: CHỈ ĐƯỢC KÍCH HOẠT khi người dùng bấm nút đỏ "Hỏi Trợ lý AI" trong DetailScreen hoặc Camera Scan
  const handleNavigateToChat = (site = null, imageUri = null) => {
    if (site) {
      setChatSiteContext(imageUri ? { ...site, userPhoto: imageUri } : site);
    } else {
      setChatSiteContext(null);
    }
    setSelectedSite(null);
    setActiveTab('chat');
  };

  // Điều hướng sang Map: Cập nhật di tích được chọn vào Map và tạo mốc focus mới
  const handleNavigateToMap = (site = null) => {
    if (site) {
      setMapFocusedSite({ ...site, _focusAt: Date.now() });
      setSelectedSite(null);
    }
    setActiveTab('map');
  };

  const handleNavigateToCamera = () => {
    setSelectedSite(null);
    setActiveTab('chat');
  };

  const renderContent = () => {
    // 1. Onboarding & Splash Screen
    if (appState === 'onboarding') {
      return <OnboardingScreen onFinish={handleOnboardingFinish} />;
    }

    // 2. Authentication Screen
    if (appState === 'auth') {
      return <AuthScreen onLoginSuccess={handleLoginSuccess} />;
    }

    // 3. Deep Dive Overlays
    if (selectedSite) {
      return (
        <DetailScreen
          site={selectedSite}
          onBack={() => setSelectedSite(null)}
          onNavigateToChat={handleNavigateToChat}
          onNavigateToMap={handleNavigateToMap}
        />
      );
    }

    // 4. Main 4 Bottom Tabs
    return (
      <SafeAreaView
        style={[
          styles.safeContainer,
          { backgroundColor: theme.colors.bg },
        ]}
      >
        <ExpoStatusBar style={isDark ? 'light' : 'dark'} />
        <View style={styles.contentArea}>
          {activeTab === 'home' && (
          <HomeScreen
            user={currentUser}
            onSelectSite={handleSelectSite}
            onNavigateToCamera={handleNavigateToCamera}
            onNavigateToMap={handleNavigateToMap}
            onNavigateToProfile={() => setActiveTab('profile')}
          />
        )}

        {/* Tab 2: MapScreen - Duy trì một Map instance duy nhất, không tạo lại khi chuyển tab (Bước 2) */}
        {(activeTab === 'map' || hasVisitedMap) && (
          <View
            style={
              activeTab === 'map'
                ? { flex: 1 }
                : { position: 'absolute', width: 0, height: 0, opacity: 0, overflow: 'hidden', zIndex: -1 }
            }
            pointerEvents={activeTab === 'map' ? 'auto' : 'none'}
          >
            <MapScreen
              onSelectSite={handleSelectSite}
              onNavigateToChat={handleNavigateToChat}
              focusedSite={mapFocusedSite}
            />
          </View>
        )}

        {activeTab === 'chat' && (
          <ChatScreen
            user={currentUser}
            activeSite={chatSiteContext}
            onNavigateToMap={handleNavigateToMap}
            onClearActiveSite={() => setChatSiteContext(null)}
          />
        )}

        {activeTab === 'profile' && (
          <ProfileScreen
            user={currentUser}
            onLogout={handleLogout}
          />
        )}
      </View>

      {/* Modern Floating Bottom Navigation Bar (4 Tab Thanh Lịch, Cân Xứng) */}
      {!isKeyboardVisible && (
        <View style={[styles.bottomNavContainer, { backgroundColor: theme.colors.tabBarBg, borderColor: theme.colors.tabBarBorder }]}>
          {/* Tab 1: Khám phá */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('home')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'home' ? 'compass' : 'compass-outline'}
              size={24}
              color={activeTab === 'home' ? theme.colors.amber : theme.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                { color: theme.colors.inkMuted },
                activeTab === 'home' && [styles.navLabelActive, { color: theme.colors.amber }],
              ]}
            >
              {t('nav.home')}
            </Text>
          </TouchableOpacity>

          {/* Tab 2: Bản đồ */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('map')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'map' ? 'map' : 'map-outline'}
              size={23}
              color={activeTab === 'map' ? theme.colors.amber : theme.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                { color: theme.colors.inkMuted },
                activeTab === 'map' && [styles.navLabelActive, { color: theme.colors.amber }],
              ]}
            >
              {t('nav.map')}
            </Text>
          </TouchableOpacity>

          {/* Tab 3: Cố vấn AI (Chatbot & Nhận diện ảnh) */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('chat')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'chat' ? 'chatbubble-ellipses' : 'chatbubble-ellipses-outline'}
              size={23}
              color={activeTab === 'chat' ? theme.colors.amber : theme.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                { color: theme.colors.inkMuted },
                activeTab === 'chat' && [styles.navLabelActive, { color: theme.colors.amber }],
              ]}
            >
              {t('nav.chat')}
            </Text>
          </TouchableOpacity>

          {/* Tab 4: Tài khoản */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('profile')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'profile' ? 'person' : 'person-outline'}
              size={23}
              color={activeTab === 'profile' ? theme.colors.amber : theme.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                { color: theme.colors.inkMuted },
                activeTab === 'profile' && [styles.navLabelActive, { color: theme.colors.amber }],
              ]}
            >
              {t('nav.profile')}
            </Text>
          </TouchableOpacity>
        </View>
      )}
      </SafeAreaView>
    );
  };

  return (
    <>
      {renderContent()}
      <UpdatePromptModal
        visible={!!updateInfo}
        updateInfo={updateInfo}
        onUpdate={() => {
          openUpdateDownload(updateInfo?.downloadUrl);
          setUpdateInfo(null);
        }}
        onLater={async () => {
          if (updateInfo?.latestBuildNumber) {
            await skipUpdateBuild(updateInfo.latestBuildNumber);
          }
          setUpdateInfo(null);
        }}
      />
    </>
  );
}

export default function App() {
  return (
    <SafeAreaProvider>
      <ThemeProvider>
        <MainApp />
      </ThemeProvider>
    </SafeAreaProvider>
  );
}

const styles = StyleSheet.create({
  safeContainer: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  contentArea: {
    flex: 1,
  },
  bottomNavContainer: {
    flexDirection: 'row',
    backgroundColor: '#FFFFFF',
    borderTopWidth: 1,
    borderColor: THEME.colors.border,
    paddingHorizontal: 8,
    alignItems: 'center',
    justifyContent: 'space-around',
    elevation: 12,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: -3 },
    shadowOpacity: 0.1,
    shadowRadius: 6,
    height: Platform.OS === 'ios' ? 84 : 66,
    paddingBottom: Platform.OS === 'ios' ? 20 : 6,
  },
  navItem: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
    height: 52,
  },
  navLabel: {
    fontSize: 10,
    color: THEME.colors.inkMuted,
    fontWeight: '600',
    marginTop: 3,
  },
  navLabelActive: {
    color: THEME.colors.amber,
    fontWeight: '700',
  },
});
