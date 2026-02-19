import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';
import 'package:kamulog_superapp/features/auth/domain/usecases/get_current_user.dart';
import 'package:kamulog_superapp/features/auth/domain/usecases/send_otp.dart';
import 'package:kamulog_superapp/features/auth/domain/usecases/sign_out.dart';
import 'package:kamulog_superapp/features/auth/domain/usecases/update_user.dart';
import 'package:kamulog_superapp/features/auth/domain/usecases/verify_otp.dart';

// ── Data Sources ──
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    storage: ref.watch(secureStorageProvider),
    database: ref.watch(appDatabaseProvider),
  );
});

// ── Repository ──
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    connectivityService: ref.watch(connectivityProvider),
  );
});

// ── Use Cases ──
final sendOtpProvider = Provider(
  (ref) => SendOtpUseCase(ref.watch(authRepositoryProvider)),
);
final verifyOtpProvider = Provider(
  (ref) => VerifyOtpUseCase(ref.watch(authRepositoryProvider)),
);
final getCurrentUserProvider = Provider(
  (ref) => GetCurrentUserUseCase(ref.watch(authRepositoryProvider)),
);
final signOutProvider = Provider(
  (ref) => SignOutUseCase(ref.watch(authRepositoryProvider)),
);
final updateUserProvider = Provider(
  (ref) => UpdateUserUseCase(ref.watch(authRepositoryProvider)),
);

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
  final String? verificationId;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.phone,
    this.verificationId,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    String? phone,
    String? verificationId,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
    );
  }
}

// ── Auth Notifier ──
class AuthNotifier extends StateNotifier<AuthState> {
  final SendOtpUseCase _sendOtp;
  final VerifyOtpUseCase _verifyOtp;
  final GetCurrentUserUseCase _getCurrentUser;
  final SignOutUseCase _signOut;
  final UpdateUserUseCase _updateUser;

  AuthNotifier(
    this._sendOtp,
    this._verifyOtp,
    this._getCurrentUser,
    this._signOut,
    this._updateUser,
  ) : super(const AuthState()) {
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _getCurrentUser(NoParams());
    result.fold(
      (failure) => state = state.copyWith(status: AuthStatus.unauthenticated),
      (user) =>
          state = state.copyWith(status: AuthStatus.authenticated, user: user),
    );
  }

  Future<void> sendOtp(String phone) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      phone: phone,
      error: null,
    );

    final result = await _sendOtp(
      SendOtpParams(
        phone: phone,
        onCodeSent: (verificationId, resendToken) {
          state = state.copyWith(
            status: AuthStatus.otpSent,
            verificationId: verificationId,
          );
        },
        onVerificationFailed: (error) {
          state = state.copyWith(status: AuthStatus.error, error: error);
        },
      ),
    );

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (_) {},
    );
  }

  Future<void> verifyOtp(String smsCode) async {
    if (state.verificationId == null) {
      state = state.copyWith(
        status: AuthStatus.error,
        error: "Verification ID missing",
      );
      return;
    }
    state = state.copyWith(status: AuthStatus.loading, error: null);

    final result = await _verifyOtp(
      VerifyOtpParams(verificationId: state.verificationId!, smsCode: smsCode),
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

  Future<void> updateUser(User user) async {
    state = state.copyWith(status: AuthStatus.loading);

    final result = await _updateUser(user);

    result.fold(
      (failure) =>
          state = state.copyWith(
            status: AuthStatus.error,
            error: failure.message,
          ),
      (updatedUser) =>
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: updatedUser,
          ),
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _signOut(NoParams());
    state = const AuthState(status: AuthStatus.unauthenticated);
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

// ── Providers ──
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    ref.watch(sendOtpProvider),
    ref.watch(verifyOtpProvider),
    ref.watch(getCurrentUserProvider),
    ref.watch(signOutProvider),
    ref.watch(updateUserProvider),
  );
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).status == AuthStatus.authenticated;
});
