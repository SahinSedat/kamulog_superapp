import 'package:dio/dio.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';

/// Admin paneliyle veri senkronizasyonunu (Profil, Mesajlar, Abonelik vb.) sağlamak için
/// hazırlanmış API Service taslağı.
/// Bu servis, daha sonra backend (Next.js / Node.js) API rotalarına uygun hale getirilecektir.
class ApiService {
  final Dio _dio;

  ApiService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl: 'https://kamulogkariyer.com/api',
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );

  /// 1. Kullanıcı Bilgilerini Senkronize Et (Profil & Ayarlar)
  Future<bool> syncUserProfile(String userId, ProfilState profil) async {
    try {
      final response = await _dio.post(
        '/admin/users/sync',
        data: {
          'userId': userId,
          'tcKimlik': profil.tcKimlik,
          'city': profil.city,
          'district': profil.district,
          'employmentType': profil.employmentType?.name,
          'institution': profil.institution,
          'title': profil.title,
          'isPremium': profil.isPremium,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      // ignore: avoid_print
      print('syncUserProfile Error: $e');
      return false;
    }
  }

  /// 2. Abonelik Durumunu Yönetim Paneline Bildir
  Future<bool> syncSubscription(
    String userId,
    bool isPremium,
    DateTime? endDate,
  ) async {
    try {
      final response = await _dio.post(
        '/admin/subscription/update',
        data: {
          'userId': userId,
          'isPremium': isPremium,
          'endDate': endDate?.toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      // ignore: avoid_print
      print('syncSubscription Error: $e');
      return false;
    }
  }

  /// 3. Danışman ile Canlı Sohbet Geçmişini Senkronize Et
  Future<bool> syncChatLog(
    String userId,
    String messageId,
    String text,
    bool hasProfanity,
  ) async {
    try {
      final response = await _dio.post(
        '/admin/messaging/log',
        data: {
          'userId': userId,
          'messageId': messageId,
          'content': text,
          'hasProfanity': hasProfanity,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      // ignore: avoid_print
      print('syncChatLog Error: $e');
      return false;
    }
  }
}
