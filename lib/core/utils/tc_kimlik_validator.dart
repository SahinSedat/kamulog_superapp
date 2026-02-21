/// TC Kimlik No doğrulama algoritması
/// Türkiye Cumhuriyeti TC Kimlik Numarası 11 haneden oluşur
/// ve belirli matematiksel kurallara uyar.
class TcKimlikValidator {
  /// TC Kimlik No doğrulaması yapar
  /// Algoritmik kontrol — İçişleri Bakanlığı API'si yerine
  static bool validate(String tcNo) {
    // 11 hane olmalı
    if (tcNo.length != 11) return false;

    // Sadece rakamlardan oluşmalı
    if (!RegExp(r'^\d{11}$').hasMatch(tcNo)) return false;

    // İlk hane 0 olamaz
    if (tcNo[0] == '0') return false;

    // Tüm rakamlar aynı olamaz (ör: 11111111111)
    if (tcNo.split('').toSet().length == 1) return false;

    final digits = tcNo.split('').map(int.parse).toList();

    // Kural 1: Tek hanelerin toplamı (1, 3, 5, 7, 9) * 7
    // eksi çift hanelerin toplamı (2, 4, 6, 8) mod 10 = 10. hane
    final oddSum = digits[0] + digits[2] + digits[4] + digits[6] + digits[8];
    final evenSum = digits[1] + digits[3] + digits[5] + digits[7];
    final tenthDigit = ((oddSum * 7) - evenSum) % 10;
    if (tenthDigit != digits[9]) return false;

    // Kural 2: İlk 10 hanenin toplamı mod 10 = 11. hane
    int sum = 0;
    for (int i = 0; i < 10; i++) {
      sum += digits[i];
    }
    if (sum % 10 != digits[10]) return false;

    return true;
  }

  /// TC Kimlik No formatla (3-3-3-2)
  static String format(String tcNo) {
    if (tcNo.length != 11) return tcNo;
    return '${tcNo.substring(0, 3)} ${tcNo.substring(3, 6)} '
        '${tcNo.substring(6, 9)} ${tcNo.substring(9, 11)}';
  }
}
