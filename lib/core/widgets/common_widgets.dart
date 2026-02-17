import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Primary action button with loading state
class KamulogButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final IconData? icon;
  final double? width;
  final Color? backgroundColor;
  final Color? textColor;

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
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          child: _buildChild(theme, isOutlined: true),
        ),
      );
    }

    return SizedBox(
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
            isOutlined ? theme.colorScheme.primary : Colors.white,
          ),
        ),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: AppTheme.spacingSm),
          Text(text),
        ],
      );
    }

    return Text(text);
  }
}

/// Styled text field with prefix icon and error support
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

/// Elevated card with consistent styling
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
    return Card(
      color: color,
      elevation: elevation,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppTheme.spacingMd),
          child: child,
        ),
      ),
    );
  }
}

/// Empty state with icon and message
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
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
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
              KamulogButton(text: actionText!, onPressed: onAction, width: 200),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading placeholder
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          colors:
              isDark
                  ? [
                    const Color(0xFF2C2C2C),
                    const Color(0xFF3C3C3C),
                    const Color(0xFF2C2C2C),
                  ]
                  : [
                    Colors.grey.shade200,
                    Colors.grey.shade100,
                    Colors.grey.shade200,
                  ],
        ),
      ),
    );
  }

  /// Builds a list loading placeholder
  static Widget listPlaceholder({int itemCount = 5}) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppTheme.spacingMd),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppTheme.spacingSm),
      itemBuilder: (_, _) => const _ShimmerListItem(),
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
            KamulogShimmer(height: 16, width: 200),
            SizedBox(height: AppTheme.spacingSm),
            KamulogShimmer(height: 12),
            SizedBox(height: AppTheme.spacingXs),
            KamulogShimmer(height: 12, width: 150),
          ],
        ),
      ),
    );
  }
}

/// Status badge chip
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusFull),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
