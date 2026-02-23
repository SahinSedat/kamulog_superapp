import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/animated_bottom_nav.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/stk/presentation/screens/stk_screen.dart';
import 'package:kamulog_superapp/features/becayis/presentation/screens/becayis_screen.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/screens/kariyer_screen.dart';
import 'package:kamulog_superapp/features/home/presentation/widgets/home_dashboard.dart';
import 'package:kamulog_superapp/features/ai/presentation/screens/ai_assistant_screen.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';
import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;

  final _screens = const [
    StkScreen(),
    BecayisScreen(),
    HomeDashboard(),
    KariyerScreen(),
    AiAssistantScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTabChanged(int index) {
    final currentIndex = ref.read(homeNavigationProvider);
    if (index == currentIndex) return;
    _fadeController.forward(from: 0);
    ref.read(homeNavigationProvider.notifier).setIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentIndex = ref.watch(homeNavigationProvider);
    return Scaffold(
      body:
          currentIndex == 2
              ? _buildHomeWithHeader(user, theme, isDark)
              : currentIndex == 4
              ? _buildAiScreen(theme, isDark)
              : _buildRegularScreen(user, theme, isDark),
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  // ── Section 1: HOME tab — gradient header + dashboard
  Widget _buildHomeWithHeader(dynamic user, ThemeData theme, bool isDark) {
    return Column(
      children: [
        // ── GRADIENT HEADER with search
        Container(
          decoration: const BoxDecoration(gradient: AppTheme.headerGradient),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: Column(
                children: [
                  // Top row: Logo + Notifications + Profile
                  Row(
                    children: [
                      // Logo
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/kamulog_logo.png',
                            width: 24,
                            height: 24,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Kamulog',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Hoş geldin, ${(user?.name ?? 'Kullanıcı').split(' ').first}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      _HeaderIcon(
                        icon: Icons.notifications_outlined,
                        badgeCount: 3,
                        onTap: () => context.push('/notifications'),
                      ),
                      const SizedBox(width: 8),
                      // Profile
                      GestureDetector(
                        onTap: () => context.push('/profile'),
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              (user?.name ?? 'K').substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // ── AI-powered search bar
                  GestureDetector(
                    onTap: () => context.push('/search'),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          Icon(
                            Icons.search_rounded,
                            color: Colors.grey[400],
                            size: 22,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Becayiş, kariyer, danışmanlık ara...',
                              style: TextStyle(
                                color: Colors.grey[400],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: AppTheme.aiGradient,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.auto_awesome,
                                  size: 14,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'AI',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        // ── Dashboard body
        Expanded(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _screens[ref.watch(homeNavigationProvider)],
          ),
        ),
      ],
    );
  }

  // ── AI Tab
  Widget _buildAiScreen(ThemeData theme, bool isDark) {
    final aiState = ref.watch(aiChatProvider);
    final hasMessages = aiState.messages.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () {
            if (hasMessages) {
              ref.read(aiChatProvider.notifier).newConversation();
            } else {
              _onTabChanged(2);
            }
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                gradient: AppTheme.aiGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.auto_awesome,
                size: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            ShaderMask(
              shaderCallback:
                  (bounds) => AppTheme.aiGradient.createShader(bounds),
              child: Text(
                hasMessages ? 'Kamulog AI' : 'AI Asistan',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          if (hasMessages)
            IconButton(
              icon: const Icon(Icons.add_comment_outlined, size: 22),
              onPressed:
                  () => ref.read(aiChatProvider.notifier).newConversation(),
            ),
          const SizedBox(width: 4),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _screens[ref.watch(homeNavigationProvider)],
      ),
    );
  }

  // ── Regular screens (STK, Becayiş, Kariyer)
  Widget _buildRegularScreen(dynamic user, ThemeData theme, bool isDark) {
    final titles = ['STK', 'Becayiş', '', 'Kariyer', ''];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        title: Text(
          titles[ref.watch(homeNavigationProvider)],
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        actions: [
          IconButton(
            icon: Badge(
              smallSize: 8,
              backgroundColor: AppTheme.errorColor,
              child: Icon(
                Icons.notifications_outlined,
                color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              ),
            ),
            onPressed: () => context.push('/notifications'),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => context.push('/profile'),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    (user?.name ?? 'K').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _screens[ref.watch(homeNavigationProvider)],
    );
  }
}

// ── Header icon with badge
class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final int badgeCount;
  final VoidCallback onTap;

  const _HeaderIcon({
    required this.icon,
    required this.badgeCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          shape: BoxShape.circle,
        ),
        child:
            badgeCount > 0
                ? Badge(
                  label: Text(
                    '$badgeCount',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  backgroundColor: AppTheme.errorColor,
                  child: Icon(icon, color: Colors.white, size: 20),
                )
                : Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}
