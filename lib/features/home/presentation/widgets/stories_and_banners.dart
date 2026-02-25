import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/theme/app_animations.dart';

// ══════════════════════════════════════════════════════════════
// 5 ANA RENK PALETİ (Gradient yok — düz renkler)
// ══════════════════════════════════════════════════════════════
const Color _kMavi = Color(0xFF2563EB); // Kariyer, Bilgi
const Color _kYesil = Color(0xFF059669); // Becayiş, Başarı
const Color _kTuruncu = Color(0xFFEA580C); // Danışmanlık, Dikkat
const Color _kMor = Color(0xFF7C3AED); // STK, AI
const Color _kKirmizi = Color(0xFFDC2626); // Duyurular, Önemli

/// Instagram-like story circles — 5 düz renk
class StoriesRow extends StatelessWidget {
  const StoriesRow({super.key});

  static const _stories = [
    _StoryData('Duyurular', Icons.campaign_rounded, _kKirmizi),
    _StoryData('Becayiş', Icons.swap_horiz_rounded, _kYesil),
    _StoryData('Kariyer', Icons.work_rounded, _kMavi),
    _StoryData('Hukuk', Icons.gavel_rounded, _kTuruncu),
    _StoryData('AI', Icons.auto_awesome_rounded, _kMor),
    _StoryData('Eğitim', Icons.school_rounded, _kMavi),
    _StoryData('Sağlık', Icons.health_and_safety_rounded, _kKirmizi),
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
          return _StoryCircle(data: story);
        },
      ),
    );
  }
}

class _StoryData {
  final String label;
  final IconData icon;
  final Color color;
  const _StoryData(this.label, this.icon, this.color);
}

class _StoryCircle extends StatelessWidget {
  final _StoryData data;
  const _StoryCircle({required this.data});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dış halka — düz renk
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: data.color,
              boxShadow: [
                BoxShadow(
                  color: data.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
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
                backgroundColor: data.color.withValues(
                  alpha: isDark ? 0.2 : 0.08,
                ),
                child: Icon(data.icon, size: 26, color: data.color),
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

/// Auto-scrolling banner carousel — düz renkler
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
      color: _kYesil,
      label: 'YENİ',
    ),
    _BannerData(
      title: 'Kariyer Fırsatları',
      subtitle: 'Kamu ve özel sektörden binlerce iş ilanı',
      icon: Icons.trending_up_rounded,
      color: _kMavi,
      label: 'POPÜLER',
    ),
    _BannerData(
      title: 'Online Danışmanlık',
      subtitle: 'Hukuki, kariyer ve psikolojik destek hizmetleri',
      icon: Icons.support_agent_rounded,
      color: _kTuruncu,
      label: 'ÜCRETSİZ',
    ),
    _BannerData(
      title: 'STK ve Sendikalar',
      subtitle: 'Sendika ve dernek etkinliklerine katılın',
      icon: Icons.groups_3_rounded,
      color: _kMor,
      label: 'ETKİNLİK',
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
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
                  color: banner.color,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: banner.color.withValues(alpha: 0.35),
                      blurRadius: 14,
                      offset: const Offset(0, 5),
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
                        // Background decorative icon
                        Positioned(
                          right: -10,
                          bottom: -10,
                          child: Icon(
                            banner.icon,
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
                                    // Label badge
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
                                        banner.label,
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
                              // Icon container
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
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final banner = _banners[i];
            return AnimatedContainer(
              duration: AppAnimations.normal,
              curve: AppAnimations.defaultCurve,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: i == _currentPage ? 24 : 8,
              height: 8,
              decoration: BoxDecoration(
                color:
                    i == _currentPage
                        ? banner.color
                        : (isDark ? Colors.white24 : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerData {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String label;
  const _BannerData({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.label,
  });
}
