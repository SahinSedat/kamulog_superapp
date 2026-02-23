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

  const CvBuilderState({
    required this.conversationId,
    this.messages = const [],
    this.isLoading = false,
  });

  CvBuilderState copyWith({
    String? conversationId,
    List<AiMessageModel>? messages,
    bool? isLoading,
  }) {
    return CvBuilderState(
      conversationId: conversationId ?? this.conversationId,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
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

  /// CV oluşturma sürecini başlatır
  Future<void> startCvBuilding() async {
    final profil = ref.read(profilProvider);

    // Başlangıç jeton kontrolü
    final currentCredits =
        profil.credits; // Career modülleri genel krediyi kullanır
    if (currentCredits < 2) {
      // Yetersiz jeton durumu UI tarafında ele alınacak
      return;
    }

    newConversation();

    // Sistem mesajını gizli olarak ekleyebiliriz veya asistanın ilk mesajıymış gibi ekleyebiliriz
    // Kariyer bilgilerini al
    final profilData = {
      'ad': profil.name,
      'kurum':
          profil
              .institution, // effectiveInstitution is a getter but institution is the field
      'unvan': profil.title,
      'deneyim':
          profil.surveyInterests.isNotEmpty
              ? profil.surveyInterests.join(', ')
              : 'Belirtilmedi',
    };

    final systemPrompt =
        'Sen profesyonel bir İK uzmanısın. Kullanıcıya bir CV hazırlamasında yardımcı olacaksın. '
        'Şu anki bilgileri: $profilData. '
        'Kullanıcıya merhaba de ve eksik bilgileri tamamlaması için adım adım sorular sor. '
        'Tüm bilgiler hazır olduğunda ve kullanıcı onayladığında son mesajında "PDF" kelimesini geçirerek bana işaret ver.';

    final msgId = const Uuid().v4();
    final systemMessage = AiMessageModel(
      id: msgId,
      conversationId: state.conversationId,
      role: AiRole.assistant,
      content:
          'Merhaba! ${profil.name ?? ''}, profesyonel CV\'ni birlikte hazırlamak için buradayım. Mevcut profil bilgilerini inceledim, eksik olan detaylar için sana birkaç soru soracağım. Hazırsan başlayalım mı?',
      createdAt: DateTime.now(),
    );

    // Initial system context state
    state = state.copyWith(messages: [systemMessage]);

    // Cache the system prompt string for _sendMessage
    _cachedSystemPrompt = systemPrompt;
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
      content: '', // Streaming ile dolacak
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
                'Sen profesyonel bir İK uzmanısın. Kullanıcıyla etkileşimdesin. Sadece CV oluşturma konusuna odaklan.',
            history: history,
          )
          .listen(
            (chunk) {
              _updateStreamingMessage(aiMsgId, chunk);
            },
            onDone: () {
              _finishStreamingMessage(aiMsgId);
              state = state.copyWith(isLoading: false);
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
