import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Kariyer modülü — AI CV oluşturma ve iş analizi
/// Ayrı modül: features/kariyer/ — ileride ayrı API/AI entegrasyonu
class CareerScreen extends StatelessWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Kariyer'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AI CV Oluşturucu Banner
            _AiCvBanner(isDark: isDark),
            const SizedBox(height: 20),

            // ── CV Analizi
            _CvAnalysisCard(isDark: isDark),
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
              subtitle: 'Bilgilerinizle profesyonel CV oluşturun',
              color: const Color(0xFF1565C0),
              onTap: () => _showAiCvBuilder(context),
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
              subtitle: 'CV\'niz ile eşleşen ilanları AI analiz etsin',
              color: const Color(0xFF2E7D32),
              onTap: () => _showJobAnalysis(context),
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
            ..._sampleJobs.map(
              (job) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: _JobCard(job: job, isDark: isDark),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showAiCvBuilder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            height: MediaQuery.of(ctx).size.height * 0.85,
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
                          gradient: AppTheme.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'AI CV Oluşturucu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Yapay zeka, bilgilerinize göre profesyonel bir CV hazırlayacak.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _CvStepItem(
                          step: 1,
                          title: 'Kişisel Bilgiler',
                          subtitle: 'Profil bilgileriniz otomatik doldurulacak',
                          icon: Icons.person_rounded,
                          isCompleted: true,
                        ),
                        _CvStepItem(
                          step: 2,
                          title: 'Eğitim Bilgileri',
                          subtitle: 'Üniversite, lise ve sertifikalar',
                          icon: Icons.school_rounded,
                          isCompleted: false,
                        ),
                        _CvStepItem(
                          step: 3,
                          title: 'İş Deneyimi',
                          subtitle: 'Önceki ve mevcut iş deneyimleriniz',
                          icon: Icons.work_rounded,
                          isCompleted: false,
                        ),
                        _CvStepItem(
                          step: 4,
                          title: 'Beceriler & Yetkinlikler',
                          subtitle: 'AI sizin için öneriler sunacak',
                          icon: Icons.psychology_rounded,
                          isCompleted: false,
                        ),
                        _CvStepItem(
                          step: 5,
                          title: 'AI ile Optimize Et',
                          subtitle:
                              'CV\'niz AI tarafından düzenlenir ve PDF olarak hazırlanır',
                          icon: Icons.auto_fix_high_rounded,
                          isCompleted: false,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'AI CV oluşturma başlatıldı — API entegrasyonu gerekli',
                                  ),
                                  backgroundColor: Color(0xFF1565C0),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'CV Oluşturmaya Başla',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
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
          ),
    );
  }

  void _showJobAnalysis(BuildContext context) {
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
                        'Yapay zeka, CV\'nizi analiz ederek en uygun iş ilanlarını bulur.',
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
                          title: 'CV Gerekli',
                          subtitle:
                              'Önce Belgelerim\'den CV yüklemeniz gerekir',
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
                            onPressed: () {
                              Navigator.pop(ctx);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'AI iş analizi başlatıldı — API entegrasyonu gerekli',
                                  ),
                                  backgroundColor: Color(0xFF2E7D32),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.play_arrow_rounded,
                              color: Colors.white,
                            ),
                            label: const Text(
                              'Analizi Başlat',
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
  const _AiCvBanner({required this.isDark});

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
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                      SizedBox(width: 4),
                      Text(
                        'AI POWERED',
                        style: TextStyle(
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
  const _CvAnalysisCard({required this.isDark});

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
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.analytics_rounded,
              color: Color(0xFF2E7D32),
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
                  'CV\'nizi yüklediğinizde AI analiz raporu oluşturur',
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
              'Premium',
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
  final _JobItem job;
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
                  color: job.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(job.icon, color: job.color, size: 20),
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
                      job.institution,
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
                child: Text(
                  '%${job.matchScore}',
                  style: const TextStyle(
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
              _JobTag(label: job.type, color: job.color),
              const SizedBox(width: 8),
              _JobTag(label: job.location, color: Colors.grey),
              const Spacer(),
              Text(
                job.deadline,
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

class _CvStepItem extends StatelessWidget {
  final int step;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isCompleted;

  const _CvStepItem({
    required this.step,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color:
                  isCompleted
                      ? const Color(0xFF2E7D32).withValues(alpha: 0.1)
                      : Colors.grey.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child:
                  isCompleted
                      ? const Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: Color(0xFF2E7D32),
                      )
                      : Text(
                        '$step',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.grey[600],
                        ),
                      ),
            ),
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
          Icon(
            isCompleted ? Icons.check_circle : Icons.chevron_right_rounded,
            size: 20,
            color: isCompleted ? const Color(0xFF2E7D32) : Colors.grey[400],
          ),
        ],
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

// ── Data Models
class _JobItem {
  final String title;
  final String institution;
  final String type;
  final String location;
  final String deadline;
  final int matchScore;
  final IconData icon;
  final Color color;

  const _JobItem({
    required this.title,
    required this.institution,
    required this.type,
    required this.location,
    required this.deadline,
    required this.matchScore,
    required this.icon,
    required this.color,
  });
}

const _sampleJobs = [
  _JobItem(
    title: 'Bilgi İşlem Uzmanı',
    institution: 'Hazine ve Maliye Bakanlığı',
    type: 'Memur',
    location: 'Ankara',
    deadline: 'Son 5 gün',
    matchScore: 92,
    icon: Icons.computer_rounded,
    color: Color(0xFF1565C0),
  ),
  _JobItem(
    title: 'İdari Personel',
    institution: 'Milli Eğitim Bakanlığı',
    type: 'Sözleşmeli',
    location: 'İstanbul',
    deadline: 'Son 12 gün',
    matchScore: 78,
    icon: Icons.school_rounded,
    color: Color(0xFFE65100),
  ),
  _JobItem(
    title: 'Muhasebe Uzmanı',
    institution: 'Sosyal Güvenlik Kurumu',
    type: 'Memur',
    location: 'Ankara',
    deadline: 'Son 20 gün',
    matchScore: 85,
    icon: Icons.calculate_rounded,
    color: Color(0xFF2E7D32),
  ),
  _JobItem(
    title: 'Hukuk Müşaviri',
    institution: 'Adalet Bakanlığı',
    type: 'Memur',
    location: 'Ankara',
    deadline: 'Son 8 gün',
    matchScore: 71,
    icon: Icons.gavel_rounded,
    color: Color(0xFF7B1FA2),
  ),
];
