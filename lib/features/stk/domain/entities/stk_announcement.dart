import 'package:equatable/equatable.dart';

class StkAnnouncement extends Equatable {
  final String id;
  final String organizationId;
  final String title;
  final String content;
  final bool isPublic;
  final DateTime? createdAt;

  const StkAnnouncement({
    required this.id,
    required this.organizationId,
    required this.title,
    required this.content,
    this.isPublic = true,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, organizationId, title, isPublic];
}
