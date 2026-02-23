import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/messaging/domain/models/message_model.dart';
import 'package:kamulog_superapp/features/messaging/presentation/providers/chat_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:intl/intl.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    final userId = ref.read(profilProvider).tcKimlik ?? 'unknown_user';

    // Clear field immediately for better UX
    _messageController.clear();

    final success = await ref
        .read(chatProvider.notifier)
        .sendMessage(text, userId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mesajınız gönderilemedi. Argo veya küfür içeriyor olabilir.',
          ),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }

    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final messages = ref.watch(chatProvider);

    // Auto scroll down when new messages arrive
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danışman ile Sohbet'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Desenli arka plan
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ChatBackgroundPainter(isDark: isDark),
                  ),
                ),
                ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return _buildMessageBubble(
                      message.text,
                      message.isMyMessage,
                      message.timestamp,
                      message.status,
                      isDark,
                    );
                  },
                ),
              ],
            ),
          ),
          _buildInputBar(isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
    String text,
    bool isMine,
    DateTime time,
    MessageStatus status,
    bool isDark,
  ) {
    final formatTime = DateFormat('HH:mm').format(time);

    // Tik ikonu ve rengini belirle
    IconData? tickIcon;
    Color? tickColor;
    if (isMine) {
      switch (status) {
        case MessageStatus.sent:
          tickIcon = Icons.check;
          tickColor = isDark ? Colors.white54 : Colors.white70;
          break;
        case MessageStatus.delivered:
          tickIcon = Icons.done_all;
          tickColor = isDark ? Colors.white54 : Colors.white70;
          break;
        case MessageStatus.read:
          tickIcon = Icons.done_all;
          tickColor = const Color(0xFF34B7F1); // Klasik mavi tik rengi
          break;
      }
    }

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              isMine
                  ? AppTheme.primaryColor
                  : (isDark ? AppTheme.cardDark : Colors.grey.shade200),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color:
                    isMine
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatTime,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isMine
                            ? Colors.white70
                            : (isDark ? Colors.white54 : Colors.black54),
                  ),
                ),
                if (isMine && tickIcon != null) ...[
                  const SizedBox(width: 4),
                  Icon(tickIcon, size: 14, color: tickColor),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isDark) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 16, 12 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(
          top: BorderSide(color: isDark ? Colors.white12 : Colors.black12),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TextField(
                controller: _messageController,
                maxLines: 4,
                minLines: 1,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Bir mesaj yazın...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : Colors.black45,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 48,
            width: 48,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: _sendMessage,
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatBackgroundPainter extends CustomPainter {
  final bool isDark;

  _ChatBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    final paint =
        Paint()
          ..color =
              isDark
                  ? Colors.white.withValues(alpha: 0.03)
                  : Colors.black.withValues(alpha: 0.03)
          ..style = PaintingStyle.fill;

    // Desen boyutları ve aralıkları
    const spacing = 40.0;
    const radius = 2.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        // Çapraz bir desen efekti vermek için her satırda kaydırma yapıyoruz
        final isEvenRow = (y / spacing).floor() % 2 == 0;
        final xOffset = isEvenRow ? 0.0 : spacing / 2.0;

        final dx = x + xOffset;
        if (dx < size.width) {
          canvas.drawCircle(Offset(dx, y), radius, paint);

          // Biraz daha farklı şekiller (örneğin çapraz ufak çizgiler) ekleyelim
          if ((x / spacing + y / spacing).floor() % 3 == 0) {
            canvas.drawRect(
              Rect.fromCenter(
                center: Offset(dx + spacing / 2, y + spacing / 2),
                width: 4,
                height: 4,
              ),
              paint
                ..color =
                    isDark
                        ? Colors.white.withValues(alpha: 0.02)
                        : Colors.black.withValues(alpha: 0.02),
            );
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ChatBackgroundPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
