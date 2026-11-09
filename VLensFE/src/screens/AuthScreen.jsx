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
import * as WebBrowser from 'expo-web-browser';
import * as Linking from 'expo-linking';
import { THEME } from '../utils/theme';
import { supabase } from '../services/supabase';
import appService from '../api/appService';

const { width } = Dimensions.get('window');

// Đóng browser session nếu redirect quay trở lại ứng dụng
WebBrowser.maybeCompleteAuthSession();

export default function AuthScreen({ onLoginSuccess }) {
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

  // Dịch thông báo lỗi Supabase sang tiếng Việt dễ hiểu
  const translateSupabaseError = (err) => {
    const msg = err?.message || '';
    if (msg.includes('Invalid login credentials')) {
      return 'Email hoặc mật khẩu không chính xác. Vui lòng kiểm tra lại!';
    }
    if (msg.includes('Email not confirmed')) {
      return 'Tài khoản chưa được kích hoạt qua email. Vui lòng kiểm tra hộp thư của bạn!';
    }
    if (msg.includes('User already registered')) {
      return 'Email này đã tồn tại tài khoản. Vui lòng chuyển sang tab Đăng nhập!';
    }
    if (msg.includes('Password should be at least')) {
      return 'Mật khẩu phải chứa ít nhất 6 ký tự!';
    }
    if (msg.includes('access_denied') || msg.includes('access blocked')) {
      return 'Xác thực Google bị từ chối hoặc tài khoản chưa được cấp quyền trong Google Cloud Console.';
    }
    return msg || 'Có lỗi xảy ra trong quá trình xác thực.';
  };

  // ==========================================
  // Hàm dùng chung: Đồng bộ hồ sơ & Hoàn tất Đăng nhập
  // ==========================================
  const syncAndCompleteLogin = async (user, accessToken) => {
    const cleanEmail = user.email || '';
    const initialUser = {
      id: user.id,
      name: user.user_metadata?.full_name || user.user_metadata?.name || cleanEmail.split('@')[0] || 'Du khách',
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
      setErrorMessage('Vui lòng nhập đầy đủ Email và Mật khẩu.');
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
      if (!data.user) throw new Error('Không nhận được thông tin người dùng từ Supabase.');

      console.log('Đăng nhập Supabase thành công:', data.user.id);
      await syncAndCompleteLogin(data.user, data.session?.access_token);
    } catch (err) {
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert('Đăng nhập thất bại', msg);
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
      setErrorMessage('Vui lòng điền đầy đủ tất cả các trường.');
      return;
    }

    if (password.length < 6) {
      setErrorMessage('Mật khẩu phải có độ dài tối thiểu 6 ký tự.');
      return;
    }

    if (password !== confirmPassword) {
      setErrorMessage('Mật khẩu xác nhận không trùng khớp.');
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
        Alert.alert('Đăng ký thành công 🎉', 'Chào mừng bạn đến với VietLens!', [
          {
            text: 'Bắt đầu khám phá',
            onPress: () => syncAndCompleteLogin(data.user, data.session?.access_token),
          },
        ]);
      } else {
        // Trường hợp Supabase bật tính năng Confirm Email
        Alert.alert(
          'Đăng ký thành công 🎉',
          'Một liên kết xác thực đã được gửi tới email của bạn. Vui lòng kiểm tra hộp thư (cả mục Spam) để kích hoạt trước khi đăng nhập.',
          [
            {
              text: 'Đã hiểu, chuyển sang Đăng nhập',
              onPress: () => switchMode('login'),
            },
          ]
        );
      }
    } catch (err) {
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert('Đăng ký thất bại', msg);
    } finally {
      setLoading(false);
    }
  };

  // ==========================================
  // Xử lý ĐĂNG NHẬP BẰNG GOOGLE OAUTH2
  // ==========================================
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
      if (!data?.url) throw new Error('Không nhận được liên kết xác thực Google từ Supabase.');

      // 3. Mở phiên trình duyệt WebBrowser
      const result = await WebBrowser.openAuthSessionAsync(data.url, redirectUrl);

      // 4. Xử lý khi trình duyệt chuyển hướng quay lại ứng dụng
      if (result.type === 'success' && result.url) {
        const parsedUrl = Linking.parse(result.url);
        const code = parsedUrl.queryParams?.code;

        if (code) {
          // Luồng chuẩn PKCE (Trao đổi auth code lấy session)
          const { data: sessionData, error: exchangeError } = await supabase.auth.exchangeCodeForSession(String(code));
          if (exchangeError) throw exchangeError;
          if (sessionData?.user) {
            await syncAndCompleteLogin(sessionData.user, sessionData.session?.access_token);
          }
        } else if (parsedUrl.queryParams?.access_token) {
          // Luồng dự phòng Implicit tokens
          const { data: sessionData, error: sessionError } = await supabase.auth.setSession({
            access_token: String(parsedUrl.queryParams.access_token),
            refresh_token: String(parsedUrl.queryParams.refresh_token || ''),
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
      Alert.alert('Đăng nhập Google', msg);
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
      name: 'Khách Khám Phá',
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
        'Quên Mật Khẩu',
        'Vui lòng nhập địa chỉ Email của bạn vào ô bên dưới, sau đó bấm lại nút "Quên mật khẩu?".'
      );
      return;
    }

    try {
      setLoading(true);
      const { error } = await supabase.auth.resetPasswordForEmail(cleanEmail);
      if (error) throw error;
      Alert.alert(
        'Đã gửi liên kết',
        `Một liên kết đặt lại mật khẩu đã được gửi tới ${cleanEmail}. Vui lòng kiểm tra hộp thư.`
      );
    } catch (err) {
      Alert.alert('Lỗi', translateSupabaseError(err));
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
              <Text style={styles.badgeText}>BẢO TỒN & PHÁT HUY DI SẢN</Text>
            </View>
            <Text style={styles.welcomeTitle}>
              Chào Mừng Đến Với{'\n'}VietLens
            </Text>
            <Text style={styles.welcomeSubtitle}>
              {authMode === 'login'
                ? 'Đăng nhập để đồng bộ cuốn Hộ Chiếu Di Sản và trò chuyện cùng trợ lý AI văn hóa.'
                : 'Tạo tài khoản mới để bắt đầu hành trình khám phá di sản 4.0 khắp Việt Nam.'}
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
                Đăng Nhập
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
                Đăng Ký
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
                <Text style={styles.inputLabel}>Họ và tên</Text>
                <View style={styles.inputWrapper}>
                  <Ionicons
                    name="person-outline"
                    size={20}
                    color={THEME.colors.inkMuted}
                    style={styles.inputIcon}
                  />
                  <TextInput
                    style={styles.textInput}
                    placeholder="Ví dụ: Nguyễn Văn An"
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
              <Text style={styles.inputLabel}>Địa chỉ Email</Text>
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
                <Text style={styles.inputLabel}>Mật khẩu</Text>
                {authMode === 'login' && (
                  <TouchableOpacity onPress={handleForgotPassword} activeOpacity={0.7}>
                    <Text style={styles.forgotPasswordText}>Quên mật khẩu?</Text>
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
                  placeholder="Tối thiểu 6 ký tự"
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
                <Text style={styles.inputLabel}>Xác nhận mật khẩu</Text>
                <View style={styles.inputWrapper}>
                  <Ionicons
                    name="shield-checkmark-outline"
                    size={20}
                    color={THEME.colors.inkMuted}
                    style={styles.inputIcon}
                  />
                  <TextInput
                    style={styles.textInput}
                    placeholder="Nhập lại mật khẩu"
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
                  {authMode === 'login' ? 'Đăng Nhập' : 'Tạo Tài Khoản'}
                </Text>
              )}
            </TouchableOpacity>

            {/* Đường phân cách */}
            <View style={styles.dividerRow}>
              <View style={styles.dividerLine} />
              <Text style={styles.dividerText}>HOẶC TIẾP TỤC VỚI</Text>
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
                  <Text style={styles.googleBtnText}>Tiếp tục với Google</Text>
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
              <Text style={styles.guestBtnText}>Khám phá ngay (Chế độ Khách)</Text>
            </TouchableOpacity>
          </View>

          {/* Footer Terms */}
          <View style={styles.termsWrapper}>
            <Text style={styles.termsText}>
              Bằng việc tiếp tục, bạn đồng ý với Điều khoản Dịch vụ và Chính sách Bảo mật của VietLens.
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
