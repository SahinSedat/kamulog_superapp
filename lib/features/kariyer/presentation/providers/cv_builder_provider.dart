import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

/// CV Oluşturucu ekranına özel State sınıfı
class CvBuilderState {
  final String conversationId;
  final List<AiMessageModel> messages;
  final bool isLoading;
  final bool isCvReady;
  final bool isStarted;

  const CvBuilderState({
    required this.conversationId,
    this.messages = const [],
    this.isLoading = false,
    this.isCvReady = false,
    this.isStarted = false,
  });

  CvBuilderState copyWith({
    String? conversationId,
    List<AiMessageModel>? messages,
    bool? isLoading,
    bool? isCvReady,
    bool? isStarted,
  }) {
    return CvBuilderState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isCvReady: isCvReady ?? this.isCvReady,
      isStarted: isStarted ?? this.isStarted,
    );
  }
}

class CvBuilderNotifier extends Notifier<CvBuilderState> {
  late AiRepository _repository;
  StreamSubscription? _streamSub;
  String? _cachedSystemPrompt;

  @override
  CvBuilderState build() {
    _repository = ref.watch(aiRepositoryProvider);
    ref.onDispose(() {
      _streamSub?.cancel();
    });
    return CvBuilderState(conversationId: const Uuid().v4());
  }

  void newConversation() {
    _streamSub?.cancel();
    state = CvBuilderState(conversationId: const Uuid().v4());
  }

