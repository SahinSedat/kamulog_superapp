import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/danismanlik/domain/entities/consultant.dart'
    as entity;
import 'package:kamulog_superapp/features/danismanlik/domain/repositories/consultant_repository.dart';

class ConsultantRepositoryImpl implements ConsultantRepository {
  final AppDatabase database;

  ConsultantRepositoryImpl({required this.database});

  @override
  Future<Either<Failure, List<entity.Consultant>>> getConsultants({
    ConsultantCategory? category,
    bool? onlineOnly,
  }) async {
    try {
      List<Consultant> results;
      if (category != null) {
        results = await database.getConsultantsByCategory(category);
      } else if (onlineOnly == true) {
        results = await database.getOnlineConsultants();
      } else {
        results = await database.getAllConsultants();
      }
      return Right(results.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.Consultant>> getConsultantById(
    String id,
  ) async {
    try {
      final all = await database.getAllConsultants();
      final found = all.firstWhere((c) => c.id == id);
      return Right(_toEntity(found));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  entity.Consultant _toEntity(Consultant db) {
    return entity.Consultant(
      id: db.id,
      userId: db.userId,
      category: db.category,
      hourlyRate: db.hourlyRate,
      rating: db.rating,
      isOnline: db.isOnline,
      fullName: db.fullName,
      avatarUrl: db.avatarUrl,
      bio: db.bio,
    );
  }
}
