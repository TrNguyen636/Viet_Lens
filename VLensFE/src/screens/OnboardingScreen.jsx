import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Dimensions,
  Animated,
  StatusBar,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { THEME } from '../utils/theme';

const { width } = Dimensions.get('window');

export default function OnboardingScreen({ onFinish }) {
  const [step, setStep] = useState(0); // 0: Splash, 1: Scan, 2: Map, 3: Permissions
  const [logoScale] = useState(new Animated.Value(0.8));
  const [logoOpacity] = useState(new Animated.Value(0));

  useEffect(() => {
    // Splash animation
    Animated.parallel([
      Animated.spring(logoScale, { toValue: 1, friction: 5, useNativeDriver: true }),
      Animated.timing(logoOpacity, { toValue: 1, duration: 800, useNativeDriver: true }),
    ]).start();

    // Auto transition from Splash after 2 seconds
    const timer = setTimeout(() => {
      setStep(1);
    }, 2200);

    return () => clearTimeout(timer);
  }, []);

  const handleNext = () => {
    if (step < 3) {
      setStep(step + 1);
    } else {
      onFinish();
    }
  };

  if (step === 0) {
    return (
      <View style={styles.splashContainer}>
        <StatusBar barStyle="dark-content" />
        <Animated.View style={[styles.splashCenter, { transform: [{ scale: logoScale }], opacity: logoOpacity }]}>
          <View style={styles.logoCircle}>
            <MaterialCommunityIcons name="camera-iris" size={54} color={THEME.colors.amber} />
          </View>
          <Text style={styles.brandTitle}>VietLens</Text>
          <Text style={styles.brandSubtitle}>Kính vạn hoa Di sản Việt Nam</Text>
          <View style={styles.badgePill}>
            <Text style={styles.badgeText}>Chạm góc nhìn, Mở di sản</Text>
          </View>
        </Animated.View>
        <Text style={styles.splashFooter}>Phiên bản Di sản Văn hóa Việt • 2026</Text>
      </View>
    );
  }

  const slides = [
    {}, // Placeholder for step 0
    {
      icon: 'camera-outline',
      iconType: 'ionicons',
      title: 'Quét Di Sản Với AI',
      desc: 'Hướng camera vào bất kỳ đền chùa, lăng tẩm hay di vật cổ. Trí tuệ nhân tạo VietLens sẽ nhận diện ngay tức khắc thông tin lịch sử nghìn năm.',
      accent: THEME.colors.amber,
    },
    {
      icon: 'map-search-outline',
      iconType: 'material',
      title: 'Bản Đồ Di Sản Tương Tác',
      desc: 'Khám phá hàng trăm địa danh lịch sử trải dài từ Bắc chí Nam. Định vị thông minh gợi ý điểm đến văn hóa ngay gần bạn.',
      accent: THEME.colors.red,
    },
    {
      icon: 'shield-account-outline',
      iconType: 'material',
      title: 'Trao Quyền Để Đồng Hành',
      desc: 'VietLens cần quyền truy cập Camera và Vị trí để nhận diện di tích trước mắt bạn và thuyết minh Audio Guide theo từng bước chân.',
      accent: THEME.colors.green,
      isPermission: true,
    },
  ];

  const current = slides[step];

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      <View style={styles.topBar}>
        <Text style={styles.topLogo}>VietLens</Text>
        {step < 3 && (
          <TouchableOpacity onPress={onFinish}>
            <Text style={styles.skipBtn}>Bỏ qua</Text>
          </TouchableOpacity>
        )}
      </View>

      <View style={styles.content}>
        <View style={[styles.illustrationCard, { borderColor: current.accent }]}>
          <View style={[styles.iconHalo, { backgroundColor: current.accent + '20' }]}>
            {current.iconType === 'ionicons' ? (
              <Ionicons name={current.icon} size={70} color={current.accent} />
            ) : (
              <MaterialCommunityIcons name={current.icon} size={70} color={current.accent} />
            )}
          </View>
          {current.isPermission && (
            <View style={styles.permList}>
              <View style={styles.permItem}>
                <Ionicons name="camera" size={18} color={THEME.colors.amber} />
                <Text style={styles.permText}>Camera: Nhận diện hiện vật & di tích</Text>
              </View>
              <View style={styles.permItem}>
                <Ionicons name="location" size={18} color={THEME.colors.red} />
                <Text style={styles.permText}>Vị trí GPS: Gợi ý di sản lân cận</Text>
              </View>
            </View>
          )}
        </View>

        <Text style={styles.slideTitle}>{current.title}</Text>
        <Text style={styles.slideDesc}>{current.desc}</Text>
      </View>

      {/* Pagination & Next Button */}
      <View style={styles.footer}>
        <View style={styles.pagination}>
          {[1, 2, 3].map((i) => (
            <View
              key={i}
              style={[
                styles.dot,
                step === i ? [styles.dotActive, { backgroundColor: current.accent }] : {},
              ]}
            />
          ))}
        </View>

        <TouchableOpacity
          style={[styles.nextBtn, { backgroundColor: current.accent }]}
          onPress={handleNext}
          activeOpacity={0.8}
        >
          <Text style={styles.nextBtnText}>
            {step === 3 ? 'Bắt đầu ngay' : 'Tiếp tục'}
          </Text>
          <Ionicons name="arrow-forward" size={18} color="#FFF" style={{ marginLeft: 6 }} />
        </TouchableOpacity>
      </View>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  splashContainer: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  splashCenter: {
    alignItems: 'center',
  },
  logoCircle: {
    width: 96,
    height: 96,
    borderRadius: 48,
    backgroundColor: '#FFF',
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 8,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 4 },
    shadowOpacity: 0.15,
    shadowRadius: 10,
    borderWidth: 2,
    borderColor: THEME.colors.border,
  },
  brandTitle: {
    fontSize: 34,
    fontWeight: '700',
    color: THEME.colors.ink,
    marginTop: 18,
    letterSpacing: 1,
  },
  brandSubtitle: {
    fontSize: 14,
    color: THEME.colors.inkMuted,
    marginTop: 4,
    fontWeight: '500',
  },
  badgePill: {
    marginTop: 20,
    paddingHorizontal: 16,
    paddingVertical: 8,
    backgroundColor: THEME.colors.parchment,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  badgeText: {
    fontSize: 13,
    color: THEME.colors.red,
    fontWeight: '700',
  },
  splashFooter: {
    position: 'absolute',
    bottom: 30,
    fontSize: 12,
    color: THEME.colors.inkLight,
  },
  topBar: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 24,
    paddingTop: 12,
  },
  topLogo: {
    fontSize: 20,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  skipBtn: {
    fontSize: 14,
    color: THEME.colors.inkMuted,
    fontWeight: '600',
  },
  content: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    paddingHorizontal: 28,
  },
  illustrationCard: {
    width: width * 0.78,
    paddingVertical: 36,
    backgroundColor: '#FFF',
    borderRadius: 24,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1.5,
    elevation: 4,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.08,
    shadowRadius: 8,
    marginBottom: 32,
  },
  iconHalo: {
    width: 120,
    height: 120,
    borderRadius: 60,
    alignItems: 'center',
    justifyContent: 'center',
  },
  permList: {
    marginTop: 20,
    width: '84%',
  },
  permItem: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 8,
    gap: 8,
  },
  permText: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    fontWeight: '500',
  },
  slideTitle: {
    fontSize: 24,
    fontWeight: '700',
    color: THEME.colors.ink,
    textAlign: 'center',
    marginBottom: 12,
  },
  slideDesc: {
    fontSize: 14,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
    lineHeight: 22,
    paddingHorizontal: 8,
  },
  footer: {
    paddingHorizontal: 24,
    paddingBottom: 28,
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  pagination: {
    flexDirection: 'row',
    gap: 6,
  },
  dot: {
    width: 8,
    height: 8,
    borderRadius: 4,
    backgroundColor: THEME.colors.border,
  },
  dotActive: {
    width: 24,
  },
  nextBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingVertical: 14,
    paddingHorizontal: 22,
    borderRadius: 30,
    elevation: 3,
  },
  nextBtnText: {
    color: '#FFF',
    fontSize: 15,
    fontWeight: '700',
  },
});

