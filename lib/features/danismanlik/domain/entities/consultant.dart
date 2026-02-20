import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class Consultant extends Equatable {
  final String id;
  final String userId;
  final ConsultantCategory category;
  final double hourlyRate;
  final double rating;
  final bool isOnline;
  final String? fullName;
  final String? avatarUrl;
  final String? bio;

  const Consultant({
    required this.id,
    required this.userId,
    required this.category,
    this.hourlyRate = 0.0,
    this.rating = 0.0,
    this.isOnline = false,
    this.fullName,
    this.avatarUrl,
    this.bio,
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    category,
    hourlyRate,
    rating,
    isOnline,
    fullName,
    avatarUrl,
    bio,
  ];
}
