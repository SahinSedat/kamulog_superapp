import 'dart:convert';
import 'package:kamulog_superapp/core/storage/secure_storage_service.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
  Future<bool> hasToken();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorageService storage;

  AuthLocalDataSourceImpl({required this.storage});

  @override
  Future<void> cacheUser(UserModel user) async {
    final json = jsonEncode(user.toJson());
    await storage.saveUserData(json);
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonStr = await storage.getUserData();
    if (jsonStr == null) return null;
    try {
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      return UserModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearCache() async {
    await storage.clearAll();
  }

  @override
  Future<bool> hasToken() async {
    return await storage.hasToken();
  }
}
