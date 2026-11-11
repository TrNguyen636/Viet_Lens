import { createClient } from '@supabase/supabase-js';
import AsyncStorage from '@react-native-async-storage/async-storage';
import { Platform } from 'react-native';

const supabaseUrl = process.env.EXPO_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.EXPO_PUBLIC_SUPABASE_KEY || process.env.EXPO_PUBLIC_SUPABASE_ANON_KEY || '';

// Bộ nhớ đệm dự phòng trong RAM nếu Native Module AsyncStorage không khả dụng
const memoryStorage = new Map();

/**
 * Adapter lưu trữ an toàn:
 * - Hỗ trợ cả Web (localStorage) và Thiết bị di động (AsyncStorage 2.2.0)
 * - Tự động bắt lỗi nếu Native Module bị null (tránh crash ứng dụng)
 */
const safeStorage = {
  getItem: async (key) => {
    try {
      if (Platform.OS === 'web' && typeof window !== 'undefined' && window.localStorage) {
        return window.localStorage.getItem(key);
      }
      return await AsyncStorage.getItem(key);
    } catch (err) {
      console.warn('[SafeStorage] Lỗi getItem, chuyển sang dùng memoryStorage:', err?.message);
      return memoryStorage.get(key) || null;
    }
  },
  setItem: async (key, value) => {
    try {
      if (Platform.OS === 'web' && typeof window !== 'undefined' && window.localStorage) {
        window.localStorage.setItem(key, value);
        return;
      }
      await AsyncStorage.setItem(key, value);
    } catch (err) {
      console.warn('[SafeStorage] Lỗi setItem, chuyển sang dùng memoryStorage:', err?.message);
      memoryStorage.set(key, value);
    }
  },
  removeItem: async (key) => {
    try {
      if (Platform.OS === 'web' && typeof window !== 'undefined' && window.localStorage) {
        window.localStorage.removeItem(key);
        return;
      }
      await AsyncStorage.removeItem(key);
    } catch (err) {
      console.warn('[SafeStorage] Lỗi removeItem:', err?.message);
      memoryStorage.delete(key);
    }
  },
};

export const supabase = createClient(supabaseUrl, supabaseAnonKey, {
  auth: {
    storage: safeStorage,
    autoRefreshToken: true,
    persistSession: true,
    detectSessionInUrl: false,
    flowType: 'pkce',
  },
});