  /// CV oluşturma sürecini başlatır — sadece ilk kez veya yeniden başlatmada çağrılır
  Future<void> startCvBuilding() async {
    // Eğer zaten başlamışsa ve mesajlar varsa, kaldığı yerden devam et
    if (state.isStarted && state.messages.isNotEmpty) {
      return;
    }

    final profil = ref.read(profilProvider);

    // Başlangıç jeton kontrolü
    final currentCredits = profil.credits;
    if (currentCredits < 2) {
      return;
    }

    newConversation();

    // Kariyer bilgilerini al
    final profilData = {
      'ad': profil.name,
      'kurum': profil.institution,
      'unvan': profil.title,
      'deneyim':
          profil.surveyInterests.isNotEmpty
              ? profil.surveyInterests.join(', ')
              : 'Belirtilmedi',
    };

    _cachedSystemPrompt =
        'Sen profesyonel bir İK uzmanısın ve CV yazarısın. SADECE CV hazırlama konusunda çalışırsın. '
        'Kullanıcının mevcut profil bilgileri: $profilData. '
        'ÖNEMLİ KURALLAR: '
        '1. SADECE CV oluşturma ile ilgili konuşursun. CV dışında herhangi bir konu hakkında soru sorulursa '
        'kibarca "Üzgünüm, benim görevim sadece CV hazırlamaktır. CV\'niz için bilgilere devam edelim." de ve konuyu CV\'ye geri getir. '
        '2. Kullanıcının cevapladığı bilgileri topla. Eğer kullanıcı bir bilgiyi atladıysa veya eksik bıraktıysa hatırlat. '
        '3. Kullanıcı "tamam" veya "tamamdır" derse, eksik bir şey yoksa CV\'yi oluştur. '
        '4. CV hazır olduğunda mesajının EN BAŞINA [CV_HAZIR] etiketini koy ve ardından CV\'nin tam metnini düzenli formatta yaz. '
        '5. Eğitim bilgilerini sorarken üniversite adı, bölüm ve mezuniyet durumunu SOR. Mezuniyet yılını AYRI bir soru olarak sor. '
        '6. Kısa, öz ve profesyonel ol.';

    final msgId = const Uuid().v4();
    final systemMessage = AiMessageModel(
      id: msgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content:
          'Merhaba ${profil.name ?? ''}! 👋 Profesyonel CV\'nizi birlikte hazırlayalım.\n\n'
          'CV\'niz için aşağıdaki bilgilere ihtiyacım var. Lütfen sırasıyla yazın:\n\n'
          '📋 **Gerekli Bilgiler:**\n\n'
          '1️⃣ **Kişisel Bilgiler:** Ad-soyad, e-posta, telefon numarası\n'
          '2️⃣ **Eğitim Bilgileri:** Okul adı, bölüm, mezuniyet durumu (mezun/devam ediyor)\n'
          '3️⃣ **Mezuniyet Yılı:** Hangi yıl mezun oldunuz? (devam ediyorsanız tahmini bitiş yılı)\n'
          '4️⃣ **İş Deneyimi:** Çalıştığınız yerler, pozisyonlar, süreler\n'
          '5️⃣ **Beceriler:** Teknik ve kişisel yetkinlikleriniz\n'
          '6️⃣ **Sertifika/Kurslar:** Varsa sertifika ve kurs bilgileri\n'
          '7️⃣ **Yabancı Dil:** Bildiğiniz diller ve seviyeniz\n\n'
          'Tüm bilgileri tek mesajda veya adım adım yazabilirsiniz. Eksik bir şey olursa hatırlatacağım. ✍️',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(messages: [systemMessage], isStarted: true);
  }

  /// Yeniden başlatma — explicit olarak çağrılır
  Future<void> restartCvBuilding() async {
    newConversation();
    final profil = ref.read(profilProvider);

    _cachedSystemPrompt =
        'Sen profesyonel bir İK uzmanısın ve CV yazarısın. SADECE CV hazırlama konusunda çalışırsın. '
        'Kullanıcının mevcut profil bilgileri: ${{'ad': profil.name, 'kurum': profil.institution, 'unvan': profil.title}}. '
        'ÖNEMLİ KURALLAR: '
        '1. SADECE CV oluşturma ile ilgili konuşursun. CV dışında herhangi bir konu hakkında soru sorulursa '
        'kibarca "Üzgünüm, benim görevim sadece CV hazırlamaktır. CV\'niz için bilgilere devam edelim." de ve konuyu CV\'ye geri getir. '
        '2. Kullanıcının cevapladığı bilgileri topla. Eğer kullanıcı bir bilgiyi atladıysa veya eksik bıraktıysa hatırlat. '
        '3. Kullanıcı "tamam" veya "tamamdır" derse, eksik bir şey yoksa CV\'yi oluştur. '
        '4. CV hazır olduğunda mesajının EN BAŞINA [CV_HAZIR] etiketini koy ve ardından CV\'nin tam metnini düzenli formatta yaz. '
        '5. Eğitim bilgilerini sorarken üniversite adı, bölüm ve mezuniyet durumunu SOR. Mezuniyet yılını AYRI bir soru olarak sor. '
        '6. Kısa, öz ve profesyonel ol.';

    final msgId = const Uuid().v4();
    final systemMessage = AiMessageModel(
      id: msgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content:
          'Merhaba ${profil.name ?? ''}! 👋 Profesyonel CV\'nizi birlikte hazırlayalım.\n\n'
          'CV\'niz için aşağıdaki bilgilere ihtiyacım var. Lütfen sırasıyla yazın:\n\n'
          '📋 **Gerekli Bilgiler:**\n\n'
          '1️⃣ **Kişisel Bilgiler:** Ad-soyad, e-posta, telefon numarası\n'
          '2️⃣ **Eğitim Bilgileri:** Okul adı, bölüm, mezuniyet durumu (mezun/devam ediyor)\n'
          '3️⃣ **Mezuniyet Yılı:** Hangi yıl mezun oldunuz? (devam ediyorsanız tahmini bitiş yılı)\n'
          '4️⃣ **İş Deneyimi:** Çalıştığınız yerler, pozisyonlar, süreler\n'
          '5️⃣ **Beceriler:** Teknik ve kişisel yetkinlikleriniz\n'
          '6️⃣ **Sertifika/Kurslar:** Varsa sertifika ve kurs bilgileri\n'
          '7️⃣ **Yabancı Dil:** Bildiğiniz diller ve seviyeniz\n\n'
          'Tüm bilgileri tek mesajda veya adım adım yazabilirsiniz. Eksik bir şey olursa hatırlatacağım. ✍️',
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [systemMessage],
      isStarted: true,
      isCvReady: false,
    );
  }

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty || state.isLoading) return;

