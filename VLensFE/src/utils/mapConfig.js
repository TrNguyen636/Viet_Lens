/**
 * Cấu hình hệ thống bản đồ số VietLens (Tọa độ mặc định, danh mục bay nhanh toàn quốc, metadata di sản)
 */

export const MAP_CONFIG = {
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
};

export default MAP_CONFIG;
