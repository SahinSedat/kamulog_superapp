import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/exceptions.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/network/connectivity_service.dart';
import 'package:kamulog_superapp/core/storage/secure_storage_service.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final SecureStorageService storage;
  final ConnectivityService connectivity;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.storage,
    required this.connectivity,
  });

  @override
  Future<Either<Failure, bool>> sendOtp({required String phone}) async {
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.sendOtp(phone: phone);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.verifyOtp(phone: phone, code: code);

      // Save tokens
      final accessToken = result['accessToken'] as String?;
      final refreshToken = result['refreshToken'] as String?;
      if (accessToken != null) {
        await storage.saveAccessToken(accessToken);
      }
      if (refreshToken != null) {
        await storage.saveRefreshToken(refreshToken);
      }

      // Parse and cache user
      final userData = result['user'] as Map<String, dynamic>?;
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await localDataSource.cacheUser(user);
        await storage.saveLastLogin(DateTime.now().toIso8601String());
        return Right(user);
      }

      return const Left(
        ServerFailure(message: 'Kullanıcı bilgileri alınamadı.'),
      );
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> register({
    required String phone,
    required String name,
    String? email,
  }) async {
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.register(
        phone: phone,
        name: name,
        email: email,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, statusCode: e.statusCode));
    } on NetworkException {
      return const Left(NetworkFailure());
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyRegistration({
    required String phone,
    required String code,
  }) async {
    if (!connectivity.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.verifyRegistration(
        phone: phone,
        code: code,
      );

      final accessToken = result['accessToken'] as String?;
      final refreshToken = result['refreshToken'] as String?;
      if (accessToken != null) {
        await storage.saveAccessToken(accessToken);
      }
      if (refreshToken != null) {
        await storage.saveRefreshToken(refreshToken);
      }

      final userData = result['user'] as Map<String, dynamic>?;
      if (userData != null) {
        final user = UserModel.fromJson(userData);
        await localDataSource.cacheUser(user);
        return Right(user);
      }

      return const Left(ServerFailure(message: 'Kayıt tamamlanamadı.'));
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final currentRefreshToken = await storage.getRefreshToken();
      if (currentRefreshToken == null) {
        return const Left(AuthFailure(message: 'Oturum bulunamadı.'));
      }
      final newToken = await remoteDataSource.refreshToken(
        refreshToken: currentRefreshToken,
      );
      await storage.saveAccessToken(newToken);
      return Right(newToken);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, statusCode: e.statusCode));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      // Try local cache first
      final cachedUser = await localDataSource.getCachedUser();
      if (cachedUser != null) return Right(cachedUser);

      // If online, fetch from remote
      if (connectivity.isConnected) {
        final user = await remoteDataSource.getUserProfile();
        await localDataSource.cacheUser(user);
        return Right(user);
      }

      return const Left(
        CacheFailure(message: 'Kullanıcı bilgileri bulunamadı.'),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.hasToken();
  }
}
