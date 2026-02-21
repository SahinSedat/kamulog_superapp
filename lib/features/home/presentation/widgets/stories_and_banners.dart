import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/theme/app_animations.dart';

/// Instagram-like story circles — BOLD colors
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  static const _stories = [
    _StoryData('Duyurular', Icons.campaign, [
      Color(0xFFD32F2F),
      Color(0xFFFF5252),
    ]),
    _StoryData('Etkinlikler', Icons.event, [
      Color(0xFF1565C0),
      Color(0xFF42A5F5),
    ]),
    _StoryData('Kariyer', Icons.work, [Color(0xFF7B1FA2), Color(0xFFAB47BC)]),
    _StoryData('Hukuk', Icons.gavel, [Color(0xFFE65100), Color(0xFFFF8F00)]),
    _StoryData('Becayiş', Icons.swap_horiz, [
      Color(0xFF2E7D32),
      Color(0xFF66BB6A),
    ]),
    _StoryData('Eğitim', Icons.school, [Color(0xFF0D47A1), Color(0xFF1976D2)]),
    _StoryData('Sağlık', Icons.health_and_safety, [
      Color(0xFFC62828),
      Color(0xFFEF5350),
    ]),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _stories.length,
        itemBuilder: (context, index) {
          final story = _stories[index];
          return _StoryCircle(data: story, index: index);
        },
      ),
    );
  }
}

class _StoryData {
  final String label;
  final IconData icon;
  final List<Color> gradientColors;
  const _StoryData(this.label, this.icon, this.gradientColors);
}

class _StoryCircle extends StatelessWidget {
  final _StoryData data;
  final int index;
  const _StoryCircle({required this.data, required this.index});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: data.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: data.gradientColors[0].withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppTheme.surfaceDark : Colors.white,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: data.gradientColors[0].withValues(
                  alpha: isDark ? 0.25 : 0.12,
                ),
                child: Icon(data.icon, size: 26, color: data.gradientColors[0]),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Auto-scrolling banner carousel with images and bold gradients
class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  final _controller = PageController(viewportFraction: 0.92);
  int _currentPage = 0;
  Timer? _autoScrollTimer;

  static const _banners = [
    _BannerData(
      title: 'Becayiş Dönemi Açıldı',
      subtitle:
          'Binlerce memur ve işçi yer değiştirme bekliyor. Hemen başvurun!',
      icon: Icons.swap_horiz_rounded,
      gradient: [Color(0xFF1565C0), Color(0xFF0D47A1)],
      bgPattern: _BannerPattern.arrows,
    ),
    _BannerData(
      title: 'Kariyer Fırsatları',
      subtitle: 'Kamu ve özel sektörden binlerce iş ilanı',
      icon: Icons.trending_up_rounded,
      gradient: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
      bgPattern: _BannerPattern.chart,
    ),
    _BannerData(
      title: 'Ücretsiz Danışmanlık',
      subtitle: 'Hukuki, kariyer ve psikolojik destek hizmetleri',
      icon: Icons.support_agent_rounded,
      gradient: [Color(0xFFE65100), Color(0xFFBF360C)],
      bgPattern: _BannerPattern.people,
    ),
    _BannerData(
      title: 'STK ve Sendikalar',
      subtitle: 'Sendika ve dernek etkinliklerine katılın',
      icon: Icons.groups_3_rounded,
      gradient: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
      bgPattern: _BannerPattern.community,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final nextPage = (_currentPage + 1) % _banners.length;
      _controller.animateToPage(
        nextPage,
        duration: AppAnimations.slow,
        curve: AppAnimations.defaultCurve,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 165,
          child: PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _banners.length,
            itemBuilder: (context, index) {
              final banner = _banners[index];
              return AnimatedContainer(
                duration: AppAnimations.normal,
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: banner.gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: banner.gradient[0].withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${banner.title} — detay sayfası yakında aktif olacak',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        // Background pattern
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            _getPatternIcon(banner.bgPattern),
                            size: 120,
                            color: Colors.white.withValues(alpha: 0.08),
                          ),
                        ),
                        // Content
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        _getBannerLabel(index),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      banner.title,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        letterSpacing: -0.3,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      banner.subtitle,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.9,
                                        ),
                                        fontSize: 12,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(
                                    AppTheme.radiusMd,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.15),
                                  ),
                                ),
                                child: Icon(
                                  banner.icon,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Bold dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: AppAnimations.normal,
              curve: AppAnimations.defaultCurve,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    i == _currentPage
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getPatternIcon(_BannerPattern pattern) {
    switch (pattern) {
      case _BannerPattern.arrows:
        return Icons.swap_horiz_rounded;
      case _BannerPattern.chart:
        return Icons.show_chart_rounded;
      case _BannerPattern.people:
        return Icons.people_alt_rounded;
      case _BannerPattern.community:
        return Icons.diversity_3_rounded;
    }
  }

  String _getBannerLabel(int index) {
    const labels = ['YENİ', 'POPÜLER', 'ÜCRETSİZ', 'ETKİNLİK'];
    return labels[index % labels.length];
  }
}

enum _BannerPattern { arrows, chart, people, community }

class _BannerData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  final _BannerPattern bgPattern;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.bgPattern,
  });
}
