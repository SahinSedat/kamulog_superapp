import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/features/kariyer/domain/entities/job_listing.dart'
    as entity;
import 'package:kamulog_superapp/features/kariyer/domain/repositories/kariyer_repository.dart';

class KariyerRepositoryImpl implements KariyerRepository {
  final AppDatabase database;
  KariyerRepositoryImpl({required this.database});

  @override
  Future<Either<Failure, List<entity.JobListing>>> getJobListings({
    String? city,
    EmploymentType? type,
    String? category,
  }) async {
    try {
      List<JobListing> results;
      if (city != null) {
        results = await database.getJobListingsByCity(city);
      } else {
        results = await database.getAllJobListings();
      }
      return Right(results.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.JobListing>> getJobListingById(
    String id,
  ) async {
    try {
      final all = await database.getAllJobListings();
      final found = all.firstWhere((j) => j.id == id);
      return Right(_toEntity(found));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entity.JobListing>>> getActiveListings() async {
    try {
      final results = await database.getActiveJobListings();
      return Right(results.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  entity.JobListing _toEntity(JobListing db) {
    return entity.JobListing(
      id: db.id,
      title: db.title,
      company: db.company,
      city: db.city,
      description: db.description,
      requirements: db.requirements,
      employmentType: db.employmentType,
      category: db.category,
      salaryMin: db.salaryMin,
      salaryMax: db.salaryMax,
      isActive: db.isActive,
      deadline: db.deadline,
      createdAt: db.createdAt,
    );
  }
}
