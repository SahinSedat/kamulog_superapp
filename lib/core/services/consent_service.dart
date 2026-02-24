import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

/// Kullanici Sozlesmesi ve KVKK onay yonetimi
/// Veritabani entegrasyonu icin bu sinif uzerinden islenecek
class ConsentService {
  /// Onaylari kaydet (tarih/saat damgasiyla)
  static Future<void> saveConsent({
    required bool userAgreement,
    required bool kvkk,
  }) async {
    await LocalStorageService.saveConsent(
      userAgreement: userAgreement,
      kvkk: kvkk,
    );
  }

  /// Kayitli onaylari yukle
  static Map<String, dynamic> loadConsent() {
    return LocalStorageService.loadConsent();
  }

  /// Kullanicinin tum sozlesmeleri onaylayip onaylamadigini kontrol et
  static bool isFullyConsented() {
    final consent = loadConsent();
    return consent['userAgreement'] == true && consent['kvkk'] == true;
  }

  /// Onay bilgilerini backend'e gondermeye hazirla
  /// Veritabani entegrasyonu yapildiginda bu metod guncellenecek
  static Map<String, dynamic> toBackendPayload() {
    final consent = loadConsent();
    return {
      'userAgreementAccepted': consent['userAgreement'] ?? false,
      'userAgreementDate': consent['userAgreementDate'],
      'kvkkAccepted': consent['kvkk'] ?? false,
      'kvkkDate': consent['kvkkDate'],
    };
  }
}
