/// Uzman değerlendirmesi / yorumu
class ExpertReview {
  final String id;
  final String reviewerName;
  final double rating;
  final String comment;
  final DateTime date;

  const ExpertReview({
    required this.id,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
  });

  String get formattedDate {
    const months = [
      '',
      'Oca',
      'Şub',
      'Mar',
      'Nis',
      'May',
      'Haz',
      'Tem',
      'Ağu',
      'Eyl',
      'Eki',
      'Kas',
      'Ara',
    ];
    return '${date.day} ${months[date.month]} ${date.year}';
  }
}
