import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/salary/domain/entities/salary_calculation.dart';

abstract class SalaryRepository {
  Future<Either<Failure, SalaryCalculation>> calculateSalary({
    required EmploymentType type,
    required int degree,
    required int step,
    required int serviceYears,
  });
  Future<Either<Failure, List<SalaryCalculation>>> getSalaryHistory(
    String userId,
  );
  Future<Either<Failure, void>> saveSalaryCalc(SalaryCalculation calc);
}
