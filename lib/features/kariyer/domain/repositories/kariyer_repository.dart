import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/kariyer/domain/entities/job_listing.dart';

abstract class KariyerRepository {
  Future<Either<Failure, List<JobListing>>> getJobListings({
    String? city,
    EmploymentType? type,
    String? category,
  });
  Future<Either<Failure, JobListing>> getJobListingById(String id);
  Future<Either<Failure, List<JobListing>>> getActiveListings();
}
