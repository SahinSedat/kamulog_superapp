import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Send OTP to phone number
  Future<Either<Failure, bool>> sendOtp({required String phone});

  /// Verify OTP and get tokens
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String code,
  });

  /// Register a new user (sends OTP)
  Future<Either<Failure, bool>> register({
    required String phone,
    required String name,
    String? email,
  });

  /// Verify registration OTP
  Future<Either<Failure, User>> verifyRegistration({
    required String phone,
    required String code,
  });

  /// Refresh access token
  Future<Either<Failure, String>> refreshToken();

  /// Get current user from local storage
  Future<Either<Failure, User>> getCurrentUser();

  /// Logout and clear session
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}
