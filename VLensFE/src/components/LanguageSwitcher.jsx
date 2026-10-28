import React from 'react';
import { View, Text, TouchableOpacity, StyleSheet } from 'react-native';
import { useTranslation } from 'react-i18next';
import { changeAppLanguage } from '../locales/i18n';
import { THEME } from '../utils/theme';

export default function LanguageSwitcher({ onLanguageChanged }) {
  const { i18n } = useTranslation();
  const currentLang = i18n.language || 'vi';

  const handleSelectLanguage = async (lang) => {
    if (lang === currentLang) return;
    await changeAppLanguage(lang);
    if (onLanguageChanged) {
      onLanguageChanged(lang);
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={[styles.btn, currentLang === 'vi' && styles.btnActive]}
        onPress={() => handleSelectLanguage('vi')}
        activeOpacity={0.8}
      >
        <Text style={[styles.btnText, currentLang === 'vi' && styles.btnTextActive]}>
          🇻🇳 VI
        </Text>
      </TouchableOpacity>

      <TouchableOpacity
        style={[styles.btn, currentLang === 'en' && styles.btnActive]}
        onPress={() => handleSelectLanguage('en')}
        activeOpacity={0.8}
      >
        <Text style={[styles.btnText, currentLang === 'en' && styles.btnTextActive]}>
          🇬🇧 EN
        </Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flexDirection: 'row',
    backgroundColor: '#EAE5D9',
    borderRadius: 20,
    padding: 3,
    alignItems: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  btn: {
    paddingHorizontal: 9,
    paddingVertical: 4,
    borderRadius: 16,
  },
  btnActive: {
    backgroundColor: THEME.colors.red,
    elevation: 2,
    shadowColor: THEME.colors.red,
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.3,
    shadowRadius: 2,
  },
  btnText: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.inkMuted,
  },
  btnTextActive: {
    color: '#FFFFFF',
  },
});
