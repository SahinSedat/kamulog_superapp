import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/ai/data/datasources/ai_remote_datasource.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/data/repositories/ai_repository_impl.dart';

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
  final bool chatLocked;
  final String? error;
  final String conversationId;
  final int aiAssistantCredits; // AI Asistan modülü kendi jeton havuzu (30)

  const AiChatState({
    this.messages = const [],
    this.isLoading = false,
    this.chatLocked = false,
    this.error,
    this.conversationId = '',
    this.aiAssistantCredits = 30,
  });

  AiChatState copyWith({
    List<AiMessageModel>? messages,
    bool? isLoading,
    bool? chatLocked,
    String? error,
    String? conversationId,
    int? aiAssistantCredits,
  }) {
    return AiChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      chatLocked: chatLocked ?? this.chatLocked,
      error: error,
      conversationId: conversationId ?? this.conversationId,
      aiAssistantCredits: aiAssistantCredits ?? this.aiAssistantCredits,
    );
  }
}

// ── Chat Notifier ──
class AiChatNotifier extends StateNotifier<AiChatState> {
  final AiRepository _repository;
  StreamSubscription<String>? _streamSub;
  int _msgCounter = 0;

  AiChatNotifier(this._repository)
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

  /// Send a user message and receive a streamed AI response.
  Future<void> sendMessage(String text, {String? context}) async {
    if (text.trim().isEmpty) return;

    // Sohbet kilitli mi?
    if (state.chatLocked) {
      state = state.copyWith(error: 'Sohbet kapalı. Jeton yetersiz.');
      return;
    }

    // AI Asistan kendi jeton havuzu — her mesaj 1 jeton
    if (state.aiAssistantCredits < 1) {
      state = state.copyWith(
        error: 'AI Asistan jetonunuz bitti.',
        chatLocked: true,
      );
      return;
    }

    state = state.copyWith(aiAssistantCredits: state.aiAssistantCredits - 1);

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
          context: context,
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
      aiAssistantCredits: state.aiAssistantCredits, // Jetonları koru
    );
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  /// AI Asistan jeton havuzundan düşüm yap (dış modüller için)
  bool hasEnoughAiCredits(int amount) {
    return state.aiAssistantCredits >= amount;
  }

  /// AI Asistan jetonlarını düşür
  bool decreaseAiCredits(int amount) {
    if (state.aiAssistantCredits < amount) return false;
    state = state.copyWith(
      aiAssistantCredits: state.aiAssistantCredits - amount,
    );
    return true;
  }
}

// ── Provider ──
final aiChatProvider = StateNotifierProvider<AiChatNotifier, AiChatState>((
  ref,
) {
  return AiChatNotifier(ref.watch(aiRepositoryProvider));
});
