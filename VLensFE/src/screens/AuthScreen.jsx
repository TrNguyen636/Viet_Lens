import React, { useState, useEffect } from 'react';
import {
  View,
  Text,
  TextInput,
  TouchableOpacity,
  StyleSheet,
  StatusBar,
  Dimensions,
  ActivityIndicator,
  Alert,
  KeyboardAvoidingView,
  ScrollView,
  Platform,
} from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import { useTranslation } from 'react-i18next';
import * as WebBrowser from 'expo-web-browser';
import * as Linking from 'expo-linking';
import { THEME } from '../utils/theme';
import { supabase } from '../services/supabase';
import appService from '../api/appService';

const { width } = Dimensions.get('window');

// Đóng browser session nếu redirect quay trở lại ứng dụng
WebBrowser.maybeCompleteAuthSession();

export default function AuthScreen({ onLoginSuccess }) {
  const { t } = useTranslation();
  // 'login' | 'register'
  const [authMode, setAuthMode] = useState('login');

  // Form Fields
  const [fullName, setFullName] = useState('');
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [confirmPassword, setConfirmPassword] = useState('');

  // UI States
  const [showPassword, setShowPassword] = useState(false);
  const [showConfirmPassword, setShowConfirmPassword] = useState(false);
  const [loading, setLoading] = useState(false);
  const [googleLoading, setGoogleLoading] = useState(false);
  const [errorMessage, setErrorMessage] = useState('');

  // Khởi động trước browser engine để giảm độ trễ khi mở Google OAuth
  useEffect(() => {
    WebBrowser.warmUpAsync();
    return () => {
      WebBrowser.coolDownAsync();
    };
  }, []);

  // Chuyển đổi tab Đăng nhập / Đăng ký
  const switchMode = (mode) => {
    setAuthMode(mode);
    setErrorMessage('');
  };

  // Dịch thông báo lỗi Supabase theo ngôn ngữ hiện tại
  const translateSupabaseError = (err) => {
    const msg = err?.message || '';
    if (msg.includes('Invalid login credentials')) {
      return t('auth.errInvalidLogin');
    }
    if (msg.includes('Email not confirmed')) {
      return t('auth.errEmailNotConfirmed');
    }
    if (msg.includes('User already registered')) {
      return t('auth.errUserExists');
    }
    if (msg.includes('Password should be at least')) {
      return t('auth.errPasswordLen');
    }
    if (msg.includes('access_denied') || msg.includes('access blocked')) {
      return t('auth.errGoogleDenied');
    }
    return msg || t('auth.errGenericAuth');
  };

  // ==========================================
  // Hàm dùng chung: Đồng bộ hồ sơ & Hoàn tất Đăng nhập
  // ==========================================
  const syncAndCompleteLogin = async (user, accessToken) => {
    const cleanEmail = user.email || '';
    const initialUser = {
      id: user.id,
      name: user.user_metadata?.full_name || user.user_metadata?.name || cleanEmail.split('@')[0] || t('auth.guestName'),
      email: cleanEmail,
      avatarUrl: user.user_metadata?.avatar_url || user.user_metadata?.picture || null,
      role: 'USER',
    };

    // Đưa người dùng vào ứng dụng ngay lập tức
    onLoginSuccess(initialUser);

    // Đồng bộ hồ sơ sang Spring Boot Backend (chạy ngầm, không chặn UI)
    try {
      const userProfile = await appService.syncUserProfile({
        token: accessToken,
        fullName: initialUser.name,
        avatarUrl: initialUser.avatarUrl,
      });
      if (userProfile) {
        console.log('[AuthScreen] Hồ sơ Backend đã đồng bộ:', userProfile);
        onLoginSuccess(userProfile);
      }
    } catch (syncErr) {
      console.log('[AuthScreen] Backend sync warning (tiếp tục phiên làm việc):', syncErr.message);
    }
  };

  // ==========================================
  // Xử lý ĐĂNG NHẬP BẰNG EMAIL / PASSWORD
  // ==========================================
  const handleSignIn = async () => {
    const cleanEmail = email.trim();
    if (!cleanEmail || !password) {
      setErrorMessage(t('auth.errMissingLogin'));
      return;
    }

    setLoading(true);
    setErrorMessage('');

    try {
      const { data, error } = await supabase.auth.signInWithPassword({
        email: cleanEmail,
        password: password,
      });

      if (error) throw error;
      if (!data.user) throw new Error(t('auth.errNoUser'));

      console.log('Đăng nhập Supabase thành công:', data.user.id);
      await syncAndCompleteLogin(data.user, data.session?.access_token);
    } catch (err) {
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert(t('auth.loginFailedTitle'), msg);
    } finally {
      setLoading(false);
    }
  };

  // ==========================================
  // Xử lý ĐĂNG KÝ TÀI KHOẢN MỚI
  // ==========================================
  const handleSignUp = async () => {
    const cleanEmail = email.trim();
    const cleanName = fullName.trim();

    if (!cleanName || !cleanEmail || !password || !confirmPassword) {
      setErrorMessage(t('auth.errMissingFields'));
      return;
    }

    if (password.length < 6) {
      setErrorMessage(t('auth.errPasswordLen'));
      return;
    }

    if (password !== confirmPassword) {
      setErrorMessage(t('auth.errPasswordMismatch'));
      return;
    }

    setLoading(true);
    setErrorMessage('');

    try {
      const { data, error } = await supabase.auth.signUp({
        email: cleanEmail,
        password: password,
        options: {
          data: {
            full_name: cleanName,
          },
        },
      });

      if (error) throw error;
      console.log('Đăng ký tài khoản Supabase thành công:', data.user?.id);

      // Nếu Supabase trả về session ngay (Auto-confirm hoặc không bật xác thực email)
      if (data.session && data.user) {
        Alert.alert(t('auth.registerSuccessTitle'), t('auth.registerSuccessMsg'), [
          {
            text: t('auth.registerSuccessBtn'),
            onPress: () => syncAndCompleteLogin(data.user, data.session?.access_token),
          },
        ]);
      } else {
        // Trường hợp Supabase bật tính năng Confirm Email
        Alert.alert(
          t('auth.registerSuccessTitle'),
          t('auth.registerVerifyMsg'),
          [
            {
              text: t('auth.registerVerifyBtn'),
              onPress: () => switchMode('login'),
            },
          ]
        );
      }
    } catch (err) {
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert(t('auth.registerFailedTitle'), msg);
    } finally {
      setLoading(false);
    }
  };

  // ==========================================
  // Xử lý ĐĂNG NHẬP BẰNG GOOGLE OAUTH2
  // ==========================================
  const extractOAuthParams = (callbackUrl) => {
    const params = { ...(Linking.parse(callbackUrl)?.queryParams || {}) };
    const hashIdx = callbackUrl.indexOf('#');
    if (hashIdx !== -1) {
      const fragment = callbackUrl.slice(hashIdx + 1);
      for (const pair of fragment.split('&')) {
        if (!pair) continue;
        const eqIdx = pair.indexOf('=');
        const key = decodeURIComponent(eqIdx === -1 ? pair : pair.slice(0, eqIdx));
        const val = eqIdx === -1 ? '' : decodeURIComponent(pair.slice(eqIdx + 1).replace(/\+/g, ' '));
        if (key && params[key] === undefined) {
          params[key] = val;
        }
      }
    }
    return params;
  };

  const handleGoogleSignIn = async () => {
    setGoogleLoading(true);
    setErrorMessage('');

    try {
      // 1. Tạo Redirect URL tự động tương thích cả Expo Go và Mobile App build (scheme: vietlens)
      const redirectUrl = Linking.createURL('auth/callback', { scheme: 'vietlens' });
      console.log('[Google Auth] Redirect URL:', redirectUrl);

      // 2. Lấy URL cấp quyền từ Supabase OAuth
      const { data, error } = await supabase.auth.signInWithOAuth({
        provider: 'google',
        options: {
          redirectTo: redirectUrl,
          skipBrowserRedirect: true,
          queryParams: {
            prompt: 'select_account',
          },
        },
      });

      if (error) throw error;
      if (!data?.url) throw new Error(t('auth.errNoGoogleUrl'));

      // 3. Mở phiên trình duyệt WebBrowser
      const result = await WebBrowser.openAuthSessionAsync(data.url, redirectUrl);

      // 4. Xử lý khi trình duyệt chuyển hướng quay lại ứng dụng (hỗ trợ cả ?query và #fragment)
      if (result.type === 'success' && result.url) {
        const oauthParams = extractOAuthParams(result.url);

        if (oauthParams.error || oauthParams.error_description) {
          throw new Error(oauthParams.error_description || oauthParams.error);
        }

        if (oauthParams.code) {
          // Luồng chuẩn PKCE (Trao đổi auth code lấy session)
          const { data: sessionData, error: exchangeError } = await supabase.auth.exchangeCodeForSession(
            String(oauthParams.code)
          );
          if (exchangeError) throw exchangeError;
          if (sessionData?.user) {
            await syncAndCompleteLogin(sessionData.user, sessionData.session?.access_token);
          }
        } else if (oauthParams.access_token) {
          // Luồng dự phòng Implicit tokens (#access_token=... hoặc ?access_token=...)
          const { data: sessionData, error: sessionError } = await supabase.auth.setSession({
            access_token: String(oauthParams.access_token),
            refresh_token: String(oauthParams.refresh_token || ''),
          });
          if (sessionError) throw sessionError;
          if (sessionData?.user) {
            await syncAndCompleteLogin(sessionData.user, sessionData.session?.access_token);
          }
        }
      }
    } catch (err) {
      console.error('[Google Auth Error]:', err);
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert(t('auth.googleAuthTitle'), msg);
    } finally {
      setGoogleLoading(false);
    }
  };

  // ==========================================
  // Xử lý KHÁM PHÁ VỚI TƯ CÁCH KHÁCH (Guest Mode)
  // ==========================================
  const handleGuestMode = () => {
    const guestUser = {
      id: 'guest-' + Math.random().toString(36).substring(2, 9),
      name: t('auth.guestName'),
      email: null,
      role: 'GUEST',
    };
    onLoginSuccess(guestUser);
  };

  // ==========================================
  // Xử lý QUÊN MẬT KHẨU
  // ==========================================
  const handleForgotPassword = async () => {
    const cleanEmail = email.trim();
    if (!cleanEmail) {
      Alert.alert(
        t('auth.forgotTitle'),
        t('auth.forgotEnterEmail')
      );
      return;
    }

    try {
      setLoading(true);
      const { error } = await supabase.auth.resetPasswordForEmail(cleanEmail);
      if (error) throw error;
      Alert.alert(
        t('auth.forgotSentTitle'),
        t('auth.forgotSentMsg', { email: cleanEmail })
      );
    } catch (err) {
      Alert.alert(t('auth.errorTitle'), translateSupabaseError(err));
    } finally {
      setLoading(false);
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <StatusBar barStyle="dark-content" />
      <KeyboardAvoidingView
        behavior={Platform.OS === 'ios' ? 'padding' : undefined}
        style={{ flex: 1 }}
      >
        <ScrollView
          contentContainerStyle={styles.scrollContent}
          showsVerticalScrollIndicator={false}
          keyboardShouldPersistTaps="handled"
        >
          {/* Header Title */}
          <View style={styles.header}>
            <View style={styles.badgeWrapper}>
              <Text style={styles.badgeText}>{t('auth.badge')}</Text>
            </View>
            <Text style={styles.welcomeTitle}>
              {t('auth.welcomeTitle')}
            </Text>
            <Text style={styles.welcomeSubtitle}>
              {authMode === 'login'
                ? t('auth.loginSubtitle')
                : t('auth.registerSubtitle')}
            </Text>
          </View>

          {/* Tab Selector: Đăng nhập / Đăng ký */}
          <View style={styles.tabContainer}>
            <TouchableOpacity
              style={[
                styles.tabButton,
                authMode === 'login' && styles.tabButtonActive,
              ]}
              onPress={() => switchMode('login')}
              activeOpacity={0.8}
            >
              <Text
                style={[
                  styles.tabButtonText,
                  authMode === 'login' && styles.tabButtonTextActive,
                ]}
              >
                {t('auth.loginTab')}
              </Text>
            </TouchableOpacity>

            <TouchableOpacity
              style={[
                styles.tabButton,
                authMode === 'register' && styles.tabButtonActive,
              ]}
              onPress={() => switchMode('register')}
              activeOpacity={0.8}
            >
              <Text
                style={[
                  styles.tabButtonText,
                  authMode === 'register' && styles.tabButtonTextActive,
                ]}
              >
                {t('auth.registerTab')}
              </Text>
            </TouchableOpacity>
          </View>

          {/* Error Banner */}
          {errorMessage ? (
            <View style={styles.errorBox}>
              <Ionicons name="alert-circle" size={18} color={THEME.colors.red} />
              <Text style={styles.errorText}>{errorMessage}</Text>
            </View>
          ) : null}

          {/* Form Inputs */}
          <View style={styles.formContainer}>
            {/* Họ và tên (chỉ hiển thị khi Đăng ký) */}
            {authMode === 'register' && (
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>{t('auth.fullNameLabel')}</Text>
                <View style={styles.inputWrapper}>
                  <Ionicons
                    name="person-outline"
                    size={20}
                    color={THEME.colors.inkMuted}
                    style={styles.inputIcon}
                  />
                  <TextInput
                    style={styles.textInput}
                    placeholder={t('auth.fullNamePlaceholder')}
                    placeholderTextColor={THEME.colors.inkLight}
                    value={fullName}
                    onChangeText={setFullName}
                    autoCapitalize="words"
                  />
                </View>
              </View>
            )}

            {/* Email */}
            <View style={styles.inputGroup}>
              <Text style={styles.inputLabel}>{t('auth.emailLabel')}</Text>
              <View style={styles.inputWrapper}>
                <Ionicons
                  name="mail-outline"
                  size={20}
                  color={THEME.colors.inkMuted}
                  style={styles.inputIcon}
                />
                <TextInput
                  style={styles.textInput}
                  placeholder="name@vietlens.vn"
                  placeholderTextColor={THEME.colors.inkLight}
                  value={email}
                  onChangeText={setEmail}
                  keyboardType="email-address"
                  autoCapitalize="none"
                  autoCorrect={false}
                />
              </View>
            </View>

            {/* Mật khẩu */}
            <View style={styles.inputGroup}>
              <View style={styles.passwordHeader}>
                <Text style={styles.inputLabel}>{t('auth.passwordLabel')}</Text>
                {authMode === 'login' && (
                  <TouchableOpacity onPress={handleForgotPassword} activeOpacity={0.7}>
                    <Text style={styles.forgotPasswordText}>{t('auth.forgotPassword')}</Text>
                  </TouchableOpacity>
                )}
              </View>
              <View style={styles.inputWrapper}>
                <Ionicons
                  name="lock-closed-outline"
                  size={20}
                  color={THEME.colors.inkMuted}
                  style={styles.inputIcon}
                />
                <TextInput
                  style={styles.textInput}
                  placeholder={t('auth.passwordPlaceholder')}
                  placeholderTextColor={THEME.colors.inkLight}
                  value={password}
                  onChangeText={setPassword}
                  secureTextEntry={!showPassword}
                  autoCapitalize="none"
                />
                <TouchableOpacity
                  onPress={() => setShowPassword(!showPassword)}
                  style={styles.eyeBtn}
                >
                  <Ionicons
                    name={showPassword ? 'eye-off-outline' : 'eye-outline'}
                    size={20}
                    color={THEME.colors.inkMuted}
                  />
                </TouchableOpacity>
              </View>
            </View>

            {/* Xác nhận mật khẩu (chỉ hiển thị khi Đăng ký) */}
            {authMode === 'register' && (
              <View style={styles.inputGroup}>
                <Text style={styles.inputLabel}>{t('auth.confirmPasswordLabel')}</Text>
                <View style={styles.inputWrapper}>
                  <Ionicons
                    name="shield-checkmark-outline"
                    size={20}
                    color={THEME.colors.inkMuted}
                    style={styles.inputIcon}
                  />
                  <TextInput
                    style={styles.textInput}
                    placeholder={t('auth.confirmPasswordPlaceholder')}
                    placeholderTextColor={THEME.colors.inkLight}
                    value={confirmPassword}
                    onChangeText={setConfirmPassword}
                    secureTextEntry={!showConfirmPassword}
                    autoCapitalize="none"
                  />
                  <TouchableOpacity
                    onPress={() => setShowConfirmPassword(!showConfirmPassword)}
                    style={styles.eyeBtn}
                  >
                    <Ionicons
                      name={showConfirmPassword ? 'eye-off-outline' : 'eye-outline'}
                      size={20}
                      color={THEME.colors.inkMuted}
                    />
                  </TouchableOpacity>
                </View>
              </View>
            )}

            {/* Nút hành động chính (Đăng nhập / Đăng ký Email) */}
            <TouchableOpacity
              style={[styles.primaryBtn, (loading || googleLoading) && styles.primaryBtnDisabled]}
              onPress={authMode === 'login' ? handleSignIn : handleSignUp}
              disabled={loading || googleLoading}
              activeOpacity={0.85}
            >
              {loading ? (
                <ActivityIndicator color="#FFF" />
              ) : (
                <Text style={styles.primaryBtnText}>
                  {authMode === 'login' ? t('auth.loginBtn') : t('auth.registerBtn')}
                </Text>
              )}
            </TouchableOpacity>

            {/* Đường phân cách */}
            <View style={styles.dividerRow}>
              <View style={styles.dividerLine} />
              <Text style={styles.dividerText}>{t('auth.orContinueWith')}</Text>
              <View style={styles.dividerLine} />
            </View>

            {/* Nút Đăng nhập Google OAuth2 */}
            <TouchableOpacity
              style={[styles.googleBtn, (loading || googleLoading) && styles.googleBtnDisabled]}
              onPress={handleGoogleSignIn}
              disabled={loading || googleLoading}
              activeOpacity={0.85}
            >
              {googleLoading ? (
                <ActivityIndicator color={THEME.colors.ink} />
              ) : (
                <View style={styles.googleContentRow}>
                  <Ionicons name="logo-google" size={19} color="#EA4335" style={{ marginRight: 10 }} />
                  <Text style={styles.googleBtnText}>{t('auth.googleBtn')}</Text>
                </View>
              )}
            </TouchableOpacity>

            {/* Nút Khám phá ngay (Chế độ Khách) */}
            <TouchableOpacity
              style={styles.guestBtn}
              onPress={handleGuestMode}
              disabled={loading || googleLoading}
              activeOpacity={0.8}
            >
              <Ionicons name="compass-outline" size={18} color={THEME.colors.amber} style={{ marginRight: 8 }} />
              <Text style={styles.guestBtnText}>{t('auth.guestBtn')}</Text>
            </TouchableOpacity>
          </View>

          {/* Footer Terms */}
          <View style={styles.termsWrapper}>
            <Text style={styles.termsText}>
              {t('auth.terms')}
            </Text>
          </View>
        </ScrollView>
      </KeyboardAvoidingView>
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  scrollContent: {
    paddingHorizontal: 24,
    paddingBottom: 30,
  },
  header: {
    marginTop: 20,
    alignItems: 'center',
  },
  badgeWrapper: {
    paddingHorizontal: 12,
    paddingVertical: 5,
    backgroundColor: THEME.colors.parchment,
    borderRadius: 16,
    borderWidth: 1,
    borderColor: THEME.colors.border,
    marginBottom: 12,
  },
  badgeText: {
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.red,
    letterSpacing: 0.8,
  },
  welcomeTitle: {
    fontSize: 26,
    fontWeight: '700',
    color: THEME.colors.ink,
    textAlign: 'center',
    lineHeight: 34,
  },
  welcomeSubtitle: {
    fontSize: 13,
    color: THEME.colors.inkMuted,
    textAlign: 'center',
    marginTop: 8,
    lineHeight: 18,
    paddingHorizontal: 10,
  },
  tabContainer: {
    flexDirection: 'row',
    backgroundColor: '#EAE6DF',
    borderRadius: 14,
    padding: 4,
    marginTop: 24,
  },
  tabButton: {
    flex: 1,
    paddingVertical: 10,
    alignItems: 'center',
    borderRadius: 11,
  },
  tabButtonActive: {
    backgroundColor: '#FFFFFF',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 3,
  },
  tabButtonText: {
    fontSize: 14,
    fontWeight: '600',
    color: THEME.colors.inkMuted,
  },
  tabButtonTextActive: {
    color: THEME.colors.ink,
    fontWeight: '700',
  },
  errorBox: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FEE2E2',
    borderWidth: 1,
    borderColor: '#FCA5A5',
    borderRadius: 10,
    padding: 12,
    marginTop: 16,
    gap: 8,
  },
  errorText: {
    flex: 1,
    fontSize: 13,
    color: THEME.colors.red,
    lineHeight: 18,
  },
  formContainer: {
    marginTop: 20,
    gap: 14,
  },
  inputGroup: {
    gap: 6,
  },
  passwordHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  inputLabel: {
    fontSize: 13,
    fontWeight: '600',
    color: THEME.colors.ink,
  },
  forgotPasswordText: {
    fontSize: 12,
    fontWeight: '600',
    color: THEME.colors.amber,
  },
  inputWrapper: {
    flexDirection: 'row',
    alignItems: 'center',
    backgroundColor: '#FFFFFF',
    borderWidth: 1.5,
    borderColor: THEME.colors.border,
    borderRadius: 12,
    paddingHorizontal: 12,
    height: 50,
  },
  inputIcon: {
    marginRight: 8,
  },
  textInput: {
    flex: 1,
    fontSize: 14,
    color: THEME.colors.ink,
    height: '100%',
  },
  eyeBtn: {
    padding: 6,
  },
  primaryBtn: {
    backgroundColor: THEME.colors.red,
    paddingVertical: 14,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 6,
    elevation: 3,
    shadowColor: THEME.colors.red,
    shadowOffset: { width: 0, height: 3 },
    shadowOpacity: 0.3,
    shadowRadius: 5,
  },
  primaryBtnDisabled: {
    opacity: 0.65,
  },
  primaryBtnText: {
    fontSize: 15,
    fontWeight: '700',
    color: '#FFFFFF',
    letterSpacing: 0.3,
  },
  dividerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 6,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: '#D1CABE',
  },
  dividerText: {
    marginHorizontal: 10,
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.inkLight,
    letterSpacing: 0.5,
  },
  googleBtn: {
    backgroundColor: '#FFFFFF',
    borderWidth: 1.5,
    borderColor: '#D1CABE',
    paddingVertical: 13,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 1,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.08,
    shadowRadius: 3,
  },
  googleBtnDisabled: {
    opacity: 0.7,
  },
  googleContentRow: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
  },
  googleBtnText: {
    fontSize: 14,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  guestBtn: {
    flexDirection: 'row',
    backgroundColor: 'transparent',
    borderWidth: 1.5,
    borderColor: THEME.colors.amber,
    paddingVertical: 12,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 2,
  },
  guestBtnText: {
    fontSize: 13,
    fontWeight: '700',
    color: THEME.colors.amber,
  },
  termsWrapper: {
    marginTop: 24,
    alignItems: 'center',
  },
  termsText: {
    fontSize: 11,
    color: THEME.colors.inkLight,
    textAlign: 'center',
    lineHeight: 16,
    paddingHorizontal: 20,
  },
});
