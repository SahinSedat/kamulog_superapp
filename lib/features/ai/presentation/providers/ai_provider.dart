import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/ai/data/datasources/ai_remote_datasource.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/data/repositories/ai_repository_impl.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

// ── Providers ──
final aiRemoteDataSourceProvider = Provider<AiRemoteDataSource>((ref) {
  return AiRemoteDataSourceImpl();
});

final aiRepositoryProvider = Provider<AiRepository>((ref) {
  return AiRepository(remoteDataSource: ref.watch(aiRemoteDataSourceProvider));
});

final aiSuggestionsProvider = FutureProvider.family<List<String>, String>((
  ref,
  context,
) {
  return ref.watch(aiRepositoryProvider).getSuggestions(context);
});

class AiChatState {
  final List<AiMessageModel> messages;
  final bool isLoading;
  final bool isCvBuilding;
  final bool isMevzuatChat; // Mevzuat bilgisi modu
  final bool isJobAnalysis; // İlan analizi modu
  final bool analysisComplete; // Analiz tamamlandı mı
  final bool chatLocked; // Jeton/mesaj limiti bittiğinde true olur
  final String? error;
  final String conversationId;
  final int aiAssistantCredits; // AI Asistan modülü kendi jeton havuzu (20)

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isCvBuilding = false,
    this.isMevzuatChat = false,
    this.isJobAnalysis = false,
    this.analysisComplete = false,
    this.chatLocked = false,
    this.error,
    this.conversationId = '',
    this.aiAssistantCredits = 20,
  });

  /// Mevcut oturumdaki kullanıcı mesaj sayısı
  int get userMessageCount =>
      messages.where((m) => m.role == AiRole.user).length;

  /// Kalan mesaj hakkı
  int get remainingMessages => (20 - userMessageCount).clamp(0, 20);

  AiChatState copyWith({
    List<AiMessageModel>? messages,
    bool? isLoading,
    bool? isCvBuilding,
    bool? isMevzuatChat,
    bool? isJobAnalysis,
    bool? analysisComplete,
    bool? chatLocked,
    String? error,
    String? conversationId,
    int? aiAssistantCredits,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isCvBuilding: isCvBuilding ?? this.isCvBuilding,
      isMevzuatChat: isMevzuatChat ?? this.isMevzuatChat,
      isJobAnalysis: isJobAnalysis ?? this.isJobAnalysis,
      analysisComplete: analysisComplete ?? this.analysisComplete,
      chatLocked: chatLocked ?? this.chatLocked,
      error: error,
      conversationId: conversationId ?? this.conversationId,
      aiAssistantCredits: aiAssistantCredits ?? this.aiAssistantCredits,
    );
  }
}

// ── Chat Notifier ──
class AiChatNotifier extends StateNotifier<AiChatState> {
  final Ref _ref;
  final AiRepository _repository;
  StreamSubscription<String>? _streamSub;
  int _msgCounter = 0;

  AiChatNotifier(this._repository, this._ref)
    : super(
        AiChatState(
          conversationId: 'conv-${DateTime.now().millisecondsSinceEpoch}',
        ),
      );

  @override
  void dispose() {
    _streamSub?.cancel();
    super.dispose();
  }

  /// Switch to CV building context
  bool startCvBuilding(ProfilState profil) {
    // CV oluşturma hakkı kontrolü (aylık 1 kez)
    if (profil.remainingAiCvCount <= 0) {
      state = state.copyWith(
        error:
            'Bu ay için CV oluşturma hakkınız doldu (1/1 kullanıldı). Gelecek ay tekrar deneyebilirsiniz.',
      );
      return false;
    }

    newConversation();
    state = state.copyWith(isCvBuilding: true, error: null);

    // Kullanıcının yüklediği PDF CV belgesi varsa metni de bağlama ekle
    String cvPdfContext = '';
    final cvDocs = profil.documents.where((d) => d.category == 'cv');
    if (cvDocs.isNotEmpty) {
      final latestCv = cvDocs.last;
      if (latestCv.content != null && latestCv.content!.isNotEmpty) {
        cvPdfContext = '''

Kullanıcının daha önce yüklemiş olduğu CV belgesi içeriği:
--- CV Başlangıç ---
${latestCv.content}
--- CV Bitiş ---
Bu bilgileri baz alarak CV'yi zenginleştir. Eksik kısımları kullanıcıya sor.
''';
      }
    }

    final profileContext = '''
Kullanıcı bir CV oluşturmak istiyor. Mevcut profil bilgileri:
Ad Soyad: ${profil.name ?? 'Belirtilmedi'}
Telefon: ${profil.phone ?? 'Belirtilmedi'}
Kurum: ${profil.effectiveInstitution}
Unvan: ${profil.title ?? 'Belirtilmedi'}
İl/İlçe: ${profil.addressText}
Beceriler: ${profil.surveyInterests.join(', ')}
$cvPdfContext
STRATEJİ:
1. Kullanıcıya merhaba de ve mevcut bilgilerini teyit et.
2. Her seferinde SADECE BİR soru sor (Eğitim, Deneyim, Sertifikalar vb.).
3. Her yanıtının sonuna mutlaka şu cümleyi ekle: "CV'nizi PDF olarak oluşturalım mı?"
4. Eğer kullanıcı PDF oluşturulmasını isterse, "Peki, PDF olarak CV'nizi hazırlıyorum ve 'Belgelerim' kısmına ekliyorum." de ve işlemi bitir.
''';
    sendMessage(
      'Merhaba, profil bilgilerime dayanarak bir CV oluşturmaya başlayabilir miyiz?',
      context: profileContext,
    );
    return true;
  }

