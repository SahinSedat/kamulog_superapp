import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Send OTP to phone number (Firebase VerifyPhoneNumber)
  Future<Either<Failure, void>> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  });

  /// Verify OTP and sign in (Firebase credential)
  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String smsCode,
  });

  /// Update user profile (name, employmentType, etc.)
  Future<Either<Failure, User>> updateUserProfile(User user);

  /// Get current user from local storage or remote if connected
  Future<Either<Failure, User>> getCurrentUser();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
