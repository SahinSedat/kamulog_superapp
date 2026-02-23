import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';

class JobDetailScreen extends ConsumerWidget {
  final JobListingModel job;

  const JobDetailScreen({super.key, required this.job});

  Future<void> _launchUrl(BuildContext context, String? urlStr) async {
    if (urlStr == null || urlStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Geçerli bir url bulunamadı')),
      );
      return;
    }
    final url = Uri.parse(urlStr);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Bağlantı açılamadı')));
      }
    }
  }

  void _analyzeJob(BuildContext context, WidgetRef ref) async {
    final profil = ref.read(profilProvider);

    if (!profil.hasCv) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Analiz için önce Belgelerim sayfasından bir CV yüklemelisiniz.',
          ),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Jeton kontrolü
    if (!profil.hasEnoughCredits(2)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Bu işlem için yeterli jetonunuz bulunmuyor (2 Jeton gerekli).',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Jetonu düş
    await ref.read(profilProvider.notifier).decreaseCredits(2);

    // CV içeriğini hazırla
    final cvDoc = profil.documents.cast<DocumentInfo?>().firstWhere(
      (doc) => doc != null && doc.category.toLowerCase() == 'cv',
      orElse: () => null,
    );

    String cvContent;
    if (cvDoc != null && cvDoc.content != null && cvDoc.content!.isNotEmpty) {
      cvContent = cvDoc.content!;
    } else {
      cvContent =
          'Ad: ${profil.name ?? "Belirtilmedi"}, Kurum: ${profil.effectiveInstitution}, Unvan: ${profil.title ?? "Belirtilmedi"}, Beceriler: ${profil.surveyInterests.join(", ")}';
    }

    // Yeni analiz akışını başlat (sayfadan ayrılmadan)
    ref
        .read(aiChatProvider.notifier)
        .startJobAnalysis(
          jobId: job.id,
          jobCode: job.code,
          jobTitle: job.title,
          jobCompany: job.company,
          jobDescription: job.description,
          jobRequirements: job.requirements,
          cvContent: cvContent,
        );

    // Modal bottom sheet ile sonucu göster
    if (context.mounted) {
      _showAnalysisModal(context, ref);
    }
  }

  void _showAnalysisModal(BuildContext context, WidgetRef ref) {
    final ilanNo = job.code ?? job.id;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => _JobAnalysisSheet(
            ilanNo: ilanNo,
            jobTitle: job.title,
            applicationUrl: job.applicationUrl ?? job.sourceUrl,
          ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final profil = ref.watch(profilProvider);

    return PopScope(
      canPop: true,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded),
            onPressed: () => context.pop(),
          ),
          title: const Text('İlan Detayı'),
          centerTitle: true,
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.toll_rounded,
                    size: 16,
                    color: AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profil.isPremium ? 'Sınırsız' : '${profil.credits} Jeton',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.business_center_rounded,
                        color: AppTheme.primaryColor,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          job.company,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? Colors.white70 : Colors.black54,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (job.location != null) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_rounded,
                                size: 14,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                job.location!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Badges
              Row(
                children: [
                  _buildBadge(
                    icon: Icons.work_outline_rounded,
                    label: job.type == 'PUBLIC' ? 'Kamu' : 'Özel Sektör',
                    color:
                        job.type == 'PUBLIC'
                            ? AppTheme.primaryColor
                            : const Color(0xFF7B1FA2),
                  ),
                  const SizedBox(width: 8),
                  if (job.salary != null)
                    _buildBadge(
                      icon: Icons.attach_money_rounded,
                      label: job.salary!,
                      color: const Color(0xFF2E7D32),
                    ),
                ],
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 20),

              // Description
              const Text(
                'İş Tanımı',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),
              Text(
                job.description,
                style: TextStyle(
                  fontSize: 14,
                  height: 1.6,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),

              const SizedBox(height: 24),

              // Requirements
              if (job.requirements != null && job.requirements!.isNotEmpty) ...[
                const Text(
                  'Aranan Nitelikler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 12),
                Text(
                  job.requirements!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.6,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Info block
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.05)
                          : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isDark ? Colors.white12 : Colors.grey[200]!,
                  ),
                ),
                child: Column(
                  children: [
                    if (job.deadline != null)
                      _buildInfoRow(
                        Icons.event_rounded,
                        'Son Başvuru',
                        '${job.deadline!.day}.${job.deadline!.month}.${job.deadline!.year}',
                        isDark,
                      ),
                    if (job.deadline != null && job.employerPhone != null)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                    if (job.employerPhone != null)
                      _buildInfoRow(
                        Icons.phone_rounded,
                        'İletişim',
                        job.employerPhone!,
                        isDark,
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 100), // padding for bottom button
            ],
          ),
        ),
        bottomSheet: Container(
          padding: const EdgeInsets.all(20),
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
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 54,
                        child: ElevatedButton.icon(
                          onPressed: () => _analyzeJob(context, ref),
                          icon: const Icon(
                            Icons.analytics_rounded,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          label: FittedBox(
                            child: Text(
                              profil.isPremium
                                  ? 'AI Analizi (Sınırsız)'
                                  : 'AI Analizi (2 Jeton)',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryColor,
                              ),
                              maxLines: 1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor.withValues(
                              alpha: 0.1,
                            ),
                            foregroundColor: AppTheme.primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: BorderSide(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed:
                              () => _launchUrl(
                                context,
                                job.applicationUrl ?? job.sourceUrl,
                              ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const FittedBox(
                            child: Text(
                              'İlana Başvur',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ), // SafeArea bottom padding için ekstra boşluk
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey[500]),
        const SizedBox(width: 12),
        Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[500])),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}

/// İlan analizi sonuçlarını gösteren modal bottom sheet
class _JobAnalysisSheet extends ConsumerWidget {
  final String ilanNo;
  final String jobTitle;
  final String? applicationUrl;

  const _JobAnalysisSheet({
    required this.ilanNo,
    required this.jobTitle,
    this.applicationUrl,
  });

  /// AI yanıtından uyumluluk skorunu parse et
  int? _parseScore(String content) {
    final patterns = [
      RegExp(r'Uyumluluk Skoru[:\s]*[%]?(\d{1,3})'),
      RegExp(r'%(\d{1,3})'),
      RegExp(r'(\d{1,3})%'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(content);
      if (match != null) {
        final score = int.tryParse(match.group(1)!);
        if (score != null && score >= 0 && score <= 100) return score;
      }
    }
    return null;
  }

  /// AI yanıtında UYGUN mu ALTERNATİF mi?
  bool _isUygun(String content) {
    final score = _parseScore(content);
    if (score != null && score >= 60) return true;
    final lower = content.toLowerCase();
    if (lower.contains('sonuç: uygun') || lower.contains('sonuç:** uygun')) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(aiChatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final assistantMessages =
        chatState.messages.where((m) => m.role == AiRole.assistant).toList();
    final lastAssistantMsg =
        assistantMessages.isNotEmpty ? assistantMessages.last : null;

    final score =
        lastAssistantMsg != null ? _parseScore(lastAssistantMsg.content) : null;
    final isUygun =
        lastAssistantMsg != null ? _isUygun(lastAssistantMsg.content) : false;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    gradient: AppTheme.aiGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.analytics_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'İlan Analizi — $ilanNo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        jobTitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // Analiz sonucu
          Expanded(
            child:
                chatState.isLoading && lastAssistantMsg == null
                    ? _buildLoadingView()
                    : lastAssistantMsg != null
                    ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Uyumluluk skoru gauge
                          if (score != null && chatState.analysisComplete) ...[
                            _buildScoreGauge(score, isUygun, isDark),
                            const SizedBox(height: 20),
                          ],

                          // Sonuç banner
                          if (chatState.analysisComplete) ...[
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (isUygun
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFFF57C00))
                                    .withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: (isUygun
                                          ? const Color(0xFF2E7D32)
                                          : const Color(0xFFF57C00))
                                      .withValues(alpha: 0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    isUygun
                                        ? Icons.check_circle_rounded
                                        : Icons.info_rounded,
                                    color:
                                        isUygun
                                            ? const Color(0xFF2E7D32)
                                            : const Color(0xFFF57C00),
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    isUygun
                                        ? 'Bu ilan size uygun!'
                                        : 'Alternatif olarak değerlendirin',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isUygun
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFF57C00),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],

                          // Mesaj içeriği
                          SelectableText(
                            lastAssistantMsg.content,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),

                          // Loading indicator while streaming
                          if (chatState.isLoading) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Analiz devam ediyor...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    )
                    : _buildLoadingView(),
          ),

          // Alt butonlar
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Başvur / Yine de Başvur
                  if (chatState.analysisComplete && applicationUrl != null) ...[
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => launchUrl(Uri.parse(applicationUrl!)),
                        icon: Icon(
                          isUygun
                              ? Icons.send_rounded
                              : Icons.open_in_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        label: Text(
                          isUygun ? 'Hemen Başvur' : 'Yine de Başvur',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isUygun
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFF57C00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  // Kapat
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed:
                          chatState.isLoading
                              ? null
                              : () {
                                ref
                                    .read(aiChatProvider.notifier)
                                    .newConversation();
                                Navigator.pop(context);
                              },
                      icon: Icon(
                        chatState.analysisComplete
                            ? Icons.check_rounded
                            : Icons.close_rounded,
                      ),
                      label: Text(
                        chatState.analysisComplete ? 'Analizi Kapat' : 'Kapat',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreGauge(int score, bool isUygun, bool isDark) {
    final color =
        score >= 70
            ? const Color(0xFF2E7D32)
            : score >= 40
            ? const Color(0xFFF57C00)
            : AppTheme.errorColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.15)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 70,
                  height: 70,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    strokeWidth: 6,
                    backgroundColor: color.withValues(alpha: 0.15),
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                Text(
                  '%$score',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Uyumluluk Skoru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  score >= 70
                      ? 'CV\'niz bu ilan için yüksek uyum gösteriyor'
                      : score >= 40
                      ? 'Kısmen uyumlu — bazı eksiklikler var'
                      : 'Düşük uyumluluk — alternatif değerlendirin',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'CV uyumluluk analizi yapılıyor...',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            'İlan No: $ilanNo',
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
