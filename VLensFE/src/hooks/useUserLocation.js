import { useState, useEffect, useCallback, useRef } from 'react';
import * as Location from 'expo-location';

// Tọa độ mặc định trung tâm Đà Nẵng / Miền Trung
export const DEFAULT_COORDS = {
  latitude: 16.0544,
  longitude: 108.2022,
  heading: 0,
  speed: 0,
};

/**
 * Custom Hook theo dõi vị trí GPS thời gian thực và góc hướng la bàn (Heading)
 * phục vụ Chế độ Dẫn đường thực tế (Tính năng 1 & 8)
 */
export default function useUserLocation(isNavigationActive = false) {
  const [coords, setCoords] = useState(DEFAULT_COORDS);
  const [permissionGranted, setPermissionGranted] = useState(false);
  const [isLocating, setIsLocating] = useState(true);
  const [errorMsg, setErrorMsg] = useState(null);
  const watcherRef = useRef(null);

  // 1. Xin quyền và lấy tọa độ hiện thời một lần
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
          heading: position.coords.heading || 0,
          speed: position.coords.speed || 0,
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

  // 2. Theo dõi chuyển động liên tục thời gian thực (Live GPS Tracking)
  useEffect(() => {
    let isMounted = true;

    async function startWatching() {
      if (!permissionGranted) return;

      try {
        if (watcherRef.current) {
          watcherRef.current.remove();
          watcherRef.current = null;
        }

        // Tần suất theo dõi: Cập nhật mỗi 2.5 giây hoặc mỗi khi di chuyển 2.5 mét
        const subscription = await Location.watchPositionAsync(
          {
            accuracy: isNavigationActive ? Location.Accuracy.BestForNavigation : Location.Accuracy.High,
            timeInterval: isNavigationActive ? 1500 : 3000,
            distanceInterval: isNavigationActive ? 2 : 5,
          },
          (pos) => {
            if (isMounted && pos?.coords) {
              setCoords({
                latitude: pos.coords.latitude,
                longitude: pos.coords.longitude,
                heading: pos.coords.heading || 0,
                speed: pos.coords.speed || 0,
              });
            }
          }
        );

        watcherRef.current = subscription;
      } catch (e) {
        console.warn('[useUserLocation] Lỗi watchPositionAsync:', e.message);
      }
    }

    startWatching();

    return () => {
      isMounted = false;
      if (watcherRef.current) {
        watcherRef.current.remove();
        watcherRef.current = null;
      }
    };
  }, [permissionGranted, isNavigationActive]);

  return {
    coords,
    permissionGranted,
    isLocating,
    errorMsg,
    refreshLocation: requestLocation,
  };
}
