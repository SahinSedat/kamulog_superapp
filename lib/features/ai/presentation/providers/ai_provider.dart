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
  final String? error;
  final String conversationId;

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.isCvBuilding = false,
    this.error,
    this.conversationId = '',
  });

  AiChatState copyWith({
    List<AiMessageModel>? messages,
    bool? isLoading,
    bool? isCvBuilding,
    String? error,
    String? conversationId,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      isCvBuilding: isCvBuilding ?? this.isCvBuilding,
      error: error,
      conversationId: conversationId ?? this.conversationId,
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

  /// Start CV Building flow with profile data
  void startCvBuilding(dynamic profil) {
    newConversation();
    state = state.copyWith(isCvBuilding: true);
    final profileContext = '''
Kullanıcı bir CV oluşturmak istiyor. Mevcut profil bilgileri:
Ad Soyad: ${profil.name ?? 'Belirtilmedi'}
Telefon: ${profil.phone ?? 'Belirtilmedi'}
Kurum: ${profil.effectiveInstitution}
Unvan: ${profil.title ?? 'Belirtilmedi'}
İl/İlçe: ${profil.addressText}
Beceriler: ${profil.surveyInterests.join(', ')}

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

    String finalContext = context ?? '';
    if (state.isCvBuilding) {
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
            state = state.copyWith(isLoading: false);
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
