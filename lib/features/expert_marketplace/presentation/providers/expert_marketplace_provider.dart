import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_category.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_profile.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/service_package.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/expert_review.dart';
import 'package:kamulog_superapp/features/expert_marketplace/data/models/ai_recommendation.dart';

// ════════════════════════════════════════════
// STATE
// ════════════════════════════════════════════

class ExpertMarketplaceState {
  final List<ExpertProfile> allExperts;
  final List<ExpertProfile> filteredExperts;
  final ExpertCategoryType? selectedCategory;
  final String searchQuery;
  final String sortBy; // 'rating', 'price', 'experience'
  final bool isLoading;
  final AIRecommendation? aiRecommendation;

  const ExpertMarketplaceState({
    this.allExperts = const [],
    this.filteredExperts = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.sortBy = 'rating',
    this.isLoading = false,
    this.aiRecommendation,
  });

  ExpertMarketplaceState copyWith({
    List<ExpertProfile>? allExperts,
    List<ExpertProfile>? filteredExperts,
    ExpertCategoryType? selectedCategory,
    bool clearCategory = false,
    String? searchQuery,
    String? sortBy,
    bool? isLoading,
    AIRecommendation? aiRecommendation,
    bool clearRecommendation = false,
  }) {
    return ExpertMarketplaceState(
      allExperts: allExperts ?? this.allExperts,
      filteredExperts: filteredExperts ?? this.filteredExperts,
      selectedCategory:
          clearCategory ? null : (selectedCategory ?? this.selectedCategory),
      searchQuery: searchQuery ?? this.searchQuery,
      sortBy: sortBy ?? this.sortBy,
      isLoading: isLoading ?? this.isLoading,
      aiRecommendation:
          clearRecommendation
              ? null
              : (aiRecommendation ?? this.aiRecommendation),
    );
  }
}

// ════════════════════════════════════════════
// NOTIFIER
// ════════════════════════════════════════════

class ExpertMarketplaceNotifier extends StateNotifier<ExpertMarketplaceState> {
  ExpertMarketplaceNotifier() : super(const ExpertMarketplaceState()) {
    _loadMockData();
  }

  void _loadMockData() {
    state = state.copyWith(
      allExperts: _mockExperts,
      filteredExperts: _mockExperts,
    );
  }

  /// Kategoriye göre filtrele
  void filterByCategory(ExpertCategoryType? category) {
    if (category == null) {
      state = state.copyWith(
        filteredExperts: state.allExperts,
        clearCategory: true,
      );
    } else {
      final filtered =
          state.allExperts.where((e) => e.category == category).toList();
      state = state.copyWith(
        filteredExperts: filtered,
        selectedCategory: category,
      );
    }
    _applySorting();
  }

  /// Sıralama değiştir
  void changeSortBy(String sortBy) {
    state = state.copyWith(sortBy: sortBy);
    _applySorting();
  }

  void _applySorting() {
    final sorted = [...state.filteredExperts];
    switch (state.sortBy) {
      case 'rating':
        sorted.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case 'price':
        sorted.sort((a, b) {
          final aMin =
              a.packages.isEmpty
                  ? 0.0
                  : a.packages
                      .map((p) => p.price)
                      .reduce((x, y) => x < y ? x : y);
          final bMin =
              b.packages.isEmpty
                  ? 0.0
                  : b.packages
                      .map((p) => p.price)
                      .reduce((x, y) => x < y ? x : y);
          return aMin.compareTo(bMin);
        });
        break;
      case 'experience':
        sorted.sort((a, b) => b.experienceYears.compareTo(a.experienceYears));
        break;
    }
    state = state.copyWith(filteredExperts: sorted);
  }

