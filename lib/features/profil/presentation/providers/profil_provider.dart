import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';

class ProfilState {
  final bool isLoading;
  final String? name;
  final String? phone;
  final String? institution;
  final String? city;
  final String? error;

  const ProfilState({
    this.isLoading = false,
    this.name,
    this.phone,
    this.institution,
    this.city,
    this.error,
  });

  ProfilState copyWith({
    bool? isLoading,
    String? name,
    String? phone,
    String? institution,
    String? city,
    String? error,
  }) {
    return ProfilState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      institution: institution ?? this.institution,
      city: city ?? this.city,
      error: error,
    );
  }
}

class ProfilNotifier extends StateNotifier<ProfilState> {
  ProfilNotifier() : super(const ProfilState());

  void loadProfile(dynamic user) {
    if (user != null) {
      state = state.copyWith(name: user.name, phone: user.phone);
    }
  }

  void updateProfile({String? name, String? institution, String? city}) {
    state = state.copyWith(name: name, institution: institution, city: city);
  }
}

final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((
  ref,
) {
  final notifier = ProfilNotifier();
  final user = ref.watch(currentUserProvider);
  notifier.loadProfile(user);
  return notifier;
});
