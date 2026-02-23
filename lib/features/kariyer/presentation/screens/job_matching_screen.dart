import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/job_matching_provider.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/jobs_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

class JobMatchingScreen extends ConsumerWidget {
  const JobMatchingScreen({super.key});

  Color _scoreColor(int score) {
    if (score >= 70) return const Color(0xFF2E7D32);
    if (score >= 40) return const Color(0xFFF57C00);
    return const Color(0xFFD32F2F);
  }

  void _startMatching(
    BuildContext context,
    WidgetRef ref,
    List<JobListingModel> jobs,
  ) async {
    final profil = ref.read(profilProvider);
    final pNotifier = ref.read(profilProvider.notifier);
    final hasCredits = profil.hasEnoughCredits(2);

    if (!hasCredits) {
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
    await pNotifier.decreaseCredits(2);

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
          'Ad: ${profil.name ?? "Belirtilmedi"}, Kurum: ${profil.institution}, Unvan: ${profil.title ?? "Belirtilmedi"}, Beceriler: ${profil.surveyInterests.join(", ")}';
    }

    // Mevcut ilanların özetini hazırla
    final jobsSummary = jobs
        .take(10)
        .map((j) {
          return '- İLAN#${j.id}: "${j.title}" | ${j.company} | ${j.description.length > 150 ? j.description.substring(0, 150) : j.description}';
        })
        .join('\n');

    // AI'ya prompt: sadece puan ve kategori, yorum yok
    final matchingPrompt = '''
SEN BİR KARİYER DANIŞMANISIN. Aşağıdaki CV ile SİSTEMDEKİ mevcut iş ilanlarını karşılaştır.

KULLANICININ CV BİLGİLERİ:
$cvContent

SİSTEMDEKİ MEVCUT İLANLAR:
$jobsSummary

GÖREVİN:
Her ilan için SADECE aşağıdaki formatta tek satır yaz. Yorum veya açıklama EKLEME:

İLAN#[kod] %[skor] [UYGUN veya ALTERNATİF]

En uygun 5 ilana UYGUN, geri kalan 2'sine ALTERNATİF etiketini ver.
Skor 0-100 arası olmalı. Başka hiçbir şey yazma.
''';

    ref.read(jobMatchingProvider.notifier).startJobMatching(matchingPrompt);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(jobMatchingProvider);
    final jobsState = ref.watch(jobsProvider);
    final profil = ref.watch(profilProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final jobs = jobsState.jobs.valueOrNull ?? [];

    return Scaffold(
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'AI İş Eşleştirme',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppTheme.cardDark : Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: isDark ? Colors.white : AppTheme.primaryColor,
          ),
          onPressed: () {
            ref.read(jobMatchingProvider.notifier).newConversation();
            context.pop();
          },
        ),
      ),
      body:
          !state.isMatchingStarted
              ? _buildIntroductionPhase(context, ref, jobs, profil, isDark)
              : _buildResultsPhase(context, ref, state, jobs, isDark),
    );
  }

  Widget _buildIntroductionPhase(
    BuildContext context,
    WidgetRef ref,
    List<JobListingModel> jobs,
    ProfilState profil,
    bool isDark,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF57C00).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Icon(
              Icons.hub_rounded,
              size: 40,
              color: Color(0xFFF57C00),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Kariyer Fırsatlarınızı Keşfedin',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Sistemdeki ${jobs.length} aktif iş ilanını CV\'niz ile yapay zeka tarafından karşılaştırıp sizin için en uygun olanları sıralıyoruz.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 40),
          _AnalysisInfoRow(
            icon: Icons.description_rounded,
            title: 'CV Kontrol Edildi',
            subtitle:
                'Analiz için sistemdeki mevcut CV içeriğiniz kullanılacak',
            isDark: isDark,
          ),
          _AnalysisInfoRow(
            icon: Icons.bar_chart_rounded,
            title: '5 Uygun + 2 Alternatif',
            subtitle:
                'En uygun 5 ilan ve 2 alternatif ilan grafikleriyle gösterilecek',
            isDark: isDark,
          ),
          _AnalysisInfoRow(
            icon: Icons.touch_app_rounded,
            title: 'Detay ve Başvuru',
            subtitle: 'Her ilanı inceleyip detaylı analiz yapabileceksiniz',
            isDark: isDark,
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _startMatching(context, ref, jobs),
              icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              label: const Text(
                'Eşleştirmeyi Başlat (2 Jeton)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF57C00),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                shadowColor: const Color(0xFFF57C00).withValues(alpha: 0.4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsPhase(
    BuildContext context,
    WidgetRef ref,
    JobMatchingState state,
    List<JobListingModel> jobs,
    bool isDark,
  ) {
    return Column(
      children: [
        if (state.isLoading && state.aiContent.isEmpty) ...[
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      color: Color(0xFFF57C00),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'İlanlar analiz ediliyor...',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ] else ...[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...jobs.take(10).map((job) {
                    final score = ref
                        .read(jobMatchingProvider.notifier)
                        .parseScoreForJob(job.id);
                    final type = ref
                        .read(jobMatchingProvider.notifier)
                        .parseTypeForJob(job.id);

                    if (score == null && state.isLoading) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              score != null && score >= 70
                                  ? const Color(
                                    0xFF2E7D32,
                                  ).withValues(alpha: 0.3)
                                  : (isDark
                                      ? Colors.white12
                                      : Colors.grey.shade200),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        if (type != null) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 3,
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  type == 'UYGUN'
                                                      ? const Color(
                                                        0xFF2E7D32,
                                                      ).withValues(alpha: 0.1)
                                                      : const Color(
                                                        0xFFF57C00,
                                                      ).withValues(alpha: 0.1),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              type,
                                              style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w700,
                                                color:
                                                    type == 'UYGUN'
                                                        ? const Color(
                                                          0xFF2E7D32,
                                                        )
                                                        : const Color(
                                                          0xFFF57C00,
                                                        ),
                                              ),
                                            ),
                                          ),
                                        ],
                                        Expanded(
                                          child: Text(
                                            job.title,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  isDark
                                                      ? Colors.white
                                                      : Colors.black87,
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${job.company} • ${(job.location ?? '')}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (score != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: _scoreColor(
                                      score,
                                    ).withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '%$score',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: _scoreColor(score),
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          if (score != null) ...[
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: score / 100,
                                minHeight: 8,
                                backgroundColor:
                                    isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  _scoreColor(score),
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            height: 40,
                            child: OutlinedButton.icon(
                              onPressed:
                                  () => context.push('/job-detail', extra: job),
                              icon: const Icon(
                                Icons.visibility_rounded,
                                size: 18,
                              ),
                              label: const Text(
                                'İlanı İncele & Başvur',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppTheme.primaryColor,
                                side: BorderSide(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  if (state.isLoading) ...[
                    const SizedBox(height: 24),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFF57C00),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Sonuçlar aktarılıyor...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _AnalysisInfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _AnalysisInfoRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