  /// AI ile serbest metin analizi — ileride LLM API'ye bağlanacak
  Future<AIRecommendation> analyzeWithAI(String userInput) async {
    state = state.copyWith(isLoading: true);
    // Simülasyon: gerçek API çağrısı yerine basit keyword analizi
    await Future.delayed(const Duration(seconds: 2));

    final lower = userInput.toLowerCase();
    ExpertCategoryType category;
    String explanation;

    if (lower.contains('hukuk') ||
        lower.contains('dava') ||
        lower.contains('soruşturma') ||
        lower.contains('ceza') ||
        lower.contains('disiplin') ||
        lower.contains('mahkeme')) {
      category = ExpertCategoryType.hukuki;
      explanation =
          'Sorununuz hukuki bir konuyla ilgili görünüyor. Size idare hukuku uzmanlarımızı öneriyoruz.';
    } else if (lower.contains('maaş') ||
        lower.contains('vergi') ||
        lower.contains('bordro') ||
        lower.contains('emekli') ||
        lower.contains('mali') ||
        lower.contains('ücret')) {
      category = ExpertCategoryType.mali;
      explanation =
          'Mali bir konuda desteğe ihtiyacınız var. Uzman mali müşavirlerimiz size yardımcı olabilir.';
    } else if (lower.contains('tayin') ||
        lower.contains('atama') ||
        lower.contains('sicil') ||
        lower.contains('izin') ||
        lower.contains('idari') ||
        lower.contains('terfi')) {
      category = ExpertCategoryType.idari;
      explanation =
          'İdari bir işlem hakkında bilgi arıyorsunuz. İdari danışmanlarımız bu konuda uzman.';
    } else if (lower.contains('cv') ||
        lower.contains('kariyer') ||
        lower.contains('iş') ||
        lower.contains('mülakat') ||
        lower.contains('başvuru')) {
      category = ExpertCategoryType.kariyer;
      explanation = 'Kariyer gelişiminiz için uzman desteği öneriyoruz.';
    } else if (lower.contains('stres') ||
        lower.contains('tükenmiş') ||
        lower.contains('motivasyon') ||
        lower.contains('psikoloj') ||
        lower.contains('moral')) {
      category = ExpertCategoryType.psikolojik;
      explanation =
          'Psikolojik destek alanında uzmanlarımız size yardımcı olabilir.';
    } else {
      category = ExpertCategoryType.hukuki;
      explanation =
          'Sorununuzu analiz ettik. En uygun uzmanlarımızı listeliyoruz.';
    }

    final suggestedExperts =
        state.allExperts
            .where((e) => e.category == category)
            .map((e) => e.id)
            .toList();

    final recommendation = AIRecommendation(
      suggestedCategory: category,
      confidenceScore: 0.85,
      explanation: explanation,
      suggestedExpertIds: suggestedExperts,
    );

    // Filtrelemeyi uygula
    filterByCategory(category);
    state = state.copyWith(isLoading: false, aiRecommendation: recommendation);

    return recommendation;
  }

  /// Öne çıkan uzmanlar
  List<ExpertProfile> get featuredExperts =>
      state.allExperts.where((e) => e.isFeatured).toList();

