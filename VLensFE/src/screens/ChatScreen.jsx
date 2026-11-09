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
import AsyncStorage from '@react-native-async-storage/async-storage';
import { THEME, useTheme } from '../utils/theme';
import appService from '../api/appService';
import { supabase } from '../services/supabase';
import { adaptHeritage } from '../utils/heritageAdapter';
import { predictHeritage, chatWithGroqCloud } from '../services/aiVisionService';
import { sendPhotoAndQuestionToModel, sendTextQuestionToModel } from '../services/aiChatModelService';
import ChatHistoryDrawer from '../components/ChatHistoryDrawer';

export default function ChatScreen({
  user = null,
  activeSite = null,
  onNavigateToMap = null,
  onClearActiveSite = null,
}) {
  const { t, i18n } = useTranslation();
  const { theme, isDark } = useTheme();
  const currentLangCode = (i18n?.language || 'vi').toLowerCase();
  const isEn = currentLangCode.startsWith('en');
  const isJa = currentLangCode.startsWith('ja');

  // Thông tin Trợ lý VietLens AI
  const advisorProfile = {
    name: 'VietLens AI',
    role: isJa ? '文化・遺産アドバイザー' : (isEn ? 'Cultural & Heritage Advisor' : 'Trợ lý Di sản & Văn hóa'),
    status: isJa ? 'オンライン' : (isEn ? 'Online' : 'Trực tuyến'),
    avatarBg: theme.colors.amber,
    icon: 'robot',
    greeting: isJa
      ? 'こんにちは！VietLens AIです。ベトナムの歴史、建築、文化に関するご案内やご質問に喜んでお答えいたします。'
      : (isEn
        ? "Hello! I am VietLens AI. Delighted to accompany and answer all your questions about Vietnam's history, architecture, and culture."
        : "Xin chào! Tôi là VietLens AI. Rất vui được đồng hành và giải đáp mọi thắc mắc về lịch sử, kiến trúc và văn hóa cùng bạn."),
  };

  const [currentSite, setCurrentSite] = useState(
    activeSite ? adaptHeritage(activeSite) : null
  );

  // Đặt lại ngữ cảnh về chế độ Trò chuyện Tự do (Open Chat)
  const handleResetSiteContext = () => {
    setCurrentSite(null);
    setMessages(buildInitialMessages(null));
    if (onClearActiveSite) {
      onClearActiveSite();
    }
  };

  // Ảnh đính kèm đang chờ gửi (cho phép người dùng xem trước và gõ câu hỏi riêng)
  const [pendingImage, setPendingImage] = useState(null); // { uri, base64 }

  // Khởi tạo tin nhắn chào đón
  const buildInitialMessages = (site) => {
    if (!site) {
      return [
        {
          id: 'welcome-general',
          sender: 'advisor',
          text: `${advisorProfile.greeting}\n\n${
            isJa
              ? 'カメラで遺産の写真を撮影・アップロードして自動識別するか、ベトナムの名所について何でもお気軽にご質問ください！'
              : (isEn
                ? 'You can snap or upload a photo of any heritage site to identify it automatically, or ask any questions about Vietnamese cultural landmarks!'
                : 'Bạn có thể chụp ảnh di tích bằng Camera để nhận diện và thuyết minh tự động, hoặc đặt bất kỳ câu hỏi nào về lịch sử, kiến trúc và văn hóa của các danh lam thắng cảnh Việt Nam nhé!')
          }`,
          time: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
        },
      ];
    }

    const siteName = site?.name || (isJa ? 'ベトナムの遺産' : (isEn ? 'Vietnam Heritage' : 'Di tích Việt Nam'));
    const location = site?.locationName || site?.province || (isJa ? 'ベトナム' : (isEn ? 'Vietnam' : 'Việt Nam'));
    const photo = site?.userPhoto || null;

    const msgs = [
      {
        id: 'welcome-1',
        sender: 'advisor',
        text: `${advisorProfile.greeting}\n\n${
          isJa
            ? `現在「${siteName}」(${location})についてご案内しています。何について知りたいですか？`
            : (isEn
              ? `We are currently exploring "${siteName}" (${location}). What would you like to discover first?`
              : `Hiện chúng ta đang cùng khám phá "${siteName}" (${location}). Bạn muốn tìm hiểu gì trước?`)
        }`,
        time: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
      },
    ];

    if (photo) {
      msgs.push({
        id: 'photo-user-init',
        sender: 'user',
        image: photo,
        text: '', // Không chèn câu hỏi mẫu, chỉ hiển thị ảnh của người dùng
        time: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
      });

      const introText =
        site?.visionReasoning ||
        site?.shortDescription ||
        site?.description ||
        site?.summary ||
        (isJa
          ? `「${siteName}」の写真を認識しました。ここは${location}の優れた文化的価値を受け継ぐ名所です。歴史や建築など、何でもお尋ねください！`
          : (isEn
            ? `I recognized your photo at ${siteName}. This place preserves distinguished cultural values of ${location}. Feel free to ask me anything!`
            : `Tôi đã nhận diện được ảnh bạn chụp tại ${siteName}. Nơi đây lưu giữ nhiều giá trị văn hóa và kiến trúc tiêu biểu của ${location}. Hãy hỏi tôi bất cứ điều gì về lịch sử, kiến trúc hoặc mẹo tham quan nhé!`));

      msgs.push({
        id: 'photo-reply-init',
        sender: 'advisor',
        text: introText.replace(/\*\*/g, '').trim(),
        detectedSite: site,
        time: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
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

  // Quản lý Slide Bar Lịch sử trò chuyện
  const [isDrawerOpen, setIsDrawerOpen] = useState(false);
  const [currentSessionId, setCurrentSessionId] = useState(null);
  const currentSessionIdRef = useRef(null);
  const [sessions, setSessions] = useState([]);
  const [isLoadingSessions, setIsLoadingSessions] = useState(false);

  // Cập nhật đồng bộ cả State và Ref để chống lỗi Stale Closure trong các hàm bất đồng bộ
  const updateSessionId = (newId) => {
    currentSessionIdRef.current = newId;
    setCurrentSessionId(newId);
  };

  // Định dạng thời gian tương đối
  const formatRelativeTime = (isoString, lang = 'vi') => {
    const currentLang = (lang || 'vi').toLowerCase();
    const isEnglish = currentLang.startsWith('en');
    const isJapanese = currentLang.startsWith('ja');
    if (!isoString) return isJapanese ? '最近' : (isEnglish ? 'Recently' : 'Gần đây');
    try {
      const date = new Date(isoString);
      if (isNaN(date.getTime())) return isJapanese ? '最近' : (isEnglish ? 'Recently' : 'Gần đây');
      const now = new Date();
      const diffSec = Math.floor((now - date) / 1000);
      if (diffSec < 60) return isJapanese ? 'たった今' : (isEnglish ? 'Just now' : 'Vừa xong');
      const diffMin = Math.floor(diffSec / 60);
      if (diffMin < 60) return isJapanese ? `${diffMin}分前` : (isEnglish ? `${diffMin}m ago` : `${diffMin} phút trước`);
      const diffHr = Math.floor(diffMin / 60);
      if (diffHr < 24) return isJapanese ? `${diffHr}時間前` : (isEnglish ? `${diffHr}h ago` : `${diffHr} giờ trước`);
      const diffDay = Math.floor(diffHr / 24);
      if (diffDay === 1) return isJapanese ? '昨日' : (isEnglish ? 'Yesterday' : 'Hôm qua');
      if (diffDay < 7) return isJapanese ? `${diffDay}日前` : (isEnglish ? `${diffDay}d ago` : `${diffDay} ngày trước`);
      return `${date.getDate()}/${date.getMonth() + 1}/${date.getFullYear()}`;
    } catch {
      return isJapanese ? '最近' : (isEnglish ? 'Recently' : 'Gần đây');
    }
  };

  const GUEST_SESSIONS_KEY = '@vietlens_guest_chat_sessions';

  const loadGuestSessions = async () => {
    try {
      const raw = await AsyncStorage.getItem(GUEST_SESSIONS_KEY);
      if (raw) {
        const parsed = JSON.parse(raw);
        if (Array.isArray(parsed)) {
          setSessions(parsed);
        }
      }
    } catch (e) {
      console.warn('[ChatScreen] Lỗi đọc guest sessions:', e?.message);
    }
  };

  const saveGuestSessions = async (newSessions) => {
    try {
      await AsyncStorage.setItem(GUEST_SESSIONS_KEY, JSON.stringify(newSessions));
    } catch (e) {
      console.warn('[ChatScreen] Lỗi lưu guest sessions:', e?.message);
    }
  };

  // Tải danh sách phiên trò chuyện từ JBE Backend (hoặc fallback AsyncStorage)
  const fetchSessions = async () => {
    setIsLoadingSessions(true);
    try {
      const { data: { session: authSession } } = await supabase.auth.getSession();
      if (authSession?.access_token) {
        const res = await appService.getChatSessions();
        if (Array.isArray(res)) {
          const mapped = res.map((s) => ({
            id: s.id,
            title: s.title || (isJa ? '会話' : (isEn ? 'Conversation' : 'Cuộc trò chuyện')),
            siteName: s.heritageName || null,
            lastMessage: s.lastMessage || (isJa ? '会話を開始...' : (isEn ? 'Start conversation...' : 'Đàm đạo di sản...')),
            updatedAt: formatRelativeTime(s.updatedAt, i18n?.language),
            heritageId: s.heritageId || null,
            isRemote: true,
          }));
          setSessions(mapped);
          return;
        }
      }
      await loadGuestSessions();
    } catch (err) {
      console.warn('[ChatScreen] Không kết nối được JBE, fallback local:', err?.message);
      await loadGuestSessions();
    } finally {
      setIsLoadingSessions(false);
    }
  };

  // Tự động tải lại lịch sử khi mở Slide Bar hoặc chuyển đổi ngôn ngữ
  useEffect(() => {
    if (isDrawerOpen) {
      fetchSessions();
    }
  }, [isDrawerOpen, i18n?.language]);

  /**
   * Lấy ID phiên hiện tại hoặc tạo DUY NHẤT 1 phiên mới khi người dùng bắt đầu câu hỏi đầu tiên.
   * TUYỆT ĐỐI không tạo phiên mới từ câu trả lời của AI.
   */
  const getOrCreateSession = async (userPromptText, site = null) => {
    // 1. Nếu cuộc trò chuyện này đã có phiên active -> Tái sử dụng phiên này
    if (currentSessionIdRef.current) {
      return currentSessionIdRef.current;
    }

    const currentSiteObj = site || currentSite;
    const siteName = currentSiteObj?.name || null;
    const heritageId = realHeritageId || currentSiteObj?.id || null;

    // Tiêu đề phiên CHỈ được trích xuất từ câu hỏi người dùng hoặc tên di sản
    let rawTitle = siteName
      ? (isJa ? `${siteName}を探索` : (isEn ? `Explore ${siteName}` : `Khám phá ${siteName}`))
      : userPromptText && userPromptText.trim().length > 0
      ? userPromptText.trim()
      : isJa ? '遺産Q&A' : (isEn ? 'Cultural Q&A' : 'Hỏi đáp di sản');

    if (rawTitle.length > 50) {
      rawTitle = rawTitle.substring(0, 47) + '...';
    }

    try {
      const { data: { session: authSession } } = await supabase.auth.getSession();
      const isAuthed = Boolean(authSession?.access_token);

      if (isAuthed) {
        const created = await appService.createChatSession(rawTitle, heritageId);
        if (created?.id) {
          updateSessionId(created.id);
          setSessions((prev) => [
            {
              id: created.id,
              title: rawTitle,
              siteName: siteName,
              lastMessage: userPromptText || '',
              updatedAt: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
              heritageId: heritageId,
              isRemote: true,
            },
            ...prev.filter((s) => s.id !== created.id),
          ]);
          return created.id;
        }
      }
    } catch (err) {
      console.warn('[ChatScreen] Không tạo được session trên JBE, fallback local:', err?.message);
    }

    // Chế độ Guest nếu chưa đăng nhập
    const guestId = 'guest-' + Date.now();
    updateSessionId(guestId);
    const guestSession = {
      id: guestId,
      title: rawTitle,
      siteName: siteName,
      lastMessage: userPromptText || '',
      updatedAt: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
      siteContext: currentSiteObj || null,
      messages: [],
      isRemote: false,
    };
    setSessions((prev) => {
      const next = [guestSession, ...prev.filter((s) => s.id !== guestId)];
      saveGuestSessions(next);
      return next;
    });
    return guestId;
  };

  /**
   * Lưu tin nhắn vào ĐÚNG phiên đã chỉ định (sessionId), cập nhật xem trước tin nhắn cuối cùng.
   */
  const saveMessageToSession = async (sessionId, { sender, content, imageUrl = null, confidenceScore = null }) => {
    if (!sessionId) return;

    try {
      const { data: { session: authSession } } = await supabase.auth.getSession();
      const isAuthed = Boolean(authSession?.access_token);

      if (isAuthed && !sessionId.startsWith('guest-')) {
        await appService.addChatMessage(sessionId, {
          sender,
          content: content || (imageUrl ? (isJa ? '[遺産写真]' : (isEn ? '[Heritage photo]' : '[Ảnh di tích]')) : '...'),
          imageUrl: imageUrl || null,
          confidenceScore: confidenceScore || null,
        });

        // Cập nhật nội dung xem trước và thời gian trên danh sách sessions
        setSessions((prev) =>
          prev.map((s) =>
            s.id === sessionId
              ? { ...s, lastMessage: content || s.lastMessage, updatedAt: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong') }
              : s
          )
        );
      } else {
        // Chế độ Guest
        setSessions((prev) => {
          const next = prev.map((s) => {
            if (s.id === sessionId) {
              const newMsg = {
                id: Date.now().toString(),
                sender,
                text: content,
                image: imageUrl,
                time: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
              };
              return {
                ...s,
                lastMessage: content || s.lastMessage,
                updatedAt: isJa ? 'たった今' : (isEn ? 'Just now' : 'Vừa xong'),
                messages: [...(s.messages || []), newMsg],
              };
            }
            return s;
          });
          saveGuestSessions(next);
          return next;
        });
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi lưu tin nhắn vào session:', err?.message);
    }
  };

  // Chọn một phiên từ danh sách lịch sử
  const handleSelectSession = async (session) => {
    updateSessionId(session.id);
    setIsLoadingSessions(true);
    try {
      if (session.isRemote) {
        const messagesData = await appService.getChatSessionMessages(session.id);
        if (Array.isArray(messagesData) && messagesData.length > 0) {
          const restored = messagesData.map((m) => ({
            id: m.id,
            sender: m.sender,
            text: m.content || '',
            image: m.imageUrl || null,
            time: formatRelativeTime(m.createdAt, i18n?.language),
          }));
          setMessages(restored);
        } else {
          setMessages(buildInitialMessages(null));
        }

        if (session.heritageId) {
          try {
            const siteDetail = await appService.getHeritageById(session.heritageId);
            if (siteDetail) {
              setCurrentSite(adaptHeritage(siteDetail));
            }
          } catch {}
        } else {
          setCurrentSite(null);
        }
      } else {
        // Guest session
        if (session.messages && session.messages.length > 0) {
          setMessages(session.messages);
        } else {
          setMessages(buildInitialMessages(session.siteContext));
        }
        setCurrentSite(session.siteContext ? adaptHeritage(session.siteContext) : null);
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi tải tin nhắn phiên:', err?.message);
    } finally {
      setIsLoadingSessions(false);
      setIsDrawerOpen(false);
    }
  };

  // Bắt đầu cuộc trò chuyện mới
  const handleNewChat = () => {
    updateSessionId(null);
    setCurrentSite(null);
    setMessages(buildInitialMessages(null));
    setIsDrawerOpen(false);
    if (onClearActiveSite) {
      onClearActiveSite();
    }
  };

  // Xóa một phiên trò chuyện
  const handleDeleteSession = async (sessionId) => {
    try {
      const target = sessions.find((s) => s.id === sessionId);
      if (target?.isRemote) {
        await appService.deleteChatSession(sessionId);
      } else {
        const remaining = sessions.filter((s) => s.id !== sessionId);
        await saveGuestSessions(remaining);
      }
      setSessions((prev) => prev.filter((s) => s.id !== sessionId));
      if (currentSessionIdRef.current === sessionId) {
        handleNewChat();
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi xóa phiên chat:', err?.message);
      Alert.alert(
        isJa ? 'エラー' : (isEn ? 'Error' : 'Lỗi'),
        isJa
          ? '会話を削除できませんでした。バックエンドの接続を確認してください！'
          : (isEn
            ? 'Could not delete session. Please check your backend connection!'
            : 'Không thể xóa cuộc trò chuyện. Vui lòng kiểm tra kết nối Backend!')
      );
    }
  };

  // Kiểm tra hoặc tìm UUID di sản từ Backend Supabase
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

  // Cập nhật khi activeSite từ props thay đổi
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
  }, [activeSite, i18n?.language]);

  // Tự động cuộn xuống khi mở bàn phím ảo
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

  // ============================================================
  // TÍCH HỢP CHỤP ẢNH & CHỌN ẢNH DI TÍCH (LƯU VÀO PREVIEW)
  // ============================================================
  const handleTakePhoto = async () => {
    try {
      const perm = await ImagePicker.requestCameraPermissionsAsync();
      if (!perm.granted) {
        Alert.alert(
          isJa ? 'カメラの権限' : (isEn ? 'Camera Permission' : 'Quyền máy ảnh'),
          isJa
            ? '遺産の写真を撮影するには、端末の設定でカメラへのアクセスを許可してください。'
            : (isEn
              ? 'Please grant camera access in your device settings to take heritage photos.'
              : 'Vui lòng cấp quyền truy cập máy ảnh trong cài đặt thiết bị để chụp di tích.')
        );
        return;
      }
      const result = await ImagePicker.launchCameraAsync({
        mediaTypes: ['images'],
        allowsEditing: false,
        quality: 0.6,
        base64: true,
      });
      if (!result.canceled && result.assets && result.assets.length > 0) {
        const asset = result.assets[0];
        setPendingImage({ uri: asset.uri, base64: asset.base64 });
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi kích hoạt máy ảnh:', err.message);
    }
  };

  const handlePickImage = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ['images'],
        allowsEditing: false,
        quality: 0.6,
        base64: true,
      });
      if (!result.canceled && result.assets && result.assets.length > 0) {
        const asset = result.assets[0];
        setPendingImage({ uri: asset.uri, base64: asset.base64 });
      }
    } catch (err) {
      console.warn('[ChatScreen] Lỗi chọn ảnh thư viện:', err.message);
    }
  };

  // ============================================================
  // XỬ LÝ GỬI TIN NHẮN (HỖ TRỢ ĐÍNH KÈM ẢNH + CÂU HỎI TÙY CHỌN)
  // ============================================================
  const handleSend = async (textToSend = null) => {
    const rawInput = textToSend !== null ? textToSend : input;
    const currentLang = i18n?.language || 'vi';
    const langIsEn = currentLang.toLowerCase().startsWith('en');
    const langIsJa = currentLang.toLowerCase().startsWith('ja');

    // ----------------------------------------------------------
    // TRƯỜNG HỢP 1: CÓ ẢNH ĐANG CHỜ GỬI (ĐÍNH KÈM ẢNH + CÂU HỎI USER)
    // ----------------------------------------------------------
    if (pendingImage) {
      const imageUri = pendingImage.uri;
      const imageBase64 = pendingImage.base64;
      const userCustomQuestion = rawInput.trim();

      // Xóa ngay trạng thái pending và input
      setPendingImage(null);
      setInput('');

      // Chỉ hiển thị chữ nếu người dùng tự nhập câu hỏi riêng.
      // Người dùng gửi ảnh thì bong bóng chỉ hiển thị ảnh, không kèm câu hỏi mẫu cứng nhắc.
      const displayText = userCustomQuestion || '';

      const userMsg = {
        id: Date.now().toString(),
        sender: 'user',
        image: imageUri,
        text: displayText,
        time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
      };

      setMessages((prev) => [...prev, userMsg]);
      setIsTyping(true);
      setTimeout(() => {
        scrollRef.current?.scrollToEnd({ animated: true });
      }, 100);

      // 1. Lấy hoặc tạo DUY NHẤT 1 phiên cho cuộc trò chuyện này
      const activeSessionId = await getOrCreateSession(
        userCustomQuestion || (langIsJa ? '遺産写真の識別' : (langIsEn ? 'Recognize heritage photo' : 'Nhận diện di tích qua ảnh')),
        currentSite
      );

      // 2. Lưu tin nhắn gửi ảnh của người dùng vào phiên này
      await saveMessageToSession(activeSessionId, {
        sender: 'user',
        content: displayText || (langIsJa ? '[遺産写真を送信]' : (langIsEn ? '[Heritage photo sent]' : '[Đã gửi ảnh di tích]')),
        imageUrl: imageUri,
      });

      try {
        let result = null;
        try {
          // 1. Gọi trực tiếp microservice VLensModel (:8000) qua JSON thuần (chống lỗi FormData Android)
          result = await sendPhotoAndQuestionToModel(
            imageUri,
            imageBase64,
            userCustomQuestion || null,
            currentLang
          );
        } catch (vlensModelErr) {
          console.warn('[ChatScreen] VLensModel error, fallback to Groq predictHeritage:', vlensModelErr.message);
          result = await predictHeritage(
            imageUri,
            currentLang,
            imageBase64,
            userCustomQuestion || null,
            { skipModelServer: true }
          );
        }

        if (result && !result.isOutOfDomain && (result.landmark || result.recognized || result.heritageName)) {
          const siteName = result.landmark || result.name || result.heritageName;
          const siteCity = result.city || result.province || (langIsJa ? 'ベトナム' : (langIsEn ? 'Vietnam' : 'Việt Nam'));
          const confidence = result.confidence || (result.confidencePercent ? parseInt(result.confidencePercent) : 94);

          const sitePayload = {
            id: result.heritageId || 'pred-' + Date.now(),
            name: siteName,
            province: siteCity,
            locationName: siteCity,
            address: result.address || (siteCity ? `${siteName}, ${siteCity}` : siteName),
            category: result.category || (langIsJa ? '文化遺産' : (langIsEn ? 'Cultural Heritage' : 'Di sản văn hóa')),
            latitude: result.latitude || null,
            longitude: result.longitude || null,
            image: imageUri,
            userPhoto: imageUri,
            description: result.answer || result.description || '',
            confidencePercent: `${confidence}%`,
          };
          setCurrentSite(sitePayload);

          const explanation =
            result.answer ||
            result.visionReasoning ||
            result.description ||
            (langIsJa
              ? 'これはベトナムを代表する歴史的・文化的に著名な遺産です。'
              : (langIsEn
                ? 'This is a renowned cultural and historical landmark in Vietnam.'
                : 'Đây là một di sản kiến trúc và văn hóa nổi tiếng của Việt Nam.'));

          const botReply = `✨ ${
            langIsJa
              ? `「${sitePayload.name}」(${sitePayload.province || 'ベトナム'}) と識別しました (信頼度 ${confidence}%)。\n\n${explanation}`
              : (langIsEn
                ? `I identified this as "${sitePayload.name}" (${sitePayload.province || 'Vietnam'}) with ${confidence}% confidence.\n\n${explanation}`
                : `Tôi nhận diện đây là "${sitePayload.name}" (${sitePayload.province || 'Việt Nam'}) với độ tin cậy ${confidence}%.\n\n${explanation}`)
          }`
            .replace(/\*\*/g, '')
            .trim();

          setMessages((prev) => [
            ...prev,
            {
              id: (Date.now() + 1).toString(),
              sender: 'advisor',
              text: botReply,
              detectedSite: sitePayload,
              time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
            },
          ]);
          await saveMessageToSession(activeSessionId, {
            sender: 'advisor',
            content: botReply,
            confidenceScore: confidence,
          });
        } else {
          setCurrentSite(null); // Giải phóng ngữ cảnh di tích cũ khi ảnh là ngoài phạm vi di sản
          const fallbackReason =
            result?.isOutOfDomain || result?.rejectionReason === 'OUT_OF_DOMAIN'
              ? (langIsJa
                ? 'この画像はベトナムの文化遺産や名所として認識されませんでした。別の角度や別の場所をお試しください！'
                : (langIsEn
                  ? 'This image does not appear to be a recognized cultural heritage site or landmark in Vietnam.'
                  : 'Hình ảnh này dường như không nằm trong danh mục các danh lam thắng cảnh hoặc di tích văn hóa Việt Nam.'))
              : (langIsJa
                ? '写真から遺産を明確に認識できませんでした。別の角度から撮影するか、直接ご質問ください！'
                : (langIsEn
                  ? 'I could not clearly recognize any heritage site in this photo. You can try another clearer angle or ask me directly!'
                  : 'Tôi chưa thể nhận diện rõ nét di tích trong ảnh. Bạn có thể chụp lại ở góc rõ hơn, đủ ánh sáng hoặc đặt câu hỏi trực tiếp cho tôi nhé!'));
          setMessages((prev) => [
            ...prev,
            {
              id: (Date.now() + 1).toString(),
              sender: 'advisor',
              text: fallbackReason,
              time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
            },
          ]);
          await saveMessageToSession(activeSessionId, {
            sender: 'advisor',
            content: fallbackReason,
          });
        }
      } catch (err) {
        console.warn('[ChatScreen] Error predicting heritage:', err.message);
        setMessages((prev) => [
          ...prev,
          {
            id: (Date.now() + 1).toString(),
            sender: 'advisor',
            text: langIsJa
              ? '写真を受信しましたが、現在自動識別が一時的に利用できません。遺産について直接ご質問ください！'
              : (langIsEn
                ? 'I received your photo, but automatic recognition is currently unavailable. You can ask me questions about any heritage site directly!'
                : 'Tôi đã nhận được ảnh của bạn! Hiện việc nhận diện tự động đang tạm thời gián đoạn. Bạn có thể hỏi tôi trực tiếp bằng văn bản về di tích bạn đang quan tâm nhé!'),
            time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
          },
        ]);
      } finally {
        setIsTyping(false);
        setTimeout(() => {
          scrollRef.current?.scrollToEnd({ animated: true });
        }, 150);
      }
      return;
    }

    // ----------------------------------------------------------
    // TRƯỜNG HỢP 2: TIN NHẮN VĂN BẢN BÌNH THƯỜNG
    // ----------------------------------------------------------
    const text = rawInput.trim();
    if (!text) return;

    const userMsg = {
      id: Date.now().toString(),
      sender: 'user',
      text: text,
      time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
    };

    setMessages((prev) => [...prev, userMsg]);
    setInput('');
    setIsTyping(true);
    scrollRef.current?.scrollToEnd({ animated: true });

    // 1. Xác định hoặc tạo DUY NHẤT 1 phiên cho cuộc hội thoại này
    const activeSessionId = await getOrCreateSession(text, currentSite);

    // 2. Lưu câu hỏi của người dùng vào phiên này
    await saveMessageToSession(activeSessionId, {
      sender: 'user',
      content: text,
    });

    try {
      let reply = '';

      // 1. Ưu tiên gọi VLensModel FastAPI (:8000)
      try {
        reply = await sendTextQuestionToModel(text, currentSite, currentLang);
      } catch (vlensErr) {
        console.warn('[ChatScreen] VLensModel text chat error, falling back:', vlensErr.message);
      }

      // 2. Gọi API Spring Boot Groq AI nếu có di sản hiện tại và VLensModel chưa có reply
      if (!reply && realHeritageId) {
        try {
          const res = await appService.sendChatMessage(realHeritageId, text);
          reply = res?.reply || res?.message;
        } catch (apiErr) {
          console.warn('[ChatScreen] Spring Boot chat API error:', apiErr.message);
        }
      }

      // 3. Fallback: Gọi trực tiếp Groq Cloud AI 24/7 (Qwen 3.8 27B)
      if (!reply) {
        try {
          reply = await chatWithGroqCloud(text, currentSite, currentLang);
        } catch (groqErr) {
          console.warn('[ChatScreen] Groq Cloud chat fallback error:', groqErr.message);
        }
      }

      // 3. Fallback an toàn nếu cả 2 phương thức đám mây gặp sự cố
      if (!reply) {
        if (currentSite) {
          reply = langIsJa
            ? `「${currentSite.name}」についてのご質問を承りました。${
                currentSite.summary || currentSite.shortDescription || currentSite.description || 'この場所はベトナムの歴史と建築において極めて重要な価値を持っています。'
              }`
            : (langIsEn
              ? `I noted your question about "${currentSite.name}". ${
                  currentSite.summary || currentSite.shortDescription || currentSite.description || 'This site holds immense historical and cultural significance in Vietnam.'
                }`
              : `Tôi đã ghi nhận câu hỏi của bạn về "${currentSite.name}". ${
                  currentSite.summary || currentSite.shortDescription || currentSite.description || 'Di tích này có bề dày lịch sử và kiến trúc rất đặc sắc của Việt Nam.'
                }`);
        } else {
          reply = langIsJa
            ? 'VietLens AIをご利用いただきありがとうございます！地図から遺産を選択するか、写真を送信して詳細な解説をご覧ください。'
            : (langIsEn
              ? 'Thank you for chatting with VietLens AI! You can select a site on the map or send a photo to receive detailed insights!'
              : 'Cảm ơn bạn đã trò chuyện cùng VietLens AI! Bạn có thể chọn một di tích cụ thể trên bản đồ hoặc chụp ảnh di tích để tôi nhận diện và thuyết minh chuyên sâu nhé!');
        }
      }

      const cleanReply = (reply || '').replace(/\*\*/g, '').trim();

      setMessages((prev) => [
        ...prev,
        {
          id: (Date.now() + 1).toString(),
          sender: 'advisor',
          text: cleanReply,
          time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
        },
      ]);
      await saveMessageToSession(activeSessionId, {
        sender: 'advisor',
        content: cleanReply,
      });
    } catch (err) {
      console.warn('[ChatScreen] Error handling message:', err.message);
      const fallbackText = currentSite
        ? (currentSite.summary || currentSite.shortDescription || '')
        : langIsJa
        ? 'VietLens AIがメッセージを受け付けました。しばらくしてからもう一度お試しください！'
        : (langIsEn
        ? 'VietLens AI received your message. Please try again shortly!'
        : 'VietLens AI đã ghi nhận câu hỏi của bạn. Vui lòng thử lại sau giây lát!');
      setMessages((prev) => [
        ...prev,
        {
          id: (Date.now() + 1).toString(),
          sender: 'advisor',
          text: fallbackText.replace(/\*\*/g, '').trim(),
          time: langIsJa ? 'たった今' : (langIsEn ? 'Just now' : 'Bây giờ'),
        },
      ]);
      await saveMessageToSession(activeSessionId, {
        sender: 'advisor',
        content: fallbackText.replace(/\*\*/g, '').trim(),
      });
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
          language: isJa ? 'ja-JP' : (isEn ? 'en-US' : 'vi-VN'),
          rate: 0.95,
          onDone: () => setIsSpeaking(false),
          onError: () => setIsSpeaking(false),
        });
      }
    }
  };

  const isSendActive = Boolean(input.trim()) || Boolean(pendingImage);

  return (
    <KeyboardAvoidingView
      style={[styles.container, { backgroundColor: theme.colors.bg }]}
      behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
      keyboardVerticalOffset={Platform.OS === 'ios' ? 90 : 20}
    >
      {/* Header VietLens AI */}
      <View style={[styles.header, { backgroundColor: theme.colors.card, borderBottomColor: theme.colors.border }]}>
        <View style={styles.headerAdvisorInfo}>
          {/* Nút Burger Menu xem Lịch sử trò chuyện */}
          <TouchableOpacity
            style={styles.burgerBtn}
            onPress={() => setIsDrawerOpen(true)}
            activeOpacity={0.7}
            hitSlop={{ top: 10, bottom: 10, left: 10, right: 10 }}
          >
            <Ionicons name="menu-outline" size={26} color={theme.colors.ink} />
          </TouchableOpacity>

          <View style={[styles.advisorAvatar, { backgroundColor: advisorProfile.avatarBg }]}>
            <MaterialCommunityIcons name={advisorProfile.icon} size={22} color="#FFF" />
          </View>
          <View style={{ marginLeft: 10 }}>
            <Text style={[styles.advisorName, { color: theme.colors.ink }]}>{advisorProfile.name}</Text>
            <View style={styles.statusRow}>
              <View style={styles.statusDot} />
              <Text style={[styles.statusText, { color: theme.colors.inkMuted }]}>
                {advisorProfile.status} • {advisorProfile.role}
              </Text>
            </View>
          </View>
        </View>

        {/* Nút Audio Speech */}
        <TouchableOpacity
          style={[
            styles.speechBtn,
            { backgroundColor: theme.colors.parchment, borderColor: theme.colors.border },
            isSpeaking && styles.speechBtnActive,
          ]}
          onPress={handleToggleSpeech}
        >
          <Ionicons
            name={isSpeaking ? 'pause' : 'volume-high'}
            size={18}
            color={isSpeaking ? '#FFF' : theme.colors.ink}
          />
        </TouchableOpacity>
      </View>

      {/* Ngữ cảnh Di sản đang đàm đạo */}
      <View
        style={[
          styles.contextBanner,
          currentSite
            ? {
                backgroundColor: isDark ? '#261E14' : '#FEF3C7',
                borderBottomColor: isDark ? '#42331C' : '#FDE68A',
              }
            : {
                backgroundColor: isDark ? '#1C1917' : '#F9FAFB',
                borderBottomColor: theme.colors.border,
              },
        ]}
      >
        <Ionicons
          name={currentSite ? 'sparkles' : 'chatbubbles-outline'}
          size={14}
          color={currentSite ? theme.colors.amber : theme.colors.red}
        />
        <Text
          style={[
            styles.contextText,
            currentSite
              ? { color: isDark ? '#FBBF24' : '#92400E' }
              : [styles.contextTextGeneral, { color: theme.colors.ink }],
          ]}
          numberOfLines={1}
        >
          {currentSite ? (
            <>
              {isJa ? '探索中: ' : (isEn ? 'Exploring: ' : 'Khám phá: ')}
              <Text style={{ fontWeight: '700' }}>{currentSite.name}</Text>
              {currentSite?.locationName ? ` • ${currentSite.locationName}` : ''}
            </>
          ) : (
            <Text style={{ fontWeight: '600' }}>
              {isJa ? 'VietLens AI • 文化遺産アドバイザー (質問自由)' : (isEn ? 'VietLens AI • National Heritage Advisor' : 'VietLens AI • Trợ lý Di sản & Văn hóa (Hỏi tự do)')}
            </Text>
          )}
        </Text>
        {currentSite && (
          <TouchableOpacity
            style={[
              styles.clearSiteBtn,
              { backgroundColor: isDark ? 'rgba(255,255,255,0.08)' : 'rgba(0,0,0,0.06)' },
            ]}
            onPress={handleResetSiteContext}
            activeOpacity={0.7}
          >
            <Ionicons name="close-circle" size={15} color={theme.colors.inkMuted} />
            <Text style={[styles.clearSiteBtnText, { color: theme.colors.inkMuted }]}>
              {isJa ? '自由対話' : (isEn ? 'Free Chat' : 'Hỏi tự do')}
            </Text>
          </TouchableOpacity>
        )}
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
                <View style={[styles.msgAvatar, { backgroundColor: advisorProfile.avatarBg }]}>
                  <MaterialCommunityIcons name={advisorProfile.icon} size={14} color="#FFF" />
                </View>
              )}
              <View
                style={[
                  styles.bubble,
                  isUser
                    ? styles.bubbleUser
                    : [
                        styles.bubbleAdvisor,
                        {
                          backgroundColor: theme.colors.card,
                          borderColor: theme.colors.border,
                        },
                      ],
                ]}
              >
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
                      <Text style={styles.photoBadgeText}>
                        {isJa ? '撮影した写真' : (isEn ? 'Captured Photo' : 'Ảnh vừa chụp')}
                      </Text>
                    </View>
                  </View>
                )}

                {!!msg.text && (
                  <Text
                    style={[
                      styles.msgText,
                      isUser ? styles.msgTextUser : [styles.msgTextAdvisor, { color: theme.colors.ink }],
                    ]}
                  >
                    {msg.text}
                  </Text>
                )}

                {/* Thẻ hành động Điều hướng Bản đồ tương tác khi AI nhận diện thành công */}
                {msg.detectedSite && (
                  <TouchableOpacity
                    style={[
                      styles.mapActionCard,
                      {
                        backgroundColor: isDark ? '#241E15' : '#FFFBEB',
                        borderColor: isDark ? '#5A4315' : '#FCD34D',
                      },
                    ]}
                    onPress={() => onNavigateToMap && onNavigateToMap(msg.detectedSite)}
                    activeOpacity={0.85}
                  >
                    <View style={styles.mapActionIconCircle}>
                      <Ionicons name="map" size={16} color="#FFF" />
                    </View>
                    <View style={styles.mapActionInfo}>
                      <Text style={[styles.mapActionTitle, { color: isDark ? '#FBBF24' : '#92400E' }]}>
                        {isJa ? 'インタラクティブマップで見る' : (isEn ? 'View on Interactive Map' : 'Xem vị trí trên Bản đồ')}
                      </Text>
                      <Text
                        style={[styles.mapActionSub, { color: isDark ? '#D97706' : '#B45309' }]}
                        numberOfLines={1}
                      >
                        {msg.detectedSite.name} ({msg.detectedSite.province || (isJa ? 'ベトナム' : (isEn ? 'Vietnam' : 'Việt Nam'))})
                      </Text>
                    </View>
                    <Ionicons name="chevron-forward" size={16} color="#C62828" />
                  </TouchableOpacity>
                )}

                <Text
                  style={[
                    styles.msgTime,
                    isUser ? styles.msgTimeUser : [styles.msgTimeAdvisor, { color: theme.colors.inkMuted }],
                  ]}
                >
                  {msg.time}
                </Text>
              </View>
            </View>
          );
        })}

        {isTyping && (
          <View style={[styles.msgRow, styles.msgRowAdvisor]}>
            <View style={[styles.msgAvatar, { backgroundColor: advisorProfile.avatarBg }]}>
              <MaterialCommunityIcons name={advisorProfile.icon} size={14} color="#FFF" />
            </View>
            <View
              style={[
                styles.bubble,
                styles.bubbleAdvisor,
                styles.typingBubble,
                { backgroundColor: theme.colors.card, borderColor: theme.colors.border },
              ]}
            >
              <ActivityIndicator size="small" color={theme.colors.amber} />
              <Text style={[styles.typingText, { color: theme.colors.inkMuted }]}>
                {isJa ? 'VietLens AIが回答を作成中...' : (isEn ? 'VietLens AI is thinking...' : 'VietLens AI đang soạn câu trả lời...')}
              </Text>
            </View>
          </View>
        )}
      </ScrollView>

      {/* THANH XEM TRƯỚC ẢNH ĐÍNH KÈM (KHI NGƯỜI DÙNG VỪA CHỤP/CHỌN ẢNH) */}
      {pendingImage && (
        <View
          style={[
            styles.pendingImageBar,
            {
              backgroundColor: isDark ? '#261717' : '#FEF2F2',
              borderTopColor: isDark ? '#4A1D1D' : '#FECACA',
            },
          ]}
        >
          <View style={styles.pendingThumbWrap}>
            <Image source={{ uri: pendingImage.uri }} style={styles.pendingThumb} />
            <TouchableOpacity
              style={styles.removePendingBtn}
              onPress={() => setPendingImage(null)}
              activeOpacity={0.7}
            >
              <Ionicons name="close" size={14} color="#FFF" />
            </TouchableOpacity>
          </View>
          <View style={styles.pendingInfoWrap}>
            <Text style={[styles.pendingTitle, { color: isDark ? '#F87171' : '#991B1B' }]}>
              {isJa ? '添付された写真' : (isEn ? 'Photo attached' : 'Ảnh đã đính kèm')}
            </Text>
            <Text
              style={[styles.pendingSubtitle, { color: isDark ? '#FCA5A5' : '#B91C1C' }]}
              numberOfLines={1}
            >
              {isJa
                ? '質問を入力するか、送信をタップして識別'
                : (isEn
                  ? 'Type your question or tap send to identify'
                  : 'Nhập câu hỏi hoặc bấm Gửi để nhận diện ngay')}
            </Text>
          </View>
        </View>
      )}

      {/* Ô Nhập tin nhắn tích hợp Camera & Thư viện */}
      <View
        style={[
          styles.inputContainer,
          { backgroundColor: theme.colors.card, borderTopColor: theme.colors.border },
        ]}
      >
        <TouchableOpacity
          style={styles.mediaBtn}
          onPress={handleTakePhoto}
          activeOpacity={0.7}
        >
          <Ionicons name="camera" size={22} color={theme.colors.red} />
        </TouchableOpacity>
        <TouchableOpacity
          style={styles.mediaBtn}
          onPress={handlePickImage}
          activeOpacity={0.7}
        >
          <Ionicons name="image-outline" size={22} color={theme.colors.inkMuted} />
        </TouchableOpacity>

        <TextInput
          style={[
            styles.textInput,
            {
              backgroundColor: isDark ? '#141210' : '#F9FAFB',
              borderColor: theme.colors.border,
              color: theme.colors.ink,
            },
          ]}
          placeholder={
            pendingImage
              ? isJa
                ? 'この写真について質問 (または送信して識別)...'
                : (isEn
                  ? 'Ask about this photo (or send to identify)...'
                  : 'Hỏi về bức ảnh này (hoặc bấm gửi để nhận diện)...')
              : isJa
              ? 'VietLens AIに遺産について質問...'
              : (isEn
                ? 'Ask VietLens AI about this site...'
                : 'Hỏi VietLens AI về di tích này...')
          }
          placeholderTextColor={theme.colors.inkLight}
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
          style={[
            styles.sendBtn,
            !isSendActive && [
              styles.sendBtnDisabled,
              { backgroundColor: isDark ? '#3D3833' : '#D1D5DB' },
            ],
          ]}
          onPress={() => handleSend()}
          disabled={!isSendActive}
        >
          <Ionicons name="arrow-up" size={20} color="#FFF" />
        </TouchableOpacity>
      </View>

      {/* Slide Bar Lịch Sử Chat */}
      <ChatHistoryDrawer
        visible={isDrawerOpen}
        onClose={() => setIsDrawerOpen(false)}
        sessions={sessions}
        currentSessionId={currentSessionId}
        onSelectSession={handleSelectSession}
        onNewChat={handleNewChat}
        onDeleteSession={handleDeleteSession}
        isLoading={isLoadingSessions}
      />
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
  burgerBtn: {
    width: 36,
    height: 36,
    borderRadius: 18,
    alignItems: 'center',
    justifyContent: 'center',
    marginRight: 6,
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
  contextBannerGeneral: {
    backgroundColor: '#F9FAFB',
    borderBottomColor: '#E5E7EB',
  },
  contextText: {
    fontSize: 12,
    color: '#92400E',
    flex: 1,
  },
  contextTextGeneral: {
    fontSize: 12,
    color: THEME.colors.ink,
    fontWeight: '500',
  },
  clearSiteBtn: {
    flexDirection: 'row',
    alignItems: 'center',
    gap: 4,
    backgroundColor: 'rgba(0,0,0,0.06)',
    paddingHorizontal: 8,
    paddingVertical: 3,
    borderRadius: 12,
  },
  clearSiteBtnText: {
    fontSize: 11,
    fontWeight: '600',
    color: THEME.colors.inkMuted,
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
  pendingImageBar: {
    flexDirection: 'row',
    alignItems: 'center',
    paddingHorizontal: 16,
    paddingVertical: 8,
    backgroundColor: '#FEF2F2',
    borderTopWidth: 1,
    borderTopColor: '#FECACA',
    gap: 12,
  },
  pendingThumbWrap: {
    position: 'relative',
  },
  pendingThumb: {
    width: 48,
    height: 48,
    borderRadius: 8,
    borderWidth: 1.5,
    borderColor: THEME.colors.red,
  },
  removePendingBtn: {
    position: 'absolute',
    top: -6,
    right: -6,
    width: 20,
    height: 20,
    borderRadius: 10,
    backgroundColor: '#DC2626',
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1.5,
    borderColor: '#FFF',
  },
  pendingInfoWrap: {
    flex: 1,
  },
  pendingTitle: {
    fontSize: 13,
    fontWeight: '700',
    color: '#991B1B',
  },
  pendingSubtitle: {
    fontSize: 11,
    color: '#B91C1C',
    marginTop: 2,
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
