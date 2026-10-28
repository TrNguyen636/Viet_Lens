import React, { useState, useEffect, useRef } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TouchableOpacity,
  Dimensions,
  Animated,
  ActivityIndicator,
  Image,
  Modal,
  Linking,
  Platform,
  LogBox,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { CameraView, useCameraPermissions } from 'expo-camera';
import * as ImagePicker from 'expo-image-picker';
import { useTranslation } from 'react-i18next';
import { THEME } from '../utils/theme';
import { predictHeritage } from '../services/aiVisionService';

// Tắt thông báo vàng vì ExpoCamera trên Android cần lồng View để giữ luồng SurfaceView không bị đen
LogBox.ignoreLogs(['The <CameraView> component does not support children']);

const { width } = Dimensions.get('window');
const SCAN_BOX_SIZE = width * 0.72;

export default function CameraScanScreen({ onNavigateToMap, onNavigateToChat, onSelectSite, onBack }) {
  const { t, i18n } = useTranslation();
  const [permission, requestPermission] = useCameraPermissions();

  useEffect(() => {
    console.log('[Camera Debug] Permission state:', {
      granted: permission?.granted,
      canAskAgain: permission?.canAskAgain,
      status: permission?.status,
    });
  }, [permission]);

  const [facing, setFacing] = useState('back'); // 'back' | 'front'
  const [flashOn, setFlashOn] = useState(false);
  const [isAnalyzing, setIsAnalyzing] = useState(false);
  const [detectedSite, setDetectedSite] = useState(null);
  const [recognitionError, setRecognitionError] = useState(null);
  const [capturedImage, setCapturedImage] = useState(null);
  const [permWaitTimeout, setPermWaitTimeout] = useState(false);
  const [cameraError, setCameraError] = useState(null);
  const [isCameraReady, setIsCameraReady] = useState(false);
  const [isReadyToMount, setIsReadyToMount] = useState(false);
  const [cameraKey, setCameraKey] = useState(0);

  const cameraRef = useRef(null);
  const analyzeTimerRef = useRef(null);

  // Kích hoạt mount CameraView sau 150ms để View hierarchy ổn định, dọn dẹp khi unmount
  useEffect(() => {
    const timer = setTimeout(() => {
      setIsReadyToMount(true);
      setCameraKey((prev) => prev + 1);
    }, 150);
    return () => {
      clearTimeout(timer);
      setIsCameraReady(false);
      setFlashOn(false);
    };
  }, []);

  // Scanner radar laser animation
  const scanAnim = useRef(new Animated.Value(0)).current;

  // Tự động kiểm tra và yêu cầu quyền truy cập khi vào màn hình lần đầu
  useEffect(() => {
    if (permission && !permission.granted && permission.canAskAgain) {
      requestPermission();
    }
  }, [permission]);

  // Bộ đếm thời gian tránh treo loading vĩnh viễn nếu permission hook chậm
  useEffect(() => {
    const timer = setTimeout(() => {
      setPermWaitTimeout(true);
    }, 2000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    const animation = Animated.loop(
      Animated.sequence([
        Animated.timing(scanAnim, {
          toValue: SCAN_BOX_SIZE - 4,
          duration: 2000,
          useNativeDriver: true,
        }),
        Animated.timing(scanAnim, {
          toValue: 0,
          duration: 2000,
          useNativeDriver: true,
        }),
      ])
    );

    animation.start();

    return () => {
      animation.stop();
      if (analyzeTimerRef.current) {
        clearTimeout(analyzeTimerRef.current);
      }
    };
  }, [scanAnim]);

  // Analyze photo & pop up result bottom sheet using Python AI Microservice
  const analyzePhoto = async (uri, base64Data = null) => {
    setCapturedImage(uri);
    setIsAnalyzing(true);
    setRecognitionError(null);
    setDetectedSite(null);

    try {
      const currentLang = i18n.language && i18n.language.startsWith('en') ? 'en' : 'vi';
      const result = await predictHeritage(uri, currentLang, base64Data);

      // Nếu AI từ chối ảnh lạ (recognized === false) hoặc điểm tin cậy < 45%
      if (!result.recognized || result.confidenceScore < 0.45) {
        setRecognitionError({
          type: result.rejectionReason === 'OUT_OF_DOMAIN' ? 'OUT_OF_DOMAIN' : 'LOW_CONFIDENCE',
          confidence: result.confidencePercent,
          reason: result.rejectionReason,
          message: result.visionReasoning || result.description,
        });
      } else {
        // Nhận diện thành công -> Nạp dữ liệu thực tế vào modal
        setDetectedSite({
          id: result.heritageId,
          name: result.name,
          image: result.imageUrl || uri,
          category: result.category,
          province: result.province,
          locationName: result.province,
          address: result.address,
          era: result.era || 'Di sản văn hóa Việt Nam',
          dynasty: result.dynasty || 'Cổ truyền',
          shortDescription: result.description,
          description: result.description,
          confidenceScore: result.confidenceScore,
          confidencePercent: result.confidencePercent,
          latitude: result.latitude,
          longitude: result.longitude,
          visionReasoning: result.visionReasoning,
          alternativeCandidates: result.alternativeCandidates || [],
        });
      }
    } catch (err) {
      console.warn('[AI Vision] Prediction error:', err);
      setRecognitionError({
        type: 'SERVER_ERROR',
        message: err.message,
      });
    } finally {
      setIsAnalyzing(false);
    }
  };

  // Capture real photo using CameraView (nén quality 0.65 để giảm đáng kể payload Base64)
  const handleCapture = async () => {
    if (cameraRef.current && isCameraReady) {
      try {
        const photo = await cameraRef.current.takePictureAsync({
          quality: 0.65, // Giảm từ 0.85 xuống 0.65 (giảm ~60% dung lượng base64, tăng tốc truyền mạng)
          base64: true,
        });
        if (photo && photo.uri) {
          analyzePhoto(photo.uri, photo.base64 || null);
          return;
        }
      } catch (err) {
        console.warn('Take picture error:', err);
      }
    }
    // Fallback mở thư viện ảnh nếu máy ảnh không chụp được
    handlePickFromGallery();
  };

  // Pick photo from gallery (kèm base64 tối ưu)
  const handlePickFromGallery = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ['images'],
        allowsEditing: true,
        aspect: [4, 3],
        quality: 0.65, // Giảm từ 0.85 xuống 0.65 để tránh nghẽn mạng
        base64: true,
      });

      if (!result.canceled && result.assets && result.assets.length > 0) {
        const asset = result.assets[0];
        analyzePhoto(asset.uri, asset.base64 || null);
      }
    } catch (e) {
      console.warn('Gallery pick error:', e);
    }
  };

  // Toggle front / back camera (cập nhật cameraKey để Android CameraX tái tạo SurfaceView sạch)
  const toggleFacing = () => {
    setFacing((current) => (current === 'back' ? 'front' : 'back'));
    setCameraKey((prev) => prev + 1);
    setIsCameraReady(false);
    setFlashOn(false);
  };

  if (!permission && !permWaitTimeout) {
    return (
      <View style={styles.centerContainer}>
        <ActivityIndicator size="large" color={THEME.colors.amber} />
        <Text style={[styles.permDesc, { marginTop: 16 }]}>{t('camera.initializing')}</Text>
      </View>
    );
  }

  if (!permission?.granted) {
    return (
      <View style={styles.centerContainer}>
        <View style={styles.permIconCircle}>
          <Ionicons name="camera-outline" size={48} color={THEME.colors.amber} />
        </View>
        <Text style={styles.permTitle}>{t('camera.permTitle')}</Text>
        <Text style={styles.permDesc}>{t('camera.permDesc')}</Text>

        <TouchableOpacity style={styles.grantBtn} onPress={requestPermission} activeOpacity={0.85}>
          <Ionicons name="shield-checkmark-outline" size={20} color="#FFF" />
          <Text style={styles.grantBtnText}>{t('camera.grantBtn')}</Text>
        </TouchableOpacity>

        {permission && !permission.canAskAgain && (
          <TouchableOpacity
            style={[styles.grantBtn, { backgroundColor: THEME.colors.ink, marginTop: 12 }]}
            onPress={() => Linking.openSettings()}
            activeOpacity={0.85}
          >
            <Ionicons name="settings-outline" size={20} color="#FFF" />
            <Text style={styles.grantBtnText}>{t('camera.openSettingsBtn')}</Text>
          </TouchableOpacity>
        )}

        <TouchableOpacity style={styles.galleryFallbackBtn} onPress={handlePickFromGallery} activeOpacity={0.7}>
          <Text style={styles.galleryFallbackText}>{t('camera.pickGallery')}</Text>
        </TouchableOpacity>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      {isReadyToMount && (
        <CameraView
          key={`cam-${facing}-${cameraKey}`}
          ref={cameraRef}
          style={styles.cameraView}
          facing={facing}
          mode="picture"
          autofocus="on"
          enableTorch={facing === 'back' && flashOn}
          onCameraReady={() => {
            console.log('[CameraView] Camera preview is ready.');
            setIsCameraReady(true);
            setCameraError(null);
          }}
          onMountError={(error) => {
            console.warn('[CameraView] Camera mount error:', error);
            setCameraError(error?.message || 'Không thể kết nối cảm biến máy ảnh');
          }}
        />
      )}

      {capturedImage && (
        <Image source={{ uri: capturedImage }} style={styles.cameraView} />
      )}

      {!isCameraReady && !cameraError && (
        <View style={styles.cameraLoadingOverlay} pointerEvents="none">
          <ActivityIndicator size="small" color={THEME.colors.amber} />
        </View>
      )}

      <View style={styles.overlayContainer} pointerEvents="box-none">
            <View style={styles.topBar}>
              <View style={styles.topLeftBox}>
                {onBack ? (
                  <TouchableOpacity style={styles.topIconBtn} onPress={onBack} activeOpacity={0.8}>
                    <Ionicons name="arrow-back" size={20} color="#FFF" />
                  </TouchableOpacity>
                ) : null}
              </View>

              <View style={styles.topCenterBox}>
                <View style={styles.modeBadge}>
                  <View style={styles.radarDot} />
                  <MaterialCommunityIcons name="radar" size={16} color={THEME.colors.yellow} />
                  <Text style={styles.modeBadgeText}>VIETLENS AI VISION</Text>
                </View>
              </View>

              <View style={styles.topRightBtns}>
                <TouchableOpacity
                  style={[styles.topIconBtn, flashOn && styles.topIconBtnActive]}
                  onPress={() => setFlashOn(!flashOn)}
                >
                  <Ionicons
                    name={flashOn ? 'flash' : 'flash-off-outline'}
                    size={20}
                    color={flashOn ? THEME.colors.yellow : '#FFF'}
                  />
                </TouchableOpacity>

                <TouchableOpacity style={styles.topIconBtn} onPress={toggleFacing}>
                  <Ionicons name="camera-reverse-outline" size={20} color="#FFF" />
                </TouchableOpacity>
              </View>
            </View>

            <View style={styles.viewfinderContainer} pointerEvents="box-none">
              <View style={styles.viewfinderBox}>
                <View style={[styles.corner, styles.topLeft]} />
                <View style={[styles.corner, styles.topRight]} />
                <View style={[styles.corner, styles.bottomLeft]} />
                <View style={[styles.corner, styles.bottomRight]} />

                <View style={styles.crosshairH} />
                <View style={styles.crosshairV} />

                {!isAnalyzing && !cameraError && (
                  <Animated.View
                    style={[
                      styles.scanLaser,
                      { transform: [{ translateY: scanAnim }] },
                    ]}
                  />
                )}

                {isAnalyzing && (
                  <View style={styles.analyzingOverlay}>
                    <ActivityIndicator size="large" color={THEME.colors.amber} />
                    <Text style={styles.analyzingText}>{t('camera.analyzing')}</Text>
                    <Text style={styles.analyzingSub}>{t('camera.analyzingSub')}</Text>
                  </View>
                )}

                {cameraError && !isAnalyzing && (
                  <View style={styles.cameraErrorOverlay}>
                    <Ionicons name="camera-reverse-outline" size={32} color={THEME.colors.amber} />
                    <Text style={styles.cameraErrorText}>Máy ảnh đang bận hoặc chưa sẵn sàng</Text>
                    <TouchableOpacity style={styles.galleryHeroBtn} onPress={handlePickFromGallery}>
                      <Ionicons name="images" size={16} color="#FFF" />
                      <Text style={styles.galleryHeroBtnText}>Chọn ảnh từ thư viện</Text>
                    </TouchableOpacity>
                  </View>
                )}
              </View>
              <Text style={styles.viewfinderGuide}>
                {isAnalyzing
                  ? t('camera.analyzing')
                  : t('camera.guideText')}
              </Text>
            </View>

            <View style={styles.bottomControls}>
              <View style={styles.bottomSideCol}>
                <TouchableOpacity style={styles.sideBtn} onPress={handlePickFromGallery} activeOpacity={0.75}>
                  <Ionicons name="images-outline" size={22} color="#FFF" />
                  <Text style={styles.sideBtnText}>{t('camera.pickGallery')}</Text>
                </TouchableOpacity>
              </View>

              <View style={styles.bottomCenterCol}>
                <TouchableOpacity
                  style={styles.shutterOuter}
                  onPress={handleCapture}
                  disabled={isAnalyzing}
                  activeOpacity={0.8}
                >
                  <View style={styles.shutterInner} />
                </TouchableOpacity>
              </View>

              {/* Cột giữ khoảng trống cân xứng để nút chụp ở đúng chính giữa */}
              <View style={styles.bottomSideCol} />
            </View>
          </View>

      {/* Recognition Result Modal / Bottom Sheet */}
      {detectedSite && (
        <Modal
          animationType="slide"
          transparent={true}
          visible={!!detectedSite}
          onRequestClose={() => {
            setDetectedSite(null);
            setCapturedImage(null);
          }}
        >
          <View style={styles.sheetBackdrop}>
            <View style={styles.bottomSheet}>
              <View style={styles.sheetHandle} />

              <TouchableOpacity
                style={styles.closeSheetBtn}
                onPress={() => {
                  setDetectedSite(null);
                  setCapturedImage(null);
                }}
              >
                <Ionicons name="close" size={22} color={THEME.colors.inkMuted} />
              </TouchableOpacity>

              <View style={styles.sheetRow}>
                <Image
                  source={{ uri: detectedSite?.image || 'https://images.unsplash.com/photo-1599707367072-cd6ada2bc375?auto=format&fit=crop&w=800&q=80' }}
                  style={styles.sheetThumb}
                />
                <View style={styles.sheetHeaderInfo}>
                  <View style={styles.verifiedBadge}>
                    <Ionicons name="checkmark-circle" size={14} color={THEME.colors.green} />
                    <Text style={styles.verifiedText}>
                      {t('camera.aiMatch')}: {detectedSite.confidencePercent || '98'}%
                    </Text>
                  </View>
                  <Text style={styles.sheetSiteName}>{detectedSite.name}</Text>
                  <Text style={styles.sheetDynasty}>{detectedSite.dynasty || detectedSite.province}</Text>
                </View>
              </View>

              <View style={styles.tagsRow}>
                <View style={styles.tagBadge}>
                  <Text style={styles.tagText}>{detectedSite.locationName || detectedSite.province}</Text>
                </View>
                <View style={[styles.tagBadge, { backgroundColor: THEME.colors.parchment }]}>
                  <Text style={[styles.tagText, { color: THEME.colors.amber }]}>
                    {detectedSite.era || detectedSite.category}
                  </Text>
                </View>
              </View>

              <Text style={styles.sheetSummary} numberOfLines={3}>
                {detectedSite.shortDescription || detectedSite.description}
              </Text>

              {/* Phân tích thị giác AI (Qwen2.5-VL) */}
              {detectedSite.visionReasoning && (
                <View style={styles.visionReasoningBox}>
                  <View style={styles.visionReasoningHeader}>
                    <Ionicons name="sparkles" size={13} color={THEME.colors.amber} />
                    <Text style={styles.visionReasoningTitle}>Phân tích thị giác AI (Qwen-VL)</Text>
                  </View>
                  <Text style={styles.visionReasoningText} numberOfLines={3}>
                    {detectedSite.visionReasoning}
                  </Text>
                </View>
              )}

              {/* Ứng viên / Địa danh tương đồng nếu có */}
              {detectedSite.alternativeCandidates?.length > 0 && (
                <View style={styles.candidatesRow}>
                  <Text style={styles.candidatesLabel}>Địa danh tương đồng:</Text>
                  <View style={styles.candidatesList}>
                    {detectedSite.alternativeCandidates.map((cand, idx) => (
                      <View key={idx} style={styles.candidateBadge}>
                        <Text style={styles.candidateText}>{cand}</Text>
                      </View>
                    ))}
                  </View>
                </View>
              )}

              <View style={styles.sheetActions}>
                <TouchableOpacity
                  style={[styles.sheetActionBtn, styles.mapActionBtn]}
                  onPress={() => {
                    const targetSite = detectedSite;
                    setDetectedSite(null);
                    setCapturedImage(null);
                    onNavigateToMap(targetSite);
                  }}
                >
                  <Ionicons name="location-sharp" size={18} color="#FFF" />
                  <Text style={styles.sheetActionBtnText}>{t('camera.viewMap')}</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={[styles.sheetActionBtn, styles.chatActionBtn]}
                  onPress={() => {
                    const targetSite = detectedSite;
                    const photoUri = capturedImage;
                    setDetectedSite(null);
                    setCapturedImage(null);
                    onNavigateToChat(targetSite, photoUri);
                  }}
                >
                  <Ionicons name="chatbubble-ellipses" size={18} color="#FFF" />
                  <Text style={styles.sheetActionBtnText}>Hỏi VietLens AI</Text>
                </TouchableOpacity>
              </View>

              <TouchableOpacity
                style={styles.fullDetailBtn}
                onPress={() => {
                  setDetectedSite(null);
                  setCapturedImage(null);
                  onSelectSite(detectedSite);
                }}
              >
                <Text style={styles.fullDetailText}>{t('camera.viewFullDetails')}</Text>
                <Ionicons name="chevron-forward" size={16} color={THEME.colors.amber} />
              </TouchableOpacity>
            </View>
          </View>
        </Modal>
      )}

      {/* Recognition Error / Unrecognized Bottom Sheet */}
      {recognitionError && (
        <Modal
          animationType="slide"
          transparent={true}
          visible={!!recognitionError}
          onRequestClose={() => {
            setRecognitionError(null);
            setCapturedImage(null);
          }}
        >
          <View style={styles.sheetBackdrop}>
            <View style={styles.bottomSheet}>
              <View style={styles.sheetHandle} />

              <TouchableOpacity
                style={styles.closeSheetBtn}
                onPress={() => {
                  setRecognitionError(null);
                  setCapturedImage(null);
                }}
              >
                <Ionicons name="close" size={22} color={THEME.colors.inkMuted} />
              </TouchableOpacity>

              <View style={[
                styles.errorIconBox,
                {
                  backgroundColor: recognitionError.type === 'OUT_OF_DOMAIN'
                    ? 'rgba(239, 68, 68, 0.12)'
                    : (recognitionError.type === 'LOW_CONFIDENCE' ? 'rgba(217, 119, 6, 0.12)' : 'rgba(239, 68, 68, 0.12)')
                }
              ]}>
                <Ionicons
                  name={
                    recognitionError.type === 'OUT_OF_DOMAIN'
                      ? 'alert-circle-outline'
                      : (recognitionError.type === 'LOW_CONFIDENCE' ? 'search-outline' : 'cloud-offline-outline')
                  }
                  size={32}
                  color={
                    recognitionError.type === 'OUT_OF_DOMAIN'
                      ? '#EF4444'
                      : (recognitionError.type === 'LOW_CONFIDENCE' ? THEME.colors.amber : '#EF4444')
                  }
                />
              </View>

              <Text style={styles.errorTitle}>
                {recognitionError.type === 'OUT_OF_DOMAIN'
                  ? 'Ảnh không chứa di tích'
                  : (recognitionError.type === 'LOW_CONFIDENCE'
                    ? t('camera.notRecognized')
                    : t('camera.serverError'))}
              </Text>

              <Text style={styles.errorDesc}>
                {recognitionError.type === 'OUT_OF_DOMAIN'
                  ? (recognitionError.message || 'Không phát hiện công trình kiến trúc hoặc di tích văn hóa trong ảnh. Hãy hướng camera thẳng vào di tích.')
                  : (recognitionError.type === 'LOW_CONFIDENCE'
                    ? t('camera.notRecognizedSub')
                    : t('camera.serverErrorSub'))}
              </Text>

              <View style={styles.errorActions}>
                <TouchableOpacity
                  style={styles.retryBtn}
                  onPress={() => {
                    setRecognitionError(null);
                    setCapturedImage(null);
                  }}
                  activeOpacity={0.8}
                >
                  <Ionicons name="camera" size={18} color="#FFF" />
                  <Text style={styles.retryBtnText}>{t('camera.retake')}</Text>
                </TouchableOpacity>

                <TouchableOpacity
                  style={styles.galleryAltBtn}
                  onPress={() => {
                    setRecognitionError(null);
                    setCapturedImage(null);
                    handlePickFromGallery();
                  }}
                  activeOpacity={0.8}
                >
                  <Ionicons name="images-outline" size={18} color={THEME.colors.ink} />
                  <Text style={styles.galleryAltBtnText}>{t('camera.pickAnother')}</Text>
                </TouchableOpacity>
              </View>
            </View>
          </View>
        </Modal>
      )}
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'transparent',
    position: 'relative',
  },
  cameraView: {
    ...StyleSheet.absoluteFillObject,
    width: '100%',
    height: '100%',
    flex: 1,
    backgroundColor: 'transparent',
  },
  cameraLoadingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'transparent',
    alignItems: 'center',
    justifyContent: 'center',
    zIndex: 5,
  },
  overlayContainer: {
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    bottom: 0,
    width: '100%',
    height: '100%',
    justifyContent: 'space-between',
    backgroundColor: 'transparent',
    zIndex: 10,
  },
  centerContainer: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
    alignItems: 'center',
    justifyContent: 'center',
    padding: 24,
  },
  permIconCircle: {
    width: 100,
    height: 100,
    borderRadius: 50,
    backgroundColor: THEME.colors.parchment,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 2,
    borderColor: THEME.colors.amber,
    marginBottom: 20,
  },
  permTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: THEME.colors.ink,
    textAlign: 'center',
  },
  permDesc: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
    marginTop: 8,
    lineHeight: 20,
    paddingHorizontal: 16,
  },
  grantBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: THEME.colors.amber,
    paddingVertical: 14,
    paddingHorizontal: 24,
    borderRadius: 16,
    gap: 8,
    marginTop: 24,
    elevation: 3,
  },
  grantBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
  galleryFallbackBtn: {
    marginTop: 16,
    paddingVertical: 8,
  },
  galleryFallbackText: {
    color: THEME.colors.inkMuted,
    fontSize: 13,
    fontWeight: '600',
    textDecorationLine: 'underline',
  },
  actionOutlineBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingVertical: 10,
    paddingHorizontal: 14,
    borderRadius: 12,
    borderWidth: 1.5,
    borderColor: THEME.colors.amber,
    backgroundColor: '#FFF',
  },
  actionOutlineText: {
    color: THEME.colors.amber,
    fontSize: 12,
    fontWeight: '700',
  },
  topBar: {
    paddingTop: Platform.OS === 'ios' ? 14 : 10,
    paddingHorizontal: 16,
    flexDirection: 'row',
    alignItems: 'center',
    zIndex: 10,
  },
  topLeftBox: {
    width: 90,
    flexDirection: 'row',
    alignItems: 'center',
  },
  topCenterBox: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  radarDot: {
    width: 7,
    height: 7,
    borderRadius: 4,
    backgroundColor: '#22C55E',
  },
  modeBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: 'rgba(28, 25, 23, 0.75)',
    paddingHorizontal: 12,
    paddingVertical: 6,
    borderRadius: 20,
    borderWidth: 1,
    borderColor: 'rgba(217, 119, 6, 0.4)',
    gap: 6,
  },
  modeBadgeText: {
    color: '#FFF',
    fontSize: 11,
    fontWeight: '700',
    letterSpacing: 0.8,
  },
  topRightBtns: {
    width: 90,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'flex-end',
    gap: 8,
  },
  topIconBtn: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: 'rgba(28, 25, 23, 0.7)',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
  },
  topIconBtnActive: {
    borderColor: THEME.colors.yellow,
    backgroundColor: 'rgba(217, 119, 6, 0.3)',
  },
  viewfinderContainer: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  viewfinderBox: {
    width: SCAN_BOX_SIZE,
    height: SCAN_BOX_SIZE,
    borderRadius: 24,
    position: 'relative',
    overflow: 'hidden',
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
    backgroundColor: 'transparent',
    alignItems: 'center',
    justifyContent: 'center',
  },
  corner: {
    position: 'absolute',
    width: 28,
    height: 28,
    borderColor: THEME.colors.amber,
  },
  topLeft: {
    top: 0,
    left: 0,
    borderTopWidth: 4,
    borderLeftWidth: 4,
    borderTopLeftRadius: 20,
  },
  topRight: {
    top: 0,
    right: 0,
    borderTopWidth: 4,
    borderRightWidth: 4,
    borderTopRightRadius: 20,
  },
  bottomLeft: {
    bottom: 0,
    left: 0,
    borderBottomWidth: 4,
    borderLeftWidth: 4,
    borderBottomLeftRadius: 20,
  },
  bottomRight: {
    bottom: 0,
    right: 0,
    borderBottomWidth: 4,
    borderRightWidth: 4,
    borderBottomRightRadius: 20,
  },
  crosshairH: {
    position: 'absolute',
    width: 24,
    height: 2,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  crosshairV: {
    position: 'absolute',
    height: 24,
    width: 2,
    backgroundColor: 'rgba(255, 255, 255, 0.3)',
  },
  scanLaser: {
    position: 'absolute',
    left: 0,
    right: 0,
    height: 3,
    backgroundColor: THEME.colors.yellow,
    shadowColor: THEME.colors.yellow,
    shadowOffset: { width: 0, height: 0 },
    shadowOpacity: 0.9,
    shadowRadius: 8,
    elevation: 6,
  },
  analyzingOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(28, 25, 23, 0.85)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 16,
  },
  analyzingText: {
    color: '#FFF',
    fontSize: 15,
    fontWeight: '700',
    marginTop: 12,
  },
  analyzingSub: {
    color: THEME.colors.amber,
    fontSize: 11,
    marginTop: 4,
    textAlign: 'center',
  },
  cameraErrorOverlay: {
    ...StyleSheet.absoluteFillObject,
    backgroundColor: 'rgba(28, 25, 23, 0.92)',
    alignItems: 'center',
    justifyContent: 'center',
    padding: 20,
  },
  cameraErrorText: {
    color: '#FFF',
    fontSize: 13,
    fontWeight: '600',
    marginTop: 10,
    textAlign: 'center',
  },
  galleryHeroBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: THEME.colors.amber,
    paddingVertical: 10,
    paddingHorizontal: 16,
    borderRadius: 12,
    gap: 6,
    marginTop: 14,
  },
  galleryHeroBtnText: {
    color: '#FFF',
    fontSize: 13,
    fontWeight: '700',
  },
  viewfinderGuide: {
    color: 'rgba(255, 255, 255, 0.85)',
    fontSize: 12,
    fontWeight: '500',
    marginTop: 16,
    textAlign: 'center',
    paddingHorizontal: 24,
  },
  bottomControls: {
    paddingBottom: Platform.OS === 'ios' ? 36 : 24,
    paddingHorizontal: 20,
    flexDirection: 'row',
    alignItems: 'center',
    zIndex: 10,
  },
  bottomSideCol: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  bottomCenterCol: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
  sideBtn: {
    width: 60,
    height: 60,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'rgba(28, 25, 23, 0.7)',
    borderRadius: 16,
    gap: 3,
    borderWidth: 1,
    borderColor: 'rgba(255, 255, 255, 0.15)',
  },
  sideBtnText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '600',
    textAlign: 'center',
  },
  shutterOuter: {
    width: 76,
    height: 76,
    borderRadius: 38,
    borderWidth: 4,
    borderColor: '#FFF',
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: 'transparent',
  },
  shutterInner: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: THEME.colors.red,
  },
  sheetBackdrop: {
    flex: 1,
    backgroundColor: 'rgba(0,0,0,0.5)',
    justifyContent: 'flex-end',
  },
  bottomSheet: {
    backgroundColor: '#FFF',
    borderTopLeftRadius: 28,
    borderTopRightRadius: 28,
    padding: 20,
    paddingBottom: 36,
  },
  sheetHandle: {
    width: 44,
    height: 5,
    backgroundColor: '#D1D5DB',
    borderRadius: 3,
    alignSelf: 'center',
    marginBottom: 12,
  },
  closeSheetBtn: {
    position: 'absolute',
    top: 16,
    right: 16,
    width: 32,
    height: 32,
    borderRadius: 16,
    backgroundColor: '#F3F4F6',
    alignItems: 'center',
    justifyContent: 'center',
  },
  sheetRow: {
    flexDirection: 'row',
    gap: 14,
    marginTop: 6,
  },
  sheetThumb: {
    width: 80,
    height: 80,
    borderRadius: 14,
  },
  sheetHeaderInfo: {
    flex: 1,
    justifyContent: 'center',
  },
  verifiedBadge: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
  },
  verifiedText: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.green,
  },
  sheetSiteName: {
    fontSize: 17,
    fontWeight: '700',
    color: THEME.colors.ink,
    marginTop: 3,
  },
  sheetDynasty: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    marginTop: 2,
  },
  tagsRow: {
    flexDirection: 'row',
    gap: 8,
    marginTop: 12,
  },
  tagBadge: {
    paddingHorizontal: 10,
    paddingVertical: 5,
    borderRadius: 8,
    backgroundColor: '#F3F4F6',
  },
  tagText: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.inkMuted,
  },
  sheetSummary: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    lineHeight: 18,
    marginTop: 10,
  },
  sheetActions: {
    flexDirection: 'row',
    gap: 12,
    marginTop: 16,
  },
  sheetActionBtn: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 12,
    borderRadius: 12,
    gap: 6,
  },
  mapActionBtn: {
    backgroundColor: THEME.colors.red,
  },
  chatActionBtn: {
    backgroundColor: THEME.colors.amber,
  },
  sheetActionBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
  fullDetailBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 14,
    paddingVertical: 8,
    gap: 4,
  },
  fullDetailText: {
    fontSize: 13,
    color: THEME.colors.amber,
    fontWeight: '700',
  },
  visionReasoningBox: {
    backgroundColor: 'rgba(217, 119, 6, 0.08)',
    borderRadius: 10,
    borderWidth: 1,
    borderColor: 'rgba(217, 119, 6, 0.2)',
    paddingHorizontal: 12,
    paddingVertical: 9,
    marginTop: 10,
  },
  visionReasoningHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    marginBottom: 4,
  },
  visionReasoningTitle: {
    fontSize: 12,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  visionReasoningText: {
    fontSize: 12,
    color: THEME.colors.ink,
    lineHeight: 17,
  },
  candidatesRow: {
    marginTop: 8,
  },
  candidatesLabel: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
    marginBottom: 4,
    fontWeight: '600',
  },
  candidatesList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 6,
  },
  candidateBadge: {
    backgroundColor: '#F3F4F6',
    borderRadius: 6,
    paddingHorizontal: 8,
    paddingVertical: 3,
  },
  candidateText: {
    fontSize: 11,
    color: THEME.colors.ink,
    fontWeight: '500',
  },
  errorIconBox: {
    width: 64,
    height: 64,
    borderRadius: 32,
    alignItems: 'center',
    justifyContent: 'center',
    alignSelf: 'center',
    marginBottom: 12,
  },
  errorTitle: {
    fontSize: 18,
    fontWeight: '700',
    color: THEME.colors.ink,
    textAlign: 'center',
    marginBottom: 6,
  },
  errorDesc: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
    lineHeight: 19,
    paddingHorizontal: 12,
    marginBottom: 20,
  },
  errorActions: {
    flexDirection: 'row',
    gap: 12,
  },
  retryBtn: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 13,
    borderRadius: 14,
    backgroundColor: THEME.colors.amber,
    gap: 6,
  },
  retryBtnText: {
    color: '#FFF',
    fontSize: 14,
    fontWeight: '700',
  },
  galleryAltBtn: {
    flex: 1,
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 13,
    borderRadius: 14,
    backgroundColor: '#F3F4F6',
    gap: 6,
  },
  galleryAltBtnText: {
    color: THEME.colors.ink,
    fontSize: 14,
    fontWeight: '600',
  },
});
