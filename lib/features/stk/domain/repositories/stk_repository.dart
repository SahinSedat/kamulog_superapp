import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/stk/domain/entities/stk_organization.dart';
import 'package:kamulog_superapp/features/stk/domain/entities/stk_announcement.dart';

abstract class StkRepository {
  Future<Either<Failure, List<StkOrganization>>> getOrganizations({
    StkType? type,
  });
  Future<Either<Failure, StkOrganization>> getOrganizationById(String id);
  Future<Either<Failure, List<StkAnnouncement>>> getAnnouncements({
    String? orgId,
  });
}
