import 'package:drift/drift.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/becayis/domain/entities/becayis_ad.dart'
    as entity;
import 'package:kamulog_superapp/features/becayis/domain/repositories/becayis_repository.dart';
import 'package:uuid/uuid.dart';

class BecayisRepositoryImpl implements BecayisRepository {
  final AppDatabase database;

  BecayisRepositoryImpl({required this.database});

  @override
  Future<Either<Failure, List<entity.BecayisAd>>> getAds({
    String? targetCity,
    EmploymentType? type,
    String? profession,
  }) async {
    try {
      List<BecayisAd> results;
      if (targetCity != null) {
        results = await database.getBecayisAdsByCity(targetCity);
      } else if (type != null) {
        results = await database.getBecayisAdsByType(type);
      } else {
        results = await database.getAllBecayisAds();
      }

      if (profession != null) {
        results = results.where((ad) => ad.profession == profession).toList();
      }

      return Right(results.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.BecayisAd>> createAd(
    entity.BecayisAd ad,
  ) async {
    try {
      final id = ad.id.isEmpty ? const Uuid().v4() : ad.id;
      final companion = BecayisAdsCompanion(
        id: Value(id),
        ownerId: Value(ad.ownerId),
        sourceCity: Value(ad.sourceCity),
        targetCity: Value(ad.targetCity),
        profession: Value(ad.profession),
        description: Value(ad.description),
        status: Value(ad.status),
        isPremium: Value(ad.isPremium),
        employmentType: Value(ad.employmentType),
      );
      await database.insertBecayisAd(companion);
      return Right(
        entity.BecayisAd(
          id: id,
          ownerId: ad.ownerId,
          sourceCity: ad.sourceCity,
          targetCity: ad.targetCity,
          profession: ad.profession,
          description: ad.description,
          status: ad.status,
          isPremium: ad.isPremium,
          employmentType: ad.employmentType,
        ),
      );
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAd(String id) async {
    try {
      await (database.delete(database.becayisAds)
        ..where((t) => t.id.equals(id))).go();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<entity.BecayisAd>>> findMatches(
    String adId,
  ) async {
    try {
      // Spec: Kullanıcının hedef ilinde, onun iline gelmek isteyen biri varsa eşleşme
      final allAds = await database.getAllBecayisAds();
      final currentAd = allAds.firstWhere((a) => a.id == adId);

      final matches = allAds.where(
        (ad) =>
            ad.id != adId &&
            ad.targetCity == currentAd.sourceCity &&
            ad.sourceCity == currentAd.targetCity &&
            ad.profession == currentAd.profession &&
            ad.status == BecayisStatus.active,
      );

      return Right(matches.map(_toEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  entity.BecayisAd _toEntity(BecayisAd db) {
    return entity.BecayisAd(
      id: db.id,
      ownerId: db.ownerId,
      sourceCity: db.sourceCity,
      targetCity: db.targetCity,
      profession: db.profession,
      description: db.description,
      status: db.status,
      isPremium: db.isPremium,
      employmentType: db.employmentType,
      createdAt: db.createdAt,
    );
  }
}
