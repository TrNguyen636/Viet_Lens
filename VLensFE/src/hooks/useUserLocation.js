import { useState, useEffect, useCallback } from 'react';
import * as Location from 'expo-location';

// Tọa độ mặc định miền Trung (Đà Nẵng): Vĩ độ 16.0544, Kinh độ 108.2022
export const DEFAULT_COORDS = {
  latitude: 16.0544,
  longitude: 108.2022,
};

/**
 * Custom Hook xin quyền và lấy tọa độ GPS thời gian thực của thiết bị
 */
export default function useUserLocation() {
  const [coords, setCoords] = useState(DEFAULT_COORDS);
  const [permissionGranted, setPermissionGranted] = useState(false);
  const [isLocating, setIsLocating] = useState(true);
  const [errorMsg, setErrorMsg] = useState(null);

  const requestLocation = useCallback(async () => {
    try {
      setIsLocating(true);
      setErrorMsg(null);

      const { status } = await Location.requestForegroundPermissionsAsync();
      if (status !== 'granted') {
        setErrorMsg('Quyền truy cập vị trí đã bị từ chối');
        setPermissionGranted(false);
        setIsLocating(false);
        return;
      }

      setPermissionGranted(true);
      const position = await Location.getCurrentPositionAsync({
        accuracy: Location.Accuracy.Balanced,
      });

      if (position?.coords) {
        setCoords({
          latitude: position.coords.latitude,
          longitude: position.coords.longitude,
        });
      }
    } catch (err) {
      console.warn('[useUserLocation] Lỗi định vị GPS:', err.message);
      setErrorMsg(err.message);
    } finally {
      setIsLocating(false);
    }
  }, []);

  useEffect(() => {
    requestLocation();
  }, [requestLocation]);

  return {
    coords,
    permissionGranted,
    isLocating,
    errorMsg,
    refreshLocation: requestLocation,
  };
}