  /// ID ile uzman bul
  ExpertProfile? getExpertById(String id) {
    try {
      return state.allExperts.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}

// ════════════════════════════════════════════
// PROVIDER
// ════════════════════════════════════════════

final expertMarketplaceProvider =
    StateNotifierProvider<ExpertMarketplaceNotifier, ExpertMarketplaceState>(
      (ref) => ExpertMarketplaceNotifier(),
    );

// ════════════════════════════════════════════
// MOCK DATA — 12 uzman (her kategoriden 2)
// ════════════════════════════════════════════

final _mockExperts = [
  // ── Hukuki
  ExpertProfile(
    id: 'exp-001',
    name: 'Av. Mehmet Kaya',
    title: 'İdare Hukuku Uzmanı',
    category: ExpertCategoryType.hukuki,
    rating: 4.9,
    reviewCount: 127,
    experienceYears: 15,
    bio:
        '15 yıllık idare hukuku deneyimi. Danıştay ve idare mahkemelerinde 500+ dava tecrübesi. Kamu personeli hakları konusunda uzmanlaşmış.',
    specializations: [
      'İdare Hukuku',
      'Disiplin Soruşturması',
      'İptal Davaları',
      'Tam Yargı Davaları',
    ],
    isOnline: true,
    isFeatured: true,
    completedConsultations: 342,
    packages: const [
      ServicePackage(
        id: 'pkg-001-1',
        name: 'Hızlı Soru',
        description: 'Tek bir soruya yazılı yanıt',
        price: 0,
        duration: '24 saat',
        includes: ['Yazılı yanıt', 'Mevzuat referansı'],
      ),
      ServicePackage(
        id: 'pkg-001-2',
        name: 'Detaylı Danışmanlık',
        description: 'Video görüşme ile detaylı analiz',
        price: 299,
        duration: '30 dk',
        isPremium: true,
        iapProductId: 'com.kamulog.expert.hukuk.standard',
        includes: ['Video görüşme', 'Dosya inceleme', 'Yazılı rapor'],
      ),
      ServicePackage(
        id: 'pkg-001-3',
        name: 'Dosya İnceleme',
        description: 'Kapsamlı dosya analizi ve strateji',
        price: 599,
        duration: '60 dk',
        isPremium: true,
        iapProductId: 'com.kamulog.expert.hukuk.premium',
        includes: [
          'Dosya analizi',
          'Hukuki strateji',
          'Dilekçe taslağı',
          'Video görüşme',
        ],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r1',
        reviewerName: 'Ali Y.',
        rating: 5.0,
        comment: 'Çok bilgili ve ilgili bir avukat. Sorunumu hemen çözdü.',
        date: DateTime(2026, 2, 15),
      ),
      ExpertReview(
        id: 'r2',
        reviewerName: 'Fatma S.',
        rating: 4.8,
        comment: 'Disiplin soruşturmasında büyük destek oldu. Teşekkürler.',
        date: DateTime(2026, 2, 10),
      ),
      ExpertReview(
        id: 'r3',
        reviewerName: 'Hasan K.',
        rating: 5.0,
        comment: 'Profesyonel yaklaşımı ile güven veriyor.',
        date: DateTime(2026, 1, 28),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-002',
    name: 'Av. Zeynep Demir',
    title: 'İş Hukuku Uzmanı',
    category: ExpertCategoryType.hukuki,
    rating: 4.7,
    reviewCount: 89,
    experienceYears: 10,
    bio:
        '10 yıldır iş hukuku alanında çalışıyor. İşe iade, kıdem/ihbar tazminatı ve işçi-işveren uyuşmazlıkları konusunda deneyimli.',
    specializations: [
      'İş Hukuku',
      'İşe İade',
      'Tazminat Davaları',
      'Toplu Sözleşme',
    ],
    isOnline: false,
    isFeatured: false,
    completedConsultations: 198,
    packages: const [
      ServicePackage(
        id: 'pkg-002-1',
        name: 'Hızlı Soru',
        description: 'Kısa yazılı yanıt',
        price: 0,
        duration: '24 saat',
        includes: ['Yazılı yanıt'],
      ),
      ServicePackage(
        id: 'pkg-002-2',
        name: 'Standart Danışmanlık',
        description: 'Sesli görüşme',
        price: 249,
        duration: '30 dk',
        isPremium: true,
        includes: ['Sesli görüşme', 'Yazılı özet'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r4',
        reviewerName: 'Murat D.',
        rating: 4.5,
        comment: 'Tazminat hesaplamasında çok yardımcı oldu.',
        date: DateTime(2026, 2, 12),
      ),
      ExpertReview(
        id: 'r5',
        reviewerName: 'Ayşe B.',
        rating: 5.0,
        comment: 'İşe iade davamda harika destek verdi.',
        date: DateTime(2026, 2, 1),
      ),
    ],
  ),

  // ── İdari
  ExpertProfile(
    id: 'exp-003',
    name: 'Dr. Ahmet Yılmaz',
    title: 'Kamu Yönetimi Uzmanı',
    category: ExpertCategoryType.idari,
    rating: 4.8,
    reviewCount: 156,
    experienceYears: 20,
    bio:
        '20 yıllık kamu yönetimi tecrübesi. Bakanlık müşavirliği yapmış. Atama, nakil ve sicil düzeltme işlemlerinde uzman.',
    specializations: [
      'Atama & Nakil',
      'Sicil İşlemleri',
      'Kadro Hukuku',
      'Disiplin Hukuku',
    ],
    isOnline: true,
    isFeatured: true,
    completedConsultations: 450,
    packages: const [
      ServicePackage(
        id: 'pkg-003-1',
        name: 'Hızlı Bilgi',
        description: 'Kısa soru-cevap',
        price: 0,
        duration: '24 saat',
        includes: ['Yazılı cevap', 'Mevzuat bilgisi'],
      ),
      ServicePackage(
        id: 'pkg-003-2',
        name: 'İşlem Rehberliği',
        description: 'Adım adım süreç danışmanlığı',
        price: 199,
        duration: '30 dk',
        isPremium: true,
        includes: ['Video görüşme', 'Süreç haritası', 'Dilekçe desteği'],
      ),
      ServicePackage(
        id: 'pkg-003-3',
        name: 'Kapsamlı Dosya',
        description: 'Tam dosya inceleme ve strateji',
        price: 499,
        duration: '60 dk',
        isPremium: true,
        includes: ['Dosya analizi', 'Strateji raporu', '2x takip görüşmesi'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r6',
        reviewerName: 'Kemal A.',
        rating: 5.0,
        comment: 'Tayin işlemimde çok yardımcı oldu. Hızlı ve etkili.',
        date: DateTime(2026, 2, 18),
      ),
      ExpertReview(
        id: 'r7',
        reviewerName: 'Selin T.',
        rating: 4.7,
        comment: 'Sicil düzeltme konusunda profesyonel destek aldım.',
        date: DateTime(2026, 2, 5),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-004',
    name: 'Elif Özkan',
    title: 'İnsan Kaynakları Danışmanı',
    category: ExpertCategoryType.idari,
    rating: 4.6,
    reviewCount: 72,
    experienceYears: 8,
    bio:
        'Kamu personel rejimi ve özlük hakları konusunda danışmanlık. 657 ve 4/B sözleşmeli personel sorunlarında uzman.',
    specializations: [
      '657 Sayılı Kanun',
      '4/B Sözleşmeli',
      'Özlük Hakları',
      'İzin Hakları',
    ],
    isOnline: true,
    isFeatured: false,
    completedConsultations: 165,
    packages: const [
      ServicePackage(
        id: 'pkg-004-1',
        name: 'Ücretsiz Danışma',
        description: 'Genel bilgi',
        price: 0,
        duration: '15 dk',
        includes: ['Kısa yanıt'],
      ),
      ServicePackage(
        id: 'pkg-004-2',
        name: 'Detaylı Analiz',
        description: 'Özlük dosyası inceleme',
        price: 179,
        duration: '30 dk',
        isPremium: true,
        includes: ['Dosya inceleme', 'Yazılı rapor'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r8',
        reviewerName: 'Derya M.',
        rating: 4.8,
        comment: '657 hakları konusunda çok bilgili.',
        date: DateTime(2026, 2, 14),
      ),
    ],
  ),

  // ── Mali
  ExpertProfile(
    id: 'exp-005',
    name: 'SMMM Burak Arslan',
    title: 'Mali Müşavir',
    category: ExpertCategoryType.mali,
    rating: 4.9,
    reviewCount: 203,
    experienceYears: 18,
    bio:
        'Kamu personeli maaş hesaplama, ek ödeme, tazminat ve emeklilik hakları konusunda 18 yıllık deneyim.',
    specializations: [
      'Maaş Hesaplama',
      'Emeklilik',
      'Vergi Danışmanlığı',
      'SGK İşlemleri',
    ],
    isOnline: true,
    isFeatured: true,
    completedConsultations: 520,
    packages: const [
      ServicePackage(
        id: 'pkg-005-1',
        name: 'Maaş Sorgulama',
        description: 'Maaş bordrosu analizi',
        price: 0,
        duration: '24 saat',
        includes: ['Bordro inceleme', 'Kıyaslama'],
      ),
      ServicePackage(
        id: 'pkg-005-2',
        name: 'Emeklilik Planı',
        description: 'Emeklilik hesaplama ve danışmanlık',
        price: 349,
        duration: '45 dk',
        isPremium: true,
        includes: [
          'Emeklilik simülasyonu',
          'Video görüşme',
          'Kıdem/ihbar hesabı',
        ],
      ),
      ServicePackage(
        id: 'pkg-005-3',
        name: 'Vergi Optimizasyonu',
        description: 'Yıllık vergi planlaması',
        price: 699,
        duration: '60 dk',
        isPremium: true,
        includes: ['Vergi analizi', 'Beyanname desteği', 'Planlama raporu'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r9',
        reviewerName: 'Osman G.',
        rating: 5.0,
        comment: 'Emeklilik hesaplamasını çok detaylı yaptı.',
        date: DateTime(2026, 2, 20),
      ),
      ExpertReview(
        id: 'r10',
        reviewerName: 'Nurcan E.',
        rating: 4.8,
        comment: 'Maaş bordrosundaki hatayı hemen fark etti.',
        date: DateTime(2026, 2, 8),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-006',
    name: 'Dr. Cemal Ünal',
    title: 'Vergi Uzmanı',
    category: ExpertCategoryType.mali,
    rating: 4.5,
    reviewCount: 64,
    experienceYears: 12,
    bio:
        'Gelir vergisi, kurumlar vergisi ve KDV konularında akademik çalışmalar yapmış. Mükelleflere vergi optimizasyonu danışmanlığı.',
    specializations: [
      'Gelir Vergisi',
      'KDV',
      'Vergi Cezaları',
      'Muafiyet & İstisna',
    ],
    isOnline: false,
    isFeatured: false,
    completedConsultations: 130,
    packages: const [
      ServicePackage(
        id: 'pkg-006-1',
        name: 'Hızlı Soru',
        description: 'Vergi sorusu yanıtı',
        price: 0,
        duration: '24 saat',
        includes: ['Yazılı yanıt'],
      ),
      ServicePackage(
        id: 'pkg-006-2',
        name: 'Vergi Danışmanlığı',
        description: 'Detaylı vergi analizi',
        price: 399,
        duration: '45 dk',
        isPremium: true,
        includes: ['Video görüşme', 'Vergi raporu'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r11',
        reviewerName: 'Tuncay H.',
        rating: 4.5,
        comment: 'Vergi konularında çok deneyimli.',
        date: DateTime(2026, 1, 25),
      ),
    ],
  ),

  // ── Kariyer
  ExpertProfile(
    id: 'exp-007',
    name: 'Dr. Ayşe Çelik',
    title: 'Kariyer Koçu',
    category: ExpertCategoryType.kariyer,
    rating: 4.8,
    reviewCount: 178,
    experienceYears: 12,
    bio:
        'Kariyer planlama, CV yazımı ve mülakat koçluğu. LinkedIn profil optimizasyonu ve iş arama stratejileri uzmanı.',
    specializations: [
      'Kariyer Planlama',
      'CV & Özgeçmiş',
      'Mülakat Koçluğu',
      'LinkedIn Optimizasyonu',
    ],
    isOnline: true,
    isFeatured: true,
    completedConsultations: 380,
    packages: const [
      ServicePackage(
        id: 'pkg-007-1',
        name: 'CV İnceleme',
        description: 'CV&apos;nizi hızlıca inceleyelim',
        price: 0,
        duration: '24 saat',
        includes: ['CV inceleme', 'Kısa geri bildirim'],
      ),
      ServicePackage(
        id: 'pkg-007-2',
        name: 'Kariyer Koçluğu',
        description: '1-1 kariyer görüşmesi',
        price: 249,
        duration: '45 dk',
        isPremium: true,
        includes: ['Video görüşme', 'Kariyer yol haritası', 'CV düzenleme'],
      ),
      ServicePackage(
        id: 'pkg-007-3',
        name: 'Mülakat Hazırlık',
        description: 'Mock interview + feedback',
        price: 449,
        duration: '60 dk',
        isPremium: true,
        includes: [
          'Mock mülakat',
          'Detaylı feedback',
          'Soru bankası',
          'Sunum koçluğu',
        ],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r12',
        reviewerName: 'Emre K.',
        rating: 5.0,
        comment: 'Mülakat hazırlığı sayesinde işi aldım!',
        date: DateTime(2026, 2, 17),
      ),
      ExpertReview(
        id: 'r13',
        reviewerName: 'Büşra A.',
        rating: 4.7,
        comment: 'CV düzenlemesi çok profesyoneldi.',
        date: DateTime(2026, 2, 3),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-008',
    name: 'Serkan Yıldırım',
    title: 'İnsan Kaynakları Uzmanı',
    category: ExpertCategoryType.kariyer,
    rating: 4.4,
    reviewCount: 56,
    experienceYears: 9,
    bio:
        'Kurumsal şirketlerde İK yöneticiliği yapmış. İşe alım süreçleri ve yetkinlik değerlendirme konusunda deneyimli.',
    specializations: [
      'İşe Alım',
      'Yetkinlik Bazlı Mülakat',
      'Ücret Yönetimi',
      'Performans Değerlendirme',
    ],
    isOnline: false,
    isFeatured: false,
    completedConsultations: 95,
    packages: const [
      ServicePackage(
        id: 'pkg-008-1',
        name: 'Ücretsiz Değerlendirme',
        description: 'Profilinizi değerlendirelim',
        price: 0,
        duration: '15 dk',
        includes: ['Profil değerlendirme'],
      ),
      ServicePackage(
        id: 'pkg-008-2',
        name: 'İK Danışmanlığı',
        description: 'İşe alım süreç rehberliği',
        price: 199,
        duration: '30 dk',
        isPremium: true,
        includes: ['Video görüşme', 'Strateji önerileri'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r14',
        reviewerName: 'Gökhan T.',
        rating: 4.3,
        comment: 'İşe alım sürecini çok iyi anlattı.',
        date: DateTime(2026, 2, 6),
      ),
    ],
  ),

  // ── Psikolojik
  ExpertProfile(
    id: 'exp-009',
    name: 'Uzm. Psk. Deniz Aydın',
    title: 'Klinik Psikolog',
    category: ExpertCategoryType.psikolojik,
    rating: 4.9,
    reviewCount: 234,
    experienceYears: 14,
    bio:
        'İş stresi, tükenmişlik sendromu ve iş-yaşam dengesi konularında uzman. Bilişsel davranışçı terapi (BDT) yaklaşımıyla çalışıyor.',
    specializations: ['İş Stresi', 'Tükenmişlik', 'Anksiyete', 'BDT'],
    isOnline: true,
    isFeatured: true,
    completedConsultations: 600,
    packages: const [
      ServicePackage(
        id: 'pkg-009-1',
        name: 'Ön Görüşme',
        description: 'Tanışma ve ihtiyaç analizi',
        price: 0,
        duration: '15 dk',
        includes: ['Ön değerlendirme'],
      ),
      ServicePackage(
        id: 'pkg-009-2',
        name: 'Bireysel Seans',
        description: 'Online terapi seansı',
        price: 399,
        duration: '50 dk',
        isPremium: true,
        includes: ['Video seans', 'Ödev ve takip', 'Seans notu'],
      ),
      ServicePackage(
        id: 'pkg-009-3',
        name: '4 Seans Paketi',
        description: 'Aylık terapi programı',
        price: 1399,
        duration: '4 x 50 dk',
        isPremium: true,
        includes: ['4 video seans', 'Sürekli destek', 'İlerleme raporu'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r15',
        reviewerName: 'Selma N.',
        rating: 5.0,
        comment: 'İş stresimle başa çıkmamda çok yardımcı oldu.',
        date: DateTime(2026, 2, 19),
      ),
      ExpertReview(
        id: 'r16',
        reviewerName: 'Volkan R.',
        rating: 4.9,
        comment: 'Profesyonel ve empatik yaklaşımı harika.',
        date: DateTime(2026, 2, 11),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-010',
    name: 'Uzm. Psk. Cansu Tekin',
    title: 'Endüstriyel Psikolog',
    category: ExpertCategoryType.psikolojik,
    rating: 4.6,
    reviewCount: 88,
    experienceYears: 7,
    bio:
        'İş yeri psikolojisi ve çalışan motivasyonu üzerine çalışıyor. Mobbing, iletişim sorunları ve takım dinamikleri konusunda uzman.',
    specializations: [
      'Mobbing',
      'İş Yeri İletişimi',
      'Motivasyon',
      'Takım Dinamikleri',
    ],
    isOnline: true,
    isFeatured: false,
    completedConsultations: 180,
    packages: const [
      ServicePackage(
        id: 'pkg-010-1',
        name: 'Ücretsiz Sohbet',
        description: 'İlk değerlendirme',
        price: 0,
        duration: '15 dk',
        includes: ['Kısa görüşme'],
      ),
      ServicePackage(
        id: 'pkg-010-2',
        name: 'Danışmanlık Seansı',
        description: 'Detaylı görüşme',
        price: 299,
        duration: '45 dk',
        isPremium: true,
        includes: ['Video seans', 'Aksiyon planı'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r17',
        reviewerName: 'İrem B.',
        rating: 4.7,
        comment: 'Mobbing konusunda çok yardımcı oldu.',
        date: DateTime(2026, 2, 13),
      ),
    ],
  ),

  // ── Diğer
  ExpertProfile(
    id: 'exp-011',
    name: 'Prof. Dr. Hakan Şen',
    title: 'Eğitim Danışmanı',
    category: ExpertCategoryType.diger,
    rating: 4.7,
    reviewCount: 112,
    experienceYears: 22,
    bio:
        'Lisansüstü eğitim danışmanlığı, akademik kariyer planlaması ve yurt dışı eğitim rehberliği konularında uzman.',
    specializations: [
      'Lisansüstü Eğitim',
      'Akademik Kariyer',
      'Yurt Dışı Eğitim',
      'Araştırma Metodolojisi',
    ],
    isOnline: false,
    isFeatured: false,
    completedConsultations: 280,
    packages: const [
      ServicePackage(
        id: 'pkg-011-1',
        name: 'Danışma',
        description: 'Eğitim yol haritası',
        price: 0,
        duration: '15 dk',
        includes: ['Kısa görüşme'],
      ),
      ServicePackage(
        id: 'pkg-011-2',
        name: 'Akademik Rehberlik',
        description: 'Detaylı planlama',
        price: 349,
        duration: '45 dk',
        isPremium: true,
        includes: ['Video görüşme', 'Yol haritası', 'Kaynak rehberi'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r18',
        reviewerName: 'Yasemin L.',
        rating: 4.8,
        comment: 'Yüksek lisans sürecimde çok faydalı oldu.',
        date: DateTime(2026, 2, 9),
      ),
    ],
  ),
  ExpertProfile(
    id: 'exp-012',
    name: 'Seda Yılmaz',
    title: 'Sosyal Girişimcilik Danışmanı',
    category: ExpertCategoryType.diger,
    rating: 4.5,
    reviewCount: 45,
    experienceYears: 6,
    bio:
        'STK yönetimi, proje yazımı ve hibe başvuruları konusunda danışmanlık. AB projeleri ve TÜBİTAK başvurularında deneyimli.',
    specializations: [
      'STK Yönetimi',
      'Proje Yazımı',
      'Hibe Başvuruları',
      'Gönüllülük',
    ],
    isOnline: true,
    isFeatured: false,
    completedConsultations: 75,
    packages: const [
      ServicePackage(
        id: 'pkg-012-1',
        name: 'Ücretsiz Sohbet',
        description: 'Genel bilgilendirme',
        price: 0,
        duration: '15 dk',
        includes: ['Kısa görüşme'],
      ),
      ServicePackage(
        id: 'pkg-012-2',
        name: 'Proje Danışmanlığı',
        description: 'Proje yazım desteği',
        price: 399,
        duration: '60 dk',
        isPremium: true,
        includes: ['Proje inceleme', 'Strateji', 'Başvuru desteği'],
      ),
    ],
    reviews: [
      ExpertReview(
        id: 'r19',
        reviewerName: 'Emrah S.',
        rating: 4.5,
        comment: 'Hibe başvurumuzda büyük destek oldu.',
        date: DateTime(2026, 1, 30),
      ),
    ],
  ),
];
