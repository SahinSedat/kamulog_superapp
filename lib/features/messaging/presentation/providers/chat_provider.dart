import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/messaging/domain/models/message_model.dart';
import 'package:kamulog_superapp/features/messaging/domain/profanity_filter_service.dart';
import 'package:uuid/uuid.dart';

// İleride web api ile gerçek zamanlı iletişim sağlamak için state management yapısı hazırlanmıştır.
class ChatNotifier extends StateNotifier<List<MessageModel>> {
  ChatNotifier() : super([]) {
    // Simüle bağlantı veya hoşgeldin mesajı
    _addSystemMessage(
      'Sohbete hoş geldiniz! Kurallarımız gereği argo/küfür içeren mesajların gönderimi sistem tarafından engellenmektedir.',
    );
  }

  void _addSystemMessage(String text) {
    state = [
      ...state,
      MessageModel(
        id: const Uuid().v4(),
        text: text,
        senderId: 'system',
        timestamp: DateTime.now(),
        isMyMessage: false,
        isSystemMessage: true,
      ),
    ];
  }

  /// Mesaj gönderme fonksiyonu. (Hem filtre taraması hem de web api uyumlu loglama barındırır)
  Future<bool> sendMessage(String text, String userId) async {
    // 1. Filtre Taraması
    if (ProfanityFilterService.hasProfanity(text)) {
      // Küfür veya argo algılandığında mesaj loglara takılabilir veya tamamen reddedilebilir.
      _logMessageAttempt(userId, text, blocked: true);
      return false; // Başarısız gönderim (Argo)
    }

    // 2. Mesaj Okey, Listeye Ekle ve Logla
    final newMessage = MessageModel(
      id: const Uuid().v4(),
      text: text,
      senderId: userId,
      timestamp: DateTime.now(),
      isMyMessage: true,
    );

    state = [...state, newMessage];

    _logMessageAttempt(userId, text, blocked: false);

    // 3. (Mock) Karşı Taraftan Cevap Simülasyonu
    Future.delayed(const Duration(seconds: 1), () {
      state = [
        ...state,
        MessageModel(
          id: const Uuid().v4(),
          text: 'Mesajınız ulaştı: \$text',
          senderId: 'admin_or_consultant',
          timestamp: DateTime.now(),
          isMyMessage: false,
        ),
      ];
    });

    return true; // Başarılı
  }

  /// Gelecekte Web paneline logların aktarılacağı metot
  void _logMessageAttempt(String userId, String text, {required bool blocked}) {
    // Bu metod kamulog-stk / admin api endpoint'lerine (örn: /api/messaging/log) bir POST isteği atacaktır.
    // Şimdilik sadece print logu bırakıyoruz.
    // ignore: avoid_print
    print(
      '[CHAT LOG] User: \$userId | Blocked: \$blocked | Content length: \${text.length} | Text: \$text',
    );
  }
}

final chatProvider = StateNotifierProvider<ChatNotifier, List<MessageModel>>((
  ref,
) {
  return ChatNotifier();
});
