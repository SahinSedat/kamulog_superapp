import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

/// Profil bilgilerini tutan state — TC, il/ilçe, kurum, unvan, belgeler ve anket sonuçları
class ProfilState {
  final bool isLoading;
  final String? name;
  final String? phone;
  final String? tcKimlik;
  final String? city;
  final String? district;
  final String? email;
  final EmploymentType? employmentType;
  final String? institution;
  final String? title;
  final List<DocumentInfo> documents;

  // Anketten gelen veriler
  final String? surveyInstitution;
  final String? surveyCity;
  final List<String> surveyInterests;

  // Kariyer & Abonelik & Jeton Bilgileri
  final int credits;
  final bool isPremium;
  final DateTime? subscriptionEndDate;
  final List<String> aiCvUsageDates; // ISO formatında tarihler
  final String? profileImagePath; // Local profile image path

  final String? error;

  const ProfilState({
    this.isLoading = false,
    this.name,
    this.phone,
    this.tcKimlik,
    this.city,
    this.district,
    this.email,
    this.employmentType,
    this.institution,
    this.title,
    this.documents = const [],
    this.surveyInstitution,
    this.surveyCity,
    this.surveyInterests = const [],
    this.credits = 20,
    this.isPremium = false,
    this.subscriptionEndDate,
    this.aiCvUsageDates = const [],
    this.error,
    this.profileImagePath,
  });

  ProfilState copyWith({
    bool? isLoading,
    String? name,
    String? phone,
    String? tcKimlik,
    String? city,
    String? district,
    String? email,
    EmploymentType? employmentType,
    String? institution,
    String? title,
    List<DocumentInfo>? documents,
    String? surveyInstitution,
    String? surveyCity,
    List<String>? surveyInterests,
    int? credits,
    bool? isPremium,
    DateTime? subscriptionEndDate,
    List<String>? aiCvUsageDates,
    String? error,
    String? profileImagePath,
  }) {
    return ProfilState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      tcKimlik: tcKimlik ?? this.tcKimlik,
      city: city ?? this.city,
      district: district ?? this.district,
      email: email ?? this.email,
      employmentType: employmentType ?? this.employmentType,
      institution: institution ?? this.institution,
      title: title ?? this.title,
      documents: documents ?? this.documents,
      surveyInstitution: surveyInstitution ?? this.surveyInstitution,
      surveyCity: surveyCity ?? this.surveyCity,
      surveyInterests: surveyInterests ?? this.surveyInterests,
      credits: credits ?? this.credits,
      isPremium: isPremium ?? this.isPremium,
      subscriptionEndDate: subscriptionEndDate ?? this.subscriptionEndDate,
      aiCvUsageDates: aiCvUsageDates ?? this.aiCvUsageDates,
      error: error,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  /// Seçili miktar kadar jetonu var mı? (Premium ise hep true)
  bool hasEnoughCredits(int amount) {
    if (isPremium) return true;
    return credits >= amount;
  }

  /// Profil tamamlanma yüzdesi
  int get completionPercent {
    int total = 7;
    int filled = 0;
    if (name != null && name!.isNotEmpty) filled++;
    if (phone != null && phone!.isNotEmpty) filled++;
    if (tcKimlik != null && tcKimlik!.isNotEmpty) filled++;
    if (city != null && city!.isNotEmpty) filled++;
    if (employmentType != null) filled++;
    if (institution != null && institution!.isNotEmpty) filled++;
    if (title != null && title!.isNotEmpty) filled++;
    return ((filled / total) * 100).round();
  }

  /// CV belgesi var mı?
  bool get hasCv => documents.any((d) => d.category == 'cv');

  /// Bu ay kaç AI CV oluşturuldu?
  int get aiCvCountThisMonth {
    final now = DateTime.now();
    return aiCvUsageDates.where((dateStr) {
      final date = DateTime.parse(dateStr);
      return date.year == now.year && date.month == now.month;
    }).length;
  }

  /// Kalan AI CV hakkı (Tüm kullanıcılar ayda 1 kez)
  int get remainingAiCvCount {
    // Tüm kullanıcılar (premium dahil) ayda 1 CV hakkı
    return (1 - aiCvCountThisMonth).clamp(0, 1);
  }

  /// Formatlanmış adres (önce profil verisi, yoksa anket verisi)
  String get addressText {
    final effectiveCity = city ?? surveyCity;
    if (effectiveCity == null) return 'Girilmedi';
    if (district != null) return '$district / $effectiveCity';
    return effectiveCity;
  }

  /// Formatlanmış kurum (önce profil verisi, yoksa anket verisi)
  String get effectiveInstitution =>
      institution ?? surveyInstitution ?? 'Belirtilmedi';

  /// Formatlanmış çalışma durumu
  String get employmentText {
    if (employmentType == null) return 'Belirtilmedi';
    switch (employmentType!) {
      case EmploymentType.memur:
        return 'Devlet Memuru';
      case EmploymentType.isci:
        return 'Kamu İşçisi';
      case EmploymentType.sozlesmeli:
        return 'Sözleşmeli';
      case EmploymentType.ozelSektor:
        return 'Özel Sektör';
    }
  }
}

class DocumentInfo {
  final String id;
  final String name;
  final String category; // cv, stk, kimlik, diger
  final String fileType;
  final DateTime uploadDate;
  final String? content;
  final String? filePath;

