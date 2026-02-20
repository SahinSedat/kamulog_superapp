import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class JobListing extends Equatable {
  final String id;
  final String title;
  final String company;
  final String city;
  final String? description;
  final String? requirements;
  final EmploymentType? employmentType;
  final String? category;
  final double? salaryMin;
  final double? salaryMax;
  final bool isActive;
  final DateTime? deadline;
  final DateTime? createdAt;

  const JobListing({
    required this.id,
    required this.title,
    required this.company,
    required this.city,
    this.description,
    this.requirements,
    this.employmentType,
    this.category,
    this.salaryMin,
    this.salaryMax,
    this.isActive = true,
    this.deadline,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    company,
    city,
    employmentType,
    isActive,
  ];
}
