import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/animated_widgets.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/home/presentation/widgets/stories_and_banners.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async {
        // TODO: Refresh data
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),

          // ── Stories Row ──
          const FadeSlideIn(child: StoriesRow()),
          const SizedBox(height: 16),

          // ── Banner Carousel ──
          const FadeSlideIn(
            delay: Duration(milliseconds: 100),
            child: BannerCarousel(),
          ),
          const SizedBox(height: 24),

          // ── Quick Actions ──
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: Column(
              children: [
                const KamulogSectionHeader(
                  title: 'Hızlı Erişim',
                  actionText: 'Tümü',
                  icon: Icons.grid_view_rounded,
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingMd,
                  ),
                  child: GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 0.85,
                    children: [
                      _QuickActionIcon(
                        icon: Icons.swap_horiz,
                        label: 'Becayiş',
                        color: AppTheme.accentColor,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.work_outline,
                        label: 'İş İlanları',
                        color: AppTheme.infoColor,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.support_agent,
                        label: 'Danışmanlık',
                        color: AppTheme.warmColor,
                        onTap: () => context.push('/consultation'),
                      ),
                      _QuickActionIcon(
                        icon: Icons.groups,
                        label: 'STK',
                        color: AppTheme.purpleAccent,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.school_outlined,
                        label: 'Eğitim',
                        color: AppTheme.primaryColor,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.gavel_outlined,
                        label: 'Hukuk',
                        color: AppTheme.errorColor,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.newspaper_outlined,
                        label: 'Haberler',
                        color: AppTheme.accentLight,
                        onTap: () {},
                      ),
                      _QuickActionIcon(
                        icon: Icons.more_horiz,
                        label: 'Daha Fazla',
                        color: AppTheme.textSecondaryLight,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // ── Recent Announcements ──
          FadeSlideIn(
            delay: const Duration(milliseconds: 300),
            child: Column(
              children: [
                const KamulogSectionHeader(
                  title: 'Son Duyurular',
                  actionText: 'Tümünü Gör',
                  icon: Icons.notifications_outlined,
                ),
                const SizedBox(height: 4),
                ..._buildAnnouncementCards(theme, isDark),
              ],
            ),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Widget> _buildAnnouncementCards(ThemeData theme, bool isDark) {
    final announcements = [
      {
        'title': 'Yeni Becayiş Dönemi Başladı',
        'subtitle':
            'Ücretli çalışanlar için yer değiştirme başvuruları açıldı.',
        'date': '15 Şubat 2026',
        'icon': Icons.campaign_outlined,
        'color': AppTheme.accentColor,
      },
      {
        'title': 'Kariyer Günleri Yaklaşıyor',
        'subtitle': 'Kurumlar kariyer fuarında sizi bekliyor.',
        'date': '14 Şubat 2026',
        'icon': Icons.event_outlined,
        'color': AppTheme.infoColor,
      },
      {
        'title': 'Hukuki Danışmanlık Hizmeti',
        'subtitle': 'Ücretsiz hukuki danışmanlık hizmetimiz başlamıştır.',
        'date': '12 Şubat 2026',
        'icon': Icons.gavel_outlined,
        'color': AppTheme.warmColor,
      },
    ];

    return announcements.asMap().entries.map((entry) {
      final index = entry.key;
      final a = entry.value;
      final color = a['color'] as Color;

      return StaggeredListItem(
        index: index,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingMd,
            vertical: 4,
          ),
          child: Container(
            decoration: AppTheme.softCardDecoration(isDark: isDark),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: isDark ? 0.15 : 0.1),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMd,
                          ),
                        ),
                        child: Icon(
                          a['icon'] as IconData,
                          color: color,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              a['title'] as String,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              a['subtitle'] as String,
                              style: theme.textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              a['date'] as String,
                              style: theme.textTheme.labelSmall,
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        size: 20,
                        color: theme.textTheme.bodySmall?.color,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }
}

class _QuickActionIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionIcon({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaleOnTap(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: isDark ? 0.15 : 0.08),
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              border: Border.all(
                color: color.withValues(alpha: isDark ? 0.1 : 0.06),
              ),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
