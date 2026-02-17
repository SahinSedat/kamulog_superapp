import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';

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
        padding: const EdgeInsets.all(AppTheme.spacingMd),
        children: [
          // Welcome card
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingLg),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(AppTheme.radiusLg),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.wb_sunny_outlined,
                      color: Colors.white70,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Hoş Geldiniz',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingSm),
                Text(
                  'Kamulog Platform',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingMd),
                Text(
                  'Ücretli çalışanlar için hepsi bir arada platform',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Quick actions grid
          Text('Hızlı Erişim', style: theme.textTheme.titleMedium),
          const SizedBox(height: AppTheme.spacingSm),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppTheme.spacingSm,
            crossAxisSpacing: AppTheme.spacingSm,
            childAspectRatio: 1.4,
            children: [
              _QuickActionCard(
                icon: Icons.swap_horiz,
                title: 'Becayiş',
                subtitle: 'Yer değiştirme',
                color: const Color(0xFF4CAF50),
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.work_outline,
                title: 'İş İlanları',
                subtitle: 'Kariyer fırsatları',
                color: const Color(0xFF2196F3),
                onTap: () {},
              ),
              _QuickActionCard(
                icon: Icons.support_agent,
                title: 'Danışmanlık',
                subtitle: 'Uzman desteği',
                color: const Color(0xFFFF9800),
                onTap: () => context.push('/consultation'),
              ),
              _QuickActionCard(
                icon: Icons.groups,
                title: 'STK',
                subtitle: 'Topluluk',
                color: const Color(0xFF9C27B0),
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingLg),

          // Recent announcements
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Son Duyurular', style: theme.textTheme.titleMedium),
              TextButton(onPressed: () {}, child: const Text('Tümünü Gör')),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSm),

          // Placeholder announcements
          ..._buildAnnouncementCards(theme),
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
      },
      {
        'title': 'Kariyer Günleri Yaklaşıyor',
        'subtitle': 'Kamu kurumları kariyer fuarında sizi bekliyor.',
        'date': '14 Şubat 2026',
        'icon': Icons.event_outlined,
      },
      {
        'title': 'Hukuki Danışmanlık Hizmeti',
        'subtitle': 'Ücretsiz hukuki danışmanlık hizmetimiz başlamıştır.',
        'date': '12 Şubat 2026',
        'icon': Icons.gavel_outlined,
      },
    ];

    return announcements.map((a) {
      return KamulogCard(
        onTap: () {},
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(
                a['icon'] as IconData,
                color: AppTheme.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMd),
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
                  const SizedBox(height: 2),
                  Text(
                    a['subtitle'] as String,
                    style: theme.textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    a['date'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: theme.textTheme.bodySmall?.color?.withValues(
                        alpha: 0.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20),
          ],
        ),
      );
    }).toList();
  }
}

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
    return KamulogCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(height: AppTheme.spacingSm),
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
