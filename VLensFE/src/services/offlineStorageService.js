import AsyncStorage from '@react-native-async-storage/async-storage';
import heritageSeedData from '../assets/data/heritageSeed.json';
import { adaptHeritageList } from '../utils/heritageAdapter';

const OFFLINE_STORAGE_KEY = '@vietlens_offline_heritages_v1';
const OFFLINE_TIMESTAMP_KEY = '@vietlens_offline_heritages_synced_at';

/**
 * Ghép bản dịch đa ngôn ngữ cho danh sách di tích từ mảng translations
 */
function applyTranslations(heritages = [], translations = [], language = 'vi') {
  const normalizedLang = String(language || 'vi').toLowerCase();
  const normalizedRows = heritages.map((item) => ({
    ...item,
    imageUrl: item.imageUrl || item.image_url,
  }));

  if (normalizedLang === 'vi' || !Array.isArray(translations) || translations.length === 0) {
    return normalizedRows;
  }

  const byHeritageId = new Map();
  translations.forEach((tr) => {
    if (tr.language_code?.toLowerCase() === normalizedLang) {
      byHeritageId.set(tr.heritage_id, tr);
    }
  });

  return normalizedRows.map((item) => {
    const tr = byHeritageId.get(item.id);
    if (!tr) return item;
    return {
      ...item,
      name: tr.name || item.name,
      description: tr.description || item.description,
      category: tr.category || item.category,
      province: tr.province || item.province,
      address: tr.address || item.address,
    };
  });
}

/**
 * Đọc dữ liệu hạt giống gốc nhúng sẵn trong ứng dụng
 */
export function getSeedHeritages(language = 'vi') {
  try {
    const heritages = heritageSeedData?.heritages || [];
    const translations = heritageSeedData?.translations || [];
    const translated = applyTranslations(heritages, translations, language);
    return adaptHeritageList(translated);
  } catch (err) {
    console.warn('[offlineStorageService] Lỗi đọc seed data:', err.message);
    return [];
  }
}

/**
 * Lấy danh sách di sản ngoại tuyến:
 * 1. Thử đọc từ AsyncStorage (nếu đã từng đồng bộ phiên bản mới hơn)
 * 2. Nếu chưa có hoặc lỗi, lập tức nạp từ heritageSeed.json
 */
export async function getOfflineHeritages(language = 'vi') {
  try {
    const cachedJson = await AsyncStorage.getItem(OFFLINE_STORAGE_KEY);
    if (cachedJson) {
      const parsed = JSON.parse(cachedJson);
      if (Array.isArray(parsed?.heritages) && parsed.heritages.length > 0) {
        const translated = applyTranslations(parsed.heritages, parsed.translations || heritageSeedData?.translations || [], language);
        return adaptHeritageList(translated);
      }
    }
  } catch (err) {
    console.warn('[offlineStorageService] Không đọc được AsyncStorage, chuyển sang seed data:', err.message);
  }

  // Fallback an toàn tuyệt đối sang dữ liệu hạt giống nhúng sẵn
  return getSeedHeritages(language);
}

/**
 * Lưu trữ danh sách di sản đã được cập nhật mới nhất từ Backend/Supabase xuống AsyncStorage
 */
export async function saveOfflineHeritages(heritages = [], translations = null) {
  if (!Array.isArray(heritages) || heritages.length === 0) return false;
  try {
    const currentTranslations = translations || heritageSeedData?.translations || [];
    const payload = {
      version: 1,
      savedAt: new Date().toISOString(),
      heritages,
      translations: currentTranslations,
    };
    await AsyncStorage.setItem(OFFLINE_STORAGE_KEY, JSON.stringify(payload));
    await AsyncStorage.setItem(OFFLINE_TIMESTAMP_KEY, new Date().toISOString());
    return true;
  } catch (err) {
    console.warn('[offlineStorageService] Lỗi lưu AsyncStorage:', err.message);
    return false;
  }
}

/**
 * Lấy mốc thời gian đồng bộ thành công gần nhất
 */
export async function getLastSyncedTime() {
  try {
    return await AsyncStorage.getItem(OFFLINE_TIMESTAMP_KEY);
  } catch {
    return null;
  }
}

export default {
  getSeedHeritages,
  getOfflineHeritages,
  saveOfflineHeritages,
  getLastSyncedTime,
};
