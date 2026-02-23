import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/jobs_provider.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:kamulog_superapp/features/ai/data/models/ai_message_model.dart';

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
                      ? 'Aylık 1 kullanımdan ${profil.remainingAiCvCount} hak kaldı'
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
              icon: Icons.hub_rounded,
              title: 'AI İş Eşleştirme',
              subtitle: '4 Uygun + 2 Alternatif İlan Önerisi',
              color: const Color(0xFFF57C00),
              onTap: () => _showJobMatching(context, ref),
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

  void _showJobMatching(BuildContext context, WidgetRef ref) {
    final profil = ref.read(profilProvider);

    if (!profil.hasCv) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'İş Eşleştirme için önce Belgelerim sayfasından bir CV yüklemelisiniz.',
          ),
          backgroundColor: Colors.orange,
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
                          color: const Color(0xFFF57C00).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.hub_rounded,
                          size: 32,
                          color: Color(0xFFF57C00),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AI İş Eşleştirme',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'CV\'nizi analiz ederek en uygun 4 iş ve alternatif 2 kariyer yolu önerir.',
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
                          icon: Icons.stars_rounded,
                          title: 'Uygun İşler',
                          subtitle: 'CV\'nize en uygun 4 ilan önerilir',
                        ),
                        _AnalysisInfoRow(
                          icon: Icons.alt_route_rounded,
                          title: 'Alternatif Kariyer',
                          subtitle: '2 Adet ikincil alternatif yol önerilir',
                        ),
                        _AnalysisInfoRow(
                          icon: Icons.comment_rounded,
                          title: 'AI Yorumu',
                          subtitle:
                              'Her öneri detaylı açıklama ve yorum içerir',
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final pNotifier = ref.read(
                                profilProvider.notifier,
                              );
                              final hasCredits = profil.hasEnoughCredits(2);

                              if (!hasCredits) {
                                Navigator.pop(ctx);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Bu işlem için yeterli jetonunuz bulunmuyor (2 Jeton gerekli).',
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                                return;
                              }

                              // Jetonu düş
                              await pNotifier.decreaseCredits(2);

                              // CV içeriğini hazırla
                              final cvDoc = profil.documents
                                  .cast<DocumentInfo?>()
                                  .firstWhere(
                                    (doc) =>
                                        doc != null &&
                                        doc.category.toLowerCase() == 'cv',
                                    orElse: () => null,
                                  );

                              String cvContent;
                              if (cvDoc != null &&
                                  cvDoc.content != null &&
                                  cvDoc.content!.isNotEmpty) {
                                cvContent = cvDoc.content!;
                              } else {
                                cvContent =
                                    'Ad: ${profil.name ?? "Belirtilmedi"}, Kurum: ${profil.effectiveInstitution}, Unvan: ${profil.title ?? "Belirtilmedi"}, Beceriler: ${profil.surveyInterests.join(", ")}';
                              }

                              // AI’ya iş eşleştirme prompt'u gönder
                              final matchingPrompt = '''
SEN BİR KARİYER DANIŞMANISIN. Aşağıdaki CV bilgilerine dayanarak bana İş önerilerinde bulun.

KULLANICININ CV BİLGİLERİ:
$cvContent

GÖREVİN:
1. **4 UYGUN İŞ İLANI**: CV'ye en uygun 4 iş ilanını öner. Her biri için:
   - 💼 **Pozisyon Adı**
   - 🏢 **Kurum/Şirket** (kamu veya özel sektör olabilir)
   - 📊 **Uyumluluk Yüzdesi** (0-100)
   - 💡 **Neden Uygun:** (kısa açıklama)

2. **2 ALTERNATİF KARİYER YOLU**: CV'nin güçlü yönlerini değerlendirerek 2 alternatif kariyer önerisi yap. Her biri için:
   - 🔄 **Alternatif Pozisyon**
   - 🏢 **Tipik Kurum**
   - ✨ **Neden Alternatif:** (neden bu yönü düşünmeli, hangi becerileri kullanabilir)

3. **GENEL DEĞERLENDİRME**: Kullanıcının kariyer profili hakkında kısa bir genel değerlendirme paragrafı.

Yanıtını Türkçe ver. Gerçekçi ve özgün önerilerde bulun.
''';

                              ref
                                  .read(aiChatProvider.notifier)
                                  .sendMessage(
                                    'CV\'me en uygun iş ilanlarını bul ve alternatif kariyer yolları öner.',
                                    context: matchingPrompt,
                                  );

                              if (context.mounted) Navigator.pop(ctx);
                              if (context.mounted) {
                                // Sonucu kariyer sayfasında modal ile göster
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  isDismissible: false,
                                  enableDrag: false,
                                  backgroundColor: Colors.transparent,
                                  builder:
                                      (_) => const _JobMatchingResultSheet(),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            label: Text(
                              profil.isPremium
                                  ? 'Eşleştirmeyi Başlat (Sınırsız)'
                                  : 'Eşleştirmeyi Başlat (2 Jeton)',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF57C00),
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
              '2 Jeton',
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
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/job-detail', extra: job),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
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
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
                      Flexible(
                        child: Text(
                          '${job.deadline!.day}.${job.deadline!.month}.${job.deadline!.year}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
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

/// AI İş Eşleştirme sonuçlarını gösteren modal bottom sheet
class _JobMatchingResultSheet extends ConsumerWidget {
  const _JobMatchingResultSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatState = ref.watch(aiChatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final assistantMessages =
        chatState.messages.where((m) => m.role == AiRole.assistant).toList();
    final lastAssistantMsg =
        assistantMessages.isNotEmpty ? assistantMessages.last : null;

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
                    color: const Color(0xFFF57C00).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: Color(0xFFF57C00),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI İş Eşleştirme Sonuçları',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '4 uygun + 2 alternatif öneri',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),
          const Divider(height: 1),

          // Sonuçlar
          Expanded(
            child:
                chatState.isLoading && lastAssistantMsg == null
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: const Color(0xFFF57C00),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'CV\'nize uygun işler aranıyor...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    )
                    : lastAssistantMsg != null
                    ? SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Mesaj içeriği
                          SelectableText(
                            lastAssistantMsg.content,
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (chatState.isLoading) ...[
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: const Color(0xFFF57C00),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Eşleştirme devam ediyor...',
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
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 40,
                            height: 40,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: const Color(0xFFF57C00),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'CV\'nize uygun işler aranıyor...',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
          ),

          // Alt buton
          Container(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed:
                      chatState.isLoading
                          ? null
                          : () {
                            ref.read(aiChatProvider.notifier).newConversation();
                            Navigator.pop(context);
                          },
                  icon: const Icon(Icons.check_rounded, color: Colors.white),
                  label: const Text(
                    'Kapat',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF57C00),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
