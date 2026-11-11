import { Platform, NativeModules } from 'react-native';
import Constants from 'expo-constants';

/**
 * Trích xuất IP máy chủ dev (Host IP) đang chạy Metro Bundler và Backend:
 * - Khi chạy trên thiết bị thật (Expo Go): Tự động phát hiện IP máy tính host
 *   qua `Constants.expoConfig.hostUri` (Ví dụ: "10.229.106.109:8081" -> "10.229.106.109")
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
 * Chuẩn hóa và chọn Base URL theo thứ tự ưu tiên:
 * 1. Biến môi trường EXPO_PUBLIC_* (hỗ trợ cả Cloud Render lẫn URL chỉ định trên mọi nền tảng)
 * 2. IP host tự động từ Metro Bundler khi phát triển LAN (trừ domain tunnel)
 * 3. Fallback localhost / 10.0.2.2 (Android Emulator)
 */
function resolveServiceUrl(envUrl, port) {
  if (envUrl && typeof envUrl === 'string') {
    const cleanUrl = envUrl.trim().replace(/\/+$/, '');
    if (cleanUrl && !cleanUrl.includes('172.16.0.255') && !cleanUrl.includes('<YOUR_LAN_IP>')) {
      return cleanUrl;
    }
  }

  if (Platform.OS === 'web') {
    return `http://localhost:${port}`;
  }

  const detectedHost = getDevHost();
  if (detectedHost) {
    const isTunnel =
      detectedHost.includes('exp.direct') ||
      detectedHost.includes('ngrok') ||
      detectedHost.includes('loca.lt');

    if (isTunnel) {
      console.warn(
        `[NetworkConfig] Đang chạy Expo Tunnel nhưng chưa cấu hình URL Cloud cho cổng ${port}.`
      );
    } else {
      return `http://${detectedHost}:${port}`;
    }
  }

  if (Platform.OS === 'android') {
    return `http://10.0.2.2:${port}`;
  }

  return `http://localhost:${port}`;
}

/**
 * Lấy Base URL cho Backend Spring Boot (ưu tiên EXPO_PUBLIC_API_URL, fallback cổng 8080)
 */
export const getBackendBaseUrl = () => {
  // Giữ tham chiếu tĩnh process.env.EXPO_PUBLIC_* để Babel/Expo inline khi bundle
  return resolveServiceUrl(process.env.EXPO_PUBLIC_API_URL, 8080);
};

/**
 * Lấy Base URL cho Python AI Microservice (ưu tiên EXPO_PUBLIC_AI_API_URL, fallback cổng 8000)
 */
export const getAiMicroserviceBaseUrl = () => {
  return resolveServiceUrl(process.env.EXPO_PUBLIC_AI_API_URL, 8000);
};