  const DocumentInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.fileType,
    required this.uploadDate,
    this.content,
    this.filePath,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'fileType': fileType,
    'uploadDate': uploadDate.toIso8601String(),
    if (content != null) 'content': content,
    if (filePath != null) 'filePath': filePath,
  };

  factory DocumentInfo.fromJson(Map<String, dynamic> json) => DocumentInfo(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    fileType: json['fileType'],
    uploadDate: DateTime.parse(json['uploadDate']),
    content: json['content'] as String?,
    filePath: json['filePath'] as String?,
  );
}

class ProfilNotifier extends StateNotifier<ProfilState> {
  ProfilNotifier() : super(const ProfilState()) {
    _init();
  }

  /// Başlangıçta yerel hafızadan verileri yükle
  void _init() {
    final profileData = LocalStorageService.loadProfile();
    final surveyData = LocalStorageService.loadSurveyResults();
    final documentsData = LocalStorageService.loadDocuments();
    final aiCvUsage = LocalStorageService.loadAiCvUsage();
    final isPremium = LocalStorageService.loadIsPremium();
    final subscriptionEndDate = LocalStorageService.loadSubscriptionEndDate();
    final profileImage = LocalStorageService.loadProfileImage();
    final savedCredits = LocalStorageService.loadCredits();

    state = state.copyWith(
      tcKimlik: profileData['tcKimlik'],
      city: profileData['city'],
      district: profileData['district'],
      email: profileData['email'],
      employmentType:
          profileData['employmentType'] != null
              ? EmploymentType.values.firstWhere(
                (e) => e.name == profileData['employmentType'],
                orElse: () => EmploymentType.memur,
              )
              : null,
      institution: profileData['institution'],
      title: profileData['title'],
      surveyInstitution: surveyData['institution'],
      surveyCity: surveyData['city'],
      surveyInterests: surveyData['interests'] ?? [],
      credits: savedCredits,
      documents: documentsData.map((d) => DocumentInfo.fromJson(d)).toList(),
      isPremium: isPremium,
      subscriptionEndDate: subscriptionEndDate,
      aiCvUsageDates: aiCvUsage,
      profileImagePath: profileImage,
    );
  }

