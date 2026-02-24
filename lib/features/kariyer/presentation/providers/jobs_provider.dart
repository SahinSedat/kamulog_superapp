import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:kamulog_superapp/features/kariyer/data/repositories/jobs_repository.dart';

// State definition for jobs
class JobsState {
  final AsyncValue<List<JobListingModel>> jobs;
  final String filterType; // 'ALL', 'PUBLIC', 'PRIVATE'
  final String searchQuery;
  final String selectedCity; // '' = tüm şehirler

  JobsState({
    required this.jobs,
    this.filterType = 'ALL',
    this.searchQuery = '',
    this.selectedCity = '',
  });

  JobsState copyWith({
    AsyncValue<List<JobListingModel>>? jobs,
    String? filterType,
    String? searchQuery,
    String? selectedCity,
  }) {
    return JobsState(
      jobs: jobs ?? this.jobs,
      filterType: filterType ?? this.filterType,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCity: selectedCity ?? this.selectedCity,
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

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCityFilter(String city) {
    state = state.copyWith(selectedCity: city);
  }
}

final jobsProvider = StateNotifierProvider<JobsNotifier, JobsState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return JobsNotifier(repository: repository);
});
