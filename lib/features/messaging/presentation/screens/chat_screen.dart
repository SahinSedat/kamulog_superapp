import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/messaging/domain/models/message_model.dart';
import 'package:kamulog_superapp/features/messaging/presentation/providers/chat_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/providers/expert_marketplace_provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

/// Danışman Mesajlarım — konuşma listesi + sohbet ekranı
class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  String? _activeConversationId;
  String? _activeExpertName;
  String? _activeExpertCategory;
  bool _activeExpertOnline = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (_activeConversationId != null) {
      return _buildChatView(isDark);
    }
    return _buildConversationList(isDark);
  }

  // ══════════════════════════════════════════════════════════════
  // CONVERSATION LIST — WhatsApp tarzı sohbet listesi
  // ══════════════════════════════════════════════════════════════

  Widget _buildConversationList(bool isDark) {
    final expertState = ref.watch(expertMarketplaceProvider);
    final experts = expertState.allExperts;

    // Mock conversations — ilk 4 uzmanla konuşma
    final conversations = experts.take(4).toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
        title: const Text('Danışman Mesajlarım'),
        centerTitle: true,
        actions: [
          IconButton(icon: const Icon(Icons.search_rounded), onPressed: () {}),
        ],
      ),
      body:
          conversations.isEmpty
              ? _buildEmptyState(isDark)
              : ListView.builder(
                padding: const EdgeInsets.only(top: 8),
                itemCount: conversations.length,
                itemBuilder: (context, index) {
                  final expert = conversations[index];
                  final category = expert.category;
                  final lastMsg =
                      _mockLastMessages[index % _mockLastMessages.length];
                  final unread = index == 0 ? 2 : (index == 2 ? 1 : 0);
                  final time =
                      index == 0
                          ? 'Şimdi'
                          : index == 1
                          ? '14:32'
                          : index == 2
                          ? 'Dün'
                          : '23 Şub';

                  return _ConversationTile(
                    name: expert.name,
                    category: _categoryLabel(category.name),
                    categoryColor: _categoryColor(category.name),
                    lastMessage: lastMsg,
                    time: time,
                    unreadCount: unread,
                    isOnline: expert.isOnline,
                    avatarText: expert.name[0],
                    isDark: isDark,
                    onTap: () {
                      setState(() {
                        _activeConversationId = expert.id;
                        _activeExpertName = expert.name;
                        _activeExpertCategory = _categoryLabel(category.name);
                        _activeExpertOnline = expert.isOnline;
                      });
                    },
                  );
                },
              ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 36,
                color: AppTheme.primaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Henüz mesajınız yok',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              'Danışmanlık modülünden bir uzman seçerek mesajlaşma başlatabilirsiniz.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white54 : Colors.grey[500],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => context.push('/consultation'),
              icon: const Icon(Icons.support_agent, size: 18),
              label: const Text('Uzman Bul'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // CHAT VIEW — WhatsApp benzeri mesaj duvarı
  // ══════════════════════════════════════════════════════════════

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
    _messageController.clear();

    final success = await ref
        .read(chatProvider.notifier)
        .sendMessage(text, userId);

    if (!success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mesajınız gönderilemedi.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
    _scrollToBottom();
  }

  Future<void> _attachFile() async {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Dosya Ekle',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _AttachOption(
                        icon: Icons.photo_rounded,
                        label: 'Fotoğraf',
                        color: const Color(0xFF4CAF50),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final picker = ImagePicker();
                          final file = await picker.pickImage(
                            source: ImageSource.gallery,
                          );
                          if (file != null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📷 Fotoğraf seçildi: ${file.name}',
                                ),
                                backgroundColor: const Color(0xFF4CAF50),
                              ),
                            );
                          }
                        },
                      ),
                      _AttachOption(
                        icon: Icons.camera_alt_rounded,
                        label: 'Kamera',
                        color: const Color(0xFF2196F3),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final picker = ImagePicker();
                          final file = await picker.pickImage(
                            source: ImageSource.camera,
                          );
                          if (file != null && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📸 Fotoğraf çekildi: ${file.name}',
                                ),
                                backgroundColor: const Color(0xFF2196F3),
                              ),
                            );
                          }
                        },
                      ),
                      _AttachOption(
                        icon: Icons.picture_as_pdf_rounded,
                        label: 'PDF / Dosya',
                        color: const Color(0xFFFF5722),
                        onTap: () async {
                          Navigator.pop(ctx);
                          final result = await FilePicker.platform.pickFiles(
                            type: FileType.custom,
                            allowedExtensions: [
                              'pdf',
                              'doc',
                              'docx',
                              'xls',
                              'xlsx',
                              'txt',
                            ],
                          );
                          if (result != null &&
                              result.files.isNotEmpty &&
                              mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '📄 Dosya seçildi: ${result.files.first.name}',
                                ),
                                backgroundColor: const Color(0xFFFF5722),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildChatView(bool isDark) {
    final messages = ref.watch(chatProvider);

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          setState(() {
            _activeConversationId = null;
            _activeExpertName = null;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
            onPressed:
                () => setState(() {
                  _activeConversationId = null;
                  _activeExpertName = null;
                }),
          ),
          titleSpacing: 0,
          title: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.15,
                    ),
                    child: Text(
                      _activeExpertName?[0] ?? '?',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.primaryColor,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  if (_activeExpertOnline)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark ? AppTheme.surfaceDark : Colors.white,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _activeExpertName ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _activeExpertOnline
                          ? 'Çevrimiçi'
                          : _activeExpertCategory ?? 'Danışman',
                      style: TextStyle(
                        fontSize: 11,
                        color:
                            _activeExpertOnline
                                ? const Color(0xFF4CAF50)
                                : (isDark ? Colors.white54 : Colors.grey[500]),
                        fontWeight:
                            _activeExpertOnline
                                ? FontWeight.w600
                                : FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert_rounded),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _ChatBackgroundPainter(isDark: isDark),
                    ),
                  ),
                  messages.isEmpty
                      ? _buildChatEmpty(isDark)
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(12),
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
      ),
    );
  }

  Widget _buildChatEmpty(bool isDark) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '🔒 Mesajlar uçtan uca şifrelenir',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.grey[500],
              ),
            ),
          ),
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

    IconData? tickIcon;
    Color? tickColor;
    if (isMine) {
      switch (status) {
        case MessageStatus.sent:
          tickIcon = Icons.check;
          tickColor = Colors.white70;
          break;
        case MessageStatus.delivered:
          tickIcon = Icons.done_all;
          tickColor = Colors.white70;
          break;
        case MessageStatus.read:
          tickIcon = Icons.done_all;
          tickColor = const Color(0xFF34B7F1);
          break;
      }
    }

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 6),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.78,
        ),
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
        decoration: BoxDecoration(
          color:
              isMine
                  ? AppTheme.primaryColor
                  : (isDark ? const Color(0xFF1F2C34) : Colors.white),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isMine ? 12 : 2),
            bottomRight: Radius.circular(isMine ? 2 : 12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 14,
                height: 1.3,
                color:
                    isMine
                        ? Colors.white
                        : (isDark ? Colors.white : Colors.black87),
              ),
            ),
            const SizedBox(height: 3),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  formatTime,
                  style: TextStyle(
                    fontSize: 10,
                    color:
                        isMine
                            ? Colors.white60
                            : (isDark ? Colors.white38 : Colors.grey),
                  ),
                ),
                if (isMine && tickIcon != null) ...[
                  const SizedBox(width: 3),
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
      padding: EdgeInsets.fromLTRB(8, 8, 8, 8 + bottomPadding),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1B2024) : const Color(0xFFF0F2F5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Dosya ekle butonu
          GestureDetector(
            onTap: _attachFile,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Icon(
                Icons.attach_file_rounded,
                color: isDark ? Colors.white54 : Colors.grey[600],
                size: 22,
              ),
            ),
          ),
          // Mesaj alanı
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF2A3137) : Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      style: const TextStyle(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Mesaj yazın...',
                        hintStyle: TextStyle(
                          color: isDark ? Colors.white38 : Colors.grey[400],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                      ),
                    ),
                  ),
                  // Kamera kısayolu
                  GestureDetector(
                    onTap: () async {
                      final picker = ImagePicker();
                      final file = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      if (file != null && mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('📸 ${file.name}'),
                            backgroundColor: const Color(0xFF4CAF50),
                          ),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 8, bottom: 8),
                      child: Icon(
                        Icons.camera_alt_rounded,
                        color: isDark ? Colors.white38 : Colors.grey[400],
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Gönder butonu
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: AppTheme.primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Yardımcı metotlar
  String _categoryLabel(String catName) {
    switch (catName) {
      case 'hukuki':
        return 'Hukuki Danışman';
      case 'idari':
        return 'İdari Danışman';
      case 'mali':
        return 'Mali Danışman';
      case 'kariyer':
        return 'Kariyer Uzmanı';
      case 'psikolojik':
        return 'Psikolog';
      default:
        return 'Danışman';
    }
  }

  Color _categoryColor(String catName) {
    switch (catName) {
      case 'hukuki':
        return const Color(0xFF6366F1);
      case 'idari':
        return const Color(0xFF0EA5E9);
      case 'mali':
        return const Color(0xFF10B981);
      case 'kariyer':
        return const Color(0xFFF59E0B);
      case 'psikolojik':
        return const Color(0xFFEC4899);
      default:
        return Colors.grey;
    }
  }

  static const _mockLastMessages = [
    'Talebinizi aldım, kontrol edip dönüş yapacağım.',
    'Teşekkür ederim, iyi çalışmalar.',
    'Dosyalarınızı inceliyorum, yakında size döneceğim.',
    'Merhaba, size nasıl yardımcı olabilirim?',
  ];
}

// ── Konuşma Tile
class _ConversationTile extends StatelessWidget {
  final String name;
  final String category;
  final Color categoryColor;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;
  final String avatarText;
  final bool isDark;
  final VoidCallback onTap;

  const _ConversationTile({
    required this.name,
    required this.category,
    required this.categoryColor,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.isOnline,
    required this.avatarText,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Avatar + online badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: categoryColor.withValues(alpha: 0.15),
                  child: Text(
                    avatarText,
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: categoryColor,
                      fontSize: 18,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppTheme.surfaceDark : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            // İçerik
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight:
                                unreadCount > 0
                                    ? FontWeight.w700
                                    : FontWeight.w600,
                            fontSize: 15,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight:
                              unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                          color:
                              unreadCount > 0
                                  ? AppTheme.primaryColor
                                  : (isDark ? Colors.white38 : Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: categoryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: categoryColor,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          lastMessage,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            color:
                                unreadCount > 0
                                    ? (isDark ? Colors.white70 : Colors.black87)
                                    : (isDark
                                        ? Colors.white38
                                        : Colors.grey[500]),
                          ),
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Dosya ekleme seçeneği
class _AttachOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _AttachOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

// ── WhatsApp tarzı desen arka plan
class _ChatBackgroundPainter extends CustomPainter {
  final bool isDark;

  _ChatBackgroundPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.isEmpty) return;

    // Ana arka plan
    final bgPaint =
        Paint()
          ..color = isDark ? const Color(0xFF0B141A) : const Color(0xFFECE5DD);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    final paint =
        Paint()
          ..color =
              isDark
                  ? Colors.white.withValues(alpha: 0.02)
                  : Colors.black.withValues(alpha: 0.025)
          ..style = PaintingStyle.fill;

    const spacing = 36.0;
    const radius = 1.5;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        final isEvenRow = (y / spacing).floor() % 2 == 0;
        final xOffset = isEvenRow ? 0.0 : spacing / 2.0;
        final dx = x + xOffset;
        if (dx < size.width) {
          canvas.drawCircle(Offset(dx, y), radius, paint);

          if ((x / spacing + y / spacing).floor() % 4 == 0) {
            canvas.drawRect(
              Rect.fromCenter(
                center: Offset(dx + spacing / 2, y + spacing / 2),
                width: 3,
                height: 3,
              ),
              paint,
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