  /// Login'den gelen bilgilerle profili başlat
  void loadFromAuth(dynamic user) {
    if (user != null) {
      // Lokal olarak kayıtlı kredi varsa onu koru, yoksa backend'den al
      final localCredits = LocalStorageService.loadCredits();
      final effectiveCredits = localCredits > 0 ? localCredits : user.credits;

      state = state.copyWith(
        name: user.name,
        phone: user.phone,
        employmentType: state.employmentType ?? user.employmentType,
        title: state.title ?? user.title,
        credits: effectiveCredits,
      );

      // Sadece ilk seferde (lokal kayıt yoksa) backend değerini kaydet
      if (localCredits <= 0) {
        LocalStorageService.saveCredits(user.credits);
      }
    }
  }

  /// Jetonu düşer
  Future<bool> decreaseCredits(int amount) async {
    if (state.isPremium) return true; // Premium ise düşme
    if (state.credits < amount) return false;

    final newCredits = state.credits - amount;
    state = state.copyWith(credits: newCredits);
    await LocalStorageService.saveCredits(newCredits);
    return true;
  }

  /// Premium aboneliği aktifleştir
  Future<void> activatePremium(DateTime endDate) async {
    state = state.copyWith(isPremium: true, subscriptionEndDate: endDate);
    await LocalStorageService.savePremiumStatus(true, endDate);
  }

  /// Premium aboneliği iptal et
  Future<void> cancelPremium() async {
    state = state.copyWith(isPremium: false, subscriptionEndDate: null);
    await LocalStorageService.savePremiumStatus(false, null);
  }

  /// Profil sıfırlama (test amaçlı desteklenebilir, veya iptal edilebilir)
  Future<void> clearPremiumStatus() async {
    state = state.copyWith(isPremium: false, subscriptionEndDate: null);
    await LocalStorageService.savePremiumStatus(false, null);
  }

  /// AI CV kullanımını kaydet
  Future<bool> recordAiCvUsage() async {
    if (state.remainingAiCvCount <= 0) return false;

    final newList = [...state.aiCvUsageDates, DateTime.now().toIso8601String()];
    state = state.copyWith(aiCvUsageDates: newList);
    await LocalStorageService.saveAiCvUsage(newList);
    return true;
  }

  /// Bilgilerim bölümünü güncelle
  Future<void> updatePersonalInfo({
    String? tcKimlik,
    String? city,
    String? district,
    String? email,
    EmploymentType? employmentType,
    String? institution,
    String? title,
  }) async {
    state = state.copyWith(
      tcKimlik: tcKimlik,
      city: city,
      district: district,
      email: email,
      employmentType: employmentType,
      institution: institution,
      title: title,
    );

    // Yerel hafızaya kaydet
    await LocalStorageService.saveProfile(
      tcKimlik: tcKimlik,
      city: city,
      district: district,
      email: email,
      employmentType: employmentType?.name,
      institution: institution,
      title: title,
    );
  }

  /// Belge ekle
  Future<void> addDocument(DocumentInfo doc) async {
    final newDocs = [...state.documents, doc];
    state = state.copyWith(documents: newDocs);
    await LocalStorageService.saveDocument(doc.toJson());
  }

  /// Belge sil
  Future<void> removeDocument(String docId) async {
    final newDocs = state.documents.where((d) => d.id != docId).toList();
    state = state.copyWith(documents: newDocs);
    await LocalStorageService.removeDocument(docId);
  }

  /// İsim güncelle
  Future<void> updateName(String name) async {
    state = state.copyWith(name: name);
    await LocalStorageService.saveProfileName(name);
  }

  /// Telefon numarasını güncelle (doğrulama sonrası çağırılır)
  Future<void> updatePhone(String phone) async {
    state = state.copyWith(phone: phone);
    await LocalStorageService.saveProfilePhone(phone);
  }

  /// Profil Fotoğrafı Güncelle
  Future<void> updateProfileImage(String path) async {
    state = state.copyWith(profileImagePath: path);
    await LocalStorageService.saveProfileImage(path);
  }
}

final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((
  ref,
) {
  final notifier = ProfilNotifier();
  final user = ref.watch(currentUserProvider);
  notifier.loadFromAuth(user);
  return notifier;
});
