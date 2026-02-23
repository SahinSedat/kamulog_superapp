import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:kamulog_superapp/features/kariyer/data/repositories/jobs_repository.dart';

// State definition for jobs
class JobsState {
  final AsyncValue<List<JobListingModel>> jobs;
  final String filterType; // 'ALL', 'PUBLIC', 'PRIVATE'

  JobsState({required this.jobs, this.filterType = 'ALL'});

  JobsState copyWith({
    AsyncValue<List<JobListingModel>>? jobs,
    String? filterType,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      filterType: filterType ?? this.filterType,
    );
  }
}

class JobsNotifier extends StateNotifier<JobsState> {
  final JobsRepository repository;

  JobsNotifier({required this.repository})
    : super(JobsState(jobs: const AsyncValue.loading())) {
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    state = state.copyWith(jobs: const AsyncValue.loading());
    try {
      final jobs = await repository.getJobs(type: state.filterType);
      state = state.copyWith(jobs: AsyncValue.data(jobs));
    } catch (e, stackTrace) {
      state = state.copyWith(jobs: AsyncValue.error(e, stackTrace));
    }
  }

  void setFilterType(String type) {
    if (state.filterType == type) return;
    state = state.copyWith(filterType: type);
    fetchJobs();
  }
}

final jobsProvider = StateNotifierProvider<JobsNotifier, JobsState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return JobsNotifier(repository: repository);
});
