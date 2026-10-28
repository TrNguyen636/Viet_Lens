import { getAiMicroserviceBaseUrl } from '../utils/networkConfig';

/**
 * Lấy Base URL của Python AI Microservice (PaiService) tự động nhận diện host IP qua Expo Constants
 */
export const getAiBaseUrl = () => {
  return getAiMicroserviceBaseUrl();
};

/**
 * Tải ảnh lên bằng XMLHttpRequest (Khắc phục triệt để lỗi "Unsupported FormDataPart" của React Native 0.86)
 */
const uploadWithXHR = (url, imageUri) => {
  return new Promise((resolve, reject) => {
    const startTime = Date.now();
    const xhr = new XMLHttpRequest();
    xhr.open('POST', url);
    xhr.timeout = 25000;
    xhr.setRequestHeader('Accept', 'application/json');
    xhr.setRequestHeader('Bypass-Tunnel-Reminder', 'true');

    xhr.onload = () => {
      const durationMs = Date.now() - startTime;
      try {
        if (xhr.status >= 200 && xhr.status < 300) {
          console.log(`[AI Vision Diagnostic] Path 2 succeeded: HTTP ${xhr.status} in ${durationMs}ms`);
          resolve(JSON.parse(xhr.responseText));
        } else {
          let errDetail = '';
          try {
            const errObj = JSON.parse(xhr.responseText);
            errDetail = typeof errObj?.detail === 'string' ? errObj.detail : JSON.stringify(errObj);
          } catch (_) {
            errDetail = xhr.responseText || '';
          }
          const safeDetail = (errDetail || `Status: ${xhr.status}`).slice(0, 200);
          console.warn(`[AI Vision Diagnostic] Path 2 failed: HTTP ${xhr.status} in ${durationMs}ms - Error: ${safeDetail}`);
          reject(new Error(`HTTP ${xhr.status}: ${safeDetail}`));
        }
      } catch (e) {
        const safeMsg = (e?.message || 'Parse error').slice(0, 200);
        console.warn(`[AI Vision Diagnostic] Path 2 response parse error in ${durationMs}ms: ${safeMsg}`);
        reject(new Error(`Parse error: ${safeMsg}`));
      }
    };

    xhr.onerror = () => {
      const durationMs = Date.now() - startTime;
      console.warn(`[AI Vision Diagnostic] Path 2 network error in ${durationMs}ms`);
      reject(new Error('Lỗi kết nối mạng (Network request failed)'));
    };

    xhr.ontimeout = () => {
      const durationMs = Date.now() - startTime;
      console.warn(`[AI Vision Diagnostic] Path 2 timeout after ${durationMs}ms`);
      const err = new Error('Quá thời gian kết nối đến máy chủ AI (Timeout after 25s)');
      err.code = 'TIMEOUT';
      reject(err);
    };

    const filename = imageUri.split('/').pop() || 'photo_scan.jpg';
    const match = /\.(\w+)$/.exec(filename);
    const mimeType = match && match[1].toLowerCase() === 'png' ? 'image/png' : 'image/jpeg';

    const formData = new FormData();
    formData.append('file', {
      uri: Platform.OS === 'android' ? imageUri : imageUri.replace('file://', ''),
      name: filename,
      type: mimeType,
    });

    xhr.send(formData);
  });
};

/**
 * Gửi ảnh chụp hoặc ảnh từ thư viện lên Python AI Microservice để nhận diện di sản
 * Hỗ trợ cả Base64 JSON (nhanh & ổn định) và XMLHttpRequest Multipart fallback
 * @param {string} imageUri - Đường dẫn ảnh cục bộ trên thiết bị
 * @param {string} lang - Mã ngôn ngữ 'vi' hoặc 'en'
 * @param {string|null} base64Data - Chuỗi base64 của ảnh (tùy chọn)
 * @returns {Promise<Object>} Thông tin chi tiết di sản nhận diện được
 */
