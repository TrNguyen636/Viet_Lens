import React, { useRef, useEffect } from 'react';
import {
  StyleSheet,
  View,
  Animated,
  PanResponder,
  Dimensions,
  BackHandler,
} from 'react-native';

const { width: SCREEN_WIDTH } = Dimensions.get('window');

/**
 * SwipeBackWrapper
 * Bọc quanh màn hình để cho phép vuốt từ mép trái sang phải (Swipe to Back).
 * Tự động đồng bộ lò xo đàn hồi (Spring), hiệu ứng mờ nền và phím cứng Back trên Android.
 */
export default function SwipeBackWrapper({
  children,
  onBack,
  edgeWidth = 60,            // Độ rộng mép màn hình bên trái để kích hoạt cử chỉ (pixel)
  threshold = 100,           // Khoảng cách vuốt tối thiểu để chấp nhận lùi trang (pixel)
  velocityThreshold = 0.45,  // Tốc độ vuốt nhanh (flick) tối thiểu
  disabled = false,
  style,
}) {
  const translateX = useRef(new Animated.Value(0)).current;

  // 1. Lắng nghe phím cứng Back hoặc cử chỉ vuốt toàn màn hình của Android
  useEffect(() => {
    if (disabled || !onBack) return;
    const backSub = BackHandler.addEventListener('hardwareBackPress', () => {
      onBack();
      return true; // Chặn hành vi thoát app mặc định
    });
    return () => backSub.remove();
  }, [disabled, onBack]);

  // 2. Thiết lập bộ nhận diện cử chỉ vuốt (PanResponder)
  const panResponder = useRef(
    PanResponder.create({
      onStartShouldSetPanResponder: () => false,
      onMoveShouldSetPanResponder: (evt, gestureState) => {
        if (disabled) return false;
        const startX = evt.nativeEvent.pageX - gestureState.dx;
        const isFromLeftEdge = startX <= edgeWidth || evt.nativeEvent.pageX <= edgeWidth + 10;
        const isMovingRight = gestureState.dx > 12;
        const isHorizontal = Math.abs(gestureState.dx) > Math.abs(gestureState.dy) * 1.6;

        return isFromLeftEdge && isMovingRight && isHorizontal;
      },
      onPanResponderGrant: () => {
        translateX.stopAnimation();
      },
      onPanResponderMove: (_, gestureState) => {
        if (gestureState.dx > 0) {
          translateX.setValue(gestureState.dx);
        }
      },
      onPanResponderRelease: (_, gestureState) => {
        const isPassedThreshold = gestureState.dx > threshold;
        const isFlicked = gestureState.vx > velocityThreshold && gestureState.dx > 30;

        if (isPassedThreshold || isFlicked) {
          // Trượt mượt ra khỏi màn hình bên phải và gọi hàm onBack
          Animated.timing(translateX, {
            toValue: SCREEN_WIDTH,
            duration: 220,
            useNativeDriver: true,
          }).start(() => {
            if (onBack) onBack();
          });
        } else {
          // Chưa đủ lực/ngưỡng vuốt -> Đàn hồi trở về vị trí cũ (Spring)
          Animated.spring(translateX, {
            toValue: 0,
            tension: 70,
            friction: 10,
            useNativeDriver: true,
          }).start();
        }
      },
      onPanResponderTerminate: () => {
        Animated.spring(translateX, {
          toValue: 0,
          tension: 70,
          friction: 10,
          useNativeDriver: true,
        }).start();
      },
    })
  ).current;

  // Hiệu ứng mờ nền phía sau khi đang kéo màn hình
  const backdropOpacity = translateX.interpolate({
    inputRange: [0, SCREEN_WIDTH],
    outputRange: [0.35, 0],
    extrapolate: 'clamp',
  });

  return (
    <View style={styles.root}>
      {/* Lớp nền mờ tối dần tạo cảm giác chiều sâu */}
      <Animated.View
        pointerEvents="none"
        style={[
          styles.backdrop,
          { opacity: backdropOpacity },
        ]}
      />

      {/* Màn hình nội dung di chuyển theo ngón tay */}
      <Animated.View
        style={[
          styles.contentWrapper,
          style,
          {
            transform: [{ translateX }],
          },
        ]}
        {...panResponder.panHandlers}
      >
        {children}
      </Animated.View>
    </View>
  );
}

const styles = StyleSheet.create({
  root: {
    flex: 1,
    backgroundColor: 'transparent',
  },
  backdrop: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: '#000000',
    zIndex: 1,
  },
  contentWrapper: {
    flex: 1,
    zIndex: 2,
    backgroundColor: '#F5F5DC',
    shadowColor: '#000',
    shadowOffset: { width: -4, height: 0 },
    shadowOpacity: 0.18,
    shadowRadius: 8,
    elevation: 8,
  },
});
