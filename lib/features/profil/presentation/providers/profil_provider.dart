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
  final EmploymentType? employmentType;
  final String? institution;
  final String? title;
  final List<DocumentInfo> documents;

  // Anketten gelen veriler
  final String? surveyInstitution;
  final String? surveyCity;
  final List<String> surveyInterests;

  // Kariyer & Abonelik & Kredi Bilgileri
  final int credits;
  final bool isPremium;
  final DateTime? subscriptionEndDate;
  final List<String> aiCvUsageDates; // ISO formatında tarihler

  final String? error;

  const ProfilState({
    this.isLoading = false,
    this.name,
    this.phone,
    this.tcKimlik,
    this.city,
    this.district,
    this.employmentType,
    this.institution,
    this.title,
    this.documents = const [],
    this.surveyInstitution,
    this.surveyCity,
    this.surveyInterests = const [],
    this.credits = 10,
    this.isPremium = false,
    this.subscriptionEndDate,
    this.aiCvUsageDates = const [],
    this.error,
  });

  ProfilState copyWith({
    bool? isLoading,
    String? name,
    String? phone,
    String? tcKimlik,
    String? city,
    String? district,
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
  }) {
    return ProfilState(
      isLoading: isLoading ?? this.isLoading,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      tcKimlik: tcKimlik ?? this.tcKimlik,
      city: city ?? this.city,
      district: district ?? this.district,
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
    );
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

  /// Kalan AI CV hakkı (Ayda 2 kez)
  int get remainingAiCvCount => (2 - aiCvCountThisMonth).clamp(0, 2);

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
    }
  }
}

/// Belge bilgisi
class DocumentInfo {
  final String id;
  final String name;
  final String category; // cv, stk, kimlik, diger
  final String fileType;
  final DateTime uploadDate;
  final String? content;

  const DocumentInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.fileType,
    required this.uploadDate,
    this.content,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'fileType': fileType,
    'uploadDate': uploadDate.toIso8601String(),
    if (content != null) 'content': content,
  };

  factory DocumentInfo.fromJson(Map<String, dynamic> json) => DocumentInfo(
    id: json['id'],
    name: json['name'],
    category: json['category'],
    fileType: json['fileType'],
    uploadDate: DateTime.parse(json['uploadDate']),
    content: json['content'] as String?,
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
    final credits = LocalStorageService.loadCredits();
    final aiCvUsage = LocalStorageService.loadAiCvUsage();

    state = state.copyWith(
      tcKimlik: profileData['tcKimlik'],
      city: profileData['city'],
      district: profileData['district'],
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
      documents: documentsData.map((d) => DocumentInfo.fromJson(d)).toList(),
      credits: credits,
      aiCvUsageDates: aiCvUsage,
    );
  }

  /// Login'den gelen bilgilerle profili başlat
  void loadFromAuth(dynamic user) {
    if (user != null) {
      state = state.copyWith(
        name: user.name,
        phone: user.phone,
        // Eğer yerelde yoksa auth'dan gelenleri de alabiliriz
        employmentType: state.employmentType ?? user.employmentType,
        title: state.title ?? user.title,
      );
    }
  }

  /// Kredi harca (Analiz vs. için)
  Future<bool> useCredits(int amount) async {
    if (state.credits < amount) return false;

    final newCredits = state.credits - amount;
    state = state.copyWith(credits: newCredits);
    await LocalStorageService.saveCredits(newCredits);
    return true;
  }

  /// Kredi ekle (Satın alım vs. sonrası için)
  Future<void> addCredits(int amount) async {
    final newCredits = state.credits + amount;
    state = state.copyWith(credits: newCredits);
    await LocalStorageService.saveCredits(newCredits);
  }

  /// Premium aboneliği aktifleştir
  Future<void> activatePremium(DateTime endDate) async {
    state = state.copyWith(isPremium: true, subscriptionEndDate: endDate);
    // İleride LocalStorageService'e de kaydedilecek
  }

  /// Premium aboneliği iptal et
  void cancelPremium() {
    state = state.copyWith(isPremium: false, subscriptionEndDate: null);
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
    EmploymentType? employmentType,
    String? institution,
    String? title,
  }) async {
    state = state.copyWith(
      tcKimlik: tcKimlik,
      city: city,
      district: district,
      employmentType: employmentType,
      institution: institution,
      title: title,
    );

    // Yerel hafızaya kaydet
    await LocalStorageService.saveProfile(
      tcKimlik: tcKimlik,
      city: city,
      district: district,
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
}

final profilProvider = StateNotifierProvider<ProfilNotifier, ProfilState>((
  ref,
) {
  final notifier = ProfilNotifier();
  final user = ref.watch(currentUserProvider);
  notifier.loadFromAuth(user);
  return notifier;
});
