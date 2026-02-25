import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/service_package.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_review.dart';

/// Uzman profili — pazar yeri ilanı
class ExpertProfile {
  final String id;
  final String name;
  final String title;
  final ExpertCategoryType category;
  final double rating;
  final int reviewCount;
  final int experienceYears;
  final String? avatarUrl;
  final String bio;
  final List<String> specializations;
  final List<ServicePackage> packages;
  final List<ExpertReview> reviews;
  final bool isOnline;
  final bool isFeatured;
  final int completedConsultations;

  const ExpertProfile({
    required this.id,
    required this.name,
    required this.title,
    required this.category,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.experienceYears = 0,
    this.avatarUrl,
    this.bio = '',
    this.specializations = const [],
    this.packages = const [],
    this.reviews = const [],
    this.isOnline = false,
    this.isFeatured = false,
    this.completedConsultations = 0,
  });

  /// En düşük fiyatlı paket
  String get priceLabel {
    if (packages.isEmpty) return 'Ücretsiz';
    final minPrice = packages
        .map((p) => p.price)
        .reduce((a, b) => a < b ? a : b);
    if (minPrice == 0) return 'Ücretsiz';
    return '₺${minPrice.toStringAsFixed(0)}\'den başlayan';
  }

  /// Ücretsiz paketi var mı?
  bool get hasFreePackage => packages.any((p) => p.price == 0);

  ExpertCategory get categoryInfo => ExpertCategory.fromType(category);
}
