import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/service_package.dart';

/// Hizmet paketi kartı — Uzman detay ekranında
class ServicePackageCard extends StatelessWidget {
  final ServicePackage package;
  final VoidCallback onTap;
  final bool isDark;
  final bool isSelected;

  const ServicePackageCard({
    super.key,
    required this.package,
    required this.onTap,
    required this.isDark,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected
            ? AppTheme.primaryColor
            : (isDark ? Colors.white12 : Colors.grey.shade200);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppTheme.primaryColor.withValues(alpha: 0.06)
                  : (isDark ? AppTheme.cardDark : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    package.name,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppTheme.primaryColor : null,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color:
                        package.isFree
                            ? AppTheme.successColor.withValues(alpha: 0.1)
                            : AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    package.priceLabel,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color:
                          package.isFree
                              ? AppTheme.successColor
                              : AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              package.description,
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white60 : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            // Süre & İçerikler
            Row(
              children: [
                Icon(Icons.timer_outlined, size: 14, color: Colors.grey[400]),
                const SizedBox(width: 4),
                Text(
                  package.duration,
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                if (package.isPremium) ...[
                  const SizedBox(width: 10),
                  Icon(
                    Icons.workspace_premium,
                    size: 14,
                    color: Colors.amber[700],
                  ),
                  const SizedBox(width: 3),
                  Text(
                    'Premium',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.amber[700],
                    ),
                  ),
                ],
              ],
            ),
            if (package.includes.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children:
                    package.includes.map((item) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isDark
                                  ? Colors.white.withValues(alpha: 0.06)
                                  : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.check_circle,
                              size: 12,
                              color: AppTheme.successColor,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item,
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
