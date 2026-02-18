import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/theme/app_animations.dart';

/// Custom animated bottom navigation bar with a centered elevated home button.
/// Features: glassmorphism background, gradient indicators, scale animations,
/// and a floating home button with AI-themed gradient.
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
    ), // Center
    _NavItem(
      icon: Icons.work_outline,
      activeIcon: Icons.work,
      label: 'Kariyer',
    ),
    _NavItem(
      icon: Icons.smart_toy_outlined,
      activeIcon: Icons.smart_toy,
      label: 'AI Asistan',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 72 + bottomPadding,
          decoration: BoxDecoration(
            color:
                isDark
                    ? AppTheme.cardDark.withValues(alpha: 0.85)
                    : Colors.white.withValues(alpha: 0.88),
            border: Border(
              top: BorderSide(
                color:
                    isDark
                        ? Colors.white.withValues(alpha: 0.06)
                        : const Color(0xFFEEEDF5),
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                blurRadius: 24,
                offset: const Offset(0, -6),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_items.length, (index) {
                if (index == 2) {
                  // Center home button
                  return _CenterHomeButton(
                    isSelected: currentIndex == 2,
                    onTap: () => onTap(2),
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
        ),
      ),
    );
  }
}

/// The elevated center home button with gradient background
class _CenterHomeButton extends StatefulWidget {
  final bool isSelected;
  final VoidCallback onTap;

  const _CenterHomeButton({required this.isSelected, required this.onTap});

  @override
  State<_CenterHomeButton> createState() => _CenterHomeButtonState();
}

class _CenterHomeButtonState extends State<_CenterHomeButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppAnimations.fast,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _controller, curve: AppAnimations.defaultCurve),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Transform.translate(
          offset: const Offset(0, -14),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient:
                  widget.isSelected
                      ? AppTheme.pastelGradient
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
                if (widget.isSelected)
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              widget.isSelected ? Icons.home_rounded : Icons.home_outlined,
              size: 28,
              color:
                  widget.isSelected
                      ? Colors.white
                      : (isDark
                          ? AppTheme.textSecondaryDark
                          : AppTheme.textSecondaryLight),
            ),
          ),
        ),
      ),
    );
  }
}

/// Standard nav bar item with animated slot indicator
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
            // Animated indicator dot
            AnimatedContainer(
              duration: AppAnimations.normal,
              curve: AppAnimations.defaultCurve,
              width: isSelected ? 24 : 0,
              height: 3,
              margin: const EdgeInsets.only(bottom: 5),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.pastelGradient : null,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Icon with scale
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 1.0, end: isSelected ? 1.12 : 1.0),
              duration: AppAnimations.normal,
              curve: AppAnimations.defaultCurve,
              builder: (context, scale, child) {
                return Transform.scale(
                  scale: scale,
                  child: Icon(
                    isSelected ? item.activeIcon : item.icon,
                    size: 24,
                    color: isSelected ? selectedColor : unselectedColor,
                  ),
                );
              },
            ),
            const SizedBox(height: 3),
            // Label
            AnimatedDefaultTextStyle(
              duration: AppAnimations.fast,
              style: TextStyle(
                fontSize: 10,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              child: Text(item.label),
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
