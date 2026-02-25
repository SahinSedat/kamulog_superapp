import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Lightweight bottom nav — NO BackdropFilter, NO blur.
/// FAB-style center home button.
class AnimatedBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AnimatedBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _items = [
    _NavItem(
      icon: Icons.groups_outlined,
      activeIcon: Icons.groups,
      label: 'STK',
    ),
    _NavItem(
      icon: Icons.swap_horiz_outlined,
      activeIcon: Icons.swap_horiz,
      label: 'Becayiş',
    ),
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Ana Sayfa',
    ),
    _NavItem(
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'Kariyer',
    ),
    _NavItem(
      icon: Icons.support_agent_outlined,
      activeIcon: Icons.support_agent,
      label: 'Danışmanlık',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 72 + bottomPadding,
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        border: Border(
          top: BorderSide(
            color:
                isDark
                    ? Colors.white.withValues(alpha: 0.06)
                    : const Color(0xFFEEEEEE),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            if (index == 2) {
              return _CenterFAB(
                isSelected: currentIndex == 2,
                onTap: () => onTap(2),
                isDark: isDark,
              );
            }
            return _NavBarItem(
              item: _items[index],
              isSelected: currentIndex == index,
              onTap: () => onTap(index),
              isDark: isDark,
            );
          }),
        ),
      ),
    );
  }
}

/// FAB-style center home button — elevated, gradient, bigger
class _CenterFAB extends StatelessWidget {
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CenterFAB({
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -18),
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient:
                isSelected
                    ? AppTheme.primaryGradient
                    : LinearGradient(
                      colors:
                          isDark
                              ? [
                                const Color(0xFF2A2E38),
                                const Color(0xFF22262E),
                              ]
                              : [
                                const Color(0xFFF0F0FA),
                                const Color(0xFFE8E8F5),
                              ],
                    ),
            shape: BoxShape.circle,
            boxShadow: [
              if (isSelected)
                BoxShadow(
                  color: AppTheme.primaryColor.withValues(alpha: 0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            isSelected ? Icons.home_rounded : Icons.home_outlined,
            size: 30,
            color:
                isSelected
                    ? Colors.white
                    : (isDark
                        ? AppTheme.textSecondaryDark
                        : AppTheme.textSecondaryLight),
          ),
        ),
      ),
    );
  }
}

/// Standard nav bar item — NO TweenAnimationBuilder (perf), simple AnimatedContainer
class _NavBarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _NavBarItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selectedColor =
        isDark ? AppTheme.primaryLight : AppTheme.primaryColor;
    final unselectedColor =
        isDark ? AppTheme.textSecondaryDark : AppTheme.textSecondaryLight;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Indicator dot
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 24 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.primaryGradient : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon
            Icon(
              isSelected ? item.activeIcon : item.icon,
              size: 24,
              color: isSelected ? selectedColor : unselectedColor,
            ),
            const SizedBox(height: 3),
            // Label
            Text(
              item.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
