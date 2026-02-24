import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:confetti/confetti.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/app_toast.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:uuid/uuid.dart';

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
      AppToast.warning(
        context,
        'Analiz için önce bir CV oluşturmanız veya yüklemeniz gerekiyor.',
      );
      return;
    }

    // Jeton kontrolü
    if (!profil.hasEnoughCredits(2)) {
      AppToast.error(
        context,
        'Bu işlem için yeterli jetonunuz bulunmuyor (2 Jeton gerekli).',
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
          'Ad: ${profil.name ?? "Belirtilmedi"}, Kurum: ${profil.institution}, Unvan: ${profil.title ?? "Belirtilmedi"}, Beceriler: ${profil.surveyInterests.join(", ")}';
    }

    if (!context.mounted) return;

    // Analiz sonucunu bottom sheet ile göster
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _AnalysisBottomSheet(job: job, cvContent: cvContent),
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

/// Tekli ilan AI analizi bottom sheet — detaylı grafiklerle
class _AnalysisBottomSheet extends ConsumerStatefulWidget {
  final JobListingModel job;
  final String cvContent;

  const _AnalysisBottomSheet({required this.job, required this.cvContent});

  @override
  ConsumerState<_AnalysisBottomSheet> createState() =>
      _AnalysisBottomSheetState();
}

class _AnalysisBottomSheetState extends ConsumerState<_AnalysisBottomSheet> {
  String _analysisResult = '';
  bool _isLoading = true;
  StreamSubscription? _sub;
  late ConfettiController _confettiController;
  bool _confettiFired = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
    _startAnalysis();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _confettiController.dispose();
    super.dispose();
  }

  void _startAnalysis() {
    final repository = ref.read(aiRepositoryProvider);
    final conversationId = const Uuid().v4();

    final prompt = '''
SEN BİR İK UZMANSIN. Aşağıdaki iş ilanını kullanıcının CV'si ile DETAYLI karşılaştır.

İLAN BİLGİLERİ:
Başlık: ${widget.job.title}
Şirket: ${widget.job.company}
Tanım: ${widget.job.description}
Gereksinimler: ${widget.job.requirements ?? 'Belirtilmedi'}

KULLANICININ CV'Sİ:
${widget.cvContent}

GÖREVİN:
Aşağıdaki FORMATTA yanıt ver (başka bir şey yazma):

GENEL:%[skor]
EĞİTİM:%[skor]
DENEYİM:%[skor]
BECERİ:%[skor]
UYUM:%[skor]
---
[2-3 cümle çok kısa gerekçe ve ilan hakkında bilgi. Güçlü ve zayıf yönleri tek satırda belirt.]
''';

    _sub = repository
        .sendMessage(
          conversationId: conversationId,
          message: 'Bu ilan için detaylı CV analizi yap.',
          context: prompt,
          history: [],
        )
        .listen(
          (chunk) {
            if (mounted) {
              setState(() {
                _analysisResult += chunk;
              });
              _checkConfetti();
            }
          },
          onDone: () {
            if (mounted) {
              setState(() {
                _isLoading = false;
              });
              _checkConfetti();
            }
          },
          onError: (error) {
            if (mounted) {
              setState(() {
                _isLoading = false;
                _analysisResult += '\n\n[Hata oluştu]';
              });
            }
          },
        );
  }

  void _checkConfetti() {
    if (_confettiFired) return;
    final score = _parseScore('GENEL');
    if (score >= 60) {
      _confettiFired = true;
      _confettiController.play();
    }
  }

  int _parseScore(String label) {
    final match = RegExp('$label:%?(\\d+)').firstMatch(_analysisResult);
    if (match != null) return int.tryParse(match.group(1)!) ?? 0;
    return 0;
  }

  String _parseRationale() {
    final parts = _analysisResult.split('---');
    if (parts.length > 1) return parts.sublist(1).join('---').trim();
    return '';
  }

  Color _scoreColor(int s) {
    if (s >= 70) return const Color(0xFF2E7D32);
    if (s >= 40) return const Color(0xFFF57C00);
    return const Color(0xFFD32F2F);
  }

  bool get _isUygun => _parseScore('GENEL') >= 60;

  void _applyToJob() async {
    final url = widget.job.applicationUrl;
    if (url != null && url.isNotEmpty) {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } else if (mounted) {
      AppToast.info(
        context,
        'Başvuru bağlantısı bulunamadı. İlanı inceleyerek başvurabilirsiniz.',
      );
    }
  }

  Widget _bar(String label, int score, Color color, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
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
                minHeight: 8,
                backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 36,
            child: Text(
              '%$score',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final genelScore = _parseScore('GENEL');
    final egitimScore = _parseScore('EĞİTİM');
    final deneyimScore = _parseScore('DENEYİM');
    final beceriScore = _parseScore('BECERİ');
    final uyumScore = _parseScore('UYUM');
    final rationale = _parseRationale();
    final hasScores = genelScore > 0;

    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(top: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.analytics_rounded,
                        color: AppTheme.primaryColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'AI İlan Analizi',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            widget.job.title,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (hasScores)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _scoreColor(genelScore).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '%$genelScore',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: _scoreColor(genelScore),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasScores) ...[
                        Text(
                          'Uyumluluk Grafikleri',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _bar(
                          'Genel',
                          genelScore,
                          _scoreColor(genelScore),
                          isDark,
                        ),
                        _bar(
                          'Eğitim',
                          egitimScore,
                          const Color(0xFF1565C0),
                          isDark,
                        ),
                        _bar(
                          'Deneyim',
                          deneyimScore,
                          const Color(0xFF7B1FA2),
                          isDark,
                        ),
                        _bar(
                          'Beceri',
                          beceriScore,
                          const Color(0xFFF57C00),
                          isDark,
                        ),
                        _bar(
                          'Uyum',
                          uyumScore,
                          const Color(0xFF2E7D32),
                          isDark,
                        ),
                        const SizedBox(height: 16),
                      ],
                      if (rationale.isNotEmpty) ...[
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color:
                                isDark
                                    ? Colors.white.withValues(alpha: 0.05)
                                    : Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isDark
                                      ? Colors.white12
                                      : Colors.grey.shade200,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline_rounded,
                                    size: 16,
                                    color:
                                        isDark
                                            ? Colors.amber[300]
                                            : Colors.amber[700],
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Değerlendirme',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color:
                                          isDark
                                              ? Colors.amber[300]
                                              : Colors.amber[700],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              SelectableText(
                                rationale,
                                style: TextStyle(
                                  fontSize: 13,
                                  height: 1.5,
                                  color:
                                      isDark ? Colors.white70 : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (!hasScores &&
                          _analysisResult.isNotEmpty &&
                          !_isLoading) ...[
                        SelectableText(
                          _analysisResult,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.6,
                            color: isDark ? Colors.white70 : Colors.black87,
                          ),
                        ),
                      ],
                      if (_isLoading) ...[
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Analiz ediliyor...',
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
              ),
              // Buttons
              Container(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                child: SafeArea(
                  child:
                      _isLoading
                          ? SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: const Text(
                                'Analiz ediliyor...',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          )
                          : Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor:
                                          isDark
                                              ? Colors.white70
                                              : Colors.grey[700],
                                      side: BorderSide(
                                        color:
                                            isDark
                                                ? Colors.white24
                                                : Colors.grey.shade300,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                    child: const Text(
                                      'Kapat',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                flex: 2,
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton.icon(
                                    onPressed: _applyToJob,
                                    icon: Icon(
                                      _isUygun
                                          ? Icons.check_circle_rounded
                                          : Icons.open_in_new_rounded,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    label: Text(
                                      _isUygun
                                          ? 'Hemen Başvur 🎉'
                                          : 'Yine de Başvur',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          _isUygun
                                              ? const Color(0xFF2E7D32)
                                              : const Color(0xFFF57C00),
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
                ),
              ),
            ],
          ),
        ),
        // Confetti
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Color(0xFF2E7D32),
              Color(0xFF4CAF50),
              Color(0xFF81C784),
              Color(0xFFFFD700),
              Color(0xFF1565C0),
            ],
            numberOfParticles: 25,
            maxBlastForce: 20,
            minBlastForce: 8,
            gravity: 0.2,
          ),
        ),
      ],
    );
  }
}

