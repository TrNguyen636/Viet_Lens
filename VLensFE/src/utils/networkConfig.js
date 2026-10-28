import { Platform, NativeModules } from 'react-native';
import Constants from 'expo-constants';

/**
 * Trích xuất IP máy chủ dev (Host IP) đang chạy Metro Bundler và Backend:
 * - Khi chạy trên thiết bị thật (Expo Go): Tự động phát hiện IP máy tính host
 *   qua `Constants.expoConfig.hostUri` (Ví dụ: "10.229.106.109:8081" -> "10.229.106.109")
 * - Giúp app tự thích ứng ngay lập tức khi đổi mạng Wi-Fi, chuyển sang 3G/Hotspot
 *   mà không bao giờ bị lỗi [No Response] hay phải sửa tay IP!
 */
export const getDevHost = () => {
  if (Platform.OS === 'web') {
    return 'localhost';
  }

  // 1. Nhận diện từ Expo Constants (Phương thức chuẩn xác nhất trên Expo Go)
  try {
    const hostUri =
      Constants.expoConfig?.hostUri ||
      Constants.manifest2?.extra?.expoGo?.debuggerHost ||
      Constants.manifest2?.extra?.expoClient?.hostUri ||
      Constants.manifest?.debuggerHost ||
      Constants.experienceUrl ||
      Constants.linkingUri;

    if (hostUri && typeof hostUri === 'string') {
      const clean = hostUri.replace(/^(exp|https?):\/\//, '');
      const host = clean.split(':')[0];
      if (host && host !== 'localhost' && host !== '127.0.0.1') {
        return host;
      }
    }
  } catch (err) {
    // Bỏ qua lỗi Constants nếu chạy ngoài môi trường Expo
  }

  // 2. Nhận diện từ NativeModules.SourceCode (Fallback cho React Native thuần)
  try {
    const scriptURL = NativeModules.SourceCode?.scriptURL;
    if (scriptURL) {
      const match = scriptURL.match(/^https?:\/\/([^/:]+)/);
      if (match && match[1] && match[1] !== 'localhost' && match[1] !== '127.0.0.1') {
        return match[1];
      }
    }
  } catch (err) {
    // Bỏ qua lỗi scriptURL
  }

  return null;
};

/**
 * Lấy Base URL cho Backend Spring Boot (cổng 8080)
 */
export const getBackendBaseUrl = () => {
  if (Platform.OS === 'web') {
    return 'http://localhost:8080';
  }

  const detectedHost = getDevHost();
  if (detectedHost) {
    return `http://${detectedHost}:8080`;
  }

  if (process.env.EXPO_PUBLIC_API_URL) {
    return process.env.EXPO_PUBLIC_API_URL;
  }

  if (Platform.OS === 'android') {
    return 'http://10.0.2.2:8080';
  }

  return 'http://localhost:8080';
};

/**
 * Lấy Base URL cho Python AI Microservice (cổng 8000)
 */
export const getAiMicroserviceBaseUrl = () => {
  if (Platform.OS === 'web') {
    return 'http://localhost:8000';
  }

  const detectedHost = getDevHost();
  if (detectedHost) {
    return `http://${detectedHost}:8000`;
  }

  if (process.env.EXPO_PUBLIC_AI_API_URL) {
    return process.env.EXPO_PUBLIC_AI_API_URL;
  }

  if (Platform.OS === 'android') {
    return 'http://10.0.2.2:8000';
  }

  return 'http://localhost:8000';
};
