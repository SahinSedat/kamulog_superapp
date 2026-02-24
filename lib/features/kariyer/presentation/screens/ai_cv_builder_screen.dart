import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';
import 'package:kamulog_superapp/features/ai/presentation/widgets/ai_typing_indicator.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/cv_builder_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:uuid/uuid.dart';

class AiCvBuilderScreen extends ConsumerStatefulWidget {
  const AiCvBuilderScreen({super.key});

  @override
  ConsumerState<AiCvBuilderScreen> createState() => _AiCvBuilderScreenState();
}

class _AiCvBuilderScreenState extends ConsumerState<AiCvBuilderScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(cvBuilderProvider.notifier).startCvBuilding();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _messageController.text;
    if (text.trim().isEmpty) return;

    final chatState = ref.read(cvBuilderProvider);
    if (chatState.isLoading) return;

    ref.read(cvBuilderProvider.notifier).sendMessage(text);
    _messageController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollToBottom();
      _focusNode.requestFocus();
    });
  }

  Future<void> _generatePdf() async {
    final cvContent = ref.read(cvBuilderProvider.notifier).extractCvContent();
    final profil = ref.read(profilProvider);

    if (cvContent.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('CV içeriği bulunamadı.'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      // Syncfusion PDF oluştur
      final PdfDocument document = PdfDocument();
      final PdfPage page = document.pages.add();

      // CV metnini sayfaya ekle
      final PdfFont headingFont = PdfStandardFont(
        PdfFontFamily.helvetica,
        16,
        style: PdfFontStyle.bold,
      );
      final PdfFont bodyFont = PdfStandardFont(PdfFontFamily.helvetica, 11);

      page.graphics.drawString(
        'CV - ${profil.name ?? 'Belge'}',
        headingFont,
        bounds: Rect.fromLTWH(0, 0, page.getClientSize().width, 30),
      );

      // Ana CV içeriğini ekle
      final PdfTextElement textElement = PdfTextElement(
        text: cvContent,
        font: bodyFont,
      );
      textElement.draw(
        page: page,
        bounds: Rect.fromLTWH(
          0,
          40,
          page.getClientSize().width,
          page.getClientSize().height - 40,
        ),
      );

      // Dosyayı kaydet
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'cv_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File('${dir.path}/$fileName');
      final bytes = await document.save();
      await file.writeAsBytes(bytes);
      document.dispose();

      // Belgelerim'e ekle
      final docId = const Uuid().v4();
      final docInfo = DocumentInfo(
        id: docId,
        name: 'AI CV - ${profil.name ?? 'Belge'}',
        category: 'cv',
        fileType: 'pdf',
        uploadDate: DateTime.now(),
        content: cvContent,
      );

      await ref.read(profilProvider.notifier).addDocument(docInfo);

      // AI CV kullanımını kaydet
      await ref.read(profilProvider.notifier).recordAiCvUsage();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              '✅ CV başarıyla PDF olarak kaydedildi ve Belgelerim\'e eklendi!',
            ),
            backgroundColor: Color(0xFF2E7D32),
            duration: Duration(seconds: 3),
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF oluşturulurken hata oluştu: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(cvBuilderProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ref.listen(cvBuilderProvider, (previous, next) {
      if (previous?.messages.length != next.messages.length || next.isLoading) {
        Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
      }
    });

    return Scaffold(
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : AppTheme.primaryColor,
            size: 20,
          ),
          onPressed: () {
            // Geri giderken state'i silme — kullanıcı döndüğünde devam eder
            context.pop();
          },
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.aiGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.document_scanner_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'AI CV Oluşturucu',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                Text(
                  'Kariyer asistanınız',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
            onPressed: () {
              ref.read(cvBuilderProvider.notifier).restartCvBuilding();
            },
            tooltip: 'Yeniden Başlat',
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Chat List
            Expanded(
              child:
                  chatState.messages.isEmpty
                      ? _buildEmptyState(isDark)
                      : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount:
                            chatState.messages.length +
                            (chatState.isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == chatState.messages.length) {
                            return const Padding(
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              child: AiTypingIndicator(),
                            );
                          }

                          final message = chatState.messages[index];
                          return _buildMessageBubble(message, isDark);
                        },
                      ),
            ),

            // Bottom Bar — PDF butonları veya mesaj input
            if (chatState.isCvReady)
              _buildPdfActions(isDark)
            else
              _buildInputArea(chatState, isDark),
          ],
        ),
      ),
    );
  }

  /// PDF Oluştur / İptal Et butonları
  Widget _buildPdfActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  ref.read(cvBuilderProvider.notifier).newConversation();
                  context.pop();
                },
                icon: const Icon(Icons.close_rounded, size: 20),
                label: const Text(
                  'İptal Et',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade600,
                  side: BorderSide(color: Colors.red.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _generatePdf,
                icon: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'PDF Oluştur',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Normal mesaj giriş alanı
  Widget _buildInputArea(CvBuilderState chatState, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: isDark ? Colors.white12 : Colors.grey.shade300,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      focusNode: _focusNode,
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                      decoration: InputDecoration(
                        hintText: 'Bir mesaj yazın...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 15,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient:
                  chatState.isLoading
                      ? LinearGradient(
                        colors: [Colors.grey.shade400, Colors.grey.shade400],
                      )
                      : AppTheme.aiGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: IconButton(
              icon: const Icon(
                Icons.send_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: chatState.isLoading ? null : _sendMessage,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  isDark
                      ? Colors.white12
                      : AppTheme.primaryColor.withValues(alpha: 0.1),
            ),
            child: Icon(
              Icons.quick_contacts_mail_rounded,
              size: 40,
              color: isDark ? Colors.white54 : AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Özgeçmişinizi Oluşturmaya Başlayalım',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mesajınızı bekliyorum...',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(AiMessageModel message, bool isDark) {
    final isUser = message.role == AiRole.user;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                gradient: AppTheme.aiGradient,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_awesome,
                color: Colors.white,
                size: 14,
              ),
            ),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color:
                    isUser
                        ? AppTheme.primaryColor
                        : isDark
                        ? AppTheme.surfaceDark
                        : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  if (!isUser)
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  if (isUser)
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(
                    // [CV_HAZIR] etiketini UI'da gösterme
                    message.content.replaceAll('[CV_HAZIR]', '').trim(),
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
                          strokeWidth: 1.5,
                          color:
                              isUser
                                  ? Colors.white60
                                  : AppTheme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (isUser) const SizedBox(width: 8),
        ],
      ),
    );
  }
}
