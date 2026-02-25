import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/providers/expert_marketplace_provider.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/widgets/ai_search_bar.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/widgets/category_card.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/widgets/expert_card.dart';

/// Ana vitrin — AI Akıllı Arama + Kategoriler + Öne Çıkan Uzmanlar
class ExpertDiscoverScreen extends ConsumerWidget {
  const ExpertDiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(expertMarketplaceProvider);
    final notifier = ref.read(expertMarketplaceProvider.notifier);
    final featured = notifier.featuredExperts;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Uzman Danışmanlık'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.history_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Talep geçmişi yakında eklenecek'),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AI Arama Çubuğu
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: AiSearchBar(
                isDark: isDark,
                onTap: () => _showAiSearch(context, ref, isDark),
              ),
            ),

            // ── AI Önerisi Banner
            if (state.aiRecommendation != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: _AiRecommendationBanner(
                  explanation: state.aiRecommendation!.explanation,
                  category: ExpertCategory.fromType(
                    state.aiRecommendation!.suggestedCategory,
                  ),
                  isDark: isDark,
                  onViewExperts: () {
                    context.push(
                      '/expert-list?category=${state.aiRecommendation!.suggestedCategory.name}',
                    );
                  },
                ),
              ),

            // ── Kategoriler
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Kategoriler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  TextButton(
                    onPressed: () => context.push('/expert-list'),
                    child: const Text(
                      'Tümünü Gör',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                childAspectRatio: 0.95,
                children:
                    ExpertCategory.all.map((cat) {
                      return CategoryCard(
                        category: cat,
                        isDark: isDark,
                        onTap:
                            () => context.push(
                              '/expert-list?category=${cat.type.name}',
                            ),
                      );
                    }).toList(),
              ),
            ),

            // ── Öne Çıkan Uzmanlar
            if (featured.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Öne Çıkan Uzmanlar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/expert-list'),
                      child: const Text('Tümü', style: TextStyle(fontSize: 13)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 170,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: featured.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    return ExpertCard(
                      expert: featured[index],
                      isDark: isDark,
                      isCompact: true,
                      onTap:
                          () => context.push(
                            '/expert-detail/${featured[index].id}',
                          ),
                    );
                  },
                ),
              ),
            ],

            // ── İstatistikler
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.white.withValues(alpha: 0.04)
                          : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _StatItem(
                      value: '${state.allExperts.length}',
                      label: 'Uzman',
                      icon: Icons.person_rounded,
                      isDark: isDark,
                    ),
                    _StatItem(
                      value: '6',
                      label: 'Kategori',
                      icon: Icons.category_rounded,
                      isDark: isDark,
                    ),
                    _StatItem(
                      value: '3K+',
                      label: 'Danışma',
                      icon: Icons.check_circle_rounded,
                      isDark: isDark,
                    ),
                    _StatItem(
                      value: '4.7',
                      label: 'Ort. Puan',
                      icon: Icons.star_rounded,
                      isDark: isDark,
                    ),
                  ],
                ),
              ),
            ),

            // ── Store Bilgisi
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color:
                      isDark
                          ? Colors.blue.withValues(alpha: 0.08)
                          : Colors.blue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.15),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_user_rounded,
                      size: 16,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Tüm ödemeler Apple App Store / Google Play Store üzerinden güvenle işlenir.',
                        style: TextStyle(
                          fontSize: 11,
                          color:
                              isDark
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade700,
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

  void _showAiSearch(BuildContext context, WidgetRef ref, bool isDark) {
    showDialog(
      context: context,
      builder:
          (ctx) => AiSearchDialog(
            isDark: isDark,
            onSubmit: (text) async {
              // Loading göster
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Row(
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('AI analiz ediyor...'),
                      ],
                    ),
                    backgroundColor: const Color(0xFF6366F1),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    duration: const Duration(seconds: 3),
                  ),
                );
              }

              final recommendation = await ref
                  .read(expertMarketplaceProvider.notifier)
                  .analyzeWithAI(text);

              if (context.mounted) {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                context.push(
                  '/expert-list?category=${recommendation.suggestedCategory.name}',
                );
              }
            },
          ),
    );
  }
}

class _AiRecommendationBanner extends StatelessWidget {
  final String explanation;
  final ExpertCategory category;
  final bool isDark;
  final VoidCallback onViewExperts;

  const _AiRecommendationBanner({
    required this.explanation,
    required this.category,
    required this.isDark,
    required this.onViewExperts,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: category.color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: category.color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: category.color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI Önerisi',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  explanation,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onViewExperts,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: category.color,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Göster',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final bool isDark;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 18, color: AppTheme.primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: isDark ? Colors.white54 : Colors.grey[500],
          ),
        ),
      ],
    );
  }
}
