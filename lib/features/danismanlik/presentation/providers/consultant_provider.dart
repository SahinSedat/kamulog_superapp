import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/danismanlik/data/repositories/consultant_repository_impl.dart';
import 'package:kamulog_superapp/features/danismanlik/domain/entities/consultant.dart';
import 'package:kamulog_superapp/features/danismanlik/domain/repositories/consultant_repository.dart';

// ── Repository
final consultantRepositoryProvider = Provider<ConsultantRepository>((ref) {
  return ConsultantRepositoryImpl(database: ref.watch(appDatabaseProvider));
});

// ── State
class ConsultantState {
  final bool isLoading;
  final List<Consultant> consultants;
  final String? error;
  final ConsultantCategory? selectedCategory;

  const ConsultantState({
    this.isLoading = false,
    this.consultants = const [],
    this.error,
    this.selectedCategory,
  });

  ConsultantState copyWith({
    bool? isLoading,
    List<Consultant>? consultants,
    String? error,
    ConsultantCategory? selectedCategory,
  }) {
    return ConsultantState(
      isLoading: isLoading ?? this.isLoading,
      consultants: consultants ?? this.consultants,
      error: error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }
}

// ── Notifier
class ConsultantNotifier extends StateNotifier<ConsultantState> {
  final ConsultantRepository _repository;

  ConsultantNotifier(this._repository) : super(const ConsultantState()) {
    loadConsultants();
  }

  Future<void> loadConsultants() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getConsultants(
      category: state.selectedCategory,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(isLoading: false, error: failure.message),
      (list) => state = state.copyWith(isLoading: false, consultants: list),
    );
  }

  void filterByCategory(ConsultantCategory? category) {
    state = state.copyWith(selectedCategory: category);
    loadConsultants();
  }
}

final consultantProvider =
    StateNotifierProvider<ConsultantNotifier, ConsultantState>((ref) {
      return ConsultantNotifier(ref.watch(consultantRepositoryProvider));
    });
