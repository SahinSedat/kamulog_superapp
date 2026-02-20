import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class BecayisAd extends Equatable {
  final String id;
  final String ownerId;
  final String sourceCity;
  final String targetCity;
  final String profession;
  final String? description;
  final BecayisStatus status;
  final bool isPremium;
  final EmploymentType? employmentType;
  final DateTime? createdAt;

  const BecayisAd({
    required this.id,
    required this.ownerId,
    required this.sourceCity,
    required this.targetCity,
    required this.profession,
    this.description,
    this.status = BecayisStatus.active,
    this.isPremium = false,
    this.employmentType,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    ownerId,
    sourceCity,
    targetCity,
    profession,
    description,
    status,
    isPremium,
    employmentType,
    createdAt,
  ];
}
