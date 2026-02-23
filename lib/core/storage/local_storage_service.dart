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
    String? employmentType,
    String? institution,
    String? title,
  }) async {
    if (tcKimlik != null) await _profile.put('tcKimlik', tcKimlik);
    if (city != null) await _profile.put('city', city);
    if (district != null) await _profile.put('district', district);
    if (employmentType != null) {
      await _profile.put('employmentType', employmentType);
    }
    if (institution != null) await _profile.put('institution', institution);
    if (title != null) await _profile.put('title', title);
  }

  static Map<String, dynamic> loadProfile() {
    return {
      'tcKimlik': _profile.get('tcKimlik'),
      'city': _profile.get('city'),
      'district': _profile.get('district'),
      'employmentType': _profile.get('employmentType'),
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
  // TEMIZLEME
  // ════════════════════════════════════════════

  static Future<void> clearAll() async {
    await _profile.clear();
    await _survey.clear();
    await _documents.clear();
  }
}
