import 'package:kamulog_superapp/core/constants/api_endpoints.dart';
import 'package:kamulog_superapp/core/error/exceptions.dart';
import 'package:kamulog_superapp/core/network/api_client.dart';
import 'package:kamulog_superapp/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<bool> sendOtp({required String phone});
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  });
  Future<bool> register({
    required String phone,
    required String name,
    String? email,
  });
  Future<Map<String, dynamic>> verifyRegistration({
    required String phone,
    required String code,
  });
  Future<String> refreshToken({required String refreshToken});
  Future<UserModel> getUserProfile();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<bool> sendOtp({required String phone}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.sendOtp,
        data: {'phone': phone},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['requiresVerification'] == true || response.statusCode == 200) {
        return true;
      }
      throw const ServerException(message: 'OTP gönderilemedi.');
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOtp({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyOtp,
        data: {'phone': phone, 'code': code},
      );
      final data = response.data as Map<String, dynamic>;
      return {
        'user': data['user'] as Map<String, dynamic>?,
        'accessToken':
            data['accessToken'] as String? ?? data['token'] as String?,
        'refreshToken': data['refreshToken'] as String?,
      };
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<bool> register({
    required String phone,
    required String name,
    String? email,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.register,
        data: {'phone': phone, 'name': name, if (email != null) 'email': email},
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> verifyRegistration({
    required String phone,
    required String code,
  }) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.verifyRegistration,
        data: {'phone': phone, 'code': code},
      );
      final data = response.data as Map<String, dynamic>;
      return {
        'user': data['user'] as Map<String, dynamic>?,
        'accessToken':
            data['accessToken'] as String? ?? data['token'] as String?,
        'refreshToken': data['refreshToken'] as String?,
      };
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<String> refreshToken({required String refreshToken}) async {
    try {
      final response = await apiClient.post(
        ApiEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final data = response.data as Map<String, dynamic>;
      return data['accessToken'] as String? ?? '';
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<UserModel> getUserProfile() async {
    try {
      final response = await apiClient.get(ApiEndpoints.userProfile);
      final data = response.data as Map<String, dynamic>;
      return UserModel.fromJson(data['user'] as Map<String, dynamic>? ?? data);
    } on ServerException {
      rethrow;
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
