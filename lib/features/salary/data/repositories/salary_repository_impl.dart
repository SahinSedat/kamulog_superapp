import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/salary/domain/entities/salary_calculation.dart'
    as entity;
import 'package:kamulog_superapp/features/salary/domain/repositories/salary_repository.dart';

class SalaryRepositoryImpl implements SalaryRepository {
  final AppDatabase database;
  SalaryRepositoryImpl({required this.database});

  static const _uuid = Uuid();

  // ── Basit maaş hesaplama (Katsayı tabanlı)
  static const double _coefficient = 0.082987; // aylık katsayı

  double _computeSalary({
    required EmploymentType type,
    required int degree,
    required int step,
    required int serviceYears,
  }) {
    // Basitleştirilmiş hesaplama
    final baseIndicators = {
      1: 1500,
      2: 1380,
      3: 1260,
      4: 1155,
      5: 1070,
      6: 990,
      7: 915,
      8: 865,
      9: 835,
      10: 810,
      11: 790,
      12: 770,
      13: 750,
      14: 735,
      15: 720,
    };

    final indicator = baseIndicators[degree] ?? 1000;
    final totalIndicator = indicator + (step * 20) + (serviceYears * 20);
    final gross = totalIndicator * _coefficient;

    // İşçi için farklı taban (TİS)
    if (type == EmploymentType.isci) {
      return gross * 1.15; // TİS farkı
    }
    return gross;
  }

  @override
  Future<Either<Failure, entity.SalaryCalculation>> calculateSalary({
    required EmploymentType type,
    required int degree,
    required int step,
    required int serviceYears,
  }) async {
    try {
      final salary = _computeSalary(
        type: type,
        degree: degree,
        step: step,
        serviceYears: serviceYears,
      );
      final calc = entity.SalaryCalculation(
        id: _uuid.v4(),
        employmentType: type,
        degree: degree,
        step: step,
        serviceYears: serviceYears,
        calculatedSalary: salary,
        createdAt: DateTime.now(),
      );
      return Right(calc);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entity.SalaryCalculation>>> getSalaryHistory(
    String userId,
  ) async {
    try {
      final results = await database.getSalaryHistory(userId);
      return Right(
        results
            .map(
              (db) => entity.SalaryCalculation(
                id: db.id,
                userId: db.userId,
                employmentType: db.employmentType,
                degree: db.degree,
                step: db.step,
                serviceYears: db.serviceYears,
                calculatedSalary: db.calculatedSalary,
                createdAt: db.createdAt,
              ),
            )
            .toList(),
      );
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveSalaryCalc(
    entity.SalaryCalculation calc,
  ) async {
    try {
      await database.insertSalaryCalc(
        SalaryCalculationsCompanion.insert(
          id: calc.id,
          employmentType: calc.employmentType,
          degree: calc.degree,
          step: calc.step,
          serviceYears: calc.serviceYears,
          calculatedSalary: calc.calculatedSalary,
          userId: Value(calc.userId),
        ),
      );
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}
