import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

/// Profil bilgilerini tutan state — TC, il/ilçe, kurum, unvan, belgeler
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

  /// Formatlanmış adres
  String get addressText {
    if (city == null) return 'Girilmedi';
    if (district != null) return '$district / $city';
    return city!;
  }

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

  const DocumentInfo({
    required this.id,
    required this.name,
    required this.category,
    required this.fileType,
    required this.uploadDate,
  });
}

class ProfilNotifier extends StateNotifier<ProfilState> {
  ProfilNotifier() : super(const ProfilState());

  /// Login'den gelen bilgilerle profili başlat
  void loadFromAuth(dynamic user) {
    if (user != null) {
      state = state.copyWith(
        name: user.name,
        phone: user.phone,
        employmentType: user.employmentType,
        title: user.title,
      );
    }
  }

  /// Bilgilerim bölümünü güncelle
  void updatePersonalInfo({
    String? tcKimlik,
    String? city,
    String? district,
    EmploymentType? employmentType,
    String? institution,
    String? title,
  }) {
    state = state.copyWith(
      tcKimlik: tcKimlik,
      city: city,
      district: district,
      employmentType: employmentType,
      institution: institution,
      title: title,
    );
  }

  /// Belge ekle
  void addDocument(DocumentInfo doc) {
    state = state.copyWith(documents: [...state.documents, doc]);
  }

  /// Belge sil
  void removeDocument(String docId) {
    state = state.copyWith(
      documents: state.documents.where((d) => d.id != docId).toList(),
    );
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
