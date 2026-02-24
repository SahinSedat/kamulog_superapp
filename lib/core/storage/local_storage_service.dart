import 'package:hive_flutter/hive_flutter.dart';

/// Yerel depolama servisi — kullanıcı verileri cihazda kalır
/// Sadece isim+telefon sunucuya gider, geri kalan her şey Hive'da
class LocalStorageService {
  static const _profileBox = 'profile';
  static const _surveyBox = 'survey';
  static const _documentsBox = 'documents';
  static const _careerBox = 'career';

  static late Box _profile;
  static late Box _survey;
  static late Box _documents;
  static late Box _career;

  /// main.dart'ta çağrılır — box'ları aç
  static Future<void> init() async {
    _profile = await Hive.openBox(_profileBox);
    _survey = await Hive.openBox(_surveyBox);
    _documents = await Hive.openBox(_documentsBox);
    _career = await Hive.openBox(_careerBox);
  }

  // ════════════════════════════════════════════
  // KARIYER & AI CV KULLANIMI — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveAiCvUsage(List<String> dates) async {
    await _career.put('aiCvUsage', dates);
  }

  static List<String> loadAiCvUsage() {
    final raw = _career.get('aiCvUsage');
    if (raw == null) return [];
    return (raw as List).cast<String>();
  }

  // ════════════════════════════════════════════
  // JETON BAĞLAMI — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveCredits(int credits) async {
    await _profile.put('credits', credits);
  }

  static int loadCredits() {
    return _profile.get('credits', defaultValue: 20);
  }

  // ════════════════════════════════════════════
  // ABONELİK (PREMIUM) DURUMU — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> savePremiumStatus(
    bool isPremium,
    DateTime? endDate,
  ) async {
    await _career.put('isPremium', isPremium);
    if (endDate != null) {
      await _career.put('subscriptionEndDate', endDate.toIso8601String());
    } else {
      await _career.delete('subscriptionEndDate');
    }
  }

  static bool loadIsPremium() {
    return _career.get('isPremium', defaultValue: false);
  }

  static DateTime? loadSubscriptionEndDate() {
    final raw = _career.get('subscriptionEndDate');
    if (raw == null) return null;
    return DateTime.tryParse(raw);
  }

  // ════════════════════════════════════════════
  // PROFIL VERİLERİ — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveProfile({
    String? tcKimlik,
    String? city,
    String? district,
    String? addressLine,
    String? postalCode,
    String? email,
    bool? emailVerified,
    String? employmentType,
    int? yearsWorking,
    String? institution,
    String? title,
  }) async {
    if (tcKimlik != null) await _profile.put('tcKimlik', tcKimlik);
    if (city != null) await _profile.put('city', city);
    if (district != null) await _profile.put('district', district);
    if (addressLine != null) await _profile.put('addressLine', addressLine);
    if (postalCode != null) await _profile.put('postalCode', postalCode);
    if (email != null) await _profile.put('email', email);
    if (emailVerified != null) {
      await _profile.put('emailVerified', emailVerified);
    }
    if (employmentType != null) {
      await _profile.put('employmentType', employmentType);
    }
    if (institution != null) await _profile.put('institution', institution);
    if (yearsWorking != null) await _profile.put('yearsWorking', yearsWorking);
    if (title != null) await _profile.put('title', title);
  }

  static Map<String, dynamic> loadProfile() {
    return {
      'tcKimlik': _profile.get('tcKimlik'),
      'city': _profile.get('city'),
      'district': _profile.get('district'),
      'addressLine': _profile.get('addressLine'),
      'postalCode': _profile.get('postalCode'),
      'email': _profile.get('email'),
      'emailVerified': _profile.get('emailVerified'),
      'employmentType': _profile.get('employmentType'),
      'yearsWorking': _profile.get('yearsWorking'),
      'institution': _profile.get('institution'),
      'title': _profile.get('title'),
    };
  }

  static Future<void> saveProfileImage(String path) async {
    await _profile.put('profileImage', path);
  }

  static String? loadProfileImage() {
    return _profile.get('profileImage');
  }

  static Future<void> saveProfileName(String name) async {
    await _profile.put('profileName', name);
  }

  static String? loadProfileName() {
    return _profile.get('profileName');
  }

  static Future<void> saveProfilePhone(String phone) async {
    await _profile.put('profilePhone', phone);
  }

  static String? loadProfilePhone() {
    return _profile.get('profilePhone');
  }

  // ════════════════════════════════════════════
  // ANKET SONUÇLARI — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveSurveyResults({
    String? institution,
    String? city,
    List<String>? interests,
  }) async {
    if (institution != null) await _survey.put('institution', institution);
    if (city != null) await _survey.put('city', city);
    if (interests != null) await _survey.put('interests', interests);
  }

  static Map<String, dynamic> loadSurveyResults() {
    return {
      'institution': _survey.get('institution'),
      'city': _survey.get('city'),
      'interests': _survey.get('interests')?.cast<String>(),
    };
  }

  /// Anket tamamlandı mı?
  static bool get hasSurveyCompleted => _survey.get('completed') == true;

  static Future<void> markSurveyCompleted() async {
    await _survey.put('completed', true);
  }

  // ════════════════════════════════════════════
  // BELGE METADATA — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveDocument(Map<String, dynamic> doc) async {
    final docs = loadDocuments();
    docs.add(doc);
    await _documents.put('list', docs);
  }

  static List<Map<String, dynamic>> loadDocuments() {
    final raw = _documents.get('list');
    if (raw == null) return [];
    return (raw as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static Future<void> removeDocument(String docId) async {
    final docs = loadDocuments();
    docs.removeWhere((d) => d['id'] == docId);
    await _documents.put('list', docs);
  }

  // ════════════════════════════════════════════
  // ════════════════════════════════════════════
  // CV PDF YÜKLEME — 1 kez hak
  // ════════════════════════════════════════════

  static Future<void> saveCvUploaded() async {
    await _career.put('cvPdfUploaded', true);
  }

  static bool isCvUploaded() {
    return _career.get('cvPdfUploaded', defaultValue: false) == true;
  }

  static Future<void> resetCvUploaded() async {
    await _career.put('cvPdfUploaded', false);
  }

  // ════════════════════════════════════════════
  // İŞ ANALİZİ GEÇMİŞİ — cihazda kalır
  // ════════════════════════════════════════════

  static Future<void> saveJobAnalysis(Map<String, dynamic> analysis) async {
    final list = loadJobAnalyses();
    list.insert(0, analysis); // En yeni başa
    // Max 50 kayıt tut
    if (list.length > 50) list.removeLast();
    await _career.put('jobAnalyses', list);
  }

  static List<Map<String, dynamic>> loadJobAnalyses() {
    final raw = _career.get('jobAnalyses');
    if (raw == null) return [];
    return (raw as List).map((e) => Map<String, dynamic>.from(e)).toList();
  }

  // ════════════════════════════════════════════
  // TEMIZLEME
  // ════════════════════════════════════════════

  static Future<void> clearAll() async {
    await _profile.clear();
    await _survey.clear();
    await _documents.clear();
    await _career.clear();
  }
}
