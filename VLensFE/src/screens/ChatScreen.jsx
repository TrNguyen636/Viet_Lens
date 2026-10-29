import React, { useState, useRef, useEffect } from 'react';
import {
  View,
  Text,
  StyleSheet,
  TextInput,
  TouchableOpacity,
  ScrollView,
  KeyboardAvoidingView,
  Platform,
  ActivityIndicator,
  Keyboard,
  Image,
  Alert,
} from 'react-native';
import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import * as Speech from 'expo-speech';
import * as ImagePicker from 'expo-image-picker';
import { useTranslation } from 'react-i18next';
import { THEME } from '../utils/theme';
import appService from '../api/appService';
import { adaptHeritage } from '../utils/heritageAdapter';
import { predictHeritage } from '../services/aiVisionService';

// Nhân vật Trợ lý AI duy nhất của ứng dụng
const VIETLENS_AI = {
  name: 'VietLens AI',
  role: 'Trợ lý Di sản & Văn hóa',
  avatarBg: THEME.colors.amber,
  icon: 'robot',
  greeting: 'Xin chào! Tôi là VietLens AI. Rất vui được đồng hành và giải đáp mọi thắc mắc về lịch sử, kiến trúc và văn hóa cùng bạn.',
};

export default function ChatScreen({ activeSite = null, onNavigateToMap = null }) {
  const { i18n } = useTranslation();
  const [currentSite, setCurrentSite] = useState(
    activeSite ? adaptHeritage(activeSite) : null
  );

  // Khởi tạo tin nhắn (nếu có ảnh chụp truyền từ Camera qua context, hiển thị ngay)
  const buildInitialMessages = (site) => {
    if (!site) {
      return [
        {
          id: 'welcome-general',
          sender: 'advisor',
          text: `${VIETLENS_AI.greeting}\n\nBạn có thể chụp ảnh di tích bằng Camera để nhận diện và thuyết minh tự động, hoặc đặt bất kỳ câu hỏi nào về lịch sử, kiến trúc và văn hóa của các danh lam thắng cảnh Việt Nam nhé!`,
          time: 'Vừa xong',
        },
      ];
    }

    const siteName = site?.name || 'Di tích Việt Nam';
    const location = site?.locationName || site?.province || 'Việt Nam';
    const photo = site?.userPhoto || null;

    const msgs = [
      {
        id: 'welcome-1',
        sender: 'advisor',
        text: `${VIETLENS_AI.greeting}\n\nHiện chúng ta đang cùng khám phá "${siteName}" (${location}). Bạn muốn tìm hiểu gì trước?`,
        time: 'Vừa xong',
      },
    ];

    if (photo) {
      msgs.push({
        id: 'photo-user-init',
        sender: 'user',
        image: photo,
        text: `Tôi vừa chụp ảnh tại ${siteName}. Hãy thuyết minh cho tôi về lịch sử và những điểm đặc sắc nhất tại đây nhé!`,
        time: 'Vừa xong',
      });

      const introText =
        site?.visionReasoning ||
        site?.shortDescription ||
        site?.description ||
        site?.summary ||
        `Tôi đã nhận diện được ảnh bạn chụp tại ${siteName}. Nơi đây lưu giữ nhiều giá trị văn hóa và kiến trúc tiêu biểu của ${location}. Hãy hỏi tôi bất cứ điều gì về lịch sử, kiến trúc hoặc mẹo tham quan nhé!`;

      msgs.push({
        id: 'photo-reply-init',
        sender: 'advisor',
        text: introText.replace(/\*\*/g, '').trim(),
        time: 'Vừa xong',
      });
    }

    return msgs;
  };

  const [messages, setMessages] = useState(() => buildInitialMessages(activeSite));
  const [input, setInput] = useState('');
  const [isSpeaking, setIsSpeaking] = useState(false);
  const [isTyping, setIsTyping] = useState(false);
  const [realHeritageId, setRealHeritageId] = useState(null);
  const scrollRef = useRef();

  // Kiểm tra hoặc tìm UUID di sản thật từ Backend Supabase
  useEffect(() => {
    let isMounted = true;
    const resolveHeritageUUID = async () => {
      const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
      if (currentSite?.id && uuidRegex.test(currentSite.id)) {
        if (isMounted) setRealHeritageId(currentSite.id);
        return;
      }

      try {
        const sites = await appService.getAllHeritage();
        if (isMounted && Array.isArray(sites) && sites.length > 0) {
          const matched = sites.find(
            (s) => s.name?.toLowerCase().includes(currentSite?.name?.toLowerCase())
          );
          setRealHeritageId(matched?.id || null);
        }
      } catch (e) {
        console.warn('[ChatScreen] Chưa lấy được danh sách UUID di sản:', e.message);
        if (isMounted) setRealHeritageId(null);
      }
    };

    resolveHeritageUUID();
    return () => {
      isMounted = false;
      Speech.stop();
    };
  }, [currentSite]);

  // Cập nhật khi activeSite từ props thay đổi (ví dụ: chuyển từ Camera sang kèm ảnh mới)
  useEffect(() => {
    if (activeSite) {
      const adapted = adaptHeritage(activeSite);
      if (activeSite.userPhoto) {
        adapted.userPhoto = activeSite.userPhoto;
      }
      if (activeSite.visionReasoning) {
        adapted.visionReasoning = activeSite.visionReasoning;
      }
      setCurrentSite(adapted);
      setMessages(buildInitialMessages(adapted));
    } else {
      setCurrentSite(null);
      setMessages(buildInitialMessages(null));
    }
  }, [activeSite]);

  // Tự động cuộn xuống tin nhắn mới nhất khi bàn phím ảo hiển thị
  useEffect(() => {
    const showSub = Keyboard.addListener(
      Platform.OS === 'ios' ? 'keyboardWillShow' : 'keyboardDidShow',
      () => {
        setTimeout(() => {
          scrollRef.current?.scrollToEnd({ animated: true });
        }, 100);
      }
    );
    return () => {
      showSub.remove();
    };
  }, []);

  // Gợi ý câu hỏi nhanh
  const quickChips = currentSite
    ? [
        `Ai là người xây dựng ${currentSite.name}?`,
        'Nét kiến trúc độc đáo nhất là gì?',
        'Thời điểm tham quan đẹp nhất trong ngày?',
        'Có giai thoại văn hóa nào về nơi này không?',
      ]
    : [
        'Kể tên các di sản thế giới tại Việt Nam',
        'Cố đô Huế có những công trình kiến trúc nào tiêu biểu?',
        'Nét đặc sắc của di sản Phố cổ Hội An là gì?',
        'Kinh nghiệm khám phá danh thắng Tràng An',
      ];

  // ============================================================
  // TÍCH HỢP CHỤP ẢNH & CHỌN ẢNH DI TÍCH TRỰC TIẾP TRONG CHAT
  // ============================================================
  const handleTakePhoto = async () => {
    try {
      const perm = await ImagePicker.requestCameraPermissionsAsync();
      if (!perm.granted) {
        Alert.alert(
          'Quyền máy ảnh',
          'Vui lòng cấp quyền truy cập máy ảnh trong cài đặt thiết bị để chụp di tích.'
        );
        return;
      }
      const result = await ImagePicker.launchCameraAsync({
        mediaTypes: ['images'],
        allowsEditing: true,
        aspect: [4, 3],
        quality: 0.85,
        base64: true,
      });
      if (!result.canceled && result.assets && result.assets.length > 0) {
        const asset = result.assets[0];
        processCapturedImage(asset.uri, asset.base64);
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi kích hoạt máy ảnh:', err.message);
    }
  };

  const handlePickImage = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ['images'],
        allowsEditing: true,
        aspect: [4, 3],
        quality: 0.85,
        base64: true,
      });
      if (!result.canceled && result.assets && result.assets.length > 0) {
        const asset = result.assets[0];
        processCapturedImage(asset.uri, asset.base64);
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi chọn ảnh thư viện:', err.message);
    }
  };

  const processCapturedImage = async (uri, base64) => {
    const userMsg = {
      id: Date.now().toString(),
      sender: 'user',
      image: uri,
      text: 'Tôi vừa chụp bức ảnh này, hãy nhận diện di tích và chia sẻ về lịch sử, kiến trúc của nó nhé!',
      time: 'Bây giờ',
    };
    setMessages((prev) => [...prev, userMsg]);
    setIsTyping(true);
    setTimeout(() => {
      scrollRef.current?.scrollToEnd({ animated: true });
    }, 100);

    try {
      const currentLang = i18n?.language || 'vi';
      const result = await predictHeritage(uri, currentLang, base64);

      if (result && (result.recognized || result.heritageName)) {
        const sitePayload = {
          id: result.heritageId || 'pred-' + Date.now(),
          name: result.name || result.heritageName,
          province: result.province,
          locationName: result.province,
          address: result.address,
          category: result.category || 'Di sản văn hóa',
          latitude: result.latitude,
          longitude: result.longitude,
          image: uri,
          userPhoto: uri,
          description: result.description,
          confidencePercent: result.confidencePercent,
        };
        setCurrentSite(sitePayload);

        const explanation =
          result.visionReasoning ||
          result.description ||
          'Đây là một di sản kiến trúc và văn hóa nổi tiếng của Việt Nam.';
        const botReply = `✨ Tôi nhận diện đây là "${sitePayload.name}" (${sitePayload.province || 'Việt Nam'})${result.confidencePercent ? ` với độ tin cậy ${result.confidencePercent}` : ''}.\n\n${explanation}`
          .replace(/\*\*/g, '')
          .trim();

        setMessages((prev) => [
          ...prev,
          {
            id: (Date.now() + 1).toString(),
            sender: 'advisor',
            text: botReply,
            time: 'Bây giờ',
            detectedSite: sitePayload, // Kích hoạt Thẻ hành động Xem trên Bản đồ
          },
        ]);
      } else {
        const fallbackReason =
          result?.rejectionReason === 'OUT_OF_DOMAIN'
            ? 'Hình ảnh này dường như không nằm trong danh mục các danh lam thắng cảnh hoặc di tích văn hóa Việt Nam.'
            : 'Tôi chưa thể nhận diện rõ nét di tích trong ảnh. Bạn có thể chụp lại ở góc rõ hơn, đủ ánh sáng hoặc đặt câu hỏi trực tiếp cho tôi nhé!';
        setMessages((prev) => [
          ...prev,
          {
            id: (Date.now() + 1).toString(),
            sender: 'advisor',
            text: fallbackReason,
            time: 'Bây giờ',
          },
        ]);
      }
    } catch (err) {
      console.warn('[ChatScreen] Error predicting heritage:', err.message);
      setMessages((prev) => [
        ...prev,
        {
          id: (Date.now() + 1).toString(),
          sender: 'advisor',
          text: 'Tôi đã nhận được ảnh của bạn! Hiện việc nhận diện tự động đang tạm thời gián đoạn. Bạn có thể hỏi tôi trực tiếp bằng văn bản về di tích bạn đang quan tâm nhé!',
          time: 'Bây giờ',
        },
      ]);
    } finally {
      setIsTyping(false);
      setTimeout(() => {
        scrollRef.current?.scrollToEnd({ animated: true });
      }, 150);
    }
  };

  // Gửi tin nhắn đến VietLens AI (Groq AI hoặc Dynamic AI Context)
  const handleSend = async (textToSend = null) => {
    const text = textToSend || input;
    if (!text.trim()) return;

    const userMsg = {
      id: Date.now().toString(),
      sender: 'user',
      text: text,
      time: 'Bây giờ',
    };

    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setIsTyping(true);
    scrollRef.current?.scrollToEnd({ animated: true });

    try {
      let reply = '';

      // 1. Gọi API Spring Boot Groq AI
      if (realHeritageId) {
        try {
          const res = await appService.sendChatMessage(realHeritageId, text);
          reply = res?.reply || res?.message;
        } catch (apiErr) {
          console.warn('[ChatScreen] Spring Boot chat API error:', apiErr.message);
        }
      }

      // 2. Nếu API lỗi hoặc chưa kết nối được
      if (!reply) {
        if (currentSite) {
          reply = `Tôi đã ghi nhận câu hỏi của bạn về "${currentSite.name}". ${currentSite.summary || currentSite.shortDescription || currentSite.description || 'Di tích này có bề dày lịch sử và kiến trúc rất đặc sắc của Việt Nam.'}`;
        } else {
          reply = 'Cảm ơn bạn đã trò chuyện cùng VietLens AI! Bạn có thể chọn một di tích cụ thể trên bản đồ hoặc chụp ảnh di tích để tôi nhận diện và thuyết minh chuyên sâu nhé!';
        }
      }

      // Làm sạch toàn bộ các ký tự in đậm markdown **
      const cleanReply = (reply || '').replace(/\*\*/g, '').trim();

      setMessages((prev) => [
        ...prev,
        {
          id: (Date.now() + 1).toString(),
          sender: 'advisor',
          text: cleanReply,
          time: 'Bây giờ',
        },
      ]);
    } catch (err) {
      console.warn('[ChatScreen] Error handling message:', err.message);
      const fallbackText = currentSite
        ? `Tôi đã ghi nhận câu hỏi của bạn về "${currentSite.name}". ${currentSite.summary || currentSite.shortDescription || ''}`.replace(/\*\*/g, '').trim()
        : 'VietLens AI đã ghi nhận câu hỏi của bạn. Vui lòng thử lại sau giây lát!';
      setMessages((prev) => [
        ...prev,
        {
          id: (Date.now() + 1).toString(),
          sender: 'advisor',
          text: fallbackText,
          time: 'Bây giờ',
        },
      ]);
    } finally {
      setIsTyping(false);
      scrollRef.current?.scrollToEnd({ animated: true });
    }
  };

  // Đọc phát âm đoạn tin nhắn mới nhất
  const handleToggleSpeech = () => {
    if (isSpeaking) {
      Speech.stop();
      setIsSpeaking(false);
    } else {
      const lastAdvisorMsg = [...messages].reverse().find((m) => m.sender === 'advisor');
      if (lastAdvisorMsg) {
        setIsSpeaking(true);
        Speech.speak(lastAdvisorMsg.text, {
          language: 'vi-VN',
          rate: 0.95,
          onDone: () => setIsSpeaking(false),
          onError: () => setIsSpeaking(false),
        });
      }
    }
  };

  return (
    <KeyboardAvoidingView
      style={styles.container}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 20}
    >
      {/* Header VietLens AI Tinh Gọn */}
      <View style={styles.header}>
        <View style={styles.headerAdvisorInfo}>
          <View style={[styles.advisorAvatar, { backgroundColor: VIETLENS_AI.avatarBg }]}>
            <MaterialCommunityIcons name={VIETLENS_AI.icon} size={22} color="#FFF" />
          </View>
          <View style={{ marginLeft: 10 }}>
            <Text style={styles.advisorName}>{VIETLENS_AI.name}</Text>
            <View style={styles.statusRow}>
              <View style={styles.statusDot} />
              <Text style={styles.statusText}>Trực tuyến • {VIETLENS_AI.role}</Text>
            </View>
          </View>
        </View>

        {/* Nút Audio Speech */}
        <TouchableOpacity
          style={[styles.speechBtn, isSpeaking && styles.speechBtnActive]}
          onPress={handleToggleSpeech}
        >
          <Ionicons
            name={isSpeaking ? 'pause' : 'volume-high'}
            size={18}
            color={isSpeaking ? '#FFF' : THEME.colors.ink}
          />
        </TouchableOpacity>
      </View>

      {/* Ngữ cảnh Di sản đang đàm đạo */}
      <View style={styles.contextBanner}>
        <Ionicons name="sparkles" size={13} color={THEME.colors.amber} />
        <Text style={styles.contextText} numberOfLines={1}>
          Khám phá:{' '}
          <Text style={{ fontWeight: '700' }}>
            {currentSite ? currentSite.name : 'Kho tàng Di sản & Văn hóa Toàn quốc'}
          </Text>
          {currentSite?.locationName ? ` • ${currentSite.locationName}` : ''}
        </Text>
      </View>

      {/* Danh sách Tin nhắn Trò chuyện */}
      <ScrollView
        ref={scrollRef}
        style={styles.chatList}
        contentContainerStyle={styles.chatListContent}
        onContentSizeChange={() => scrollRef.current?.scrollToEnd({ animated: true })}
      >
        {messages.map((msg) => {
          const isUser = msg.sender === 'user';
          return (
            <View
              key={msg.id}
              style={[styles.msgRow, isUser ? styles.msgRowUser : styles.msgRowAdvisor]}
            >
              {!isUser && (
                <View style={[styles.msgAvatar, { backgroundColor: VIETLENS_AI.avatarBg }]}>
                  <MaterialCommunityIcons name={VIETLENS_AI.icon} size={14} color="#FFF" />
                </View>
              )}
              <View style={[styles.bubble, isUser ? styles.bubbleUser : styles.bubbleAdvisor]}>
                {/* Hiển thị ảnh chụp trực quan nếu tin nhắn có kèm ảnh */}
                {msg.image && (
                  <View style={styles.photoContainer}>
                    <Image
                      source={{ uri: msg.image }}
                      style={styles.msgPhoto}
                      resizeMode="cover"
                    />
                    <View style={styles.photoBadge}>
                      <Ionicons name="camera" size={12} color="#FFF" />
                      <Text style={styles.photoBadgeText}>Ảnh vừa chụp</Text>
                    </View>
                  </View>
                )}

                {!!msg.text && (
                  <Text style={[styles.msgText, isUser ? styles.msgTextUser : styles.msgTextAdvisor]}>
                    {msg.text}
                  </Text>
                )}

                {/* Thẻ hành động Điều hướng Bản đồ tương tác khi AI nhận diện thành công */}
                {msg.detectedSite && (
                  <TouchableOpacity
                    style={styles.mapActionCard}
                    onPress={() => onNavigateToMap && onNavigateToMap(msg.detectedSite)}
                    activeOpacity={0.85}
                  >
                    <View style={styles.mapActionIconCircle}>
                      <Ionicons name="map" size={16} color="#FFF" />
                    </View>
                    <View style={styles.mapActionInfo}>
                      <Text style={styles.mapActionTitle}>Xem vị trí trên Bản đồ</Text>
                      <Text style={styles.mapActionSub} numberOfLines={1}>
                        {msg.detectedSite.name} ({msg.detectedSite.province || 'Việt Nam'})
                      </Text>
                    </View>
                    <Ionicons name="chevron-forward" size={16} color="#C62828" />
                  </TouchableOpacity>
                )}

                <Text style={[styles.msgTime, isUser ? styles.msgTimeUser : styles.msgTimeAdvisor]}>
                  {msg.time}
                </Text>
              </View>
            </View>
          );
        })}

        {isTyping && (
          <View style={[styles.msgRow, styles.msgRowAdvisor]}>
            <View style={[styles.msgAvatar, { backgroundColor: VIETLENS_AI.avatarBg }]}>
              <MaterialCommunityIcons name={VIETLENS_AI.icon} size={14} color="#FFF" />
            </View>
            <View style={[styles.bubble, styles.bubbleAdvisor, styles.typingBubble]}>
              <ActivityIndicator size="small" color={THEME.colors.amber} />
              <Text style={styles.typingText}>VietLens AI đang soạn câu trả lời...</Text>
            </View>
          </View>
        )}
      </ScrollView>

      {/* Quick Question Chips */}
      <View style={styles.quickChipsWrapper}>
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={styles.quickChipsScroll}>
          {quickChips.map((chip, idx) => (
            <TouchableOpacity
              key={idx}
              style={styles.quickChip}
              onPress={() => handleSend(chip)}
            >
              <Text style={styles.quickChipText}>{chip}</Text>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </View>

      {/* Ô Nhập tin nhắn tích hợp Camera & Thư viện */}
      <View style={styles.inputContainer}>
        <TouchableOpacity
          style={styles.mediaBtn}
          onPress={handleTakePhoto}
          activeOpacity={0.7}
        >
          <Ionicons name="camera" size={22} color={THEME.colors.red} />
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.mediaBtn}
          onPress={handlePickImage}
          activeOpacity={0.7}
        >
          <Ionicons name="image-outline" size={22} color={THEME.colors.inkMuted} />
        </TouchableOpacity>

        <TextInput
          style={styles.textInput}
          placeholder="Hỏi VietLens AI về di tích này..."
          placeholderTextColor={THEME.colors.inkLight}
          value={input}
          onChangeText={setInput}
          onSubmitEditing={() => handleSend()}
          onFocus={() => {
            setTimeout(() => {
              scrollRef.current?.scrollToEnd({ animated: true });
            }, 150);
          }}
        />
        <TouchableOpacity
          style={[styles.sendBtn, !input.trim() && styles.sendBtnDisabled]}
          onPress={() => handleSend()}
          disabled={!input.trim()}
        >
          <Ionicons name="arrow-up" size={20} color="#FFF" />
        </TouchableOpacity>
      </View>
    </KeyboardAvoidingView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: THEME.colors.bg,
  },
  header: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingTop: 14,
    paddingBottom: 12,
    backgroundColor: '#FFF',
    borderBottomWidth: 1,
    borderBottomColor: THEME.colors.border,
  },
  headerAdvisorInfo: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  advisorAvatar: {
    width: 42,
    height: 42,
    borderRadius: 21,
    alignItems: 'center',
    justifyContent: 'center',
    elevation: 2,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 1 },
    shadowOpacity: 0.1,
    shadowRadius: 3,
  },
  advisorName: {
    fontSize: 16,
    fontWeight: '700',
    color: THEME.colors.ink,
  },
  statusRow: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 5,
    marginTop: 2,
  },
  statusDot: {
    width: 7,
    height: 7,
    borderRadius: 3.5,
    backgroundColor: THEME.colors.green,
  },
  statusText: {
    fontSize: 11,
    color: THEME.colors.inkMuted,
  },
  speechBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    backgroundColor: THEME.colors.parchment,
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  speechBtnActive: {
    backgroundColor: THEME.colors.red,
    borderColor: THEME.colors.red,
  },
  contextBanner: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 6,
    paddingHorizontal: 16,
    paddingVertical: 8,
    backgroundColor: '#FEF3C7',
    borderBottomWidth: 1,
    borderBottomColor: '#FDE68A',
  },
  contextText: {
    fontSize: 12,
    color: '#92400E',
    flex: 1,
  },
  chatList: {
    flex: 1,
  },
  chatListContent: {
    paddingHorizontal: 16,
    paddingVertical: 14,
  },
  msgRow: {
    flexDirection: 'row',
    marginBottom: 14,
    alignItems: 'flex-end',
  },
  msgRowUser: {
    justifyContent: 'flex-end',
  },
  msgRowAdvisor: {
    justifyContent: 'flex-start',
  },
  msgAvatar: {
    width: 28,
    height: 28,
    borderRadius: 14,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 8,
    marginBottom: 2,
  },
  bubble: {
    maxWidth: '84%',
    paddingHorizontal: 14,
    paddingVertical: 10,
    borderRadius: 18,
  },
  bubbleUser: {
    backgroundColor: THEME.colors.red,
    borderBottomRightRadius: 4,
  },
  bubbleAdvisor: {
    backgroundColor: '#FFF',
    borderBottomLeftRadius: 4,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  photoContainer: {
    position: 'relative',
    marginBottom: 8,
    borderRadius: 12,
    overflow: 'hidden',
  },
  msgPhoto: {
    width: 230,
    height: 155,
    borderRadius: 12,
  },
  photoBadge: {
    position: 'absolute',
    bottom: 6,
    left: 6,
    backgroundColor: 'rgba(0, 0, 0, 0.65)',
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 8,
  },
  photoBadgeText: {
    color: '#FFF',
    fontSize: 10,
    fontWeight: '600',
  },
  typingBubble: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 8,
  },
  typingText: {
    fontSize: 12,
    color: THEME.colors.inkMuted,
    fontStyle: 'italic',
  },
  msgText: {
    fontSize: 14,
    lineHeight: 21,
  },
  msgTextUser: {
    color: '#FFF',
  },
  msgTextAdvisor: {
    color: THEME.colors.ink,
  },
  msgTime: {
    fontSize: 10,
    marginTop: 4,
    alignSelf: 'flex-end',
  },
  msgTimeUser: {
    color: '#FEE2E2',
  },
  msgTimeAdvisor: {
    color: THEME.colors.inkMuted,
  },
  quickChipsWrapper: {
    paddingVertical: 6,
    backgroundColor: THEME.colors.bg,
  },
  quickChipsScroll: {
    paddingHorizontal: 16,
    gap: 8,
  },
  quickChip: {
    backgroundColor: '#FFF',
    paddingHorizontal: 12,
    paddingVertical: 7,
    borderRadius: 14,
    borderWidth: 1,
    borderColor: THEME.colors.border,
  },
  quickChipText: {
    fontSize: 12,
    color: THEME.colors.ink,
  },
  inputContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 10,
    backgroundColor: '#FFF',
    borderTopWidth: 1,
    borderTopColor: THEME.colors.border,
  },
  textInput: {
    flex: 1,
    backgroundColor: '#F9FAFB',
    borderWidth: 1,
    borderColor: THEME.colors.border,
    borderRadius: 20,
    paddingHorizontal: 16,
    paddingVertical: 9,
    fontSize: 14,
    color: THEME.colors.ink,
  },
  sendBtn: {
    width: 38,
    height: 38,
    borderRadius: 19,
    backgroundColor: THEME.colors.red,
    alignItems: 'center',
    justifyContent: 'center',
    marginLeft: 10,
  },
  sendBtnDisabled: {
    backgroundColor: '#D1D5DB',
  },
  mediaBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 4,
  },
  mapActionCard: {
    marginTop: 10,
    backgroundColor: '#FFFBEB',
    borderWidth: 1.5,
    borderColor: '#FCD34D',
    borderRadius: 14,
    padding: 10,
    flexDirection: 'row',
    alignItems: 'center',
    gap: 10,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.08,
    shadowRadius: 4,
    elevation: 2,
  },
  mapActionIconCircle: {
    width: 34,
    height: 34,
    borderRadius: 17,
    backgroundColor: THEME.colors.red,
    alignItems: 'center',
    justifyContent: 'center',
  },
  mapActionInfo: {
    flex: 1,
  },
  mapActionTitle: {
    fontSize: 12,
    fontWeight: '800',
    color: '#92400E',
  },
  mapActionSub: {
    fontSize: 11,
    color: '#B45309',
    marginTop: 1,
  },
});
