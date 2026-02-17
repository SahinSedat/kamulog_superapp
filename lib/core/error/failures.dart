import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({required this.message, this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.statusCode});

  factory ServerFailure.fromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return const ServerFailure(
          message: 'Geçersiz istek. Lütfen bilgilerinizi kontrol edin.',
          statusCode: 400,
        );
      case 401:
        return const ServerFailure(
          message: 'Oturumunuzun süresi dolmuş. Lütfen tekrar giriş yapın.',
          statusCode: 401,
        );
      case 403:
        return const ServerFailure(
          message: 'Bu işlem için yetkiniz bulunmamaktadır.',
          statusCode: 403,
        );
      case 404:
        return const ServerFailure(
          message: 'İstenen kaynak bulunamadı.',
          statusCode: 404,
        );
      case 429:
        return const ServerFailure(
          message: 'Çok fazla istek gönderildi. Lütfen biraz bekleyiniz.',
          statusCode: 429,
        );
      case 500:
        return const ServerFailure(
          message: 'Sunucu hatası oluştu. Lütfen daha sonra tekrar deneyiniz.',
          statusCode: 500,
        );
      default:
        return ServerFailure(
          message: 'Beklenmeyen bir hata oluştu. (Kod: $statusCode)',
          statusCode: statusCode,
        );
    }
  }
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message =
        'İnternet bağlantısı bulunamadı. Lütfen bağlantınızı kontrol edin.',
  });
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Yerel veri okunamadı.'});
}

class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.statusCode});
}

class ValidationFailure extends Failure {
  const ValidationFailure({required super.message});
}

class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'İstek zaman aşımına uğradı. Lütfen tekrar deneyiniz.',
  });
}
