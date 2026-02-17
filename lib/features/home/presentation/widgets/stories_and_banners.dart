import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Instagram-like story circles at the top of the home screen.
/// Mock data for now — will be managed from admin panel later.
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  static const _stories = [
    _StoryData('Duyurular', Icons.campaign, [
      Color(0xFFFF6B6B),
      Color(0xFFFF8E53),
    ]),
    _StoryData('Etkinlikler', Icons.event, [
      Color(0xFF4ECDC4),
      Color(0xFF2196F3),
    ]),
    _StoryData('Kariyer', Icons.work, [Color(0xFFA855F7), Color(0xFF6366F1)]),
    _StoryData('Hukuk', Icons.gavel, [Color(0xFFF59E0B), Color(0xFFEF4444)]),
    _StoryData('Becayiş', Icons.swap_horiz, [
      Color(0xFF10B981),
      Color(0xFF059669),
    ]),
    _StoryData('Eğitim', Icons.school, [Color(0xFF3B82F6), Color(0xFF8B5CF6)]),
    _StoryData('Sağlık', Icons.health_and_safety, [
      Color(0xFFEC4899),
      Color(0xFFF43F5E),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Gradient ring
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
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              padding: const EdgeInsets.all(2),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: data.gradientColors[0].withValues(alpha: 0.15),
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

/// Auto-scrolling banner carousel for promotions/news.
/// Mock data for now — will be managed from admin panel later.
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
      gradient: [Color(0xFF667EEA), Color(0xFF764BA2)],
    ),
    _BannerData(
      title: 'Kariyer Fırsatları',
      subtitle: 'Binlerce iş ilanı sizi bekliyor',
      icon: Icons.trending_up,
      gradient: [Color(0xFF11998E), Color(0xFF38EF7D)],
    ),
    _BannerData(
      title: 'Ücretsiz Danışmanlık',
      subtitle: 'Hukuki ve kariyer danışmanlığı hizmetimiz başladı',
      icon: Icons.support_agent,
      gradient: [Color(0xFFF093FB), Color(0xFFF5576C)],
    ),
    _BannerData(
      title: 'STK Toplantıları',
      subtitle: 'Online etkinliklere katılmak için tıklayın',
      icon: Icons.groups_3,
      gradient: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
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
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
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
                duration: const Duration(milliseconds: 300),
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
                      color: banner.gradient[0].withValues(alpha: 0.35),
                      blurRadius: 12,
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
                                    color: Colors.white.withValues(alpha: 0.85),
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
                              borderRadius: BorderRadius.circular(16),
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
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color:
                    i == _currentPage
                        ? AppTheme.primaryColor
                        : AppTheme.primaryColor.withValues(alpha: 0.2),
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
