import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/becayis/domain/entities/becayis_ad.dart';

abstract class BecayisRepository {
  Future<Either<Failure, List<BecayisAd>>> getAds({
    String? targetCity,
    EmploymentType? type,
    String? profession,
  });
  Future<Either<Failure, BecayisAd>> createAd(BecayisAd ad);
  Future<Either<Failure, void>> deleteAd(String id);
  Future<Either<Failure, List<BecayisAd>>> findMatches(String adId);
}
