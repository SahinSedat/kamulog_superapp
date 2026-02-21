import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/animated_widgets.dart';
import 'package:kamulog_superapp/features/home/presentation/widgets/stories_and_banners.dart';
import 'package:kamulog_superapp/features/stories/presentation/widgets/stories_section.dart';

class HomeDashboard extends ConsumerWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return RefreshIndicator(
      color: AppTheme.primaryColor,
      onRefresh: () async {},
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const SizedBox(height: 12),

          // ═══ SECTION 1: STORIES
          const StoriesSection(),
          const SizedBox(height: 16),

          // ═══ SECTION 2: BANNER CAROUSEL (Promotion Slider)
          const FadeSlideIn(child: BannerCarousel()),
          const SizedBox(height: 20),

          // ═══ SECTION 3: QUICK ACCESS CIRCULAR ICON GRID
          FadeSlideIn(
            delay: const Duration(milliseconds: 100),
            child: _QuickAccessGrid(theme: theme, isDark: isDark),
          ),
          const SizedBox(height: 20),

          // ═══ SECTION 4: ANNOUNCEMENT STRIP (Kampanya)
          FadeSlideIn(
            delay: const Duration(milliseconds: 200),
            child: _AnnouncementStrip(isDark: isDark),
          ),
          const SizedBox(height: 20),

          // ═══ SECTION 5: POPULAR CONTENT / AI RECOMMENDATIONS
          FadeSlideIn(
            delay: const Duration(milliseconds: 300),
            child: _PopularContentSection(theme: theme, isDark: isDark),
          ),
          const SizedBox(height: 20),

          // ═══ SECTION 6: AI RECOMMENDATION PANEL
          FadeSlideIn(
            delay: const Duration(milliseconds: 400),
            child: _AiRecommendationPanel(theme: theme, isDark: isDark),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── SECTION 3: Quick Access Circular Icon Grid
// ══════════════════════════════════════════════════════════════

class _QuickAccessGrid extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const _QuickAccessGrid({required this.theme, required this.isDark});

  static const _actions = [
    _QuickAction('STK', Icons.groups_rounded, Color(0xFF7B1FA2)),
    _QuickAction('Becayiş', Icons.swap_horiz_rounded, Color(0xFF2E7D32)),
    _QuickAction('Kariyer', Icons.work_rounded, Color(0xFF1565C0)),
    _QuickAction('Danışmanlık', Icons.support_agent_rounded, Color(0xFFE65100)),
    _QuickAction('Duyurular', Icons.campaign_rounded, Color(0xFFC62828)),
    _QuickAction('Profilim', Icons.person_rounded, Color(0xFF00695C)),
    _QuickAction(
      'Başvurular',
      Icons.assignment_turned_in_rounded,
      Color(0xFF4A148C),
    ),
    _QuickAction('AI Asistan', Icons.auto_awesome_rounded, Color(0xFF0D47A1)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              const Text(
                'Hızlı Erişim',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Tümü →',
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
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 0.78,
            children:
                _actions.map((action) {
                  return ScaleOnTap(
                    onTap: () {
                      if (action.label == 'Danışmanlık') {
                        context.push('/consultation');
                      }
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: action.color.withValues(
                              alpha: isDark ? 0.2 : 0.1,
                            ),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: action.color.withValues(
                                alpha: isDark ? 0.15 : 0.12,
                              ),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: action.color.withValues(alpha: 0.15),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Icon(
                            action.icon,
                            color: action.color,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          action.label,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  const _QuickAction(this.label, this.icon, this.color);
}

// ══════════════════════════════════════════════════════════════
// ── SECTION 4: Announcement Strip
// ══════════════════════════════════════════════════════════════

class _AnnouncementStrip extends StatelessWidget {
  final bool isDark;
  const _AnnouncementStrip({required this.isDark});

  static const _announcements = [
    _AnnData('🔔 Becayiş başvuruları açıldı! Son gün: 28 Şubat', [
      Color(0xFF1565C0),
      Color(0xFF0D47A1),
    ]),
    _AnnData('📢 Yeni kariyer fırsatları eklendi — 250 ilan', [
      Color(0xFF2E7D32),
      Color(0xFF1B5E20),
    ]),
    _AnnData('⚖️ Ücretsiz hukuk danışmanlığı için randevu alın', [
      Color(0xFFE65100),
      Color(0xFFBF360C),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _announcements.length,
        itemBuilder: (context, index) {
          final ann = _announcements[index];
          return Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: ann.gradient),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: ann.gradient[0].withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                ann.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnnData {
  final String text;
  final List<Color> gradient;
  const _AnnData(this.text, this.gradient);
}

// ══════════════════════════════════════════════════════════════
// ── SECTION 5: Popular Content (Card List)
// ══════════════════════════════════════════════════════════════

class _PopularContentSection extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const _PopularContentSection({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.local_fire_department_rounded,
                size: 20,
                color: AppTheme.errorColor,
              ),
              const SizedBox(width: 6),
              const Text(
                'Popüler İçerikler',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Tümünü Gör →',
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
        // Horizontal card scroll
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _popularItems.length,
            itemBuilder: (context, index) {
              final item = _popularItems[index];
              return _PopularCard(item: item, isDark: isDark);
            },
          ),
        ),
      ],
    );
  }

  static const _popularItems = [
    _PopularItem(
      title: 'İstanbul → Ankara Becayiş',
      subtitle: 'Milli Eğitim Bakanlığı · Öğretmen',
      badge: 'Popüler',
      badgeColor: Color(0xFFC62828),
      icon: Icons.swap_horiz_rounded,
      color: Color(0xFF2E7D32),
      stats: '45 eşleşme',
    ),
    _PopularItem(
      title: 'Ücretsiz Hukuk Danışmanlık',
      subtitle: 'Av. Mehmet Yılmaz · Online',
      badge: 'Yeni',
      badgeColor: Color(0xFF1565C0),
      icon: Icons.gavel_rounded,
      color: Color(0xFF4A148C),
      stats: '⭐ 4.9',
    ),
    _PopularItem(
      title: 'Devlet Memurluğu İlanları',
      subtitle: 'Sağlık Bakanlığı · 35 açık pozisyon',
      badge: 'Sıcak',
      badgeColor: Color(0xFFE65100),
      icon: Icons.work_rounded,
      color: Color(0xFF1565C0),
      stats: '1.2K görülme',
    ),
    _PopularItem(
      title: 'STK Sendika Etkinlikleri',
      subtitle: 'Türk Eğitim-Sen · Online buluşma',
      badge: 'Etkinlik',
      badgeColor: Color(0xFF7B1FA2),
      icon: Icons.groups_rounded,
      color: Color(0xFF7B1FA2),
      stats: '120 katılımcı',
    ),
  ];
}

class _PopularItem {
  final String title, subtitle, badge, stats;
  final Color badgeColor, color;
  final IconData icon;
  const _PopularItem({
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.icon,
    required this.color,
    required this.stats,
  });
}

class _PopularCard extends StatelessWidget {
  final _PopularItem item;
  final bool isDark;

  const _PopularCard({required this.item, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : const Color(0xFFE8E8E8),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: icon + badge
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: item.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.color, size: 22),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: item.badgeColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // Title
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                // Subtitle
                Text(
                  item.subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const Spacer(),
                // Bottom: stats + favorite
                Row(
                  children: [
                    Text(
                      item.stats,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: item.color,
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.favorite_border_rounded,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── SECTION 6: AI Recommendation Panel
// ══════════════════════════════════════════════════════════════

class _AiRecommendationPanel extends StatelessWidget {
  final ThemeData theme;
  final bool isDark;

  const _AiRecommendationPanel({required this.theme, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Color(0x4DC62828),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Pattern
            Positioned(
              right: -20,
              top: -20,
              child: Icon(
                Icons.auto_awesome_rounded,
                size: 140,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'AI Önerileri',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'Sizin için kişiselleştirilmiş',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // AI suggestions
                  _AiSuggestionChip(
                    icon: Icons.swap_horiz_rounded,
                    text: 'Ankara\'ya becayiş ilanları var — 12 eşleşme',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _AiSuggestionChip(
                    icon: Icons.work_rounded,
                    text: 'Size uygun 3 yeni iş ilanı bulundu',
                    onTap: () {},
                  ),
                  const SizedBox(height: 8),
                  _AiSuggestionChip(
                    icon: Icons.calculate_rounded,
                    text: 'Maaş zammınızı hesaplayın — 2025 güncelleme',
                    onTap: () => context.push('/salary-calculator'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AiSuggestionChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _AiSuggestionChip({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: Colors.white54,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
