import 'package:shared_preferences/shared_preferences.dart';

/// Bildirim tercihleri yonetimi
/// Veritabani entegrasyonu icin bu sinif uzerinden islenecek
class NotificationPreferencesService {
  static const String _pushConsentKey = 'pushConsent';
  static const String _smsConsentKey = 'smsConsent';
  static const String _emailConsentKey = 'emailConsent';

  /// Push bildirim tercihini kaydet
  static Future<void> savePushConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushConsentKey, value);
  }

  /// SMS bildirim tercihini kaydet
  static Future<void> saveSmsConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_smsConsentKey, value);
  }

  /// E-posta bildirim tercihini kaydet
  static Future<void> saveEmailConsent(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_emailConsentKey, value);
  }

  /// Tum bildirim tercihlerini kaydet (toplu)
  static Future<void> saveAll({
    required bool push,
    required bool sms,
    required bool email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_pushConsentKey, push);
    await prefs.setBool(_smsConsentKey, sms);
    await prefs.setBool(_emailConsentKey, email);
  }

  /// Tum bildirim tercihlerini yukle
  static Future<Map<String, bool>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'push': prefs.getBool(_pushConsentKey) ?? false,
      'sms': prefs.getBool(_smsConsentKey) ?? false,
      'email': prefs.getBool(_emailConsentKey) ?? false,
    };
  }

  /// Tercihleri backend'e gondermeye hazirla
  /// Veritabani entegrasyonu yapildiginda bu metod guncellenecek
  static Future<Map<String, dynamic>> toBackendPayload() async {
    final prefs = await loadPreferences();
    return {
      'pushNotificationsEnabled': prefs['push'] ?? false,
      'smsNotificationsEnabled': prefs['sms'] ?? false,
      'emailNotificationsEnabled': prefs['email'] ?? false,
    };
  }
}
