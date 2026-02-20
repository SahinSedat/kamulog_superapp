import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/becayis/data/repositories/becayis_repository_impl.dart';
import 'package:kamulog_superapp/features/becayis/domain/entities/becayis_ad.dart';
import 'package:kamulog_superapp/features/becayis/domain/repositories/becayis_repository.dart';

// ── Repository
final becayisRepositoryProvider = Provider<BecayisRepository>((ref) {
  return BecayisRepositoryImpl(database: ref.watch(appDatabaseProvider));
});

// ── State
class BecayisState {
  final bool isLoading;
  final List<BecayisAd> ads;
  final String? error;
  final String? selectedCity;
  final EmploymentType? selectedType;

  const BecayisState({
    this.isLoading = false,
    this.ads = const [],
    this.error,
    this.selectedCity,
    this.selectedType,
  });

  BecayisState copyWith({
    bool? isLoading,
    List<BecayisAd>? ads,
    String? error,
    String? selectedCity,
    EmploymentType? selectedType,
  }) {
    return BecayisState(
      isLoading: isLoading ?? this.isLoading,
      ads: ads ?? this.ads,
      error: error,
      selectedCity: selectedCity ?? this.selectedCity,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

// ── Notifier
class BecayisNotifier extends StateNotifier<BecayisState> {
  final BecayisRepository _repository;

  BecayisNotifier(this._repository) : super(const BecayisState()) {
    loadAds();
  }

  Future<void> loadAds() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getAds(
      targetCity: state.selectedCity,
      type: state.selectedType,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (ads) => state = state.copyWith(isLoading: false, ads: ads),
    );
  }

  Future<void> createAd(BecayisAd ad) async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.createAd(ad);
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (_) => loadAds(),
    );
  }

  void filterByCity(String? city) {
    state = state.copyWith(selectedCity: city);
    loadAds();
  }

  void filterByType(EmploymentType? type) {
    state = state.copyWith(selectedType: type);
    loadAds();
  }

  Future<List<BecayisAd>> findMatches(String adId) async {
    final result = await _repository.findMatches(adId);
    return result.fold((_) => [], (matches) => matches);
  }
}

final becayisProvider = StateNotifierProvider<BecayisNotifier, BecayisState>((
  ref,
) {
  return BecayisNotifier(ref.watch(becayisRepositoryProvider));
});
