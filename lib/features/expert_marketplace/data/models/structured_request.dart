/// AI tarafından yapılandırılmış danışmanlık talebi
class StructuredRequest {
  final String expertId;
  final String packageId;
  final String summary;
  final String detailedBriefing;
  final List<String> keyPoints;
  final List<String> missingInfo;
  final String rawUserInput;
  final DateTime createdAt;

  const StructuredRequest({
    required this.expertId,
    required this.packageId,
    required this.summary,
    required this.detailedBriefing,
    this.keyPoints = const [],
    this.missingInfo = const [],
    this.rawUserInput = '',
    required this.createdAt,
  });
}
