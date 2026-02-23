import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/presentation/widgets/ai_typing_indicator.dart';

class AiMessageBubble extends StatelessWidget {
  final AiMessageModel message;
  final bool showAvatar;
  final bool isDark;
  const AiMessageBubble({
    super.key,
    required this.message,
    required this.showAvatar,
    required this.isDark,
  });

  bool get isUser => message.role == AiRole.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: showAvatar ? 16 : 4,
        bottom: 4,
        left: isUser ? 48 : 0,
        right: isUser ? 0 : 48,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          // AI avatar
          if (!isUser && showAvatar)
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 8, top: 2),
              decoration: const BoxDecoration(
                gradient: AppTheme.aiGradient,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 15,
                color: Colors.white,
              ),
            )
          else if (!isUser)
            const SizedBox(width: 38),

          // Message bubble
          Flexible(
            child: GestureDetector(
              onLongPress: () {
                HapticFeedback.lightImpact();
                Clipboard.setData(ClipboardData(text: message.content));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Mesaj kopyalandı'),
                    duration: const Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: isUser ? AppTheme.aiGradient : null,
                  color:
                      isUser
                          ? null
                          : isDark
                          ? AppTheme.cardDark
                          : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isUser ? 18 : 4),
                    bottomRight: Radius.circular(isUser ? 4 : 18),
                  ),
                  border:
                      isUser
                          ? null
                          : Border.all(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.06)
                                    : Colors.black.withValues(alpha: 0.06),
                          ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isUser
                              ? AppTheme.primaryColor.withValues(alpha: 0.2)
                              : Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    message.isStreaming && message.content.isEmpty
                        ? const AiTypingIndicator()
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              message.content,
                              style: TextStyle(
                                fontSize: 14.5,
                                height: 1.5,
                                color:
                                    isUser
                                        ? Colors.white
                                        : isDark
                                        ? Colors.white.withValues(alpha: 0.9)
                                        : Colors.black87,
                              ),
                            ),

                            if (message.isStreaming)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      isUser
                                          ? Colors.white60
                                          : AppTheme.primaryColor.withValues(
                                            alpha: 0.5,
                                          ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
