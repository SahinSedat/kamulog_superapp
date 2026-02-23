import 'package:kamulog_superapp/features/kariyer/data/datasources/jobs_remote_datasource.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

abstract class JobsRepository {
  Future<List<JobListingModel>> getJobs({String type = 'ALL', String? search});
}

class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<JobListingModel>> getJobs({
    String type = 'ALL',
    String? search,
  }) async {
    return await remoteDataSource.getJobs(type: type, search: search);
  }
}

// Global Repository Provider
final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  final dataSource = JobsRemoteDataSourceImpl();
  return JobsRepositoryImpl(remoteDataSource: dataSource);
});
