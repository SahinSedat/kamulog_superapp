import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/providers/expert_marketplace_provider.dart';

/// AI Talep Asistanı + IAP Ödeme ekranı
class ExpertRequestScreen extends ConsumerStatefulWidget {
  final String expertId;
  final String packageId;
  const ExpertRequestScreen({
    super.key,
    required this.expertId,
    required this.packageId,
  });

  @override
  ConsumerState<ExpertRequestScreen> createState() =>
      _ExpertRequestScreenState();
}

class _ExpertRequestScreenState extends ConsumerState<ExpertRequestScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();

  // AI Asistan durumları
  bool _isAnalyzing = false;
  bool _briefingReady = false;
  String _aiSummary = '';
  String _aiBriefing = '';
  List<String> _aiKeyPoints = [];
  List<String> _aiFollowUps = [];
  bool _purchaseComplete = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notifier = ref.read(expertMarketplaceProvider.notifier);
    final expert = notifier.getExpertById(widget.expertId);

    if (expert == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Uzman bulunamadı')),
      );
    }

    final package = expert.packages.firstWhere(
      (p) => p.id == widget.packageId,
      orElse: () => expert.packages.first,
    );
    final catInfo = expert.categoryInfo;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('AI Talep Asistanı'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Uzman + Paket Özeti
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: catInfo.color.withValues(alpha: 0.15),
                    child: Text(
                      expert.name.split(' ').map((w) => w[0]).take(2).join(),
                      style: TextStyle(
                        color: catInfo.color,
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          expert.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${package.name} • ${package.priceLabel}',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark ? Colors.white54 : Colors.grey[600],
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
                      color:
                          package.isFree
                              ? AppTheme.successColor.withValues(alpha: 0.1)
                              : AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      package.priceLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color:
                            package.isFree
                                ? AppTheme.successColor
                                : AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── AI Asistan Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome, color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI Talep Asistanı',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Sorununuzu anlatın, AI profesyonel bir brifing hazırlasın.',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ── Soru Girişi
            const Text(
              'Sorununuzu Anlatın',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              maxLines: 5,
              enabled: !_briefingReady,
              decoration: InputDecoration(
                hintText:
                    'Detaylı anlatın... Örn: "3 yıldır çalıştığım kurumda tayin hakkımı kullanmak istiyorum ama..."',
                hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13),
                filled: true,
                fillColor:
                    isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : Colors.grey.shade50,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide(
                    color: isDark ? Colors.white12 : Colors.grey.shade300,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(
                    color: Color(0xFF6366F1),
                    width: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ── AI Analiz Butonu
            if (!_briefingReady)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isAnalyzing ? null : _analyzeRequest,
                  icon:
                      _isAnalyzing
                          ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.auto_awesome, size: 18),
                  label: Text(
                    _isAnalyzing
                        ? 'AI Analiz Ediyor...'
                        : 'AI ile Brifing Oluştur',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: const Color(
                      0xFF6366F1,
                    ).withValues(alpha: 0.5),
                    disabledForegroundColor: Colors.white70,
                  ),
                ),
              ),

            // ── AI Brifing Sonucu
            if (_briefingReady) ...[
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : const Color(0xFFF5F3FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.2),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: Color(0xFF6366F1),
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'AI Brifing Raporu',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Özet
                    const Text(
                      'Özet',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _aiSummary,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Anahtar Noktalar
                    const Text(
                      'Anahtar Noktalar',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ..._aiKeyPoints.map(
                      (p) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle,
                              size: 14,
                              color: AppTheme.successColor,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                p,
                                style: TextStyle(
                                  fontSize: 12,
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Detaylı Brifing
                    const Text(
                      'Uzmana İletilecek Brifing',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _aiBriefing,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.5,
                      ),
                    ),

                    // Takip soruları
                    if (_aiFollowUps.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      const Text(
                        'AI Önerileri',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      ..._aiFollowUps.map(
                        (q) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                size: 14,
                                color: Colors.amber[700],
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  q,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        isDark
                                            ? Colors.white70
                                            : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ── Ödeme/Gönder Butonu
              if (!_purchaseComplete)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed:
                        () => _submitRequest(
                          context,
                          package.isPremium,
                          package.priceLabel,
                        ),
                    icon: Icon(
                      package.isPremium
                          ? Icons.shopping_cart_rounded
                          : Icons.send_rounded,
                      size: 18,
                    ),
                    label: Text(
                      package.isPremium
                          ? 'Satın Al ve Gönder (${package.priceLabel})'
                          : 'Talebi Gönder (Ücretsiz)',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          package.isPremium
                              ? AppTheme.primaryColor
                              : AppTheme.successColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),

              // ── Başarılı gönderim
              if (_purchaseComplete) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.successColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: AppTheme.successColor,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Talebiniz Başarıyla Gönderildi!',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Uzman en kısa sürede yanıt verecektir. Bildirimlerinizi takip edin.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      TextButton(
                        onPressed: () => context.go('/consultation'),
                        child: const Text('Ana Vitrene Dön'),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeRequest() async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen sorununuzu anlatın'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isAnalyzing = true);

    // AI Simülasyonu — gerçek LLM çağrısı yerine
    await Future.delayed(const Duration(seconds: 3));

    final input = _controller.text.trim();

    setState(() {
      _isAnalyzing = false;
      _briefingReady = true;
      _aiSummary =
          'Danışan, $input konusunda profesyonel destek talep etmektedir.';
      _aiKeyPoints = [
        'Konuyla ilgili mevzuat araştırması gerekebilir',
        'Zaman sınırı veya süre kısıtlaması sorulmalı',
        'Daha önce başvuru yapılıp yapılmadığı önemli',
        'İlgili belgeler talep edilebilir',
      ];
      _aiBriefing =
          'Sayın Uzman,\n\nDanışanımız aşağıdaki konuda profesyonel görüşünüze ihtiyaç duymaktadır:\n\n"$input"\n\nKonunun detaylı analizi ve mevzuat çerçevesinde değerlendirilmesi talep edilmektedir. Danışanın durumuna özel çözüm önerileri beklenmektedir.';
      _aiFollowUps = [
        'Tebliğ veya bildirim tarihi varsa eklemeniz faydalı olur',
        'Daha önce idari başvuru yaptıysanız sonucunu belirtin',
        'Varsa ilgili belgeleri hazırlayın',
      ];
    });

    // Scroll aşağı
    await Future.delayed(const Duration(milliseconds: 300));
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _submitRequest(
    BuildContext ctx,
    bool isPremium,
    String priceLabel,
  ) async {
    if (isPremium) {
      // IAP Simülasyonu
      final confirmed = await showDialog<bool>(
        context: ctx,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Row(
                children: [
                  Icon(
                    Icons.shopping_cart_rounded,
                    color: AppTheme.primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text('Ödeme Onayı'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bu hizmet için $priceLabel ödeme yapılacaktır.'),
                  const SizedBox(height: 8),
                  Text(
                    'Ödeme Apple App Store / Google Play Store üzerinden güvenle işlenecektir.',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('İptal'),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Onayla ve Öde'),
                ),
              ],
            ),
      );

      if (confirmed != true) return;

      // Sipariş kaydı
      await LocalStorageService.addOrderRecord(
        title: 'Uzman Danışmanlık',
        description: 'AI destekli danışmanlık hizmeti',
        price: priceLabel,
        plan: 'danismanlik',
      );
    }

    if (ctx.mounted) {
      setState(() => _purchaseComplete = true);
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Text('Talebiniz başarıyla gönderildi!'),
            ],
          ),
          backgroundColor: AppTheme.successColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }
}
