import axios from 'axios';
import { Platform } from 'react-native';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { supabase } from '../services/supabase';
import { getBackendBaseUrl } from '../utils/networkConfig';

const BASE_URL = getBackendBaseUrl();
console.log('[axiosClient] Khởi tạo baseURL kết nối Backend:', BASE_URL);

const axiosClient = axios.create({
  baseURL: BASE_URL,
  timeout: 45000, // 45 giây (đồng bộ với RestTemplate timeout của Backend AI)
  headers: {
    'Content-Type': 'application/json',
    Accept: 'application/json',
  },
});

// ============================================================
// BỘ ĐỆM TOKEN & MUTEX LOCK CHO TIẾN TRÌNH REFRESH TOKEN
// ============================================================
let cachedAccessToken = null;
let isRefreshing = false;
let failedQueue = [];

// Lắng nghe thay đổi trạng thái đăng nhập để cập nhật token trong RAM tức thì
try {
  supabase.auth.onAuthStateChange((_event, session) => {
    cachedAccessToken = session?.access_token || null;
  });
} catch (e) {
  console.warn('[axiosClient] Không thể lắng nghe authStateChange:', e?.message);
}

/**
 * Xử lý hàng đợi các request đang chờ refresh token
 */
const processQueue = (error, token = null) => {
  failedQueue.forEach((prom) => {
    if (error) {
      prom.reject(error);
    } else {
      prom.resolve(token);
    }
  });
  failedQueue = [];
};

// ============================================================
// 1. REQUEST INTERCEPTOR: Tự động đính kèm Supabase Access Token
// ============================================================
axiosClient.interceptors.request.use(
  async (config) => {
    // Luôn cập nhật baseURL động theo IP thực tế của máy dev tại thời điểm gửi request
    config.baseURL = getBackendBaseUrl();

    try {
      // Ưu tiên token truyền trực tiếp trong payload nếu có
      if (config.data?.token && !config.headers.Authorization) {
        config.headers.Authorization = `Bearer ${config.data.token}`;
      }

      // Nếu chưa có header Authorization
      if (!config.headers.Authorization) {
        // 1. Thử lấy từ cache RAM
        if (cachedAccessToken) {
          config.headers.Authorization = `Bearer ${cachedAccessToken}`;
        } else {
          // 2. Fallback đọc từ Supabase Session
          const { data: { session }, error } = await supabase.auth.getSession();
          if (session?.access_token && !error) {
            cachedAccessToken = session.access_token;
            config.headers.Authorization = `Bearer ${session.access_token}`;
          }
        }
      }

      // 3. Đính kèm mã ngôn ngữ hiện tại vào header Accept-Language
      try {
        const currentLang = await AsyncStorage.getItem('user_preferred_language');
        config.headers['Accept-Language'] = (currentLang === 'en') ? 'en' : 'vi';
      } catch (langErr) {
        config.headers['Accept-Language'] = 'vi';
      }
    } catch (err) {
      console.warn('[axiosClient] Lỗi khi cấu hình Request Headers:', err?.message);
    }

    return config;
  },
  (error) => Promise.reject(error)
);

// ============================================================
// 2. RESPONSE INTERCEPTOR: Auto-Retry & Mutex Refresh Token
// ============================================================
axiosClient.interceptors.response.use(
  (response) => {
    return response.data;
  },
  async (error) => {
    const originalRequest = error.config;
    if (!originalRequest) return Promise.reject(error);

    const status = error.response?.status;
    const url = originalRequest?.url;

    // --- A. XỬ LÝ LỖI 401 VỚI MUTEX LOCK (CHỐNG RACE CONDITION THU HỒI TOKEN) ---
    if (status === 401 && !originalRequest._retry) {
      if (isRefreshing) {
        // Đã có 1 request đang refresh session -> Đưa request này vào hàng đợi
        return new Promise((resolve, reject) => {
          failedQueue.push({ resolve, reject });
        })
          .then((newToken) => {
            originalRequest.headers.Authorization = `Bearer ${newToken}`;
            return axiosClient(originalRequest);
          })
          .catch((err) => Promise.reject(err));
      }

      originalRequest._retry = true;
      isRefreshing = true;

      try {
        console.log('[axiosClient] Token hết hạn (401), đang kích hoạt Mutex refresh token...');
        const { data: { session }, error: refreshError } = await supabase.auth.refreshSession();

        if (refreshError || !session?.access_token) {
          throw refreshError || new Error('Không thể làm mới phiên Supabase Auth');
        }

        const newToken = session.access_token;
        cachedAccessToken = newToken;
        originalRequest.headers.Authorization = `Bearer ${newToken}`;

        // Giải phóng toàn bộ các request đang chờ trong hàng đợi
        processQueue(null, newToken);

        return axiosClient(originalRequest);
      } catch (refreshErr) {
        console.error('[axiosClient] Refresh token thất bại:', refreshErr?.message);
        cachedAccessToken = null;
        processQueue(refreshErr, null);
        return Promise.reject(refreshErr);
      } finally {
        isRefreshing = false;
      }
    }

    // --- B. AUTO-RETRY VỚI EXPONENTIAL BACKOFF (LỖI MẠNG HOẶC SERVER 5XX) ---
    const isNetworkError = !error.response && error.code !== 'ECONNABORTED';
    const isServerTransientError = status >= 502 && status <= 504;

    originalRequest._retryCount = originalRequest._retryCount || 0;
    const MAX_RETRIES = 2; // Tối đa thử lại 2 lần

    if ((isNetworkError || isServerTransientError) && originalRequest._retryCount < MAX_RETRIES) {
      originalRequest._retryCount += 1;
      const delayMs = Math.pow(2, originalRequest._retryCount) * 1000; // Lần 1: 2s, Lần 2: 4s

      console.warn(`[axiosClient] Sự cố mạng/máy chủ [${status || 'No Response'}]. Thử lại lần ${originalRequest._retryCount}/${MAX_RETRIES} sau ${delayMs}ms... (${url})`);

      await new Promise((resolve) => setTimeout(resolve, delayMs));
      return axiosClient(originalRequest);
    }

    console.warn(`[axiosClient] Lỗi gọi API [${originalRequest?.method?.toUpperCase()}] ${url}:`, {
      status,
      message: error.response?.data?.message || error.message,
    });

    return Promise.reject(error);
  }
);

export default axiosClient;

