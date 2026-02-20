import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/kariyer/data/repositories/kariyer_repository_impl.dart';
import 'package:kamulog_superapp/features/kariyer/domain/entities/job_listing.dart';
import 'package:kamulog_superapp/features/kariyer/domain/repositories/kariyer_repository.dart';

final kariyerRepositoryProvider = Provider<KariyerRepository>((ref) {
  return KariyerRepositoryImpl(database: ref.watch(appDatabaseProvider));
});

class KariyerState {
  final bool isLoading;
  final List<JobListing> listings;
  final String? error;
  final String? selectedCity;

  const KariyerState({
    this.isLoading = false,
    this.listings = const [],
    this.error,
    this.selectedCity,
  });

  KariyerState copyWith({
    bool? isLoading,
    List<JobListing>? listings,
    String? error,
    String? selectedCity,
  }) {
    return KariyerState(
      isLoading: isLoading ?? this.isLoading,
      listings: listings ?? this.listings,
      error: error,
      selectedCity: selectedCity ?? this.selectedCity,
    );
  }
}

class KariyerNotifier extends StateNotifier<KariyerState> {
  final KariyerRepository _repository;
  KariyerNotifier(this._repository) : super(const KariyerState()) {
    loadListings();
  }

  Future<void> loadListings() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getJobListings(city: state.selectedCity);
    result.fold(
      (f) => state = state.copyWith(isLoading: false, error: f.message),
      (list) => state = state.copyWith(isLoading: false, listings: list),
    );
  }

  void filterByCity(String? city) {
    state = state.copyWith(selectedCity: city);
    loadListings();
  }
}

final kariyerProvider = StateNotifierProvider<KariyerNotifier, KariyerState>((
  ref,
) {
  return KariyerNotifier(ref.watch(kariyerRepositoryProvider));
});
