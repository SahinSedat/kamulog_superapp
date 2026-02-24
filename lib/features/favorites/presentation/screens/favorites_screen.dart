import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/favorites/data/favorites_service.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';

/// Favoriler sayfasi — kategorilere ayrilmis: Is Ilanlari, Becayis, Diger
class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final favorites = ref.watch(favoritesProvider);

    final jobFavorites = favorites.where((e) => e.category == 'job').toList();
    final becayisFavorites =
        favorites.where((e) => e.category == 'becayis').toList();
    final otherFavorites =
        favorites
            .where((e) => e.category != 'job' && e.category != 'becayis')
            .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Favorilerim'),
        centerTitle: true,
      ),
      body:
          favorites.isEmpty
              ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Henuz favori eklemediniz',
                      style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Is ilanlari ve becayis ilanlarini\nfavorilere ekleyebilirsiniz',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    ),
                  ],
                ),
              )
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (jobFavorites.isNotEmpty) ...[
                      _SectionTitle(
                        icon: Icons.work_outline_rounded,
                        title: 'Is Ilanlari',
                        count: jobFavorites.length,
                      ),
                      const SizedBox(height: 8),
                      ...jobFavorites.map(
                        (item) => _FavoriteCard(item: item, isDark: isDark),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (becayisFavorites.isNotEmpty) ...[
                      _SectionTitle(
                        icon: Icons.swap_horiz_rounded,
                        title: 'Becayis Ilanlari',
                        count: becayisFavorites.length,
                      ),
                      const SizedBox(height: 8),
                      ...becayisFavorites.map(
                        (item) => _FavoriteCard(item: item, isDark: isDark),
                      ),
                      const SizedBox(height: 20),
                    ],
                    if (otherFavorites.isNotEmpty) ...[
                      _SectionTitle(
                        icon: Icons.bookmark_outline_rounded,
                        title: 'Diger',
                        count: otherFavorites.length,
                      ),
                      const SizedBox(height: 8),
                      ...otherFavorites.map(
                        (item) => _FavoriteCard(item: item, isDark: isDark),
                      ),
                    ],
                  ],
                ),
              ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppTheme.primaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _FavoriteCard extends ConsumerStatefulWidget {
  final FavoriteItem item;
  final bool isDark;
  const _FavoriteCard({required this.item, required this.isDark});

  @override
  ConsumerState<_FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends ConsumerState<_FavoriteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isDark = widget.isDark;

    final categoryIcon =
        item.category == 'job'
            ? Icons.work_outline_rounded
            : item.category == 'becayis'
            ? Icons.swap_horiz_rounded
            : Icons.bookmark_outline_rounded;

    final categoryColor =
        item.category == 'job'
            ? const Color(0xFF1565C0)
            : item.category == 'becayis'
            ? const Color(0xFF2E7D32)
            : AppTheme.primaryColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                isDark ? Colors.white12 : Colors.grey.withValues(alpha: 0.12),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 4,
          ),
          leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(categoryIcon, color: categoryColor, size: 20),
          ),
          title: Text(
            item.title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Text(
            item.subtitle,
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Link kopyala
              IconButton(
                icon: const Icon(Icons.link_rounded, size: 20),
                onPressed: () {
                  Clipboard.setData(
                    ClipboardData(
                      text: 'kamulog://detail/${item.category}/${item.id}',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Link kopyalandi'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
              // Animasyonlu favori cikarma
              ScaleTransition(
                scale: _heartScale,
                child: GestureDetector(
                  onTap: () {
                    _heartController.forward(from: 0);
                    ref
                        .read(favoritesProvider.notifier)
                        .removeFavorite(item.id, item.category);
                  },
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 20,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            // Is ilani ise extraData'dan JobListingModel olustur ve ilana git
            if (item.category == 'job' && item.extraData != null) {
              try {
                final job = JobListingModel.fromJson(item.extraData!);
                context.push('/job-detail', extra: job);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Ilan verisi yuklenemedi')),
                );
              }
            } else if (item.routePath != null) {
              context.push(item.routePath!);
            }
          },
        ),
      ),
    );
  }
}
