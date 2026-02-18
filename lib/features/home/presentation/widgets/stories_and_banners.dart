import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/theme/app_animations.dart';

/// Instagram-like story circles at the top of the home screen.
/// Uses pastel vintage-modern gradients.
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  static const _stories = [
    _StoryData('Duyurular', Icons.campaign, [
      Color(0xFFF28B82),
      Color(0xFFF4A261),
    ]),
    _StoryData('Etkinlikler', Icons.event, [
      Color(0xFF6BCBB4),
      Color(0xFF8AB4F8),
    ]),
    _StoryData('Kariyer', Icons.work, [Color(0xFFB39DDB), Color(0xFF7C8CF8)]),
    _StoryData('Hukuk', Icons.gavel, [Color(0xFFF7D070), Color(0xFFF4A261)]),
    _StoryData('Becayiş', Icons.swap_horiz, [
      Color(0xFF81C995),
      Color(0xFF6BCBB4),
    ]),
    _StoryData('Eğitim', Icons.school, [Color(0xFF8AB4F8), Color(0xFFB39DDB)]),
    _StoryData('Sağlık', Icons.health_and_safety, [
      Color(0xFFF28B82),
      Color(0xFFB39DDB),
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
          // Gradient ring with soft pastel colors
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
                  color: data.gradientColors[0].withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppTheme.surfaceDark : AppTheme.surfaceLight,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: data.gradientColors[0].withValues(
                  alpha: isDark ? 0.2 : 0.1,
                ),
                child: Icon(data.icon, size: 26, color: data.gradientColors[0]),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

/// Auto-scrolling banner carousel with pastel vintage gradients.
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
      title: 'Yeni Dönem Başladı',
      subtitle: 'Becayiş başvuruları açıldı, hemen başvurun!',
      icon: Icons.rocket_launch,
      gradient: [Color(0xFF7C8CF8), Color(0xFFB39DDB)],
    ),
    _BannerData(
      title: 'Kariyer Fırsatları',
      subtitle: 'Binlerce iş ilanı sizi bekliyor',
      icon: Icons.trending_up,
      gradient: [Color(0xFF6BCBB4), Color(0xFF81C995)],
    ),
    _BannerData(
      title: 'Ücretsiz Danışmanlık',
      subtitle: 'Hukuki ve kariyer danışmanlığı hizmetimiz başladı',
      icon: Icons.support_agent,
      gradient: [Color(0xFFF4A261), Color(0xFFF28B82)],
    ),
    _BannerData(
      title: 'STK Toplantıları',
      subtitle: 'Online etkinliklere katılmak için tıklayın',
      icon: Icons.groups_3,
      gradient: [Color(0xFF8AB4F8), Color(0xFF6BCBB4)],
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
          height: 150,
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
                      color: banner.gradient[0].withValues(alpha: 0.25),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  banner.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  banner.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.88),
                                    fontSize: 13,
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
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(
                                AppTheme.radiusMd,
                              ),
                            ),
                            child: Icon(
                              banner.icon,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _banners.length,
            (i) => AnimatedContainer(
              duration: AppAnimations.normal,
              curve: AppAnimations.defaultCurve,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 22 : 6,
              height: 6,
              decoration: BoxDecoration(
                gradient: i == _currentPage ? AppTheme.pastelGradient : null,
                color:
                    i == _currentPage
                        ? null
                        : AppTheme.primaryColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
}
