class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({required this.message, this.statusCode});

  @override
  String toString() => 'ServerException: $message (Code: $statusCode)';
}

class NetworkException implements Exception {
  final String message;

  const NetworkException({this.message = 'İnternet bağlantısı bulunamadı.'});

  @override
  String toString() => 'NetworkException: $message';
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Yerel veri hatası.'});

  @override
  String toString() => 'CacheException: $message';
}

class AuthException implements Exception {
  final String message;
  final int? statusCode;

  const AuthException({required this.message, this.statusCode});

  @override
  String toString() => 'AuthException: $message (Code: $statusCode)';
}

class TokenExpiredException implements Exception {
  final String message;

  const TokenExpiredException({this.message = 'Oturum süresi doldu.'});

  @override
  String toString() => 'TokenExpiredException: $message';
}
