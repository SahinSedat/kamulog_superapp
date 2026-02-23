import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/jobs_provider.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';

/// Kariyer modülü — AI CV oluşturma ve iş analizi
/// Ayrı modül: features/kariyer/ — ileride ayrı API/AI entegrasyonu
class CareerScreen extends ConsumerWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profil = ref.watch(profilProvider);
    final jobsState = ref.watch(jobsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kariyer'),
        centerTitle: true,
        actions: [
          _CreditBadge(credits: profil.credits),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AI CV Oluşturucu Banner
            _AiCvBanner(isDark: isDark, remaining: profil.remainingAiCvCount),
            const SizedBox(height: 20),

            // ── CV Analizi
            _CvAnalysisCard(isDark: isDark, hasCv: profil.hasCv),
            const SizedBox(height: 20),

            // ── Hızlı Eylemler
            const Row(
              children: [
                Icon(
                  Icons.flash_on_rounded,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Hızlı Eylemler',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _QuickActionCard(
              icon: Icons.auto_awesome_rounded,
              title: 'AI ile CV Oluştur',
              subtitle:
                  profil.remainingAiCvCount > 0
                      ? 'Aylık 2 kullanımdan ${profil.remainingAiCvCount} hak kaldı'
                      : 'Bu ayki kullanım hakkınız doldu',
              color: const Color(0xFF1565C0),
              onTap: () => _showAiCvBuilder(context, ref),
            ),
            const SizedBox(height: 10),
            _QuickActionCard(
              icon: Icons.upload_file_rounded,
              title: 'Mevcut CV Yükle',
              subtitle: 'PDF veya DOCX formatında CV yükleyin',
              color: const Color(0xFF7B1FA2),
              onTap: () => context.push('/documents'),
            ),
            const SizedBox(height: 10),
            _QuickActionCard(
              icon: Icons.analytics_rounded,
              title: 'İş İlanlarını Analiz Et',
              subtitle: 'CV eşleştirme analizi (5 Kredi)',
              color: const Color(0xFF2E7D32),
              onTap: () => _showJobAnalysis(context, ref),
            ),
            const SizedBox(height: 10),
            _QuickActionCard(
              icon: Icons.school_rounded,
              title: 'KPSS Hazırlık',
              subtitle: 'Sınav takvimi ve hazırlık kaynakları',
              color: const Color(0xFFE65100),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('KPSS modülü yakında aktif olacak'),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),
            // ── Güncel İş İlanları
            const Row(
              children: [
                Icon(
                  Icons.work_rounded,
                  size: 18,
                  color: AppTheme.primaryColor,
                ),
                SizedBox(width: 6),
                Text(
                  'Güncel İş İlanları',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            jobsState.jobs.when(
              data: (jobs) {
                if (jobs.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text('Şu an güncel ilan bulunmuyor.'),
                    ),
                  );
                }
                return Column(
                  children:
                      jobs
                          .map(
                            (job) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _JobCard(job: job, isDark: isDark),
                            ),
                          )
                          .toList(),
                );
              },
              loading:
                  () => const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  ),
              error:
                  (err, stack) => Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text('İlanlar yüklenirken hata oluştu: \$err'),
                    ),
                  ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAiCvBuilder(BuildContext context, WidgetRef ref) {
    final profil = ref.read(profilProvider);

    if (profil.remainingAiCvCount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu ayki AI CV oluşturma hakkınız dolmuştur (2/2).'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // AI Asistanına yönlendir ve CV akışını başlat
    ref.read(aiChatProvider.notifier).startCvBuilding(profil);
    ref.read(homeNavigationProvider.notifier).setIndex(4);
    context.pop(); // Geriye (Home'a) dön ki tablar gözüksün
  }

  void _showJobAnalysis(BuildContext context, WidgetRef ref) {
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

    if (profil.credits < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Yetersiz kredi. İş analizi için 5 kredi gereklidir.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            height: MediaQuery.of(ctx).size.height * 0.7,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.analytics_rounded,
                          size: 32,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AI İş Analizi',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yapay zeka, CV\'nizi analiz ederek en uygun iş ilanlarını bulur.\nMaliyet: 5 Kredi (Mevcut: ${profil.credits})',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _AnalysisInfoRow(
                          icon: Icons.description_rounded,
                          title: 'CV Kontrol Edildi',
                          subtitle:
                              'Analiz için sistemdeki CV\'niz kullanılacak',
                        ),
                        _AnalysisInfoRow(
                          icon: Icons.search_rounded,
                          title: 'Otomatik Tarama',
                          subtitle: 'Kamu ve özel sektör ilanları taranır',
                        ),
                        _AnalysisInfoRow(
                          icon: Icons.score_rounded,
                          title: 'Uyumluluk Skoru',
                          subtitle:
                              'Her ilan için yüzdelik uyumluluk hesaplanır',
                        ),
                        _AnalysisInfoRow(
                          icon: Icons.tips_and_updates_rounded,
                          title: 'Öneriler',
                          subtitle: 'CV iyileştirme önerileri sunulur',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              Navigator.pop(ctx);
                              final success = await ref
                                  .read(profilProvider.notifier)
                                  .useCredits(5);

                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'AI iş analizi başlatıldı! 5 kredi düşüldü.',
                                    ),
                                    backgroundColor: Color(0xFF2E7D32),
                                  ),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Analizi Başlat (5 Kredi)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

// ── AI CV Banner
class _AiCvBanner extends StatelessWidget {
  final bool isDark;
  final int remaining;
  const _AiCvBanner({required this.isDark, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AYLIK HAK: $remaining/2',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yapay Zeka ile\nCV Oluştur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Profesyonel CV\'niz dakikalar içinde hazır.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CV Analiz Kartı
class _CvAnalysisCard extends StatelessWidget {
  final bool isDark;
  final bool hasCv;
  const _CvAnalysisCard({required this.isDark, required this.hasCv});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (hasCv ? const Color(0xFF2E7D32) : Colors.orange)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasCv ? Icons.analytics_rounded : Icons.warning_amber_rounded,
              color: hasCv ? const Color(0xFF2E7D32) : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CV Analizi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  hasCv
                      ? 'AI analiz raporu oluşturmaya hazır'
                      : 'Analiz için önce CV yüklemelisiniz',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '5 Kredi',
              style: TextStyle(
                color: Color(0xFF1565C0),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Credit Badge Widget
class _CreditBadge extends StatelessWidget {
  final int credits;
  const _CreditBadge({required this.credits});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.stars_rounded,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            '$credits Kredi',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Action Card
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ── Job Card
class _JobCard extends StatelessWidget {
  final JobListingModel job;
  final bool isDark;
  const _JobCard({required this.job, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.business_center_rounded,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      job.company,
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Yeni',
                  style: TextStyle(
                    color: Color(0xFF2E7D32),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _JobTag(
                label: job.type == 'PUBLIC' ? 'Kamu' : 'Özel Sektör',
                color:
                    job.type == 'PUBLIC'
                        ? AppTheme.primaryColor
                        : const Color(0xFF7B1FA2),
              ),
              const SizedBox(width: 8),
              if (job.location != null)
                _JobTag(label: job.location!, color: Colors.grey),
              const Spacer(),
              if (job.deadline != null)
                Text(
                  '\${job.deadline!.day}.\${job.deadline!.month}.\${job.deadline!.year}',
                  style: TextStyle(fontSize: 10, color: Colors.grey[400]),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _JobTag extends StatelessWidget {
  final String label;
  final Color color;
  const _JobTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _AnalysisInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _AnalysisInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
