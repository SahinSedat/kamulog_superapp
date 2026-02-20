import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/stk/data/repositories/stk_repository_impl.dart';
import 'package:kamulog_superapp/features/stk/domain/entities/stk_organization.dart';
import 'package:kamulog_superapp/features/stk/domain/entities/stk_announcement.dart';
import 'package:kamulog_superapp/features/stk/domain/repositories/stk_repository.dart';

final stkRepositoryProvider = Provider<StkRepository>((ref) {
  return StkRepositoryImpl(database: ref.watch(appDatabaseProvider));
});

class StkState {
  final bool isLoading;
  final List<StkOrganization> organizations;
  final List<StkAnnouncement> announcements;
  final String? error;

  const StkState({
    this.isLoading = false,
    this.organizations = const [],
    this.announcements = const [],
    this.error,
  });

  StkState copyWith({
    bool? isLoading,
    List<StkOrganization>? organizations,
    List<StkAnnouncement>? announcements,
    String? error,
  }) {
    return StkState(
      isLoading: isLoading ?? this.isLoading,
      organizations: organizations ?? this.organizations,
      announcements: announcements ?? this.announcements,
      error: error,
    );
  }
}

class StkNotifier extends StateNotifier<StkState> {
  final StkRepository _repository;
  StkNotifier(this._repository) : super(const StkState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true);
    final orgResult = await _repository.getOrganizations();
    final annResult = await _repository.getAnnouncements();
    state = state.copyWith(
      isLoading: false,
      organizations: orgResult.getOrElse((_) => []),
      announcements: annResult.getOrElse((_) => []),
    );
  }
}

final stkProvider = StateNotifierProvider<StkNotifier, StkState>((ref) {
  return StkNotifier(ref.watch(stkRepositoryProvider));
});
