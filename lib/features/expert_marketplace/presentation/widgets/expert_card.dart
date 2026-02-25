import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_profile.dart';

/// Uzman kartı — listeleme ve keşfet ekranında
class ExpertCard extends StatelessWidget {
  final ExpertProfile expert;
  final VoidCallback onTap;
  final bool isDark;
  final bool isCompact; // horizontal scroll için

  const ExpertCard({
    super.key,
    required this.expert,
    required this.onTap,
    required this.isDark,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isCompact) return _buildCompact();
    return _buildFull();
  }

  Widget _buildCompact() {
    final catInfo = expert.categoryInfo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar + online badge
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: catInfo.color.withValues(alpha: 0.15),
                  child: Text(
                    expert.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(
                      color: catInfo.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
                if (expert.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppTheme.cardDark : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              expert.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              expert.title,
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white54 : Colors.grey[600],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                const SizedBox(width: 3),
                Text(
                  expert.rating.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  expert.priceLabel,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color:
                        expert.hasFreePackage
                            ? AppTheme.successColor
                            : AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFull() {
    final catInfo = expert.categoryInfo;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white10 : Colors.grey.shade200,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: catInfo.color.withValues(alpha: 0.15),
                  child: Text(
                    expert.name.split(' ').map((w) => w[0]).take(2).join(),
                    style: TextStyle(
                      color: catInfo.color,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                ),
                if (expert.isOnline)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDark ? AppTheme.cardDark : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          expert.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (expert.isFeatured)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: const Text(
                            '⭐ Öne Çıkan',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: Colors.amber,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    expert.title,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 15,
                        color: Colors.amber,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${expert.rating.toStringAsFixed(1)} (${expert.reviewCount})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Icon(
                        Icons.work_outline_rounded,
                        size: 13,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${expert.experienceYears} yıl',
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color:
                              expert.hasFreePackage
                                  ? AppTheme.successColor.withValues(alpha: 0.1)
                                  : AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          expert.priceLabel,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color:
                                expert.hasFreePackage
                                    ? AppTheme.successColor
                                    : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
