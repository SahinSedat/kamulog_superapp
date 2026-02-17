import 'package:intl/intl.dart';

class Validators {
  Validators._();

  /// Validates Turkish phone number (10 digits, no prefix)
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefon numarası gerekli';
    }
    final cleaned = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 10) {
      return 'Telefon numarası 10 haneli olmalıdır';
    }
    if (!cleaned.startsWith('5')) {
      return 'Geçerli bir cep telefonu numarası giriniz';
    }
    return null;
  }

  /// Validates OTP code
  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'Doğrulama kodu gerekli';
    }
    if (value.length != 6) {
      return 'Doğrulama kodu 6 haneli olmalıdır';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(value)) {
      return 'Sadece rakam girişi yapılabilir';
    }
    return null;
  }

  /// Validates email
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'E-posta adresi gerekli';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Geçerli bir e-posta adresi giriniz';
    }
    return null;
  }

  /// Validates required field
  static String? validateRequired(String? value, [String? fieldName]) {
    if (value == null || value.trim().isEmpty) {
      return '${fieldName ?? 'Bu alan'} gereklidir';
    }
    return null;
  }

  /// Validates min length
  static String? validateMinLength(
    String? value,
    int min, [
    String? fieldName,
  ]) {
    if (value == null || value.length < min) {
      return '${fieldName ?? 'Bu alan'} en az $min karakter olmalıdır';
    }
    return null;
  }
}

class Formatters {
  Formatters._();

  /// Formats phone to display format: 5XX XXX XX XX
  static String formatPhoneDisplay(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length != 10) return phone;
    return '${cleaned.substring(0, 3)} ${cleaned.substring(3, 6)} '
        '${cleaned.substring(6, 8)} ${cleaned.substring(8, 10)}';
  }

  /// Formats phone for API: +905XXXXXXXXX
  static String formatPhoneForApi(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length == 10) return '+90$cleaned';
    if (cleaned.length == 12 && cleaned.startsWith('90')) return '+$cleaned';
    return '+90$cleaned';
  }

  /// Masks phone: *******1234
  static String maskPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^\d]'), '');
    if (cleaned.length < 4) return phone;
    final last4 = cleaned.substring(cleaned.length - 4);
    return '*' * (cleaned.length - 4) + last4;
  }

  /// Formats date to Turkish locale
  static String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'tr_TR').format(date);
  }

  /// Formats date with time
  static String formatDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm', 'tr_TR').format(date);
  }

  /// Formats relative time (e.g., "2 saat önce")
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inSeconds < 60) return 'Az önce';
    if (diff.inMinutes < 60) return '${diff.inMinutes} dakika önce';
    if (diff.inHours < 24) return '${diff.inHours} saat önce';
    if (diff.inDays < 7) return '${diff.inDays} gün önce';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} hafta önce';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} ay önce';
    return '${(diff.inDays / 365).floor()} yıl önce';
  }

  /// Truncates text with ellipsis
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
