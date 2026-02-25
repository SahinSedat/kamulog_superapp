import 'package:flutter/material.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';

/// Kategori kartı — Keşfet ekranındaki grid, responsive
class CategoryCard extends StatelessWidget {
  final ExpertCategory category;
  final VoidCallback onTap;
  final bool isDark;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color:
              isDark
                  ? category.color.withValues(alpha: 0.12)
                  : category.color.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: category.color.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(category.icon, color: category.color, size: 18),
            ),
            const SizedBox(height: 6),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              category.description,
              style: TextStyle(
                fontSize: 9,
                color: isDark ? Colors.white54 : Colors.black45,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
