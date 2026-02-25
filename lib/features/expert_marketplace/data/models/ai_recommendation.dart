import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';

/// AI tarafından üretilen uzman önerisi
class AIRecommendation {
  final ExpertCategoryType suggestedCategory;
  final double confidenceScore; // 0.0 - 1.0
  final String explanation;
  final List<String> suggestedExpertIds;
  final List<String> followUpQuestions;

  const AIRecommendation({
    required this.suggestedCategory,
    required this.confidenceScore,
    required this.explanation,
    this.suggestedExpertIds = const [],
    this.followUpQuestions = const [],
  });
}
