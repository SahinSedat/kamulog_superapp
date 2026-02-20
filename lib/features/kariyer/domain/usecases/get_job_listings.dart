import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/kariyer/domain/entities/job_listing.dart';
import 'package:kamulog_superapp/features/kariyer/domain/repositories/kariyer_repository.dart';

class GetJobListings extends UseCase<List<JobListing>, NoParams> {
  final KariyerRepository repository;
  GetJobListings(this.repository);

  @override
  Future<Either<Failure, List<JobListing>>> call(NoParams params) {
    return repository.getActiveListings();
  }
}
