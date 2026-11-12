import AsyncStorage from '@react-native-async-storage/async-storage';
import Constants from 'expo-constants';
import { Linking } from 'react-native';

const SKIPPED_BUILD_STORAGE_KEY = '@vietlens_skipped_update_build';
const REQUEST_TIMEOUT_MS = 5000;

/**
 * Đọc thông tin phiên bản hiện tại được nhúng trong app.json / build
 */
export function getCurrentAppVersionInfo() {
  const extra = Constants.expoConfig?.extra || {};
  const androidCfg = Constants.expoConfig?.android || {};
  const buildNumber = Number(extra.buildNumber ?? androidCfg.versionCode ?? 1);
  return {
    version: Constants.expoConfig?.version || '1.0.0',
    buildNumber: Number.isFinite(buildNumber) ? buildNumber : 1,
    githubRepo: extra.githubRepo || 'TrNguyen636/Viet_Lens',
  };
}

/**
 * Trích xuất số build từ tag_name (vd: "v1.0.12" -> 12) hoặc phần body release
 */
export function parseBuildNumberFromRelease(release) {
  const tag = String(release?.tag_name || '').trim();
  const tagMatch = tag.match(/(\d+)\s*$/);
  if (tagMatch) {
    return Number(tagMatch[1]);
  }
  const body = String(release?.body || '');
  const bodyMatch = body.match(/build\s*#\s*(\d+)/i);
  if (bodyMatch) {
    return Number(bodyMatch[1]);
  }
  return null;
}

/**
 * Đánh dấu bỏ qua thông báo cập nhật cho 1 build cụ thể
 */
export async function skipUpdateBuild(buildNumber) {
  try {
    await AsyncStorage.setItem(SKIPPED_BUILD_STORAGE_KEY, String(buildNumber));
  } catch {
    // Bỏ qua lỗi lưu storage không quan trọng
  }
}

/**
 * Mở trình duyệt tải file APK từ GitHub Releases
 */
export async function openUpdateDownload(downloadUrl) {
  if (!downloadUrl) return false;
  try {
    await Linking.openURL(downloadUrl);
    return true;
  } catch (err) {
    console.warn('[appUpdateService] Không thể mở link tải APK:', err?.message);
    return false;
  }
}

/**
 * Kiểm tra bản phát hành APK mới nhất trên GitHub Releases.
 * Luôn trả về null một cách an toàn nếu đang offline hoặc chưa có release nào.
 */
export async function checkForAppUpdate({ force = false } = {}) {
  const { version: currentVersion, buildNumber: currentBuildNumber, githubRepo } =
    getCurrentAppVersionInfo();

  const controller = new AbortController();
  const timer = setTimeout(() => controller.abort(), REQUEST_TIMEOUT_MS);

  try {
    const response = await fetch(`https://api.github.com/repos/${githubRepo}/releases/latest`, {
      headers: { Accept: 'application/vnd.github+json' },
      signal: controller.signal,
    });

    if (!response.ok) {
      return null;
    }

    const release = await response.json();
    const latestBuildNumber = parseBuildNumberFromRelease(release);
    if (!latestBuildNumber || latestBuildNumber <= currentBuildNumber) {
      return null;
    }

    const apkAsset = Array.isArray(release.assets)
      ? release.assets.find((asset) => String(asset?.name || '').toLowerCase().endsWith('.apk'))
      : null;

    if (!apkAsset?.browser_download_url) {
      return null;
    }

    if (!force) {
      const skipped = await AsyncStorage.getItem(SKIPPED_BUILD_STORAGE_KEY);
      if (skipped && Number(skipped) === latestBuildNumber) {
        return null;
      }
    }

    return {
      hasUpdate: true,
      currentVersion,
      currentBuildNumber,
      latestVersion: String(release.tag_name || '').replace(/^v/i, '') || `1.0.${latestBuildNumber}`,
      latestBuildNumber,
      releaseNotes: String(release.body || '').trim(),
      downloadUrl: apkAsset.browser_download_url,
      releasePageUrl: release.html_url || null,
    };
  } catch {
    return null;
  } finally {
    clearTimeout(timer);
  }
}
