import { getAiBaseUrl } from '../services/aiVisionService';

/**
 * Cấu hình hệ thống bản đồ Vector PMTiles Toàn Quốc và MapLibre GL JS
 */

export const MAP_CONFIG = {
  // Nguồn Vector Tile CDN Đám mây (OpenFreeMap Planet - Bao phủ 100% Việt Nam, miễn phí trọn đời, tải mượt trên 3G/5G/Wi-Fi)
  CLOUD_VECTOR_TILE_URL: 'https://tiles.openfreemap.org/planet',

  // Style vector trực tiếp từ OpenFreeMap (Tùy chọn)
  OPENFREEMAP_STYLE_URL: 'https://tiles.openfreemap.org/styles/bright',

  // Đường dẫn PMTiles nội bộ từ PaiService (Tùy chọn khi cần chạy offline hoàn toàn trên máy dev)
  get PMTILES_URL() {
    return `${getAiBaseUrl()}/tiles/vietnam.pmtiles`;
  },

  // Đường dẫn dự phòng vùng trọng điểm Đà Nẵng / Miền Trung trên Supabase Storage (18MB)
  FALLBACK_PMTILES_URL:
    'https://fjqgblqepphurmyyiusq.supabase.co/storage/v1/object/public/maps/danang.pmtiles',

  // Máy chủ chỉ đường OpenStreetMap miễn phí (OSRM Routing)
  OSRM_BASE_URL: 'https://router.project-osrm.org',

  // Trung tâm ban đầu: Cầu Rồng - Đà Nẵng (Điểm giữa hai miền đất nước)
  DEFAULT_CENTER: [108.2274, 16.0610],
  DEFAULT_ZOOM: 14.5,
  DEFAULT_PITCH: 45,
  DEFAULT_BEARING: -15,

  // Danh mục phím tắt bay nhanh đến các trọng điểm du lịch và di sản toàn quốc
  DESTINATIONS: {
    // --- Miền Bắc ---
    hanoi: {
      name: 'Hà Nội (Hồ Gươm)',
      region: 'Miền Bắc',
      emoji: '🏮',
      center: [105.8524, 21.0285],
      zoom: 15.5,
      pitch: 50,
      bearing: -20,
    },
    halong: {
      name: 'Vịnh Hạ Long',
      region: 'Miền Bắc',
      emoji: '⛵',
      center: [107.0843, 20.9101],
      zoom: 13.5,
      pitch: 45,
      bearing: 15,
    },
    ninhbinh: {
      name: 'Tràng An (Ninh Bình)',
      region: 'Miền Bắc',
      emoji: '🛶',
      center: [105.9189, 20.2506],
      zoom: 14.5,
      pitch: 55,
      bearing: 30,
    },
    sapa: {
      name: 'Sa Pa (Fansipan)',
      region: 'Miền Bắc',
      emoji: '⛰️',
      center: [103.8438, 22.3364],
      zoom: 14.0,
      pitch: 60,
      bearing: 45,
    },

    // --- Miền Trung ---
    hue: {
      name: 'Đại Nội Huế',
      region: 'Miền Trung',
      emoji: '🏯',
      center: [107.5786, 16.4698],
      zoom: 15.8,
      pitch: 50,
      bearing: 0,
    },
    danang: {
      name: 'Cầu Rồng (Đà Nẵng)',
      region: 'Miền Trung',
      emoji: '🌉',
      center: [108.2274, 16.0610],
      zoom: 15.8,
      pitch: 55,
      bearing: -30,
    },
    hoian: {
      name: 'Phố Cổ Hội An',
      region: 'Miền Trung',
      emoji: '🏮',
      center: [108.3283, 15.8770],
      zoom: 16.2,
      pitch: 50,
      bearing: 20,
    },
    sontra: {
      name: 'Bán Đảo Sơn Trà',
      region: 'Miền Trung',
      emoji: '🐒',
      center: [108.2800, 16.1200],
      zoom: 13.8,
      pitch: 45,
      bearing: -15,
    },

    // --- Miền Nam ---
    saigon: {
      name: 'TP. Hồ Chí Minh',
      region: 'Miền Nam',
      emoji: '🏙️',
      center: [106.6983, 10.7769],
      zoom: 15.5,
      pitch: 55,
      bearing: -25,
    },
    cantho: {
      name: 'Cần Thơ (Ninh Kiều)',
      region: 'Miền Nam',
      emoji: '🌾',
      center: [105.7877, 10.0342],
      zoom: 15.2,
      pitch: 45,
      bearing: 10,
    },
    phuquoc: {
      name: 'Đảo Phú Quốc',
      region: 'Miền Nam',
      emoji: '🏖️',
      center: [103.9630, 10.2289],
      zoom: 13.2,
      pitch: 40,
      bearing: 0,
    },
  },

  // Icon & màu sắc nhận diện theo phân loại di sản
  CATEGORY_META: {
    'Kiến trúc & Cung đình': { icon: '🏛️', color: '#ea580c' },
    'Danh lam thắng cảnh': { icon: '⛰️', color: '#0284c7' },
    'Di tích lịch sử': { icon: '⛩️', color: '#dc2626' },
    'Văn hóa & Đời sống': { icon: '🪕', color: '#d97706' },
    'Lễ hội truyền thống': { icon: '🏮', color: '#c026d3' },
    'Ẩm thực dân gian': { icon: '🍜', color: '#16a34a' },
    default: { icon: '📍', color: '#C62828' },
  },
};

export function getCategoryMeta(category) {
  if (!category) return MAP_CONFIG.CATEGORY_META.default;
  for (const [key, val] of Object.entries(MAP_CONFIG.CATEGORY_META)) {
    if (category.toLowerCase().includes(key.toLowerCase())) {
      return val;
    }
  }
  return MAP_CONFIG.CATEGORY_META.default;
}

export default MAP_CONFIG;
