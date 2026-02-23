import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:confetti/confetti.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/subscription/presentation/providers/subscription_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

class UpgradePlanScreen extends ConsumerStatefulWidget {
  const UpgradePlanScreen({super.key});

  @override
  ConsumerState<UpgradePlanScreen> createState() => _UpgradePlanScreenState();
}

class _UpgradePlanScreenState extends ConsumerState<UpgradePlanScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final subscriptionState = ref.watch(subscriptionStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Planı Yükselt'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header Image/Icon
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppTheme.aiGradient,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.diamond_outlined,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Premium Sürüm ile Sınırları Kaldırın',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Yapay zeka analizleri, sınırsız mesajlaşma ve size özel avantajlardan hemen faydalanın.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
                const SizedBox(height: 32),

                // Feature List
                _buildFeatureRow(
                  Icons.check_circle_rounded,
                  'Anlık Sınırsız Mesajlaşma',
                  isDark,
                ),
                _buildFeatureRow(
                  Icons.check_circle_rounded,
                  'AI Destekli CV Hazırlama ve Görüntüleme',
                  isDark,
                ),
                _buildFeatureRow(
                  Icons.check_circle_rounded,
                  'Aylık Tüm Özelliklere Erişim (+1000 Kredi)',
                  isDark,
                ),
                _buildFeatureRow(
                  Icons.check_circle_rounded,
                  'Sınırsız Becayiş İlanı İnceleme',
                  isDark,
                ),
                const SizedBox(height: 32),

                // Subscriptions or Loading state from IAP
                Text(
                  'Abonelik Paketleri',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),

                subscriptionState.when(
                  data: (products) {
                    if (products.isEmpty) {
                      return _buildDummyPlans(context, ref, isDark);
                    }
                    return Column(
                      children:
                          products
                              .map(
                                (product) => _buildProductCard(
                                  context,
                                  ref,
                                  product,
                                  isDark,
                                ),
                              )
                              .toList(),
                    );
                  },
                  loading:
                      () => const Center(child: CircularProgressIndicator()),
                  error:
                      (err, stack) =>
                          Center(child: Text('Mağazaya bağlanılamadı: \$err')),
                ),
              ],
            ),
          ),
          // Confetti overlay
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Color(0xFFD4AF37),
                Color(0xFFFFD700),
                AppTheme.primaryColor,
                AppTheme.accentColor,
                Colors.white,
                Colors.orangeAccent,
              ],
              emissionFrequency: 0.05,
              numberOfParticles: 30,
              gravity: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.successColor, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Apple & Google Store ID'leri henüz tanımlı değilse gösterilecek test kartları
  Widget _buildDummyPlans(BuildContext context, WidgetRef ref, bool isDark) {
    return Column(
      children: [
        _DummyPlanCard(
          title: 'Aylık Premium',
          price: '₺ 299,99 / ay',
          isPopular: false,
          isDark: isDark,
          onTap: () => _simulatePurchase(context, ref, 'aylik'),
        ),
        const SizedBox(height: 16),
        _DummyPlanCard(
          title: 'Yıllık Premium',
          price: '₺ 2.999,99 / yıl',
          isPopular: true,
          isDark: isDark,
          onTap: () => _simulatePurchase(context, ref, 'yillik'),
        ),
      ],
    );
  }

  void _simulatePurchase(
    BuildContext context,
    WidgetRef ref,
    String plan,
  ) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Satın alım simülasyonu başlatılıyor... (Test Modu)'),
      ),
    );
    await Future.delayed(const Duration(seconds: 2));
    // Premium durumunu aktifleştir (aylık = 30 gün, yıllık = 365 gün)
    final duration = plan == 'yillik' ? 365 : 30;
    await ref
        .read(profilProvider.notifier)
        .activatePremium(DateTime.now().add(Duration(days: duration)));

    // 🎉 Konfeti animasyonunu tetikle!
    _confettiController.play();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '🎉 Tebrikler, Premium hesaba geçtiniz! +1000 Kredi eklendi.',
          ),
          backgroundColor: AppTheme.successColor,
          duration: Duration(seconds: 4),
        ),
      );
    }
  }

  Widget _buildProductCard(
    BuildContext context,
    WidgetRef ref,
    ProductDetails product,
    bool isDark,
  ) {
    bool isYearly = product.id.contains('yearly');
    return GestureDetector(
      onTap:
          () => ref.read(subscriptionStateProvider.notifier).buyPlan(product),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isYearly
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white12 : Colors.grey.shade200),
            width: isYearly ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isYearly
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title.split(' (').first,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  product.price,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if (isYearly)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'En Popüler',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.accentDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DummyPlanCard extends StatelessWidget {
  final String title;
  final String price;
  final bool isPopular;
  final bool isDark;
  final VoidCallback onTap;

  const _DummyPlanCard({
    required this.title,
    required this.price,
    required this.isPopular,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isPopular
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white12 : Colors.grey.shade200),
            width: isPopular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color:
                  isPopular
                      ? AppTheme.primaryColor.withValues(alpha: 0.1)
                      : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryColor,
                  ),
                ),
                if (isPopular)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'En Popüler',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.accentDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
