import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

/// Kullanici oturum yonetimi — telefon numarasi degisikligi tespiti
/// Veritabani entegrasyonu icin bu sinif uzerinden islenecek
class UserSessionService {
  /// Onceki kullanicidan farkli bir numara ile giris yapilip yapilmadigini kontrol et
  /// Farkli numara ise eski Hive verilerini temizle
  static Future<bool> handleUserSwitch(String? incomingPhone) async {
    final storedPhone = LocalStorageService.loadProfilePhone();

    if (storedPhone != null &&
        storedPhone.isNotEmpty &&
        incomingPhone != null &&
        incomingPhone.isNotEmpty &&
        storedPhone != incomingPhone) {
      // Farkli kullanici — eski verileri temizle
      await LocalStorageService.clearAll();
      return true; // Kullanici degisti
    }
    return false; // Ayni kullanici
  }

  /// Mevcut oturumdaki telefon numarasini kaydet
  static Future<void> saveCurrentPhone(String phone) async {
    await LocalStorageService.saveProfilePhone(phone);
  }

  /// Mevcut oturumun telefon numarasini al
  static String? getCurrentPhone() {
    return LocalStorageService.loadProfilePhone();
  }
}
