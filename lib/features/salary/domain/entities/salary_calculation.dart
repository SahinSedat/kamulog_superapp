import 'package:equatable/equatable.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class SalaryCalculation extends Equatable {
  final String id;
  final String? userId;
  final EmploymentType employmentType;
  final int degree;
  final int step;
  final int serviceYears;
  final double calculatedSalary;
  final DateTime? createdAt;

  const SalaryCalculation({
    required this.id,
    this.userId,
    required this.employmentType,
    required this.degree,
    required this.step,
    required this.serviceYears,
    required this.calculatedSalary,
    this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    employmentType,
    degree,
    step,
    calculatedSalary,
  ];
}
