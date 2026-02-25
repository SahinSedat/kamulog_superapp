import 'package:flutter/material.dart';

/// Uzman Pazar Yeri kategorileri
enum ExpertCategoryType { hukuki, idari, mali, kariyer, psikolojik, diger }

class ExpertCategory {
  final ExpertCategoryType type;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const ExpertCategory({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });

  static const List<ExpertCategory> all = [
    ExpertCategory(
      type: ExpertCategoryType.hukuki,
      name: 'Hukuki',
      description: 'İdare hukuku, ceza, iş hukuku',
      icon: Icons.gavel_rounded,
      color: Color(0xFF6366F1),
    ),
    ExpertCategory(
      type: ExpertCategoryType.idari,
      name: 'İdari',
      description: 'Atama, tayin, sicil işlemleri',
      icon: Icons.account_balance_rounded,
      color: Color(0xFF0EA5E9),
    ),
    ExpertCategory(
      type: ExpertCategoryType.mali,
      name: 'Mali',
      description: 'Maaş, vergi, özlük hakları',
      icon: Icons.account_balance_wallet_rounded,
      color: Color(0xFF10B981),
    ),
    ExpertCategory(
      type: ExpertCategoryType.kariyer,
      name: 'Kariyer',
      description: 'CV, iş arama, kariyer planı',
      icon: Icons.trending_up_rounded,
      color: Color(0xFFF59E0B),
    ),
    ExpertCategory(
      type: ExpertCategoryType.psikolojik,
      name: 'Psikolojik',
      description: 'İş stresi, tükenmişlik, motivasyon',
      icon: Icons.psychology_rounded,
      color: Color(0xFFEC4899),
    ),
    ExpertCategory(
      type: ExpertCategoryType.diger,
      name: 'Diğer',
      description: 'Genel danışmanlık',
      icon: Icons.more_horiz_rounded,
      color: Color(0xFF8B5CF6),
    ),
  ];

  static ExpertCategory fromType(ExpertCategoryType type) {
    return all.firstWhere((c) => c.type == type);
  }
}
