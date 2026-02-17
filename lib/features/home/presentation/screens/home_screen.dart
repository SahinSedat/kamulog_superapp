import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/animated_bottom_nav.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/features/stk/presentation/screens/stk_screen.dart';
import 'package:kamulog_superapp/features/becayis/presentation/screens/becayis_screen.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/screens/kariyer_screen.dart';
import 'package:kamulog_superapp/features/home/presentation/widgets/home_dashboard.dart';
import 'package:kamulog_superapp/features/ai/presentation/screens/ai_assistant_screen.dart';
import 'package:kamulog_superapp/features/ai/presentation/providers/ai_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  // Tabs: 0=STK, 1=Becayiş, 2=HomeDashboard, 3=Kariyer, 4=AI Asistan
  int _currentIndex = 2; // Start on Home
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
    if (index == _currentIndex) return;
    _fadeController.forward(from: 0);
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar:
          _currentIndex == 4
              ? _buildAiAppBar(theme, isDark)
              : _buildMainAppBar(user, theme, isDark),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: IndexedStack(index: _currentIndex, children: _screens),
      ),
      bottomNavigationBar: AnimatedBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabChanged,
      ),
    );
  }

  PreferredSizeWidget _buildAiAppBar(ThemeData theme, bool isDark) {
    final aiState = ref.watch(aiChatProvider);
    final hasMessages = aiState.messages.isNotEmpty;

    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 20,
          color: theme.textTheme.bodyLarge?.color,
        ),
        onPressed: () {
          if (hasMessages) {
            // Chat mode → go back to AI welcome screen
            ref.read(aiChatProvider.notifier).newConversation();
          } else {
            // Welcome mode → go back to Home tab
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
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
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
            icon: Icon(
              Icons.add_comment_outlined,
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
              size: 22,
            ),
            tooltip: 'Yeni Sohbet',
            onPressed:
                () => ref.read(aiChatProvider.notifier).newConversation(),
          ),
        const SizedBox(width: 4),
      ],
    );
  }

  PreferredSizeWidget _buildMainAppBar(
    dynamic user,
    ThemeData theme,
    bool isDark,
  ) {
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
      title: Row(
        children: [
          // AI gradient logo
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: AppTheme.aiGradient,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 18,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Kamulog',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: theme.textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                'AI Destekli Platform',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppTheme.accentLight : AppTheme.accentColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Notification bell
        IconButton(
          icon: Badge(
            smallSize: 8,
            backgroundColor: AppTheme.errorColor,
            child: Icon(
              Icons.notifications_outlined,
              color: theme.textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
            ),
          ),
          onPressed: () {},
        ),
        // User avatar menu
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: PopupMenuButton<String>(
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                gradient: AppTheme.aiGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
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
            onSelected: (value) {
              if (value == 'logout') {
                ref.read(authProvider.notifier).logout();
              }
            },
            itemBuilder:
                (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? 'Kullanıcı',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          user?.phone ?? '',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'profile',
                    child: ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text('Profil'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'settings',
                    child: ListTile(
                      leading: Icon(Icons.settings_outlined),
                      title: Text('Ayarlar'),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuDivider(),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout, color: AppTheme.errorColor),
                      title: Text(
                        'Çıkış Yap',
                        style: TextStyle(color: AppTheme.errorColor),
                      ),
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
          ),
        ),
      ],
    );
  }
}
