import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/features/ai/presentation/widgets/ai_message_bubble.dart';
import 'package:kamulog_superapp/features/ai/presentation/widgets/ai_suggestion_chips.dart';

class AiAssistantScreen extends ConsumerStatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  ConsumerState<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends ConsumerState<AiAssistantScreen>
    with TickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();
  late final AnimationController _welcomeAnim;

  @override
  void initState() {
    super.initState();
    _welcomeAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _welcomeAnim.dispose();
    super.dispose();
  }

  void _send([String? text]) {
    final msg = text ?? _controller.text;
    if (msg.trim().isEmpty) return;

    ref.read(aiChatProvider.notifier).sendMessage(msg);
    _controller.clear();
    _focusNode.requestFocus();

    // Scroll to bottom after a short delay
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 100,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(aiChatProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen(aiChatProvider, (previous, next) {
      if (next.error != null && previous?.error != next.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    });

    // Auto-scroll when messages change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (chatState.messages.isNotEmpty) _scrollToBottom();
    });

    final aiCredits = chatState.aiAssistantCredits;

    return Column(
      children: [
        // Jeton bilgisi barı
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            border: Border(
              bottom: BorderSide(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.black.withValues(alpha: 0.06),
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.toll_rounded,
                size: 16,
                color:
                    aiCredits > 0 ? AppTheme.primaryColor : AppTheme.errorColor,
              ),
              const SizedBox(width: 6),
              Text(
                '$aiCredits Jeton kaldı',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color:
                      aiCredits > 0
                          ? (isDark ? Colors.white70 : Colors.black54)
                          : AppTheme.errorColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '(her mesaj 1 jeton)',
                style: TextStyle(fontSize: 10, color: Colors.grey[500]),
              ),
            ],
          ),
        ),

        // Chat area
        Expanded(
          child:
              chatState.messages.isEmpty
                  ? _buildWelcomeView(theme, isDark, ref)
                  : _buildChatList(chatState, theme, isDark),
        ),

        // Input area (chatLocked ise uyarı göster)
        if (chatState.chatLocked)
          _buildLockedBar(isDark)
        else
          _buildInputBar(chatState, theme, isDark),
      ],
    );
  }

  Widget _buildLockedBar(bool isDark) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(
          top: BorderSide(color: AppTheme.errorColor.withValues(alpha: 0.3)),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.lock_rounded, color: AppTheme.errorColor, size: 18),
          SizedBox(width: 8),
          Text(
            'Sohbet limitiniz (20 Mesaj) doldu.',
            style: TextStyle(
              color: AppTheme.errorColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeView(ThemeData theme, bool isDark, WidgetRef ref) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _welcomeAnim, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _welcomeAnim, curve: Curves.easeOut)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacingLg),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // AI Avatar with glow
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  gradient: AppTheme.aiGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 32,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  size: 40,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppTheme.spacingLg),

              // Title
              ShaderMask(
                shaderCallback:
                    (bounds) => AppTheme.aiGradient.createShader(bounds),
                child: Text(
                  'Kamulog AI',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingSm),

              Text(
                'Size nasıl yardımcı olabilirim?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.textTheme.bodyMedium?.color?.withValues(
                    alpha: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Feature cards
              _buildFeatureCard(
                icon: Icons.work_outline,
                title: 'Kariyer Danışmanlığı',
                description: 'CV hazırlama, mülakat ipuçları, kariyer planı',
                gradient: AppTheme.aiGradient,
                isDark: isDark,
                onTap:
                    () => ref
                        .read(aiChatProvider.notifier)
                        .sendMessage('Kariyer planlamasında bana yardım et'),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              _buildFeatureCard(
                icon: Icons.gavel_outlined,
                title: 'Mevzuat Bilgisi',
                description: 'Kanunlar, yönetmelikler, özlük hakları',
                gradient: AppTheme.primaryGradient,
                isDark: isDark,
                onTap:
                    () => ref.read(aiChatProvider.notifier).startMevzuatChat(),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              _buildFeatureCard(
                icon: Icons.swap_horiz,
                title: 'Becayiş Rehberi',
                description: 'Başvuru, süreç, dikkat edilecekler',
                gradient: const LinearGradient(
                  colors: [Color(0xFF00B894), Color(0xFF00CEC9)],
                ),
                isDark: isDark,
                onTap:
                    () => ref
                        .read(aiChatProvider.notifier)
                        .sendMessage('Becayiş süreci hakkında bilgi ver'),
              ),
              const SizedBox(height: AppTheme.spacingMd),

              // Quick suggestions
              const AiSuggestionChips(),

              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
    required Gradient gradient,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusLg),
        child: Container(
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg),
            border: Border.all(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: isDark ? Colors.white30 : Colors.black26,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatList(AiChatState chatState, ThemeData theme, bool isDark) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        final message = chatState.messages[index];
        final showAvatar =
            index == 0 || chatState.messages[index - 1].role != message.role;

        return AiMessageBubble(
          message: message,
          showAvatar: showAvatar,
          isDark: isDark,
          isCvBuilding: chatState.isCvBuilding,
        );
      },
    );
  }

  Widget _buildInputBar(AiChatState chatState, ThemeData theme, bool isDark) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
        AppTheme.spacingMd,
        AppTheme.spacingSm,
        AppTheme.spacingSm,
        AppTheme.spacingSm + bottomPadding,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // New conversation button
          if (chatState.messages.isNotEmpty)
            GestureDetector(
              onTap: () => ref.read(aiChatProvider.notifier).newConversation(),
              child: Container(
                width: 38,
                height: 38,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ),

          // Text input
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.08)
                          : Colors.grey.shade200,
                ),
              ),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                maxLines: null,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                style: TextStyle(
                  fontSize: 15,
                  color: isDark ? Colors.white : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Mesajınızı yazın...',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white30 : Colors.black38,
                    fontSize: 15,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 10,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Send button
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: chatState.isLoading ? null : AppTheme.aiGradient,
              color:
                  chatState.isLoading
                      ? (isDark ? Colors.white12 : Colors.grey.shade200)
                      : null,
              borderRadius: BorderRadius.circular(14),
              boxShadow:
                  chatState.isLoading
                      ? null
                      : [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: chatState.isLoading ? null : () => _send(),
                borderRadius: BorderRadius.circular(14),
                child:
                    chatState.isLoading
                        ? Center(
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  isDark
                                      ? Colors.white60
                                      : AppTheme.primaryColor,
                            ),
                          ),
                        )
                        : const Icon(
                          Icons.send_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
