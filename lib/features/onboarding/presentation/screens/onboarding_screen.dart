import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      title: 'Kamulog\'a Hoş Geldiniz',
      description:
          'Kamu ve özel sektör çalışanları için hazırlanmış Türkiye\'nin en kapsamlı platformu.',
      icon: Icons.hub_rounded,
      gradient: [Color(0xFF1565C0), Color(0xFF0D47A1)],
      features: ['Becayiş', 'Kariyer', 'Danışmanlık', 'STK'],
    ),
    _OnboardingPage(
      title: 'Kolay Becayiş',
      description:
          'Binlerce kurumdan onbinlerce memur ve işçi ile anında eşleşin. Yer değiştirme hiç bu kadar kolay olmamıştı.',
      icon: Icons.swap_horiz_rounded,
      gradient: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
      features: [
        'Akıllı Eşleşme',
        'Kurum Filtresi',
        'Şehir Bazlı',
        'AI Destek',
      ],
    ),
    _OnboardingPage(
      title: 'Kariyer & Danışmanlık',
      description:
          'İş ilanları, hukuki danışmanlık ve kariyer desteği tek ekranda. Uzmanlarla birebir görüşün.',
      icon: Icons.rocket_launch_rounded,
      gradient: [Color(0xFFE65100), Color(0xFFBF360C)],
      features: ['İş İlanları', 'Hukuk Danışma', 'Kariyer Koçu', 'Psikoloji'],
    ),
    _OnboardingPage(
      title: 'Hadi Başlayalım!',
      description:
          'Size özel içerik sunabilmemiz için birkaç soruya yanıt verin.',
      icon: Icons.flag_rounded,
      gradient: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
      features: ['Kişiselleştirilmiş', 'Bildirimler', 'Topluluk', 'Güvenli'],
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go('/onboarding-survey');
    }
  }

  void _skip() {
    context.go('/onboarding-survey');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentPage == _pages.length - 1;

    return Scaffold(
      body: Stack(
        children: [
          // Pages
          PageView.builder(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: page.gradient,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      const Spacer(flex: 2),
                      // Icon
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                            width: 2,
                          ),
                        ),
                        child: Icon(page.icon, size: 60, color: Colors.white),
                      ),
                      const SizedBox(height: 40),
                      // Title
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32),
                        child: Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Description
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 15,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Feature chips
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.center,
                        children:
                            page.features.map((f) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.2),
                                  ),
                                ),
                                child: Text(
                                  f,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              );
            },
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Dot indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: i == _currentPage ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color:
                                i == _currentPage
                                    ? Colors.white
                                    : Colors.white.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Buttons
                    Row(
                      children: [
                        if (!isLast)
                          TextButton(
                            onPressed: _skip,
                            child: Text(
                              'Atla',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _next,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primaryColor,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 14,
                            ),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                isLast ? 'Başlayalım' : 'İleri',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                isLast
                                    ? Icons.arrow_forward_rounded
                                    : Icons.chevron_right_rounded,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final List<String> features;

  const _OnboardingPage({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
    required this.features,
  });
}
