import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/providers/core_providers.dart';
import 'package:kamulog_superapp/core/usecase/usecase.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/user_remote_datasource.dart';
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

final userRemoteDataSourceProvider = Provider<UserRemoteDataSource>((ref) {
  return UserRemoteDataSourceImpl(apiClient: ref.watch(apiClientProvider));
});

// ── Repository ──
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
    userRemoteDataSource: ref.watch(userRemoteDataSourceProvider),
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
  final String? displayName;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.error,
    this.phone,
    this.verificationId,
    this.displayName,
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? error,
    String? phone,
    String? verificationId,
    String? displayName,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      error: error,
      phone: phone ?? this.phone,
      verificationId: verificationId ?? this.verificationId,
      displayName: displayName ?? this.displayName,
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

  Future<void> sendOtp(String phone, {String? displayName}) async {
    state = state.copyWith(
      status: AuthStatus.loading,
      phone: phone,
      displayName: displayName,
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
      VerifyOtpParams(
        verificationId: state.verificationId!,
        smsCode: smsCode,
        displayName: state.displayName,
        phone: state.phone,
      ),
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

  /// Telefon numarası değiştirmek için OTP gönder
  /// Auth state'i DEĞİŞTİRMEZ — ayrı callback kullanır
  String? _phoneChangeVerificationId;
  bool _phoneChangeLoading = false;
  String? _phoneChangeError;

  bool get phoneChangeLoading => _phoneChangeLoading;
  String? get phoneChangeError => _phoneChangeError;

  Future<void> sendPhoneChangeOtp(String newPhone) async {
    _phoneChangeLoading = true;
    _phoneChangeError = null;
    _phoneChangeVerificationId = null;
    state = state.copyWith(error: null);

    final completer = Completer<void>();

    final result = await _sendOtp(
      SendOtpParams(
        phone: newPhone,
        onCodeSent: (verificationId, resendToken) {
          _phoneChangeVerificationId = verificationId;
          _phoneChangeLoading = false;
          _phoneChangeError = null;
          state = state.copyWith(error: null);
          if (!completer.isCompleted) completer.complete();
        },
        onVerificationFailed: (error) {
          _phoneChangeLoading = false;
          _phoneChangeError = error;
          state = state.copyWith(error: error);
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    result.fold(
      (failure) {
        _phoneChangeLoading = false;
        _phoneChangeError = failure.message;
        state = state.copyWith(error: failure.message);
        if (!completer.isCompleted) completer.complete();
      },
      (_) {
        // UseCase başarılı — callback'i bekle
      },
    );

    // Firebase callback'inin tamamlanmasını bekle
    await completer.future;
  }

  /// Telefon değişikliğini OTP ile doğrula ve profili güncelle
  Future<bool> verifyPhoneChangeOtp(String smsCode, String newPhone) async {
    if (_phoneChangeVerificationId == null) {
      _phoneChangeError = 'Verification ID missing';
      state = state.copyWith(error: _phoneChangeError);
      return false;
    }
    _phoneChangeLoading = true;
    state = state.copyWith(error: null);

    final result = await _verifyOtp(
      VerifyOtpParams(
        verificationId: _phoneChangeVerificationId!,
        smsCode: smsCode,
        displayName: state.user?.name,
      ),
    );

    return result.fold(
      (failure) {
        _phoneChangeLoading = false;
        _phoneChangeError = failure.message;
        state = state.copyWith(error: failure.message);
        return false;
      },
      (verifiedUser) {
        _phoneChangeLoading = false;
        _phoneChangeVerificationId = null;
        // Kullanıcının telefon numarasını güncelle
        final updatedUser = state.user?.copyWith(phone: newPhone);
        if (updatedUser != null) {
          _updateUser(updatedUser);
          state = state.copyWith(
            status: AuthStatus.authenticated,
            user: updatedUser,
          );
        }
        return true;
      },
    );
  }

  Future<void> logout() async {
    state = state.copyWith(status: AuthStatus.loading);
    await _signOut(NoParams());
    // SecureStorage (token/session) zaten _signOut icerisinde temizleniyor
    // Hive profil verilerini TEMIZLEME — ayni kullanici geri girebilir
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
