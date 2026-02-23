import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';

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

    // Profil yüklendiğinden emin olduktan sonra AI Asistanına pasla.

    final cvDoc = profil.documents.cast<DocumentInfo?>().firstWhere(
      (doc) => doc != null && doc.category.toLowerCase() == 'cv',
      orElse: () => null,
    );

    String cvTextContent = '';
    if (cvDoc != null && cvDoc.content != null && cvDoc.content!.isNotEmpty) {
      cvTextContent =
          "\n\nKULLANICININ ORJİNAL CV İÇERİĞİ:\n\${cvDoc.content}\n\nLütfen bu CV içeriğini okuyarak aşağıdaki ilana uygunluğumu analiz et.";
    } else {
      cvTextContent =
          "\n\nLütfen sistemde kayıtlı profil verilerime (beceriler, unvan, deneyim vb.) göre şu iş ilanı ile detaylıca karşılaştır.";
    }

    final prompt =
        "$cvTextContent\n\nBana uygunluk oranımı, bu ilan için güçlü ve zayıf yönlerimi açıkla.\n\nİlan Başlığı: ${job.title}\nKurum: ${job.company}\nİş Tanımı: ${job.description}";
    ref.read(aiChatProvider.notifier).sendMessage(prompt);

    // AI Asistan tab'ına yönlendir
    if (context.mounted) {
      ref.read(homeNavigationProvider.notifier).setIndex(4);
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('İlan Detayı'),
        centerTitle: true,
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
                        label: const FittedBox(
                          child: Text(
                            'AI Analizi (5 Kredi)',
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
