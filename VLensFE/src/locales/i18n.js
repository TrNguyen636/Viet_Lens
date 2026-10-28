import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import AsyncStorage from '@react-native-async-storage/async-storage';

import vi from './vi.json';
import en from './en.json';

const LANGUAGE_KEY = 'user_preferred_language';

const resources = {
  vi: { translation: vi },
  en: { translation: en },
};

i18n
  .use(initReactI18next)
  .init({
    compatibilityJSON: 'v3',
    resources,
    lng: 'vi', // Ngôn ngữ mặc định ban đầu
    fallbackLng: 'vi',
    interpolation: {
      escapeValue: false,
    },
  });

// Khôi phục ngôn ngữ đã lưu từ AsyncStorage khi ứng dụng khởi động
export const initLanguagePreference = async () => {
  try {
    const savedLang = await AsyncStorage.getItem(LANGUAGE_KEY);
    if (savedLang && (savedLang === 'vi' || savedLang === 'en')) {
      await i18n.changeLanguage(savedLang);
      return savedLang;
    }
  } catch (e) {
    console.warn('[i18n] Không đọc được ngôn ngữ lưu trữ:', e);
  }
  return 'vi';
};

// Hàm chuyển đổi ngôn ngữ và lưu trữ
export const changeAppLanguage = async (lang) => {
  try {
    const target = lang === 'en' ? 'en' : 'vi';
    await i18n.changeLanguage(target);
    await AsyncStorage.setItem(LANGUAGE_KEY, target);
    return target;
  } catch (e) {
    console.warn('[i18n] Lỗi khi đổi ngôn ngữ:', e);
    return i18n.language;
  }
};

export default i18n;