  /// Mevzuat bilgisi bağlamını başlat
  void startMevzuatChat() {
    newConversation();
    state = state.copyWith(
      isMevzuatChat: true,
      isCvBuilding: false,
      isJobAnalysis: false,
      error: null,
    );

    final mevzuatContext = '''
SEN BİR KAMU MEVZUAT UZMANISIN. SADECE aşağidaki konulara cevap vereceksin:
- 657 Sayılı Devlet Memurları Kanunu
- Kamu çalışanları özlük hakları, izin, rapor, tayin, becayiş
- Görevde yükselme, unvan değişikliği
- Memur disiplin cezaları ve yasal hakları
Eğer bu konular dışında bir şey sorulursa "Üzgünüm, bilgi alanım sadece kamu mevzuatı (657 vb.) ile ilgilidir. Lütfen mevzuatla ilgili bir soru sorun." şeklinde yanıt vererek kibarca reddet.
''';

    sendMessage(
      'Merhaba, kamu mevzuatı, 657 sayılı kanun veya özlük hakları ile ilgili sorunuzu sorabilirsiniz.',
      context: mevzuatContext,
    );
  }

  /// İlan bazlı CV uyumluluk analizi başlat (modal içinde gösterilir)
  void startJobAnalysis({
    required String jobId,
    required String? jobCode,
    required String jobTitle,
    required String jobCompany,
    required String jobDescription,
    required String? jobRequirements,
    required String cvContent,
  }) {
    newConversation();
    state = state.copyWith(
      isJobAnalysis: true,
      analysisComplete: false,
      isCvBuilding: false,
      isMevzuatChat: false,
      error: null,
    );

    final ilanNo = jobCode ?? jobId;

    final analysisPrompt = '''
SEN BİR KARİYER DANIŞMANISIN. Aşağıda bir iş ilanı ve kullanıcının CV bilgileri verilmiştir.
GÖREVİN: SADECE bu ilan ile CV uyumluluğunu analiz etmektir. CV'nin tamamını yazmana gerek yok.

📋 İLAN BİLGİLERİ:
İlan No: $ilanNo
Pozisyon: $jobTitle
Şirket/Kurum: $jobCompany
Açıklama: $jobDescription
${jobRequirements != null ? 'Gereksinimler: $jobRequirements' : ''}

📄 KULLANICININ CV ÖZETİ:
$cvContent

ANALİZ FORMATI (KISA ve GRAFİK tut):
1. 📊 **Uyumluluk Skoru:** (0-100 arası yüzde olarak belirt ve kısa açıklama)
2. ✅ **Güçlü Yönler:** (maksimum 3 madde, kısa)
3. ⚠️ **Eksikler:** (maksimum 3 madde, kısa)
4. 🎯 **Sonuç:** UYGUN veya ALTERNATİF olarak belirt (1 cümle açıklama)

ÖNEMLİ: Kısa ve öz yaz. Uzun paragraflardan kaçın. Sadece bu ilan (No: $ilanNo) bağlamında analiz yap. Türkçe yanıtla.
''';

    sendMessage(
      'İlan No: $ilanNo - "$jobTitle" pozisyonu için CV uyumluluk analizi yap.',
      context: analysisPrompt,
    );
  }

  /// Simulate saving a PDF to documents
  Future<void> simulatePdfExport() async {
    state = state.copyWith(isLoading: true);

    // Simulate processing
    await Future.delayed(const Duration(seconds: 2));

    // Add to actual documents
    final docId = 'cv-${DateTime.now().millisecondsSinceEpoch}';
    final doc = DocumentInfo(
      id: docId,
      name:
          'Yapay Zeka Hazırlanan CV - ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}',
      category: 'cv',
      fileType: 'pdf',
      uploadDate: DateTime.now(),
    );

    await _ref.read(profilProvider.notifier).addDocument(doc);
    await _ref.read(profilProvider.notifier).recordAiCvUsage();

    state = state.copyWith(isLoading: false);
  }

