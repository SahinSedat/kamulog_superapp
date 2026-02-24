import 'package:shared_preferences/shared_preferences.dart';

/// Bildirim tercihleri yonetimi
/// Veritabani entegrasyonu icin bu sinif uzerinden islenecek
class NotificationPreferencesService {
  static const String _smsConsentKey = 'smsConsent';
  static const String _emailConsentKey = 'emailConsent';

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

  /// Tum bildirim tercihlerini yukle
  static Future<Map<String, bool>> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'sms': prefs.getBool(_smsConsentKey) ?? false,
      'email': prefs.getBool(_emailConsentKey) ?? false,
    };
  }

  /// Tercihleri backend'e gondermeye hazirla
  /// Veritabani entegrasyonu yapildiginda bu metod guncellenecek
  static Future<Map<String, dynamic>> toBackendPayload() async {
    final prefs = await loadPreferences();
    return {
      'smsNotificationsEnabled': prefs['sms'] ?? false,
      'emailNotificationsEnabled': prefs['email'] ?? false,
    };
  }
}
