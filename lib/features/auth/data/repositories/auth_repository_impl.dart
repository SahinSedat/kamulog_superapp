import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kamulog_superapp/core/error/failures.dart';
import 'package:kamulog_superapp/core/network/connectivity_service.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/datasources/user_remote_datasource.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';
import 'package:kamulog_superapp/features/auth/domain/entities/user.dart';
import 'package:kamulog_superapp/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;
  final UserRemoteDataSource userRemoteDataSource;
  final ConnectivityService connectivityService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.userRemoteDataSource,
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
    String? displayName,
    String? phone,
  }) async {
    if (connectivityService.isConnected) {
      try {
        final userModel = await remoteDataSource.verifyOtp(
          verificationId: verificationId,
          smsCode: smsCode,
          displayName: displayName,
          phone: phone,
        );

        // WhatsApp OTP doğrulaması başarılı — backend'e profil kaydet/senkronize et
        try {
          final backendUser = await userRemoteDataSource.syncUserProfile({
            'userId': userModel.id,
            'phone': userModel.phone,
            if (displayName != null && displayName.isNotEmpty)
              'name': displayName,
          });
          // Backend'den gelen zengin profil verisini kullan
          await localDataSource.cacheUser(backendUser);
          return Right(backendUser);
        } catch (e) {
          debugPrint('⚠️ Backend sync hatası (çevrimdışı devam): $e');
          // Backend hatası olsa bile doğrulanmış kullanıcı ile devam et
          await localDataSource.cacheUser(userModel);
          return Right(userModel);
        }
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
      // 1. Önce lokal cache'e bak
      final localUser = await localDataSource.getCachedUser();
      if (localUser != null) {
        // Arka planda backend'den güncellenmiş veriyi çek
        if (connectivityService.isConnected) {
          _syncFromBackendInBackground(localUser);
        }
        return Right(localUser);
      }

      // 2. Lokal cache yoksa — Firebase'den kontrol et
      if (connectivityService.isConnected) {
        final remoteUser = await remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          // 3. Backend'den profil detaylarını çek
          try {
            final backendUser = await userRemoteDataSource.fetchUserProfile();
            if (backendUser != null) {
              await localDataSource.cacheUser(backendUser);
              return Right(backendUser);
            }
          } catch (e) {
            debugPrint('⚠️ Backend profil çekme hatası: $e');
          }
          // Fallback: sadece Firebase verisiyle devam
          await localDataSource.cacheUser(remoteUser);
          return Right(remoteUser);
        }
      }
      return const Left(CacheFailure(message: 'Kullanıcı bulunamadı'));
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  /// Arka planda backend'den profil senkronizasyonu
  Future<void> _syncFromBackendInBackground(UserModel localUser) async {
    try {
      final backendUser = await userRemoteDataSource.fetchUserProfile();
      if (backendUser != null) {
        // Backend'den gelen bilgilerle lokal cache'i güncelle
        final mergedUser = UserModel(
          id: localUser.id,
          phone:
              backendUser.phone.isNotEmpty
                  ? backendUser.phone
                  : localUser.phone,
          name: backendUser.name ?? localUser.name,
          email: backendUser.email ?? localUser.email,
          avatarUrl: backendUser.avatarUrl ?? localUser.avatarUrl,
          role: backendUser.role,
          isVerified: backendUser.isVerified || localUser.isVerified,
          createdAt: backendUser.createdAt ?? localUser.createdAt,
          subscriptionTier:
              backendUser.subscriptionTier ?? localUser.subscriptionTier,
          employmentType:
              backendUser.employmentType ?? localUser.employmentType,
          ministryCode: backendUser.ministryCode ?? localUser.ministryCode,
          title: backendUser.title ?? localUser.title,
          credits:
              backendUser.credits > 0 ? backendUser.credits : localUser.credits,
        );
        await localDataSource.cacheUser(mergedUser);
      }
    } catch (e) {
      debugPrint('⚠️ Arka plan senkronizasyon hatası: $e');
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

      // Backend'e de kaydet (arka planda)
      if (connectivityService.isConnected) {
        try {
          await userRemoteDataSource.syncUserProfile(userModel.toJson());
        } catch (e) {
          debugPrint('⚠️ Profil backend sync hatası: $e');
        }
      }

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