  /// Send a user message and receive a streamed AI response.
  Future<void> sendMessage(String text, {String? context}) async {
    if (text.trim().isEmpty) return;

    // Sohbet kilitli mi?
    if (state.chatLocked) {
      state = state.copyWith(
        error: 'Sohbet kapalı. Jeton yetersiz veya mesaj limiti doldu.',
      );
      return;
    }

    final userMessageCount =
        state.messages.where((m) => m.role == AiRole.user).length;

    // 20 mesaj limiti
    if (userMessageCount >= 20) {
      state = state.copyWith(
        error:
            'Sohbet limitine (20 mesaj) ulaşıldı. Lütfen yeni bir sohbet başlatın.',
        chatLocked: true,
      );
      return;
    }

    final pNotifier = _ref.read(profilProvider.notifier);
    final profilState = _ref.read(profilProvider);

    // Jeton kontrolü — sadece kullanıcının kendi mesajında (context == null)
    if (context == null) {
      // AI Asistanda kullanıcı kendi sohbet ediyorsa ayrı jeton havuzu
      if (!state.isJobAnalysis && !state.isMevzuatChat) {
        // AI Asistan kendi jeton havuzu
        if (state.aiAssistantCredits < 2) {
          state = state.copyWith(
            error: 'AI Asistan jetonunuz bitti (2 jeton gerekli).',
            chatLocked: true,
          );
          return;
        }
        state = state.copyWith(
          aiAssistantCredits: state.aiAssistantCredits - 2,
        );
      } else {
        // Kariyer modülü (iş analizi, mevzuat) — profil jetonları
        if (!profilState.hasEnoughCredits(2)) {
          state = state.copyWith(
            error: 'Yeterli jetonunuz bulunmuyor (2 jeton gerekli).',
            chatLocked: true,
          );
          return;
        }
        await pNotifier.decreaseCredits(2);
      }
    }

    String finalContext = context ?? '';
    if (state.isCvBuilding) {
      // Aylık hak kontrolü (Premium dahil veya değil)
      if (profilState.remainingAiCvCount <= 0) {
        // Çıkış yap ve tek seferlik asistan mesajı ile sohbeti kilitle
        final assistantMsg = AiMessageModel(
          id: 'ai-limit-${DateTime.now().millisecondsSinceEpoch}',
          conversationId: state.conversationId,
          role: AiRole.assistant,
          content:
              'Aylık CV oluşturma hakkınız (1/1) dolmuştur. Yeni haklar bir sonraki ay yenilenecektir.',
          createdAt: DateTime.now(),
        );

        state = state.copyWith(
          messages: [...state.messages, assistantMsg],
          chatLocked: true,
        );
        return;
      }

      finalContext +=
          '\n\nKRİTİK TALİMAT: Kullanıcı şu an SADECE CV hazırlama akışında. Eğer kullanıcı CV dışı bir şey sorarsa (hava durumu, genel sohbet vb.), nazikçe sadece CV hazırlamaya odaklanması gerektiğini söyle ve kaldığın yerden devam et.';
    }

    _msgCounter++;
    final userMsg = AiMessageModel(
      id: 'user-$_msgCounter-${DateTime.now().millisecondsSinceEpoch}',
      conversationId: state.conversationId,
      role: AiRole.user,
      content: text.trim(),
      createdAt: DateTime.now(),
    );

    _msgCounter++;
    final assistantMsgId =
        'ai-$_msgCounter-${DateTime.now().millisecondsSinceEpoch}';

    final assistantMsg = AiMessageModel(
      id: assistantMsgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content: '',
      createdAt: DateTime.now(),
      isStreaming: true,
    );

    // Capture history before adding new messages
    final history = [...state.messages, userMsg];

    state = state.copyWith(
      messages: [...state.messages, userMsg, assistantMsg],
      isLoading: true,
      error: null,
    );

    final buffer = StringBuffer();

    _streamSub?.cancel();
    _streamSub = _repository
        .sendMessage(
          conversationId: state.conversationId,
          message: text.trim(),
          context: finalContext.isEmpty ? null : finalContext,
          history: history,
        )
        .listen(
          (chunk) {
            buffer.write(chunk);
            _updateLastAssistantMessage(
              assistantMsgId,
              buffer.toString(),
              isStreaming: true,
            );
          },
          onDone: () {
            _updateLastAssistantMessage(
              assistantMsgId,
              buffer.toString(),
              isStreaming: false,
            );
            // İş analizi modunda analiz tamamlandığında otomatik kilit
            if (state.isJobAnalysis) {
              state = state.copyWith(
                isLoading: false,
                analysisComplete: true,
                chatLocked: true,
              );
            } else {
              state = state.copyWith(isLoading: false);
            }
          },
          onError: (error) {
            _updateLastAssistantMessage(
              assistantMsgId,
              'Bir hata oluştu. Lütfen tekrar deneyin.',
              isStreaming: false,
            );
            state = state.copyWith(isLoading: false, error: error.toString());
          },
        );
  }

  void _updateLastAssistantMessage(
    String id,
    String content, {
    required bool isStreaming,
  }) {
    final updated =
        state.messages.map((m) {
          if (m.id == id) {
            return m.copyWith(content: content, isStreaming: isStreaming);
          }
          return m;
        }).toList();

    state = state.copyWith(messages: updated);
  }

  /// Start a new conversation.
  void newConversation() {
    _streamSub?.cancel();
    _msgCounter = 0;
    state = AiChatState(
      conversationId: 'conv-${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Provider ──
final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier(ref.watch(aiRepositoryProvider), ref);
});
