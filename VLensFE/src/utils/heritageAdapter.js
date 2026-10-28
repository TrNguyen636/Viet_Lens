/**
 * Bộ chuyển đổi dữ liệu (Data Adapter) cho Di sản văn hóa VietLens.
 * Chuẩn hóa đối tượng trả về từ Spring Boot (HeritageResponseDTO)
 * để tương thích mượt mà với tất cả các Component giao diện hiện tại của Frontend.
 */

export const DEFAULT_HERITAGE_IMAGE =
  'https://images.unsplash.com/photo-1528127269322-539801943592?auto=format&fit=crop&w=800&q=80';

/**
 * Trích xuất đoạn tóm tắt ngắn từ mô tả dài của Backend
 */
function extractSummary(text, maxLength = 160) {
  if (!text) return 'Di tích lịch sử và danh lam văn hóa tiêu biểu của Việt Nam.';
  // Loại bỏ các dấu gạch đầu dòng câu hỏi nếu có
  const clean = text.replace(/^-\s*/, '').trim();
  const firstSentence = clean.split('\n')[0];
  if (firstSentence.length <= maxLength) return firstSentence;
  return firstSentence.substring(0, maxLength).trim() + '...';
}

/**
 * Chuẩn hóa 1 di sản từ backend sang format Frontend
 * @param {Object} item - HeritageResponseDTO từ Backend
 * @returns {Object} Đối tượng chuẩn hóa
 */
export function adaptHeritage(item) {
  if (!item) return null;

  // Lấy ảnh: ưu tiên imageUrl hoặc image_url từ Supabase Storage, fallback sang image hoặc default
  const image = item.imageUrl || item.image_url || item.image || DEFAULT_HERITAGE_IMAGE;

  // Tọa độ địa lý
  const latitude = item.latitude ?? item.lat ?? 16.0544;
  const longitude = item.longitude ?? item.lng ?? 108.2022;

  // Tên địa phương hiển thị
  const locationName = item.province || item.address?.split(',')[0] || item.locationName || 'Việt Nam';

  // Mô tả
  const description = item.description || item.summary || '';
  const summary = item.summary || item.shortDescription || extractSummary(description);

  return {
    ...item,
    id: item.id?.toString() || Math.random().toString(),
    name: item.name || 'Di sản văn hóa',
    category: item.category || 'Văn hóa',
    categoryLabel: item.categoryLabel || item.category || 'Di sản văn hóa',
    province: item.province || '',
    address: item.address || locationName,
    locationName: locationName,
    image: image,
    imageUrl: image,
    latitude: latitude,
    longitude: longitude,
    lat: latitude,
    lng: longitude,
    description: description,
    summary: summary,
    shortDescription: summary,
    dynasty: item.dynasty || item.province || 'Việt Nam cổ truyền',
    era: item.era || 'Di tích lịch sử văn hóa',
    distance: item.distance != null ? Number(item.distance) : null,
    // Cờ đánh dấu dữ liệu từ Backend thật
    isRealData: Boolean(item.id && (item.latitude || item.imageUrl)),
  };
}

/**
 * Kiểm tra xem di sản có phải là công trình / địa danh vật thể cố định không
 * (Tạm thời loại trừ Ẩm thực và Lễ hội trên bản đồ/danh sách chính theo yêu cầu)
 */
export function isPhysicalHeritage(category) {
  if (!category) return true;
  const lower = category.toLowerCase();
  return (
    !lower.includes('ẩm thực') &&
    !lower.includes('am thuc') &&
    !lower.includes('lễ hội') &&
    !lower.includes('le hoi')
  );
}

/**
 * Chuẩn hóa một mảng di sản (đã lọc danh mục Ẩm thực và Lễ hội)
 * @param {Array} list - Mảng HeritageResponseDTO
 * @returns {Array} Mảng các đối tượng đã chuẩn hóa
 */
export function adaptHeritageList(list) {
  if (!Array.isArray(list)) return [];
  return list
    .map(adaptHeritage)
    .filter((item) => item && isPhysicalHeritage(item.category));
}

export default {
  adaptHeritage,
  adaptHeritageList,
  isPhysicalHeritage,
  DEFAULT_HERITAGE_IMAGE,
};
