import axiosClient from './axiosClient';

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