    final userMsgId = const Uuid().v4();
    final userMessage = AiMessageModel(
      id: userMsgId,
      conversationId: state.conversationId,
      role: AiRole.user,
      content: text.trim(),
      createdAt: DateTime.now(),
    );

    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );

    final aiMsgId = const Uuid().v4();
    final aiMessage = AiMessageModel(
      id: aiMsgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    state = state.copyWith(messages: [...state.messages, aiMessage]);

    try {
      final history =
          state.messages
              .where(
                (m) =>
                    m.id != userMsgId &&
                    m.id != aiMsgId &&
                    m.content.isNotEmpty,
              )
              .toList();

      _streamSub = _repository
          .sendMessage(
            conversationId: state.conversationId,
            message: text.trim(),
            context:
                _cachedSystemPrompt ??
                'Sen profesyonel bir İK uzmanısın. SADECE CV oluşturma konusuna odaklan. Konu dışı sorulara kibarca ret et.',
            history: history,
          )
          .listen(
            (chunk) {
              _updateStreamingMessage(aiMsgId, chunk);
            },
            onDone: () {
              _finishStreamingMessage(aiMsgId);
              state = state.copyWith(isLoading: false);
              _checkCvReady();
            },
            onError: (error) {
              _updateStreamingMessage(
                aiMsgId,
                '\n\n[Hata oluştu: Sunucu yanıt veremiyor]',
              );
              _finishStreamingMessage(aiMsgId);
              state = state.copyWith(isLoading: false);
            },
          );
    } catch (e) {
      _updateStreamingMessage(aiMsgId, '\n\n[Beklenmeyen bir hata oluştu]');
      _finishStreamingMessage(aiMsgId);
      state = state.copyWith(isLoading: false);
    }
  }

  /// AI mesajlarında [CV_HAZIR] etiketi var mı kontrol et
  void _checkCvReady() {
    for (final msg in state.messages) {
      if (msg.role == AiRole.assistant && msg.content.contains('[CV_HAZIR]')) {
        state = state.copyWith(isCvReady: true);
        return;
      }
    }
  }

  /// CV hazır olduğunda tüm AI mesajlarından CV metnini çıkar
  String extractCvContent() {
    if (state.messages.isEmpty) return '';
    // [CV_HAZIR] içeren mesajı bul
    for (final msg in state.messages.reversed) {
      if (msg.role == AiRole.assistant && msg.content.contains('[CV_HAZIR]')) {
        return msg.content.replaceAll('[CV_HAZIR]', '').trim();
      }
    }
    // Yoksa son AI mesajını döndür
    final lastAiMsg = state.messages.lastWhere(
      (m) => m.role == AiRole.assistant,
      orElse: () => state.messages.last,
    );
    return lastAiMsg.content.replaceAll('[CV_HAZIR]', '').trim();
  }

  void _updateStreamingMessage(String messageId, String additionalContent) {
    if (additionalContent.isEmpty) return;

    final updatedMessages =
        state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(content: m.content + additionalContent);
          }
          return m;
        }).toList();
    state = state.copyWith(messages: updatedMessages);
  }

  void _finishStreamingMessage(String messageId) {
    final updatedMessages =
        state.messages.map((m) {
          if (m.id == messageId) {
            return m.copyWith(isStreaming: false);
          }
          return m;
        }).toList();
    state = state.copyWith(messages: updatedMessages);
  }
}

final cvBuilderProvider = NotifierProvider<CvBuilderNotifier, CvBuilderState>(
  () => CvBuilderNotifier(),
);
