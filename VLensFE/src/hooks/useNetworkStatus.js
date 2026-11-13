import { useState, useEffect } from 'react';
import NetInfo from '@react-native-community/netinfo';

/**
 * Custom Hook giám sát trạng thái kết nối mạng theo thời gian thực
 * @returns {Object} { isConnected, isInternetReachable, connectionType }
 */
export function useNetworkStatus() {
  const [networkStatus, setNetworkStatus] = useState({
    isConnected: true, // Mặc định giả định có mạng để không nháy banner khi vừa khởi động
    isInternetReachable: true,
    connectionType: 'unknown',
  });

  useEffect(() => {
    // 1. Lấy trạng thái mạng ban đầu
    NetInfo.fetch().then((state) => {
      setNetworkStatus({
        isConnected: Boolean(state.isConnected),
        isInternetReachable: state.isInternetReachable !== false,
        connectionType: state.type || 'unknown',
      });
    });

    // 2. Đăng ký lắng nghe sự kiện thay đổi mạng
    const unsubscribe = NetInfo.addEventListener((state) => {
      const connected = Boolean(state.isConnected);
      const reachable = state.isInternetReachable !== false;
      setNetworkStatus({
        isConnected: connected,
        isInternetReachable: reachable,
        connectionType: state.type || 'unknown',
      });
    });

    return () => {
      unsubscribe();
    };
  }, []);

  return networkStatus;
}

export default useNetworkStatus;
