import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/home/presentation/widgets/stories_and_banners.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return RefreshIndicator(
      onRefresh: () async {
        // TODO: Refresh data
      },
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),

          // ── Stories Row (Instagram-like) ──
          const StoriesRow(),
          const SizedBox(height: 16),

          // ── Banner Carousel ──
          const BannerCarousel(),
          const SizedBox(height: 20),

          // ── Quick Actions  ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              children: [
                Text(
                  'Hızlı Erişim',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                  ),
                  child: Text(
                    'Tümü',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
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
                  color: const Color(0xFF10B981),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.work_outline,
                  label: 'İş İlanları',
                  color: const Color(0xFF3B82F6),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.support_agent,
                  label: 'Danışmanlık',
                  color: const Color(0xFFF59E0B),
                  onTap: () => context.push('/consultation'),
                ),
                _QuickActionIcon(
                  icon: Icons.groups,
                  label: 'STK',
                  color: const Color(0xFF8B5CF6),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.school_outlined,
                  label: 'Eğitim',
                  color: const Color(0xFFEC4899),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.gavel_outlined,
                  label: 'Hukuk',
                  color: const Color(0xFFEF4444),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.newspaper_outlined,
                  label: 'Haberler',
                  color: const Color(0xFF06B6D4),
                  onTap: () {},
                ),
                _QuickActionIcon(
                  icon: Icons.more_horiz,
                  label: 'Daha Fazla',
                  color: const Color(0xFF6B7280),
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // ── Recent Announcements ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMd),
            child: Row(
              children: [
                Text(
                  'Son Duyurular',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Tümünü Gör',
                    style: TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),

          // Announcement cards
          ..._buildAnnouncementCards(theme),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  List<Widget> _buildAnnouncementCards(ThemeData theme) {
    final announcements = [
      {
        'title': 'Yeni Becayiş Dönemi Başladı',
        'subtitle':
            'Ücretli çalışanlar için yer değiştirme başvuruları açıldı.',
        'date': '15 Şubat 2026',
        'icon': Icons.campaign_outlined,
        'color': const Color(0xFF4CAF50),
      },
      {
        'title': 'Kariyer Günleri Yaklaşıyor',
        'subtitle': 'Kurumlar kariyer fuarında sizi bekliyor.',
        'date': '14 Şubat 2026',
        'icon': Icons.event_outlined,
        'color': const Color(0xFF2196F3),
      },
      {
        'title': 'Hukuki Danışmanlık Hizmeti',
        'subtitle': 'Ücretsiz hukuki danışmanlık hizmetimiz başlamıştır.',
        'date': '12 Şubat 2026',
        'icon': Icons.gavel_outlined,
        'color': const Color(0xFFFF9800),
      },
    ];

    return announcements.map((a) {
      final color = a['color'] as Color;
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMd,
          vertical: 4,
        ),
        child: Material(
          color: theme.cardTheme.color ?? Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          elevation: 1,
          shadowColor: Colors.black.withValues(alpha: 0.06),
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(a['icon'] as IconData, color: color, size: 24),
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
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.7,
                            ),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          a['date'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.textTheme.bodySmall?.color?.withValues(
                              alpha: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey.shade400,
                  ),
                ],
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
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
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
