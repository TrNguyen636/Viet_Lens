import React, { useState } from 'react';
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
import { THEME } from '../utils/theme';
import { supabase } from '../services/supabase';
import appService from '../api/appService';

const { width } = Dimensions.get('window');

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
  const [errorMessage, setErrorMessage] = useState('');

  // Chuyển đổi tab Đăng nhập / Đăng ký
  const switchMode = (mode) => {
    setAuthMode(mode);
    setErrorMessage('');
  };

  // Dịch thông báo lỗi Supabase sang tiếng Việt dễ hiểu
  const translateSupabaseError = (err) => {
    const msg = err?.message || '';
    if (msg.includes('Invalid login credentials')) {
      return 'Email hoặc mật khẩu không chính xác. Vui lòng thử lại!';
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
    return msg || 'Có lỗi xảy ra trong quá trình xác thực.';
  };

  // ==========================================
  // Xử lý ĐĂNG NHẬP (Sign In)
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
      // 1. Gọi Supabase Auth để xác thực người dùng
      const { data, error } = await supabase.auth.signInWithPassword({
        email: cleanEmail,
        password: password,
      });

      if (error) throw error;

      console.log('Đăng nhập Supabase thành công:', data.user?.id);

      // 2. Hoàn tất đăng nhập và chuyển vào ứng dụng ngay lập tức (không bị nghẽn bởi backend)
      const initialUser = {
        id: data.user.id,
        name: data.user.user_metadata?.full_name || cleanEmail.split('@')[0],
        email: data.user.email,
        role: 'USER',
      };
      onLoginSuccess(initialUser);

      // 3. Tự động đồng bộ với Backend Spring Boot ở chế độ chạy ngầm (non-blocking)
      appService
        .syncUserProfile({
          token: data.session?.access_token,
          fullName: data.user?.user_metadata?.full_name || cleanEmail.split('@')[0],
        })
        .then((userProfile) => {
          if (userProfile) {
            console.log('[AuthScreen] Đồng bộ hồ sơ Backend thành công:', userProfile);
            onLoginSuccess(userProfile);
          }
        })
        .catch((syncErr) => {
          console.log('[AuthScreen] Backend chưa phản hồi (tiếp tục dùng thông tin session):', syncErr.message);
        });
    } catch (err) {
      const msg = translateSupabaseError(err);
      setErrorMessage(msg);
      Alert.alert('Đăng nhập thất bại', msg);
    } finally {
      setLoading(false);
    }
  };

  // ==========================================
  // Xử lý ĐĂNG KÝ (Sign Up)
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
      // 1. Gọi Supabase Auth để tạo tài khoản mới
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

      // Nếu Supabase trả về session ngay (không bắt xác thực email)
      if (data.session) {
        try {
          await appService.syncUserProfile({
            token: data.session?.access_token,
            fullName: cleanName,
          });
        } catch (syncErr) {
          console.warn('Lỗi đồng bộ Backend sau đăng ký:', syncErr.message);
        }

        Alert.alert('Thành công', 'Chào mừng bạn đến với VietLens!', [
          {
            text: 'Bắt đầu',
            onPress: () =>
              onLoginSuccess({
                id: data.user.id,
                name: cleanName,
                email: cleanEmail,
                role: 'USER',
              }),
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
              <Text style={styles.inputLabel}>Mật khẩu</Text>
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

            {/* Nút hành động chính (Đăng nhập / Đăng ký) */}
            <TouchableOpacity
              style={[styles.primaryBtn, loading && styles.primaryBtnDisabled]}
              onPress={authMode === 'login' ? handleSignIn : handleSignUp}
              disabled={loading}
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
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderRadius: 10,
    marginTop: 16,
    gap: 8,
  },
  errorText: {
    fontSize: 13,
    color: THEME.colors.red,
    flex: 1,
    lineHeight: 18,
  },
  formContainer: {
    width: '100%',
    marginTop: 18,
    gap: 14,
  },
  inputGroup: {
    gap: 6,
  },
  inputLabel: {
    fontSize: 13,
    fontWeight: '600',
    color: THEME.colors.ink,
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
    paddingVertical: 15,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    marginTop: 10,
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
    fontSize: 16,
    fontWeight: '700',
    color: '#FFFFFF',
  },
  dividerRow: {
    flexDirection: 'row',
    alignItems: 'center',
    marginVertical: 4,
  },
  dividerLine: {
    flex: 1,
    height: 1,
    backgroundColor: THEME.colors.border,
  },
  dividerText: {
    marginHorizontal: 12,
    fontSize: 11,
    fontWeight: '700',
    color: THEME.colors.inkLight,
  },

  termsWrapper: {
    marginTop: 20,
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
