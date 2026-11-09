/**
 * VLENS MODEL AI CHAT SERVICE
 * -----------------------------------------------------------
 * Dịch vụ giao tiếp trực tiếp với microservice VLensModel (FastAPI port 8000).
 * Sử dụng định dạng JSON thuần qua endpoint /process-json để loại bỏ 100%
 * lỗi "Unsupported FormDataPart implementation" trên React Native / Android.
 * 
 * Phạm vi:
 * - Gửi ảnh (Base64) + câu hỏi tùy chọn để nhận diện di sản văn hóa
 * - Trò chuyện văn bản hỏi đáp sâu về lịch sử, kiến trúc theo ngữ cảnh di sản
 * - Tự động loại bỏ thông tin thời tiết & địa điểm xung quanh (giữ giao diện chat tinh gọn)
 * - Tích hợp cơ chế Timeout an toàn chống treo app khi server chưa bật
 */

import { getAiMicroserviceBaseUrl } from '../utils/networkConfig';
import { groundWithDatabase } from './aiVisionService';

const REQUEST_TIMEOUT_MS = 65000; // 65 giây tối đa cho pipeline AI đa phương thức (Ngrok + Qwen Vision + Groq)

/**
 * Nhận diện ngôn ngữ mục tiêu dựa trên câu hỏi người dùng và ngôn ngữ giao diện
 */
function detectEffectiveLanguage(text, defaultLang = 'vi') {
  const isEn = defaultLang && defaultLang.toLowerCase().startsWith('en');
  const isJa = defaultLang && defaultLang.toLowerCase().startsWith('ja');
  const userTypedJa = text && /[\u3040-\u30ff\u3400-\u4dbf\u4e00-\u9fff]/.test(text);
  const userTypedEn = text &&
    !/[àáảãạăằắẳẵặâầấẩẫậèéẻẽẹêềếểễệìíỉĩịòóỏõọôồốổỗộơờớởỡợùúủũụưừứửữựỳýỷỹỵđ]/i.test(text) &&
    /\b(what|where|how|tell|who|please|is|are|bridge|temple|pagoda|history|architecture|information|summarize|identify)\b/i.test(text);
  return (isJa || userTypedJa) ? 'ja' : ((isEn || userTypedEn) ? 'en' : 'vi');
}

/**
 * Fetch an toàn có gắn bộ đếm thời gian Timeout chống treo ứng dụng
 */
async function fetchWithTimeout(url, options = {}, timeoutMs = REQUEST_TIMEOUT_MS) {
  const controller = new AbortController();
  const timer = setTimeout(() => {
    controller.abort();
  }, timeoutMs);

  try {
    const response = await fetch(url, {
      ...options,
      signal: controller.signal,
    });
    return response;
  } catch (err) {
    if (err.name === 'AbortError') {
      throw new Error(
        `Không nhận được phản hồi từ VLensModel sau ${timeoutMs / 1000}s. Hãy đảm bảo bạn đã chạy song song cả run_mock.bat và run_model.bat!`
      );
    }
    throw err;
  } finally {
    clearTimeout(timer);
  }
}

/**
 * Gửi ảnh chụp/tải lên kèm câu hỏi của người dùng tới VLensModel (:8000/process-json)
 *
 * @param {string} imageUri - Đường dẫn file ảnh cục bộ trên thiết bị
 * @param {string|null} imageBase64 - Chuỗi Base64 của ảnh (từ ImagePicker)
 * @param {string|null} userQuestion - Câu hỏi người dùng nhập (nếu có)
 * @param {string} lang - 'vi', 'en' hoặc 'ja'
 * @returns {Promise<Object>} Kết quả nhận diện và lời thoại giải thích
 */
