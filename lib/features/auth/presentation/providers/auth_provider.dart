import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';
import 'package:kamulog_superapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

// ── Data Sources ──
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(storage: ref.watch(secureStorageProvider));
});

// ── Repository ──
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    storage: ref.watch(secureStorageProvider),
    connectivity: ref.watch(connectivityProvider),
  );
});

// ── Auth State ──
enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  otpSent,
  error,
}

class AuthState {
  final AuthStatus status;
  final User? user;
  final String? error;
  final String? phone;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.phone,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    String? phone,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      phone: phone ?? this.phone,
    );
  }
}

// ── Auth Notifier ──
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final AuthLocalDataSource _localDataSource;

  // TODO: Set to false before production release
  static const bool _kDevMode = true;

  AuthNotifier(this._repository, this._localDataSource)
    : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(status: AuthStatus.loading);

    if (_kDevMode) {
      // In dev mode, check if we have a cached user from a previous session
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        state = state.copyWith(
          status: AuthStatus.authenticated,
          user: cachedUser,
        );
        return;
      }
      state = state.copyWith(status: AuthStatus.unauthenticated);
      return;
    }

    final isAuth = await _repository.isAuthenticated();
    if (isAuth) {
      final result = await _repository.getCurrentUser();
      result.fold(
        (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
        (user) =>
            state = state.copyWith(
              status: AuthStatus.authenticated,
              user: user,
            ),
      );
    } else {
      state = state.copyWith(status: AuthStatus.unauthenticated);
    }
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(status: AuthStatus.loading, phone: phone);

    if (_kDevMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      state = state.copyWith(status: AuthStatus.otpSent);
      return;
    }

    final result = await _repository.sendOtp(phone: phone);
    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (_) => state = state.copyWith(status: AuthStatus.otpSent),
    );
  }

  Future<void> verifyOtp(String code) async {
    if (state.phone == null) return;
    state = state.copyWith(status: AuthStatus.loading);

    if (_kDevMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      final mockUser = UserModel(
        id: 'dev-user-001',
        name: 'Test Kullanıcı',
        email: 'test@kamulog.com',
        phone: state.phone ?? '+905551234567',
        role: 'user',
        isVerified: true,
      );
      // Persist mock user so session survives app restart
      await _localDataSource.cacheUser(mockUser);
      state = state.copyWith(status: AuthStatus.authenticated, user: mockUser);
      return;
    }

    final result = await _repository.verifyOtp(phone: state.phone!, code: code);
    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> register({
    required String phone,
    required String name,
    String? email,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, phone: phone);
    final result = await _repository.register(
      phone: phone,
      name: name,
      email: email,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (_) => state = state.copyWith(status: AuthStatus.otpSent),
    );
  }

  Future<void> verifyRegistration(String code) async {
    if (state.phone == null) return;
    state = state.copyWith(status: AuthStatus.loading);
    final result = await _repository.verifyRegistration(
      phone: state.phone!,
      code: code,
    );
    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _localDataSource.clearCache();
    await _repository.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Providers ──
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(authLocalDataSourceProvider),
  );
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});
