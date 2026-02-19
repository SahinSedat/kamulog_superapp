import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/animated_widgets.dart';

// ══════════════════════════════════════════════════════════════
// ── KamulogButton — Primary action button with press animation
// ══════════════════════════════════════════════════════════════

class KamulogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;
  final LinearGradient? gradient;

  const KamulogButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.backgroundColor,
    this.textColor,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (gradient != null && !isOutlined) {
      return ScaleOnTap(
        onTap: isLoading ? null : onPressed,
        child: Container(
          width: width ?? double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: gradient,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            boxShadow: [
              BoxShadow(
                color: (gradient!.colors.first).withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(child: _buildChild(theme)),
        ),
      );
    }

    if (isOutlined) {
      return ScaleOnTap(
        onTap: isLoading ? null : onPressed,
        child: SizedBox(
          width: width ?? double.infinity,
          height: 52,
          child: OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            child: _buildChild(theme, isOutlined: true),
          ),
        ),
      );
    }

    return ScaleOnTap(
      onTap: isLoading ? null : onPressed,
      child: SizedBox(
        width: width ?? double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style:
              backgroundColor != null
                  ? ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    foregroundColor: textColor ?? Colors.white,
                  )
                  : null,
          child: _buildChild(theme),
        ),
      ),
    );
  }

  Widget _buildChild(ThemeData theme, {bool isOutlined = false}) {
    if (isLoading) {
      return SizedBox(
        height: 22,
        width: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            isOutlined
                ? theme.colorScheme.primary
                : (gradient != null ? Colors.white : Colors.white),
          ),
        ),
      );
    }

    final textStyle = TextStyle(
      color:
          gradient != null
              ? Colors.white
              : (isOutlined ? theme.colorScheme.primary : null),
      fontSize: 15,
      fontWeight: FontWeight.w600,
    );

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: gradient != null ? Colors.white : null),
          const SizedBox(width: AppTheme.spacingSm),
          Text(text, style: gradient != null ? textStyle : null),
        ],
      );
    }

    return Text(text, style: gradient != null ? textStyle : null);
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogTextField — Styled input field
// ══════════════════════════════════════════════════════════════

class KamulogTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final List<dynamic>? inputFormatters;

  const KamulogTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      readOnly: readOnly,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon:
            prefixIcon != null
                ? Icon(prefixIcon, color: Theme.of(context).colorScheme.primary)
                : null,
        suffixIcon: suffix,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogCard — Soft shadow card with tap animation
// ══════════════════════════════════════════════════════════════

class KamulogCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final double? elevation;

  const KamulogCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardWidget = Container(
      decoration: AppTheme.softCardDecoration(isDark: isDark),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppTheme.spacingMd),
            child: child,
          ),
        ),
      ),
    );

    if (onTap != null) {
      return ScaleOnTap(onTap: onTap, child: cardWidget);
    }
    return cardWidget;
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogGlassCard — Glassmorphism card
// ══════════════════════════════════════════════════════════════

class KamulogGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final double borderRadius;

  const KamulogGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.borderRadius = AppTheme.radiusLg,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: AppTheme.glassDecoration(
            isDark: isDark,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(borderRadius),
              child: Padding(
                padding: padding ?? const EdgeInsets.all(AppTheme.spacingMd),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );

    if (onTap != null) {
      return ScaleOnTap(onTap: onTap, child: card);
    }
    return card;
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogAiCard — AI suggestion card with gradient border
// ══════════════════════════════════════════════════════════════

class KamulogAiCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final VoidCallback? onTap;
  final LinearGradient gradient;

  const KamulogAiCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.onTap,
    this.gradient = AppTheme.aiGradient,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return ScaleOnTap(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusLg),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.5),
          padding: const EdgeInsets.all(AppTheme.spacingMd),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusLg - 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                ),
                child: Icon(icon, color: Colors.white, size: 22),
              ),
              const SizedBox(width: AppTheme.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.titleSmall),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: theme.textTheme.bodySmall?.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogSectionHeader — Section title with "See All" button
// ══════════════════════════════════════════════════════════════

class KamulogSectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onAction;
  final IconData? icon;

  const KamulogSectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onAction,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMd,
        vertical: AppTheme.spacingSm,
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: AppTheme.spacingSm),
          ],
          Text(title, style: theme.textTheme.titleMedium),
          const Spacer(),
          if (actionText != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogEmptyState — Empty state with icon and message
// ══════════════════════════════════════════════════════════════

class KamulogEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const KamulogEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary.withValues(alpha: 0.1),
                    theme.colorScheme.secondary.withValues(alpha: 0.08),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: theme.colorScheme.primary.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppTheme.spacingLg),
            Text(
              title,
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacingSm),
              Text(
                subtitle!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: AppTheme.spacingLg),
              KamulogButton(
                text: actionText!,
                onPressed: onAction,
                width: 200,
                gradient: AppTheme.primaryGradient,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogShimmer — Legacy shimmer placeholder (kept for compatibility)
// ══════════════════════════════════════════════════════════════

class KamulogShimmer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const KamulogShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppTheme.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }

  /// Builds a list loading placeholder
  static Widget listPlaceholder({int itemCount = 5}) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (_, __) => const _ShimmerListItem(),
    );
  }
}

class _ShimmerListItem extends StatelessWidget {
  const _ShimmerListItem();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacingMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SkeletonLoader(height: 16, width: 200),
            SizedBox(height: AppTheme.spacingSm),
            SkeletonLoader(height: 12),
            SizedBox(height: AppTheme.spacingXs),
            SkeletonLoader(height: 12, width: 150),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── KamulogBadge — Status badge chip
// ══════════════════════════════════════════════════════════════

class KamulogBadge extends StatelessWidget {
  final String text;
  final Color color;
  final IconData? icon;

  const KamulogBadge({
    super.key,
    required this.text,
    required this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingSm + 2,
        vertical: AppTheme.spacingXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