export async function sendPhotoAndQuestionToModel(imageUri, imageBase64 = null, userQuestion = null, lang = 'vi') {
  const baseUrl = getAiMicroserviceBaseUrl();
  const isEn = lang && lang.toLowerCase().startsWith('en');
  const isJa = lang && lang.toLowerCase().startsWith('ja');
  const defaultPrompt = isJa
    ? 'この写真に写っているベトナムの文化遺産や名所を特定し、その歴史と建築について日本語で簡潔に紹介してください。'
    : (isEn
      ? 'Please identify which Vietnamese heritage site or landmark is in this photo, and provide a concise summary of its history and architecture.'
      : 'Hãy cho tôi biết đây là danh lam thắng cảnh / di tích nào tại Việt Nam và giới thiệu ngắn gọn về lịch sử, kiến trúc của nó bằng tiếng Việt.');

  const promptText = userQuestion && userQuestion.trim()
    ? `${userQuestion.trim()}\n(${defaultPrompt})`
    : defaultPrompt;

  const endpoint = `${baseUrl}/process-json`;
  console.log(`[VLensModel JSON] Gửi ảnh Base64 tới AI endpoint: ${endpoint}`);

  const targetLanguage = detectEffectiveLanguage(userQuestion, lang);

  const payload = {
    prompt: promptText,
    image_base64: imageBase64 || null,
    language: targetLanguage,
  };

  const response = await fetchWithTimeout(endpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`VLensModel HTTP ${response.status}: ${errorText || response.statusText}`);
  }

  const data = await response.json();

  // Kiểm tra nếu Vision Server (8082 hoặc Ngrok Colab) chưa bật / không kết nối được
  if (
    data.vision_error === 'VISION_SERVER_UNREACHABLE' ||
    (data.landmark === 'Unknown' &&
      typeof data.answer === 'string' &&
      (data.answer.includes('Ngrok might be down') || data.answer.includes('Cannot connect to Vision Server')))
  ) {
    throw new Error(
      'Vision Server (port 8082 hoặc Colab Ngrok) hiện đang tắt! Hãy bật run_mock.bat (hoặc kiểm tra PINGGY_URL).'
    );
  }

  // Kiểm tra nếu mô hình từ chối ảnh ngoài miền (Out-Of-Domain: selfie, đồ ăn...)
  if (data.landmark === 'OUT_OF_DOMAIN' || (data.landmark === 'Unknown' && data.confidence < 0.2)) {
    return {
      success: true,
      isOutOfDomain: true,
      message: isJa
        ? 'この画像はベトナムの文化遺産や名所として認識されませんでした。別の角度や別の場所をお試しください！'
        : (isEn
          ? 'This image does not appear to be a recognized Vietnamese cultural heritage or landmark. Please try capturing another angle or site!'
          : 'Hình ảnh này dường như không thuộc danh lam thắng cảnh hoặc di tích văn hóa Việt Nam. Bạn hãy thử chụp lại góc khác hoặc di tích khác nhé!'),
      raw: data,
    };
  }

  const rawLandmark = data.landmark || (isJa ? 'ベトナムの遺産' : (isEn ? 'Vietnam Landmark' : 'Di tích Việt Nam'));
  const rawCity = data.city && data.city !== 'Unknown' ? data.city : (isJa ? 'ベトナム' : (isEn ? 'Vietnam' : 'Việt Nam'));

  // Stage 2: Đối chiếu tên di sản & tỉnh thành với CSDL thực tế (Supabase Grounding)
  // Gắn timeout 3s để không bao giờ làm nghẽn hiển thị câu trả lời AI nếu backend chậm
  let groundedSite = null;
  try {
    const groundPromise = groundWithDatabase(rawLandmark, rawCity);
    const timeoutPromise = new Promise((resolve) => setTimeout(() => resolve(null), 3000));
    groundedSite = await Promise.race([groundPromise, timeoutPromise]);
  } catch (groundErr) {
    console.warn('[VLensModel Grounding] Không thể đối chiếu CSDL di sản:', groundErr.message);
  }

  const finalLandmark = groundedSite?.name || rawLandmark;
  const finalCity = groundedSite?.province || groundedSite?.locationName || rawCity;
  const finalLat = groundedSite?.latitude != null ? Number(groundedSite.latitude) : null;
  const finalLng = groundedSite?.longitude != null ? Number(groundedSite.longitude) : null;
  const finalAddress =
    groundedSite?.address || (finalCity ? `${finalLandmark}, ${finalCity}` : finalLandmark);
  const finalCategory =
    groundedSite?.category || (isJa ? '文化遺産・建築' : (isEn ? 'Cultural Heritage' : 'Kiến trúc & Di sản văn hóa'));

  return {
    success: true,
    isOutOfDomain: false,
    grounded: Boolean(groundedSite),
    heritageId: groundedSite?.id || `vlens-${Date.now()}`,
    landmark: finalLandmark,
    city: finalCity,
    address: finalAddress,
    category: finalCategory,
    latitude: !isNaN(finalLat) ? finalLat : null,
    longitude: !isNaN(finalLng) ? finalLng : null,
    imageUrl: groundedSite?.imageUrl || groundedSite?.image || imageUri,
    confidence: Math.round((data.confidence || 0.94) * 100),
    answer: data.answer || groundedSite?.description || '',
    description: groundedSite?.description || data.answer || '',
    raw: data,
  };
}

/**
 * Gửi câu hỏi văn bản thuần túy tới VLensModel (Text-only Q&A)
 *
 * @param {string} question - Câu hỏi của người dùng
 * @param {Object|null} currentSite - Ngữ cảnh di tích đang tìm hiểu (nếu có)
 * @param {string} lang - 'vi', 'en' hoặc 'ja'
 * @returns {Promise<string>} Câu trả lời từ AI
 */
export async function sendTextQuestionToModel(question, currentSite = null, lang = 'vi') {
  if (!question || !question.trim()) {
    return '';
  }

  const baseUrl = getAiMicroserviceBaseUrl();
  const isEn = lang && lang.toLowerCase().startsWith('en');
  const isJa = lang && lang.toLowerCase().startsWith('ja');

  let contextualPrompt = question.trim();
  if (currentSite && currentSite.name) {
    const siteName = currentSite.name;
    const location = currentSite.city || currentSite.province || (isJa ? 'ベトナム' : (isEn ? 'Vietnam' : 'Việt Nam'));
    contextualPrompt = isJa
      ? `旅行者は「${siteName}」(${location})について質問しています。文化的背景を踏まえ、丁寧な日本語で簡潔に回答してください: "${question.trim()}"`
      : (isEn
        ? `The user is exploring "${siteName}" (${location}). Answer this question concisely with cultural depth: "${question.trim()}"`
        : `Du khách đang tìm hiểu về di tích "${siteName}" (${location}). Hãy trả lời câu hỏi sau một cách súc tích, chuẩn xác và giàu cảm xúc văn hóa: "${question.trim()}"`);
  }

  const targetLanguage = detectEffectiveLanguage(question, lang);

  const payload = {
    prompt: contextualPrompt,
    image_base64: null,
    language: targetLanguage,
  };

  const endpoint = `${baseUrl}/process-json`;
  console.log(`[VLensModel Text] Gửi câu hỏi văn bản tới AI: ${endpoint} (Ngôn ngữ: ${targetLanguage})`);

  const response = await fetchWithTimeout(endpoint, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
    body: JSON.stringify(payload),
  });

  if (!response.ok) {
    const errorText = await response.text();
    throw new Error(`VLensModel HTTP ${response.status}: ${errorText || response.statusText}`);
  }

  const data = await response.json();
  return data.answer || '';
}

export default {
  sendPhotoAndQuestionToModel,
  sendTextQuestionToModel,
};
