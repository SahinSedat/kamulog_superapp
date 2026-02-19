import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/network/connectivity_service.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final ConnectivityService connectivityService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.connectivityService,
  });

  @override
  Future<Either<Failure, void>> signInWithPhone({
    required String phone,
    required Function(String, int?) onCodeSent,
    required Function(String) onVerificationFailed,
  }) async {
    if (connectivityService.isConnected) {
      try {
        await remoteDataSource.signInWithPhone(
          phone: phone,
          onCodeSent: onCodeSent,
          onVerificationFailed: onVerificationFailed,
        );
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String verificationId,
    required String smsCode,
  }) async {
    if (connectivityService.isConnected) {
      try {
        final userModel = await remoteDataSource.verifyOtp(
          verificationId: verificationId,
          smsCode: smsCode,
        );
        await localDataSource.cacheUser(userModel);
        return Right(userModel);
      } catch (e) {
        return Left(ServerFailure(message: e.toString()));
      }
    } else {
      return const Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final localUser = await localDataSource.getCachedUser();
      if (localUser != null) {
        return Right(localUser);
      }

      if (connectivityService.isConnected) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          await localDataSource.cacheUser(remoteUser);
          return Right(remoteUser);
        }
      }
      return const Left(CacheFailure(message: 'Kullanıcı bulunamadı'));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateUserProfile(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await localDataSource.cacheUser(userModel);
      return Right(userModel);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.hasToken();
  }
}
