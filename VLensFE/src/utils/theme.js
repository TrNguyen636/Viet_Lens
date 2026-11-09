import React, { createContext, useContext, useState, useEffect } from 'react';
import AsyncStorage from '@react-native-async-storage/async-storage';

export const LIGHT_THEME = {
  isDark: false,
  colors: {
    bg: '#F5F5DC',        // Main vintage beige background
    card: '#FFFFFF',      // Pure white card for contrast
    parchment: '#EFEACF', // Subtle parchment card background
    border: '#DDD6BE',    // Warm border
    ink: '#1C1917',       // High-contrast deep ink text
    inkMuted: '#57534E',  // Muted ink description
    inkLight: '#A8A29E',  // Light text
    amber: '#FF8F00',     // Primary accent amber
    yellow: '#FBC02D',    // Golden yellow accent
    red: '#C62828',       // Cultural Crimson Red
    redLight: '#FFEBEE',  // Red soft background
    green: '#2E7D32',     // Heritage green
    greenLight: '#E8F5E9',
    overlay: 'rgba(28, 25, 23, 0.65)',
    cardDark: '#292524',
    tabBarBg: '#FFFFFF',
    tabBarBorder: '#DDD6BE',
  },
  typography: {
    title: { fontSize: 24, fontWeight: '700' },
    subtitle: { fontSize: 18, fontWeight: '600' },
    body: { fontSize: 14, fontWeight: '400' },
    caption: { fontSize: 12, fontWeight: '400' },
  },
};

export const DARK_THEME = {
  isDark: true,
  colors: {
    bg: '#141210',        // Warm dark charcoal vintage background
    card: '#1E1B18',      // Soft dark card
    parchment: '#282420', // Warm dark card secondary
    border: '#36312B',    // Subtle warm dark border
    ink: '#EDE8DF',       // Warm ivory primary text (chống chói mắt)
    inkMuted: '#9C968B',  // Muted warm secondary text
    inkLight: '#706B62',  // Tertiary text
    amber: '#FFA000',     // Amber accent
    yellow: '#FBC02D',    // Golden yellow accent
    red: '#C62828',       // Cultural Crimson Red
    redLight: '#2C1B1B',  // Soft dark red background
    green: '#388E3C',     // Heritage green
    greenLight: '#1B2C1C',
    overlay: 'rgba(0, 0, 0, 0.75)',
    cardDark: '#12100E',
    tabBarBg: '#1A1815',
    tabBarBorder: '#36312B',
  },
  typography: {
    title: { fontSize: 24, fontWeight: '700' },
    subtitle: { fontSize: 18, fontWeight: '600' },
    body: { fontSize: 14, fontWeight: '400' },
    caption: { fontSize: 12, fontWeight: '400' },
  },
};

// Giữ lại export THEME mặc định để tương thích 100% với các file import tĩnh
export const THEME = LIGHT_THEME;

const ThemeContext = createContext({
  theme: LIGHT_THEME,
  isDark: false,
  toggleTheme: () => {},
  setDarkMode: () => {},
});

const THEME_STORAGE_KEY = '@vietlens_theme_mode';

export function ThemeProvider({ children }) {
  const [isDark, setIsDark] = useState(false);

  useEffect(() => {
    AsyncStorage.getItem(THEME_STORAGE_KEY).then((stored) => {
      if (stored === 'dark') {
        setIsDark(true);
      }
    }).catch((err) => {
      console.warn('[Theme] Lỗi đọc theme từ storage:', err.message);
    });
  }, []);

  const toggleTheme = async () => {
    setIsDark((prev) => {
      const next = !prev;
      AsyncStorage.setItem(THEME_STORAGE_KEY, next ? 'dark' : 'light').catch(() => {});
      return next;
    });
  };

  const setDarkMode = async (value) => {
    const isDarkBool = Boolean(value);
    setIsDark(isDarkBool);
    await AsyncStorage.setItem(THEME_STORAGE_KEY, isDarkBool ? 'dark' : 'light').catch(() => {});
  };

  const theme = isDark ? DARK_THEME : LIGHT_THEME;

  return (
    <ThemeContext.Provider value={{ theme, isDark, toggleTheme, setDarkMode }}>
      {children}
    </ThemeContext.Provider>
  );
}

export function useTheme() {
  const context = useContext(ThemeContext);
  if (!context) {
    return {
      theme: LIGHT_THEME,
      isDark: false,
      toggleTheme: () => {},
      setDarkMode: () => {},
    };
  }
  return context;
}

export default {
  LIGHT_THEME,
  DARK_THEME,
  THEME,
  ThemeProvider,
  useTheme,
};
