import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:kamulog_superapp/core/config/env_config.dart';
import 'package:kamulog_superapp/core/constants/api_endpoints.dart';
import 'package:kamulog_superapp/core/error/exceptions.dart';
import 'package:kamulog_superapp/core/storage/secure_storage_service.dart';

class ApiClient {
  late final Dio _dio;
  final SecureStorageService _storage;

  ApiClient({required SecureStorageService storage}) : _storage = storage {
    _dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        receiveTimeout: const Duration(seconds: AppConstants.apiTimeoutSeconds),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-App-Platform': 'mobile',
          'X-App-Version': AppConstants.appVersion,
        },
      ),
    );

    _dio.interceptors.addAll([
      _AuthInterceptor(storage: _storage, dio: _dio),
      _RetryInterceptor(dio: _dio),
      if (!kReleaseMode) _LoggingInterceptor(),
    ]);
  }

  // ── GET ──
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── POST ──
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      return await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── PUT ──
  Future<Response> put(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.put(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── PATCH ──
  Future<Response> patch(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.patch(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── DELETE ──
  Future<Response> delete(String path, {dynamic data, Options? options}) async {
    try {
      return await _dio.delete(path, data: data, options: options);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // ── Multipart Upload ──
  Future<Response> uploadFile(
    String path, {
    required FormData formData,
    void Function(int, int)? onSendProgress,
  }) async {
    try {
      return await _dio.post(
        path,
        data: formData,
        onSendProgress: onSendProgress,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 5),
        ),
      );
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message: 'Bağlantı zaman aşımına uğradı.',
        );
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode ?? 500;
        final message = _extractErrorMessage(e.response);
        if (statusCode == 401) {
          return AuthException(
            message: message ?? 'Oturum süresi dolmuş.',
            statusCode: 401,
          );
        }
        return ServerException(
          message: message ?? 'Sunucu hatası oluştu.',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: e.message ?? 'Beklenmeyen bir hata oluştu.',
        );
    }
  }

  String? _extractErrorMessage(Response? response) {
    try {
      final data = response?.data;
      if (data is Map<String, dynamic>) {
        return data['error'] as String? ?? data['message'] as String?;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

// ── Auth Interceptor ──
class _AuthInterceptor extends Interceptor {
  final SecureStorageService _storage;
  final Dio _dio;

  _AuthInterceptor({required SecureStorageService storage, required Dio dio})
    : _storage = storage,
      _dio = dio;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final refreshed = await _tryRefreshToken();
      if (refreshed) {
        final token = await _storage.getAccessToken();
        err.requestOptions.headers['Authorization'] = 'Bearer $token';
        try {
          final response = await _dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      } else {
        await _storage.clearAll();
      }
    }
    handler.next(err);
  }

  Future<bool> _tryRefreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;

      final response = await Dio().post(
        '${EnvConfig.apiBaseUrl}${ApiEndpoints.refreshToken}',
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        await _storage.saveTokens(
          accessToken: data['accessToken'] as String,
          refreshToken: data['refreshToken'] as String? ?? refreshToken,
        );
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}

// ── Retry Interceptor ──
class _RetryInterceptor extends Interceptor {
  final Dio _dio;
  static const _maxRetries = AppConstants.maxRetryAttempts;

  _RetryInterceptor({required Dio dio}) : _dio = dio;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isRetryable =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);

    if (!isRetryable) {
      handler.next(err);
      return;
    }

    int retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;
    if (retryCount >= _maxRetries) {
      handler.next(err);
      return;
    }

    retryCount++;
    err.requestOptions.extra['retryCount'] = retryCount;

    final delay = Duration(milliseconds: 1000 * retryCount);
    await Future.delayed(delay);

    try {
      final response = await _dio.fetch(err.requestOptions);
      handler.resolve(response);
    } catch (e) {
      handler.next(err);
    }
  }
}

// ── Logging Interceptor ──
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    debugPrint('🌐 [${options.method}] ${options.uri}');
    if (options.data != null) {
      debugPrint('📤 Body: ${options.data}');
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint('✅ [${response.statusCode}] ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('❌ [${err.response?.statusCode}] ${err.requestOptions.uri}');
    debugPrint('   Error: ${err.message}');
    handler.next(err);
  }
}