export const predictHeritage = async (imageUri, lang = 'vi', base64Data = null) => {
  const baseUrl = getAiBaseUrl();
  const safeLang = lang && lang.startsWith('en') ? 'en' : 'vi';

  const hasBase64 = Boolean(base64Data);
  const base64Length = typeof base64Data === 'string' ? base64Data.length : 0;
  const hasImageUri = Boolean(imageUri);

  console.log('[AI Vision Diagnostic] Request initiated:', {
    hasBase64,
    base64Length,
    hasImageUri,
    lang: safeLang,
    baseUrl,
  });

  let rawData = null;
  let path1Error = null;
  let path2Error = null;

  // 1. Path 1: POST JSON trực tiếp tới /api/v1/predict-base64 khi có base64Data
  if (base64Data) {
    const endpoint = `${baseUrl}/api/v1/predict-base64`;
    const controller = new AbortController();
    const startTime = Date.now();
    let timedOut = false;
    const timeoutId = setTimeout(() => {
      timedOut = true;
      controller.abort();
    }, 20000);

    try {
      console.log(`[AI Vision Diagnostic] Path 1 starting: POST JSON to ${endpoint}`);
      const response = await fetch(endpoint, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'Bypass-Tunnel-Reminder': 'true',
        },
        body: JSON.stringify({
          image_base64: base64Data,
          lang: safeLang,
        }),
        signal: controller.signal,
      });

      const durationMs = Date.now() - startTime;

      if (response.ok) {
        rawData = await response.json();
        console.log(`[AI Vision Diagnostic] Path 1 succeeded: HTTP ${response.status} in ${durationMs}ms`);
      } else {
        let errDetail = '';
        try {
          const errJson = await response.json();
          errDetail = typeof errJson?.detail === 'string' ? errJson.detail : JSON.stringify(errJson);
        } catch (_) {
          errDetail = await response.text().catch(() => '');
        }
        const safeDetail = (errDetail || 'Unknown error').slice(0, 200);
        path1Error = new Error(`HTTP ${response.status}: ${safeDetail}`);
        console.warn(`[AI Vision Diagnostic] Path 1 failed: HTTP ${response.status} in ${durationMs}ms - Error: ${safeDetail}`);
      }
    } catch (err) {
      const durationMs = Date.now() - startTime;
      const isTimeout = timedOut || err?.name === 'AbortError';
      const errMsg = isTimeout
        ? 'Request timed out after 20000ms'
        : (err?.message || 'Network/Fetch error').slice(0, 200);
      path1Error = new Error(errMsg);
      console.warn(`[AI Vision Diagnostic] Path 1 exception in ${durationMs}ms: ${errMsg}`);
    } finally {
      clearTimeout(timeoutId);
    }
  }

  // 2. Path 2: Fallback XMLHttpRequest Multipart tới /api/v1/predict?lang=...
  if (!rawData && imageUri) {
    const endpoint = `${baseUrl}/api/v1/predict?lang=${safeLang}`;
    console.log(`[AI Vision Diagnostic] Path 2 starting: fallback XMLHttpRequest to ${endpoint}`);
    try {
      rawData = await uploadWithXHR(endpoint, imageUri);
    } catch (err) {
      path2Error = err;
      console.warn(`[AI Vision Diagnostic] Path 2 failed: ${(err?.message || 'Unknown XHR error').slice(0, 200)}`);
    }
  }

  if (!rawData) {
    const p1Msg = path1Error ? path1Error.message : (base64Data ? 'Failed without detail' : 'Skipped (no base64)');
    const p2Msg = path2Error ? path2Error.message : (imageUri ? 'Failed without detail' : 'Skipped (no imageUri)');
    const combinedError = new Error(
      `AI Vision Failed. [Path 1 Base64]: ${p1Msg} | [Path 2 XHR]: ${p2Msg}`
    );
    console.error('[AI Vision Diagnostic] Both paths failed:', combinedError.message);
    throw combinedError;
  }

  return {
    success: true,
    recognized: rawData.recognized !== false,
    rejectionReason: rawData.rejection_reason || null,
    heritageId: rawData.heritage_id,
    name: rawData.heritage_name,
    confidenceScore: rawData.confidence_score, // ví dụ: 0.85
    rawSimilarity: rawData.raw_similarity || rawData.confidence_score,
    confidencePercent: (rawData.confidence_score * 100).toFixed(1), // ví dụ: "85.0"
    category: rawData.category,
    province: rawData.province,
    address: rawData.address,
    description: rawData.description,
    imageUrl: rawData.image_url,
    latitude: rawData.latitude,
    longitude: rawData.longitude,
    language: rawData.language,
    visionReasoning: rawData.vision_reasoning || null,
    alternativeCandidates: Array.isArray(rawData.alternative_candidates) ? rawData.alternative_candidates : [],
  };
};
