import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/providers/expert_marketplace_provider.dart';
import 'package:kamulog_superapp/features/expert_marketplace/presentation/widgets/expert_card.dart';

/// Uzman listeleme ekranı — filtreleme ve sıralama
class ExpertListScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  const ExpertListScreen({super.key, this.initialCategory});

  @override
  ConsumerState<ExpertListScreen> createState() => _ExpertListScreenState();
}

class _ExpertListScreenState extends ConsumerState<ExpertListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialCategory != null) {
        try {
          final catType = ExpertCategoryType.values.firstWhere(
            (e) => e.name == widget.initialCategory,
          );
          ref
              .read(expertMarketplaceProvider.notifier)
              .filterByCategory(catType);
        } catch (_) {}
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final state = ref.watch(expertMarketplaceProvider);
    final notifier = ref.read(expertMarketplaceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            notifier.filterByCategory(null);
            context.pop();
          },
        ),
        title: Text(
          state.selectedCategory != null
              ? ExpertCategory.fromType(state.selectedCategory!).name
              : 'Tüm Uzmanlar',
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Filtre & Sıralama Barı
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.cardDark : Colors.white,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.white10 : Colors.grey.shade200,
                ),
              ),
            ),
            child: Row(
              children: [
                // Kategori filtresi
                Expanded(
                  child: SizedBox(
                    height: 34,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _FilterChip(
                          label: 'Tümü',
                          isSelected: state.selectedCategory == null,
                          isDark: isDark,
                          onTap: () => notifier.filterByCategory(null),
                        ),
                        const SizedBox(width: 6),
                        ...ExpertCategory.all.map((cat) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: _FilterChip(
                              label: cat.name,
                              isSelected: state.selectedCategory == cat.type,
                              isDark: isDark,
                              color: cat.color,
                              onTap: () => notifier.filterByCategory(cat.type),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Sıralama
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.sort_rounded,
                    size: 22,
                    color: isDark ? Colors.white70 : Colors.black54,
                  ),
                  onSelected: (value) => notifier.changeSortBy(value),
                  itemBuilder:
                      (ctx) => [
                        PopupMenuItem(
                          value: 'rating',
                          child: Row(
                            children: [
                              Icon(
                                Icons.star_rounded,
                                size: 18,
                                color:
                                    state.sortBy == 'rating'
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              const Text('Puana Göre'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'price',
                          child: Row(
                            children: [
                              Icon(
                                Icons.attach_money_rounded,
                                size: 18,
                                color:
                                    state.sortBy == 'price'
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              const Text('Fiyata Göre'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'experience',
                          child: Row(
                            children: [
                              Icon(
                                Icons.work_rounded,
                                size: 18,
                                color:
                                    state.sortBy == 'experience'
                                        ? AppTheme.primaryColor
                                        : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              const Text('Deneyime Göre'),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
          ),

          // ── Sonuç sayısı
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                Text(
                  '${state.filteredExperts.length} uzman bulundu',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white54 : Colors.grey[600],
                  ),
                ),
                const Spacer(),
                Text(
                  'Sıralama: ${_sortLabel(state.sortBy)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),

          // ── Uzman Listesi
          Expanded(
            child:
                state.filteredExperts.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.search_off_rounded,
                            size: 48,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Bu kategoride uzman bulunamadı',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ],
                      ),
                    )
                    : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: state.filteredExperts.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        final expert = state.filteredExperts[index];
                        return ExpertCard(
                          expert: expert,
                          isDark: isDark,
                          onTap:
                              () => context.push('/expert-detail/${expert.id}'),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  String _sortLabel(String sortBy) {
    switch (sortBy) {
      case 'rating':
        return 'Puan';
      case 'price':
        return 'Fiyat';
      case 'experience':
        return 'Deneyim';
      default:
        return 'Puan';
    }
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.isDark,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final chipColor = color ?? AppTheme.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? chipColor.withValues(alpha: 0.15)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.06)
                      : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? chipColor : Colors.transparent,
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color:
                isSelected
                    ? chipColor
                    : (isDark ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }
}
