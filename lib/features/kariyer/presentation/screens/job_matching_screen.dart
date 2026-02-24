import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/app_toast.dart';
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

  List<JobListingModel> _filteredJobs(
    List<JobListingModel> jobs,
    String query,
  ) {
    if (query.isEmpty) return jobs;
    final q = query.toLowerCase();
    return jobs
        .where(
          (j) =>
              j.title.toLowerCase().contains(q) ||
              j.description.toLowerCase().contains(q) ||
              j.company.toLowerCase().contains(q),
        )
        .toList();
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

    // CV içeriğini hazırla — TÜM kayıtlı CV belgelerini topla
    final cvDocs =
        profil.documents
            .where((doc) => doc.category.toLowerCase() == 'cv')
            .toList();

    final StringBuffer cvBuffer = StringBuffer();

    // Kayıtlı CV belge içeriklerini ekle
    for (final doc in cvDocs) {
      if (doc.content != null && doc.content!.isNotEmpty) {
        cvBuffer.writeln('--- ${doc.name} ---');
        cvBuffer.writeln(doc.content!);
        cvBuffer.writeln();
      }
    }

    // Profil bilgilerini ekle (CV'de olmayan bilgiler için)
    cvBuffer.writeln('--- PROFİL BİLGİLERİ ---');
    if (profil.name != null) cvBuffer.writeln('Ad Soyad: ${profil.name}');
    if (profil.institution != null && profil.institution!.isNotEmpty) {
      cvBuffer.writeln('Kurum: ${profil.institution}');
    }
    if (profil.title != null && profil.title!.isNotEmpty) {
      cvBuffer.writeln('Unvan: ${profil.title}');
    }
    if (profil.city != null && profil.city!.isNotEmpty) {
      cvBuffer.writeln('Şehir: ${profil.city}');
    }
    if (profil.employmentType != null) {
      cvBuffer.writeln('Çalışma Durumu: ${profil.employmentType!.name}');
    }
    if (profil.surveyInterests.isNotEmpty) {
      cvBuffer.writeln(
        'İlgi Alanları/Beceriler: ${profil.surveyInterests.join(", ")}',
      );
    }

    final cvContent = cvBuffer.toString().trim();

    if (cvContent.isEmpty || cvDocs.isEmpty) {
      if (context.mounted) {
        AppToast.warning(
          context,
          'Lütfen önce CV yükleyin veya AI ile CV oluşturun.',
        );
      }
      return;
    }

    // Mevcut ilanların özetini hazırla — TÜM ilanlar
    final jobsSummary = jobs
        .map((j) {
          final desc =
              j.description.length > 300
                  ? j.description.substring(0, 300)
                  : j.description;
          final reqs = j.requirements ?? 'Belirtilmedi';
          return '- İLAN#${j.id}: "${j.title}" | ${j.company} | Gereksinimler: $reqs | Açıklama: $desc';
        })
        .join('\n');

    // Kullanıcının şehri
    final userCity = profil.city ?? profil.surveyCity ?? '';

    // Veriyi (CV + İlanlar) context olarak gönder (system prompt'a eklenir)
    final dataContext = '''
KULLANICININ CV BİLGİLERİ:
$cvContent

KULLANICININ YAŞADIĞI ŞEHİR: ${userCity.isNotEmpty ? userCity : 'Belirtilmedi'}

SİSTEMDEMİZDEKİ İLANLAR:
$jobsSummary
''';

    // Analiz talimatlarını message olarak gönder
    final matchingMessage = '''
SEN UZMAN BİR KARİYER DANIŞMANISIN. Yukarıdaki CV bilgileri ve ilanları analiz et.

KRİTİK EŞLEME KURALLARI:
1. SADECE kullanıcının eğitimi, unvanı, mesleği ve gerçek yetkinlikleriyle ÖRTÜŞEN ilanları UYGUN işaretle.
2. Kullanıcının meslek alanıyla ALAKASIZ ilanları KESİNLİKLE önerme:
   - Güvenlikçiye mühendislik ilanı ÖNERME
   - Öğretmene şoförlük ilanı ÖNERME
   - Muhasebeciye hemşirelik ilanı ÖNERME
3. Eğitim seviyesi ve alanı EN ÖNEMLİ kriter (%35 ağırlık).
4. Liyakat öncelikli — kullanıcının gerçekten yapabileceği işleri öner.
5. Alternatif ilanlar bile kullanıcının sektörüyle YAKIN olmalı.
6. ŞEHİR KURALI: Özel sektör ilanlarında kullanıcının yaşadığı şehirdeki ilanlara +5 puan bonusu ver. KAMU ilanlarında şehir önemli DEĞİL, kamu ilanları tüm Türkiye için geçerlidir.

PUANLAMA: EĞİTİM %35, DENEYİM %25, BECERİ %20, UYUM %20
- %60+ = UYGUN (max 7)
- %40-59 = ALTERNATİF (sadece yakın alan)
- %40 altı = LİSTELEME

ÇIKTI FORMATI (SADECE bu format, başka hiçbir şey yazma):
İLAN#[id] %[genel_skor] [UYGUN veya ALTERNATİF]
EĞİTİM:%[skor] DENEYİM:%[skor] BECERİ:%[skor] UYUM:%[skor]
''';

    ref
        .read(jobMatchingProvider.notifier)
        .startJobMatchingWithContext(matchingMessage, dataContext);
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
            title: '7 Uygun + 3 Alternatif',
            subtitle:
                'En uyumlu 7 ilan ve 3 alternatif ilan detaylı grafiklerle gösterilecek',
            isDark: isDark,
          ),
          _AnalysisInfoRow(
            icon: Icons.touch_app_rounded,
            title: 'Detaylı Grafikler',
            subtitle:
                'Eğitim, deneyim, beceri ve uyum puanları ayrı ayrı gösterilecek',
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
                  // Arama alanı
                  TextField(
                    onChanged:
                        (val) => ref
                            .read(jobMatchingProvider.notifier)
                            .setSearchQuery(val),
                    decoration: InputDecoration(
                      hintText: 'İlan ara (başlık veya içerik)...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade400,
                        fontSize: 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: Colors.grey.shade400,
                        size: 20,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.white10 : Colors.grey.shade100,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._filteredJobs(jobs, state.searchQuery).map((job) {
                    final score = ref
                        .read(jobMatchingProvider.notifier)
                        .parseScoreForJob(job.id);
                    final type = ref
                        .read(jobMatchingProvider.notifier)
                        .parseTypeForJob(job.id);
                    final subScores = ref
                        .read(jobMatchingProvider.notifier)
                        .parseSubScoresForJob(job.id);

                    // Analiz bittiyse ve skor yoksa bu ilanı gösterme
                    if (score == null) {
                      return const SizedBox.shrink();
                    }

                    final isUygun = type == 'UYGUN';

                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isUygun
                                  ? const Color(
                                    0xFF2E7D32,
                                  ).withValues(alpha: 0.4)
                                  : (isDark
                                      ? Colors.white12
                                      : Colors.grey.shade200),
                          width: isUygun ? 1.5 : 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                isUygun
                                    ? const Color(
                                      0xFF2E7D32,
                                    ).withValues(alpha: 0.08)
                                    : Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Başlık + Etiket + Skor
                          Row(
                            children: [
                              if (type != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  margin: const EdgeInsets.only(right: 8),
                                  decoration: BoxDecoration(
                                    color:
                                        isUygun
                                            ? const Color(
                                              0xFF2E7D32,
                                            ).withValues(alpha: 0.12)
                                            : const Color(
                                              0xFFF57C00,
                                            ).withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    type,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isUygun
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFF57C00),
                                    ),
                                  ),
                                ),
                              ],
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
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
                                    const SizedBox(height: 2),
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
                          ),

                          // Genel uyumluluk bar
                          const SizedBox(height: 14),
                          _buildScoreBar(
                            label: 'Genel Uyumluluk',
                            score: score,
                            isDark: isDark,
                          ),

                          // Alt kategori grafikleri
                          if (subScores != null) ...[
                            const SizedBox(height: 8),
                            _buildScoreBar(
                              label: 'Eğitim',
                              score: subScores['egitim'] ?? 0,
                              isDark: isDark,
                              color: const Color(0xFF1565C0),
                            ),
                            const SizedBox(height: 4),
                            _buildScoreBar(
                              label: 'Deneyim',
                              score: subScores['deneyim'] ?? 0,
                              isDark: isDark,
                              color: const Color(0xFF7B1FA2),
                            ),
                            const SizedBox(height: 4),
                            _buildScoreBar(
                              label: 'Beceri',
                              score: subScores['beceri'] ?? 0,
                              isDark: isDark,
                              color: const Color(0xFFF57C00),
                            ),
                            const SizedBox(height: 4),
                            _buildScoreBar(
                              label: 'Uyum',
                              score: subScores['uyum'] ?? 0,
                              isDark: isDark,
                              color: const Color(0xFF2E7D32),
                            ),
                          ],

                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: OutlinedButton.icon(
                                    onPressed:
                                        () => context.push(
                                          '/job-detail',
                                          extra: job,
                                        ),
                                    icon: const Icon(
                                      Icons.visibility_rounded,
                                      size: 18,
                                    ),
                                    label: const Text(
                                      'İlanı İncele',
                                      style: TextStyle(
                                        fontSize: 12,
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
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: SizedBox(
                                  height: 40,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final url =
                                          job.applicationUrl ?? job.sourceUrl;
                                      if (url != null && url.isNotEmpty) {
                                        final uri = Uri.parse(url);
                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(
                                            uri,
                                            mode:
                                                LaunchMode.externalApplication,
                                          );
                                          return;
                                        }
                                      }
                                      // Fallback: kamulogkariyer.com/jobs
                                      if (context.mounted) {
                                        final fallbackUri = Uri.parse(
                                          'https://kamulogkariyer.com/jobs',
                                        );
                                        await launchUrl(
                                          fallbackUri,
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isUygun
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFF57C00),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      elevation: 1,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                    ),
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        isUygun
                                            ? '✅ Başvur'
                                            : '📋 Yine de Başvur',
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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

  /// Detaylı skor bar widget
  Widget _buildScoreBar({
    required String label,
    required int score,
    required bool isDark,
    Color? color,
  }) {
    final barColor = color ?? _scoreColor(score);
    return Row(
      children: [
        SizedBox(
          width: 70,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 6,
              backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(barColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '%$score',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: barColor,
            ),
          ),
        ),
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
