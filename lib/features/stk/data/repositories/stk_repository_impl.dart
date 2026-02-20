import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/stk/domain/entities/stk_organization.dart'
    as entity;
import 'package:kamulog_superapp/features/stk/domain/entities/stk_announcement.dart'
    as ann_entity;
import 'package:kamulog_superapp/features/stk/domain/repositories/stk_repository.dart';

class StkRepositoryImpl implements StkRepository {
  final AppDatabase database;
  StkRepositoryImpl({required this.database});

  @override
  Future<Either<Failure, List<entity.StkOrganization>>> getOrganizations({
    StkType? type,
  }) async {
    try {
      final results = await database.getAllStkOrganizations();
      final filtered =
          type == null
              ? results
              : results.where((o) => o.type == type).toList();
      return Right(filtered.map(_toOrgEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, entity.StkOrganization>> getOrganizationById(
    String id,
  ) async {
    try {
      final all = await database.getAllStkOrganizations();
      final found = all.firstWhere((o) => o.id == id);
      return Right(_toOrgEntity(found));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ann_entity.StkAnnouncement>>> getAnnouncements({
    String? orgId,
  }) async {
    try {
      List<StkAnnouncement> results;
      if (orgId != null) {
        results = await database.getAnnouncementsByOrg(orgId);
      } else {
        results = await database.getAllAnnouncements();
      }
      return Right(results.map(_toAnnEntity).toList());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  entity.StkOrganization _toOrgEntity(StkOrganization db) {
    return entity.StkOrganization(
      id: db.id,
      name: db.name,
      type: db.type,
      description: db.description,
      logoUrl: db.logoUrl,
      city: db.city,
      memberCount: db.memberCount,
      isVerified: db.isVerified,
      createdAt: db.createdAt,
    );
  }

  ann_entity.StkAnnouncement _toAnnEntity(StkAnnouncement db) {
    return ann_entity.StkAnnouncement(
      id: db.id,
      organizationId: db.organizationId,
      title: db.title,
      content: db.content,
      isPublic: db.isPublic,
      createdAt: db.createdAt,
    );
  }
}
