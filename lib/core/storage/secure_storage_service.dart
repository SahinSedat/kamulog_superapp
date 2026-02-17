import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  // ── Keys ──
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userDataKey = 'user_data';
  static const _sessionIdKey = 'session_id';
  static const _lastLoginKey = 'last_login';

  // ── Token Operations ──
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  // ── User Data ──
  Future<void> saveUserData(String jsonData) async {
    await _storage.write(key: _userDataKey, value: jsonData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  // ── Session ──
  Future<void> saveSessionId(String sessionId) async {
    await _storage.write(key: _sessionIdKey, value: sessionId);
  }

  Future<String?> getSessionId() async {
    return await _storage.read(key: _sessionIdKey);
  }

  Future<void> saveLastLogin(String timestamp) async {
    await _storage.write(key: _lastLoginKey, value: timestamp);
  }

  Future<String?> getLastLogin() async {
    return await _storage.read(key: _lastLoginKey);
  }

  // ── Generic Operations ──
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> hasToken() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
