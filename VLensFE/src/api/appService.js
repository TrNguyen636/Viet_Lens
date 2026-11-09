import axiosClient from './axiosClient';
import { supabase } from '../services/supabase';

/**
 * Service chứa toàn bộ các hàm gọi API đến Spring Boot Backend (JBE)
 */
export const appService = {
  // ============================================================
  // 1. HERITAGE APIS (Di sản văn hóa & Địa danh)
  // ============================================================

  /**
   * Lấy toàn bộ danh sách di sản văn hóa
   * Endpoint: GET /api/heritage/all
   * @returns {Promise<Array>} List<HeritageResponseDTO>
   */
  getAllHeritage: async () => {
    return await axiosClient.get('/api/heritage/all');
  },

  /**
   * Tìm kiếm di sản theo từ khóa (tên, địa chỉ, mô tả, tỉnh thành)
   * Endpoint: GET /api/heritage/search?keyword=...
   * @param {string} keyword
   * @returns {Promise<Array>} List<HeritageResponseDTO>
   */
  searchHeritage: async (keyword) => {
    return await axiosClient.get('/api/heritage/search', {
      params: { keyword },
    });
  },

  /**
   * Lấy danh sách di sản lân cận toạ độ GPS
   * Endpoint: GET /api/heritage/nearby?lat=...&lng=...&radius=...&limit=...
   * @param {number} lat - Vĩ độ
   * @param {number} lng - Kinh độ
   * @param {number} radius - Bán kính km (mặc định 10km)
   * @param {number} limit - Số lượng kết quả tối đa
   * @returns {Promise<Array>} List<HeritageResponseDTO> có kèm trường distance
   */
  getNearbyHeritage: async (lat, lng, radius = 15.0, limit = 20) => {
    return await axiosClient.get('/api/heritage/nearby', {
      params: { lat, lng, radius, limit },
    });
  },

  /**
   * Lấy danh sách di sản theo khung nhìn Bounding Box (Bước 3)
   * Endpoint: GET /api/heritage/bbox?minLat=...&minLng=...&maxLat=...&maxLng=...&limit=...
   */
  getHeritageByBBox: async (minLat, minLng, maxLat, maxLng, limit = 100, signal = null) => {
    try {
      return await axiosClient.get('/api/heritage/bbox', {
        params: { minLat, minLng, maxLat, maxLng, limit },
        signal,
        timeout: 6000,
      });
    } catch (err) {
      if (err?.name === 'CanceledError' || err?.name === 'AbortError') {
        throw err;
      }
      // Dự phòng truy vấn trực tiếp từ CSDL Supabase của dự án nếu Spring Boot chưa restart
      const sMinLat = Math.min(minLat, maxLat);
      const sMaxLat = Math.max(minLat, maxLat);
      const sMinLng = Math.min(minLng, maxLng);
      const sMaxLng = Math.max(minLng, maxLng);
      const { data, error } = await supabase
        .from('heritage_info')
        .select('id, name, description, category, province, address, latitude, longitude, image_url')
        .gte('latitude', sMinLat)
        .lte('latitude', sMaxLat)
        .gte('longitude', sMinLng)
        .lte('longitude', sMaxLng)
        .limit(limit);
      if (error) throw error;
      return (data || []).map((item) => ({
        ...item,
        imageUrl: item.image_url,
      }));
    }
  },

  /**
   * Tính toán tuyến đường nội bộ qua Backend (Bước 4: KHÔNG dùng Google Directions/Routes API)
   * Endpoint: POST /api/routes
   */
  calculateRoute: async (originLat, originLng, destLat, destLng, mode = 'driving') => {
    try {
      return await axiosClient.post(
        '/api/routes',
        {
          originLat,
          originLng,
          destLat,
          destLng,
          mode,
        },
        { timeout: 6000 }
      );
    } catch (_err) {
      // Dự phòng định tuyến OSRM nếu Backend Spring Boot chưa restart
      const osrmUrl = `https://router.project-osrm.org/route/v1/${mode}/${originLng},${originLat};${destLng},${destLat}?overview=full&geometries=geojson`;
      const res = await fetch(osrmUrl);
      const json = await res.json();
      if (json.routes && json.routes.length > 0) {
        const route = json.routes[0];
        const distanceKm = Number((route.distance / 1000).toFixed(1));
        const durationMin = Math.max(1, Math.round(route.duration / 60));
        const points = (route.geometry?.coordinates || []).map(([lng, lat]) => ({
          latitude: lat,
          longitude: lng,
        }));
        return { distanceKm, durationMin, points };
      }
      throw new Error('Không tìm thấy tuyến đường');
    }
  },

  /**
   * Lấy chi tiết di sản theo ID (UUID)
   * Endpoint: GET /api/heritage/{id}
   * @param {string} id - UUID di sản
   * @returns {Promise<Object>} HeritageResponseDTO
   */
  getHeritageById: async (id) => {
    if (!id) return null;
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(String(id))) {
      return null;
    }
    return await axiosClient.get(`/api/heritage/${id}`);
  },

  // ============================================================
  // 2. INTERACTIONS & BOOKMARKS (Di sản đã lưu / Yêu thích)
  // ============================================================

  /**
   * Toggle Bookmark di sản (Lưu hoặc Huỷ lưu)
   * Endpoint: POST /api/interactions/bookmark/{heritageId}
   * @param {string} heritageId
   * @returns {Promise<Object>} { bookmarked: boolean, message: string }
   */
  toggleBookmark: async (heritageId) => {
    return await axiosClient.post(`/api/interactions/bookmark/${heritageId}`);
  },

  /**
   * Lấy danh sách tất cả di sản đã lưu của người dùng hiện tại
   * Endpoint: GET /api/interactions/bookmarks
   * @returns {Promise<Array>} List<HeritageResponseDTO>
   */
  getUserBookmarks: async () => {
    return await axiosClient.get('/api/interactions/bookmarks');
  },

  // ============================================================
  // 3. GROQ AI CHATBOT (Trợ lý Di sản VietLens)
  // ============================================================

  /**
   * Gửi tin nhắn trò chuyện với Trợ lý Di sản VietLens
   * Endpoint: POST /api/ai/chat
   * @param {string} heritageId - UUID của di sản văn hóa
   * @param {string} message    - Nội dung câu hỏi từ người dùng
   * @returns {Promise<Object>} ChatResponseDTO chứa câu trả lời từ AI
   */
  sendChatMessage: async (heritageId, message) => {
    const payload = {
      heritageId,
      message,
    };
    return await axiosClient.post('/api/ai/chat', payload);
  },

  // ============================================================
  // 4. CHAT HISTORY (Lịch sử trò chuyện qua Spring Boot JBE)
  // ============================================================

  /**
   * Lấy toàn bộ danh sách phiên trò chuyện của người dùng
   * Endpoint: GET /api/chat/sessions
   * @returns {Promise<Array>} List<SessionResponseDTO>
   */
  getChatSessions: async () => {
    return await axiosClient.get('/api/chat/sessions');
  },

  /**
   * Tạo phiên trò chuyện mới
   * Endpoint: POST /api/chat/sessions
   * @param {string} title
   * @param {string|null} heritageId
   * @returns {Promise<Object>} SessionResponseDTO
   */
  createChatSession: async (title = 'Cuộc trò chuyện mới', heritageId = null) => {
    return await axiosClient.post('/api/chat/sessions', {
      title,
      heritageId,
    });
  },

  /**
   * Lấy toàn bộ tin nhắn thuộc một phiên trò chuyện
   * Endpoint: GET /api/chat/sessions/{sessionId}/messages
   * @param {string} sessionId
   * @returns {Promise<Array>} List<MessageResponseDTO>
   */
  getChatSessionMessages: async (sessionId) => {
    return await axiosClient.get(`/api/chat/sessions/${sessionId}/messages`);
  },

  /**
   * Thêm tin nhắn vào một phiên trò chuyện
   * Endpoint: POST /api/chat/sessions/{sessionId}/messages
   * @param {string} sessionId
   * @param {Object} messageData { sender, content, imageUrl, confidenceScore }
   * @returns {Promise<Object>} MessageResponseDTO
   */
  addChatMessage: async (sessionId, messageData = {}) => {
    return await axiosClient.post(`/api/chat/sessions/${sessionId}/messages`, messageData);
  },

  /**
   * Xóa một phiên trò chuyện
   * Endpoint: DELETE /api/chat/sessions/{sessionId}
   * @param {string} sessionId
   * @returns {Promise<Object>} { success: boolean, message: string }
   */
  deleteChatSession: async (sessionId) => {
    return await axiosClient.delete(`/api/chat/sessions/${sessionId}`);
  },

  // ============================================================
  // 5. USER & AUTH SYNC
  // ============================================================

  /**
   * Lấy thông tin hồ sơ của người dùng hiện tại từ Spring Boot Backend
   * Endpoint: GET /api/users/profile
   * @returns {Promise<Object>} UserResponse DTO từ backend
   */
  getUserProfile: async () => {
    return await axiosClient.get('/api/users/profile');
  },

  /**
   * Đồng bộ user từ Supabase Auth vào bảng users trong CSDL PostgreSQL của Backend
   * Endpoint: POST /api/users/sync
   * @param {Object} userData - Thông tin người dùng { fullName, avatarUrl }
   * @returns {Promise<Object>} UserResponse DTO sau khi đồng bộ
   */
  syncUserProfile: async (userData = {}) => {
    return await axiosClient.post('/api/users/sync', userData);
  },
};

export default appService;
