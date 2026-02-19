import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/database/app_database.dart';
import 'package:kamulog_superapp/core/storage/secure_storage_service.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> hasToken();
  Future<void> updateEmploymentType(String userId, EmploymentType type);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storage;
  final AppDatabase database;

  AuthLocalDataSourceImpl({required this.storage, required this.database});

  @override
  Future<void> cacheUser(UserModel user) async {
    // 1. Cache to Secure Storage for quick access (tokens etc.)
    final json = jsonEncode(user.toJson());
    await storage.saveUserData(json);

    // 2. Cache to Drift Database for relational data and offline queries
    await database.insertUser(
      UsersCompanion(
        id: Value(user.id),
        phone: Value(user.phone),
        fullName: Value(user.name),
        employmentType: Value(user.employmentType),
        ministryCode: Value(user.ministryCode),
        title: Value(user.title),
      ),
    );
  }

  @override
  Future<UserModel?> getCachedUser() async {
    // Try to get from Secure Storage first
    final jsonStr = await storage.getUserData();
    if (jsonStr != null) {
      try {
        final data = jsonDecode(jsonStr) as Map<String, dynamic>;
        var userModel = UserModel.fromJson(data);

        // Enhance with DB data if available
        final dbUser = await database.getUser(userModel.id);
        if (dbUser != null) {
          if (dbUser.employmentType != null) {
            userModel =
                userModel.copyWith(employmentType: dbUser.employmentType)
                    as UserModel;
          }
        }
        return userModel;
      } catch (_) {}
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await storage.clearAll();
  }

  @override
  Future<bool> hasToken() async {
    return await storage.hasToken();
  }

  @override
  Future<void> updateEmploymentType(String userId, EmploymentType type) async {
    await (database.update(database.users)..where(
      (t) => t.id.equals(userId),
    )).write(UsersCompanion(employmentType: Value(type)));

    // Also update secure storage cache to keep sync
    final currentUser = await getCachedUser();
    if (currentUser != null) {
      final updatedUser =
          currentUser.copyWith(employmentType: type) as UserModel;
      await cacheUser(updatedUser);
    }
  }
}
