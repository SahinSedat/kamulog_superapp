import 'package:flutter/foundation.dart';
import 'package:kamulog_superapp/core/network/api_client.dart';
import 'package:kamulog_superapp/core/constants/api_endpoints.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';

/// Backend veritabanı ile kullanıcı profil CRUD işlemleri
/// Kimlik doğrulama ApiClient auth interceptor üzerinden yapılır (Bearer Token)
abstract class UserRemoteDataSource {
  /// Backend'den kullanıcı profil bilgilerini çek
  Future<UserModel?> fetchUserProfile();

  /// Backend'den tüm profil alanlarını ham Map olarak çek
  Future<Map<String, dynamic>?> fetchFullProfile();

  /// Backend'e kullanıcı profil bilgilerini kaydet / güncelle
  Future<UserModel> syncUserProfile(Map<String, dynamic> profileData);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;

  UserRemoteDataSourceImpl({required ApiClient apiClient})
    : _apiClient = apiClient;

  @override
  Future<UserModel?> fetchUserProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        // API'den gelen 'user' anahtarı varsa onu kullan
        final userData = data['user'] ?? data;
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      debugPrint('📡 Profil çekme hatası: $e');
      return null;
    }
  }

  @override
  Future<UserModel> syncUserProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await _apiClient.put(
        ApiEndpoints.userProfile,
        data: profileData,
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        final userData = data['user'] ?? data;
        return UserModel.fromJson(userData);
      }

      // Fallback: gönderdiğimiz veriyle model oluştur
      return UserModel.fromJson(profileData);
    } catch (e) {
      debugPrint('📡 Profil senkronizasyon hatası: $e');
      // Hata olursa bile gönderdiğimiz veriyle lokal kullanım sağla
      return UserModel.fromJson(profileData);
    }
  }

  @override
  Future<Map<String, dynamic>?> fetchFullProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.userProfile);

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data as Map<String, dynamic>;
        return (data['user'] ?? data) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      debugPrint('Tam profil cekme hatasi: $e');
      return null;
    }
  }
}
