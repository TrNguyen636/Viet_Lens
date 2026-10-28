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
import CameraScanScreen from './src/screens/CameraScanScreen';
import MapScreen from './src/screens/MapScreen';
import ChatScreen from './src/screens/ChatScreen';
import ProfileScreen from './src/screens/ProfileScreen';
import DetailScreen from './src/screens/DetailScreen';
import { THEME } from './src/utils/theme';
import { supabase } from './src/services/supabase';
import appService from './src/api/appService';
import './src/locales/i18n';
import { initLanguagePreference } from './src/locales/i18n';
import { useTranslation } from 'react-i18next';

export default function App() {
  const { t } = useTranslation();

  // Navigation Flow States:
  // 'onboarding' | 'auth' | 'main'
  const [appState, setAppState] = useState('onboarding');
  const [currentUser, setCurrentUser] = useState(null);

  // Active Bottom Tab: 'home' | 'camera' | 'map' | 'chat' | 'profile'
  const [activeTab, setActiveTab] = useState('home');

  const [selectedSite, setSelectedSite] = useState(null); // When opening DetailScreen
  const [chatSiteContext, setChatSiteContext] = useState(null); // Khởi tạo null, không dùng mock Hoàng Thành Thăng Long

  // Lắng nghe bàn phím ảo để tự động ẩn Bottom Navigation Bar khi gõ phím
  const [isKeyboardVisible, setIsKeyboardVisible] = useState(false);

  useEffect(() => {
    initLanguagePreference();
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

    // Lắng nghe sự kiện đăng xuất hoặc refresh token
    const { data: { subscription } } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === 'SIGNED_OUT') {
        setCurrentUser(null);
        setAppState('auth');
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

  // Site Select & Deep Dive
  const handleSelectSite = (site) => {
    setSelectedSite(site);
    setChatSiteContext(site);
  };

  const handleNavigateToChat = (site = null, imageUri = null) => {
    if (site) {
      setChatSiteContext(imageUri ? { ...site, userPhoto: imageUri } : site);
    }
    setSelectedSite(null);
    setActiveTab('chat');
  };

  const handleNavigateToMap = (site = null) => {
    if (site) {
      setChatSiteContext(site);
      setSelectedSite(null);
    }
    setActiveTab('map');
  };

  const handleNavigateToCamera = () => {
    setSelectedSite(null);
    setActiveTab('camera');
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
        />
      );
    }

    // 4. Main 5 Bottom Tabs
    return (
      <SafeAreaView
        style={[
          styles.safeContainer,
          activeTab === 'camera' && { backgroundColor: '#000000' },
        ]}
      >
        <ExpoStatusBar style={activeTab === 'camera' ? 'light' : 'dark'} />
        <View style={[styles.contentArea, activeTab === 'camera' && { backgroundColor: 'transparent' }]}>
          {activeTab === 'home' && (
          <HomeScreen
            user={currentUser}
            onSelectSite={handleSelectSite}
            onNavigateToCamera={handleNavigateToCamera}
            onNavigateToMap={handleNavigateToMap}
          />
        )}

        {activeTab === 'camera' && (
          <CameraScanScreen
            onNavigateToMap={handleNavigateToMap}
            onNavigateToChat={handleNavigateToChat}
            onSelectSite={handleSelectSite}
            onBack={() => setActiveTab('home')}
          />
        )}

        {activeTab === 'map' && (
          <MapScreen
            onSelectSite={handleSelectSite}
            onNavigateToChat={handleNavigateToChat}
            focusedSite={chatSiteContext}
          />
        )}

        {activeTab === 'chat' && (
          <ChatScreen activeSite={chatSiteContext} />
        )}

        {activeTab === 'profile' && (
          <ProfileScreen
            user={currentUser}
            onLogout={handleLogout}
          />
        )}
      </View>

      {/* Modern Floating Bottom Navigation Bar (Tự động ẩn khi bàn phím bật) */}
      {!isKeyboardVisible && (
        <View style={styles.bottomNavContainer}>
          {/* Tab 1: Khám phá */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('home')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'home' ? 'compass' : 'compass-outline'}
              size={24}
              color={activeTab === 'home' ? THEME.colors.amber : THEME.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                activeTab === 'home' && styles.navLabelActive,
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
              color={activeTab === 'map' ? THEME.colors.amber : THEME.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                activeTab === 'map' && styles.navLabelActive,
              ]}
            >
              {t('nav.map')}
            </Text>
          </TouchableOpacity>

          {/* Tab 3: Quét AI (Prominent Center Button) */}
          <TouchableOpacity
            style={styles.navItemCamera}
            onPress={() => setActiveTab('camera')}
            activeOpacity={0.85}
          >
            <View
              style={[
                styles.cameraCircle,
                activeTab === 'camera' && styles.cameraCircleActive,
              ]}
            >
              <Ionicons name="scan-outline" size={26} color="#FFF" />
            </View>
            <Text
              style={[
                styles.navLabel,
                activeTab === 'camera' && styles.navLabelActive,
                { marginTop: 2 },
              ]}
            >
              {t('nav.camera')}
            </Text>
          </TouchableOpacity>

          {/* Tab 4: Hướng dẫn viên AI */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('chat')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'chat' ? 'chatbubble-ellipses' : 'chatbubble-ellipses-outline'}
              size={23}
              color={activeTab === 'chat' ? THEME.colors.amber : THEME.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                activeTab === 'chat' && styles.navLabelActive,
              ]}
            >
              {t('nav.chat')}
            </Text>
          </TouchableOpacity>

          {/* Tab 5: Hồ sơ */}
          <TouchableOpacity
            style={styles.navItem}
            onPress={() => setActiveTab('profile')}
            activeOpacity={0.7}
          >
            <Ionicons
              name={activeTab === 'profile' ? 'person' : 'person-outline'}
              size={23}
              color={activeTab === 'profile' ? THEME.colors.amber : THEME.colors.inkMuted}
            />
            <Text
              style={[
                styles.navLabel,
                activeTab === 'profile' && styles.navLabelActive,
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
    <SafeAreaProvider>
      {renderContent()}
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
  navItemCamera: {
    alignItems: 'center',
    justifyContent: 'center',
    flex: 1,
    marginTop: -20,
    zIndex: 99,
  },
  cameraCircle: {
    width: 54,
    height: 54,
    borderRadius: 27,
    backgroundColor: THEME.colors.red,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 8,
    shadowColor: THEME.colors.red,
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.4,
    shadowRadius: 6,
    borderWidth: 3,
    borderColor: '#FFF',
  },
  cameraCircleActive: {
    backgroundColor: THEME.colors.amber,
  },
});
