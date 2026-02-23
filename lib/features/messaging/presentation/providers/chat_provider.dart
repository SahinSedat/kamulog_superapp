import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/messaging/domain/models/message_model.dart';
import 'package:kamulog_superapp/features/messaging/domain/profanity_filter_service.dart';
import 'package:uuid/uuid.dart';

/// Anlık mesajlaşma state yöneticisi.
/// Küfür/argo tespit edildiğinde mesaj sessizce engellenir.
/// Tik sistemi: sent → delivered → read simülasyonu.
class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier() : super([]);

  /// Mesaj gönderme. Küfür varsa sessizce engeller (kullanıcıya bildirim yok).
  Future<bool> sendMessage(String text, String userId) async {
    // 1. Filtre Taraması — küfür varsa sessizce engelle
    if (ProfanityFilterService.hasProfanity(text)) {
      _logMessageAttempt(userId, text, blocked: true);
      // Mesajı hiç göndermeden sessizce başarılı gibi göster
      return true;
    }

    // 2. Mesaj ekle — başlangıçta "sent" (tek tik ✓)
    final msgId = const Uuid().v4();
    final newMessage = MessageModel(
      id: msgId,
      text: text,
      senderId: userId,
      timestamp: DateTime.now(),
      isMyMessage: true,
      status: MessageStatus.sent,
    );

    state = [...state, newMessage];
    _logMessageAttempt(userId, text, blocked: false);

    // 3. Tik simülasyonu: 1sn sonra delivered (çift tik ✓✓)
    Future.delayed(const Duration(seconds: 1), () {
      _updateMessageStatus(msgId, MessageStatus.delivered);
    });

    // 4. 3sn sonra read (mavi çift tik ✓✓)
    Future.delayed(const Duration(seconds: 3), () {
      _updateMessageStatus(msgId, MessageStatus.read);
    });

    return true;
  }

  /// Mesaj durumunu güncelle (tik sistemi)
  void _updateMessageStatus(String messageId, MessageStatus newStatus) {
    state =
        state.map((m) {
          if (m.id == messageId) {
            return m.copyWith(status: newStatus);
          }
          return m;
        }).toList();
  }

  /// API log metodu (ileride admin panele aktarılacak)
  void _logMessageAttempt(String userId, String text, {required bool blocked}) {
    // ignore: avoid_print
    print(
      '[CHAT LOG] User: $userId | Blocked: $blocked | Length: ${text.length}',
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>((
  ref,
) {
  return ChatNotifier();
});
