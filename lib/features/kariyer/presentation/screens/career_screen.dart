import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/widgets/app_toast.dart';
import 'package:kamulog_superapp/core/data/turkey_locations.dart';
import 'package:kamulog_superapp/core/providers/home_navigation_provider.dart';
import 'package:kamulog_superapp/features/profil/presentation/providers/profil_provider.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/providers/jobs_provider.dart';
import 'package:kamulog_superapp/features/kariyer/data/models/job_listing_model.dart';
import 'package:kamulog_superapp/features/kariyer/presentation/screens/job_detail_screen.dart';
import 'package:kamulog_superapp/features/favorites/data/favorites_service.dart';

/// Kariyer modülü — AI CV oluşturma ve iş analizi
/// Ayrı modül: features/kariyer/ — ileride ayrı API/AI entegrasyonu
class CareerScreen extends ConsumerWidget {
  const CareerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final profil = ref.watch(profilProvider);
    final jobsState = ref.watch(jobsProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            ref.read(homeNavigationProvider.notifier).setIndex(2);
          },
        ),
        title: const Text('Kariyer'),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () {
              if (profil.isPremium) {
                context.push('/subscription-history');
              } else {
                context.push('/upgrade');
              }
            },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    profil.credits <= 0 && !profil.isPremium
                        ? Colors.red.withValues(alpha: 0.1)
                        : AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    profil.credits <= 0 && !profil.isPremium
                        ? Icons.error_outline_rounded
                        : Icons.toll_rounded,
                    size: 16,
                    color:
                        profil.credits <= 0 && !profil.isPremium
                            ? Colors.red
                            : AppTheme.primaryColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    profil.isPremium
                        ? 'Sınırsız'
                        : profil.credits <= 0
                        ? 'Jeton Al'
                        : '${profil.credits} Jeton',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color:
                          profil.credits <= 0 && !profil.isPremium
                              ? Colors.red
                              : AppTheme.primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(jobsProvider);
          await Future.delayed(const Duration(milliseconds: 800));
        },
        color: Colors.white,
        backgroundColor: const Color(0xFF1565C0),
        strokeWidth: 3,
        displacement: 50,
        edgeOffset: 10,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        notificationPredicate: defaultScrollNotificationPredicate,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── AI CV Oluşturucu Banner
                    _AiCvBanner(
                      isDark: isDark,
                      remaining: profil.remainingAiCvCount,
                    ),
                    const SizedBox(height: 20),

                    // ── CV Analizi
                    _CvAnalysisCard(isDark: isDark, hasCv: profil.hasCv),
                    const SizedBox(height: 20),

                    // ── Hızlı Eylemler
                    const Row(
                      children: [
                        Icon(
                          Icons.flash_on_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Hızlı Eylemler',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Opacity(
                      opacity: profil.remainingAiCvCount > 0 ? 1.0 : 0.5,
                      child: _QuickActionCard(
                        icon: Icons.auto_awesome_rounded,
                        title: 'AI ile CV Oluştur',
                        subtitle:
                            profil.remainingAiCvCount > 0
                                ? 'Aylık 1 hak — ${profil.remainingAiCvCount} kullanım kaldı'
                                : 'Bu ayki hakkınız doldu • PDF yükleyebilirsiniz',
                        color: const Color(0xFF1565C0),
                        onTap: () => _showAiCvBuilder(context, ref),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Builder(
                      builder: (context) {
                        // Sistemdeki CV sayısını kontrol et (max 2)
                        final cvCount =
                            profil.documents
                                .where((d) => d.category.toLowerCase() == 'cv')
                                .length;
                        final cvFull = cvCount >= 2;
                        return Opacity(
                          opacity: cvFull ? 0.5 : 1.0,
                          child: _QuickActionCard(
                            icon:
                                cvFull
                                    ? Icons.check_circle_rounded
                                    : Icons.upload_file_rounded,
                            title:
                                cvFull
                                    ? 'CV Hakkınız Doldu (2/2)'
                                    : 'Mevcut CV Yükle ($cvCount/2)',
                            subtitle:
                                cvFull
                                    ? 'Maksimum 2 CV hakkınız kullanıldı • Silip yeniden yükleyebilirsiniz'
                                    : 'PDF veya DOCX formatında CV yükleyin',
                            color:
                                cvFull ? Colors.grey : const Color(0xFF7B1FA2),
                            onTap:
                                cvFull
                                    ? null
                                    : () => context.push('/documents'),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    _QuickActionCard(
                      icon: Icons.hub_rounded,
                      title: 'AI İş Eşleştirme',
                      subtitle: 'Profilinize uygun ilanları AI ile analiz edin',
                      color: const Color(0xFFF57C00),
                      onTap: () => _showJobMatching(context, ref),
                    ),
                    const SizedBox(height: 10),
                    _QuickActionCard(
                      icon: Icons.school_rounded,
                      title: 'KPSS Hazırlık',
                      subtitle: 'Sınav takvimi ve hazırlık kaynakları',
                      color: const Color(0xFFE65100),
                      onTap: () {
                        AppToast.info(
                          context,
                          'KPSS modülü yakında aktif olacak',
                        );
                      },
                    ),

                    const SizedBox(height: 24),
                    // ── Güncel İş İlanları
                    Row(
                      children: [
                        const Icon(
                          Icons.work_rounded,
                          size: 18,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Güncel İş İlanları',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        jobsState.jobs.when(
                          data:
                              (jobs) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '${jobs.length} İlan',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                              ),
                          loading: () => const SizedBox.shrink(),
                          error: (_, __) => const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // ── Filtre Chips
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: [
                          _FilterChip(
                            label: 'Tümü',
                            value: 'ALL',
                            selected: jobsState.filterType == 'ALL',
                            onSelected:
                                () => ref
                                    .read(jobsProvider.notifier)
                                    .setFilterType('ALL'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Kamu',
                            value: 'PUBLIC',
                            selected: jobsState.filterType == 'PUBLIC',
                            onSelected:
                                () => ref
                                    .read(jobsProvider.notifier)
                                    .setFilterType('PUBLIC'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Özel',
                            value: 'PRIVATE',
                            selected: jobsState.filterType == 'PRIVATE',
                            onSelected:
                                () => ref
                                    .read(jobsProvider.notifier)
                                    .setFilterType('PRIVATE'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'Sözleşmeli',
                            value: 'CONTRACT',
                            selected: jobsState.filterType == 'CONTRACT',
                            onSelected:
                                () => ref
                                    .read(jobsProvider.notifier)
                                    .setFilterType('CONTRACT'),
                          ),
                          const SizedBox(width: 8),
                          _FilterChip(
                            label: 'İşçi',
                            value: 'WORKER',
                            selected: jobsState.filterType == 'WORKER',
                            onSelected:
                                () => ref
                                    .read(jobsProvider.notifier)
                                    .setFilterType('WORKER'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    // ── Şehir Filtresi
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color:
                            jobsState.selectedCity.isNotEmpty
                                ? AppTheme.primaryColor.withValues(alpha: 0.1)
                                : (isDark
                                    ? Colors.white10
                                    : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              jobsState.selectedCity.isNotEmpty
                                  ? AppTheme.primaryColor
                                  : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Şehir seçme alanı — picker açar
                          GestureDetector(
                            onTap:
                                () => _showCityPicker(
                                  context,
                                  ref,
                                  jobsState.selectedCity,
                                ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 16,
                                  color:
                                      jobsState.selectedCity.isNotEmpty
                                          ? AppTheme.primaryColor
                                          : Colors.grey,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  jobsState.selectedCity.isNotEmpty
                                      ? jobsState.selectedCity
                                      : 'Tüm Şehirler',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        jobsState.selectedCity.isNotEmpty
                                            ? AppTheme.primaryColor
                                            : Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 4),
                          // X butonu — filtreyi temizler (ayrı tap zone)
                          if (jobsState.selectedCity.isNotEmpty)
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                ref
                                    .read(jobsProvider.notifier)
                                    .setCityFilter('');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            )
                          else
                            GestureDetector(
                              onTap:
                                  () => _showCityPicker(
                                    context,
                                    ref,
                                    jobsState.selectedCity,
                                  ),
                              child: Icon(
                                Icons.arrow_drop_down,
                                size: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // ── Arama alanı
                    TextField(
                      onChanged:
                          (val) => ref
                              .read(jobsProvider.notifier)
                              .setSearchQuery(val),
                      decoration: InputDecoration(
                        hintText: 'İlan ara (başlık, şirket veya içerik)...',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: 20,
                        ),
                        filled: true,
                        fillColor:
                            isDark ? Colors.white10 : Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    jobsState.jobs.when(
                      data: (jobs) {
                        // Şehir filtreleme
                        final cityFilter = jobsState.selectedCity.toLowerCase();

                        // Arama filtreleme
                        final q = jobsState.searchQuery.toLowerCase();
                        var filteredJobs = jobs.toList();

                        // Şehir bazlı filtreleme
                        if (cityFilter.isNotEmpty) {
                          filteredJobs =
                              filteredJobs
                                  .where(
                                    (j) => (j.location ?? '')
                                        .toLowerCase()
                                        .contains(cityFilter),
                                  )
                                  .toList();
                        }

                        // Kelime araması (başlık, açıklama, şirket, ilan kodu)
                        if (q.isNotEmpty) {
                          filteredJobs =
                              filteredJobs
                                  .where(
                                    (j) =>
                                        j.title.toLowerCase().contains(q) ||
                                        j.description.toLowerCase().contains(
                                          q,
                                        ) ||
                                        j.company.toLowerCase().contains(q) ||
                                        JobDetailScreen.getListingCode(
                                          j,
                                        ).toLowerCase().contains(q),
                                  )
                                  .toList();
                        }
                        if (filteredJobs.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: Text('Şu an güncel ilan bulunmuyor.'),
                            ),
                          );
                        }
                        return Column(
                          children:
                              filteredJobs
                                  .map(
                                    (job) => Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 10,
                                      ),
                                      child: _JobCard(job: job, isDark: isDark),
                                    ),
                                  )
                                  .toList(),
                        );
                      },
                      loading:
                          () => const Center(
                            child: Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      error:
                          (err, stack) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text(
                                'İlanlar yüklenirken hata oluştu: \$err',
                              ),
                            ),
                          ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAiCvBuilder(BuildContext context, WidgetRef ref) {
    final profil = ref.read(profilProvider);

    if (profil.remainingAiCvCount <= 0) {
      AppToast.warning(
        context,
        'Bu ayki AI CV oluşturma hakkınız dolmuştur.\nDilerseniz Belgelerim sayfasından PDF olarak CV yükleyebilirsiniz.',
      );
      return;
    }

    // Profil bilgisi kontrolü (TC Kimlik, Kurum, Unvan hariç)
    final missingFields = <String>[];
    if (profil.name == null || profil.name!.isEmpty) {
      missingFields.add('Ad Soyad');
    }
    if (profil.phone == null || profil.phone!.isEmpty) {
      missingFields.add('Telefon');
    }
    if (profil.email == null || profil.email!.isEmpty) {
      missingFields.add('E-posta');
    }
    if (profil.city == null) missingFields.add('Şehir');
    if (profil.district == null) missingFields.add('İlçe');
    if (profil.employmentType == null) missingFields.add('Çalışma Durumu');

    if (missingFields.isNotEmpty) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange.shade700,
                  ),
                  const SizedBox(width: 8),
                  const Text('Profil Eksik'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'AI ile CV oluşturmak için aşağıdaki bilgileri tamamlayın:',
                  ),
                  const SizedBox(height: 12),
                  ...missingFields.map(
                    (f) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(
                        children: [
                          const Icon(Icons.circle, size: 6, color: Colors.red),
                          const SizedBox(width: 8),
                          Text(
                            f,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Kapat'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/profile/edit');
                  },
                  child: const Text('Profili Düzenle'),
                ),
              ],
            ),
      );
      return;
    }

    context.push('/career/cv-builder');
  }

  void _showCityPicker(BuildContext context, WidgetRef ref, String current) {
    showDialog(
      context: context,
      builder: (ctx) {
        String search = '';
        return StatefulBuilder(
          builder: (ctx, setState) {
            final allCities = TurkeyLocations.cities;
            final filtered =
                search.isEmpty
                    ? allCities
                    : allCities
                        .where(
                          (c) => c.toLowerCase().contains(search.toLowerCase()),
                        )
                        .toList();
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: const Text('Şehir Seçin'),
              content: SizedBox(
                width: double.maxFinite,
                height: 400,
                child: Column(
                  children: [
                    TextField(
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: 'Şehir ara...',
                        prefixIcon: const Icon(Icons.search, size: 20),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (v) => setState(() => search = v),
                    ),
                    const SizedBox(height: 10),
                    // Tümü seçeneği
                    ListTile(
                      dense: true,
                      leading: const Icon(Icons.public, size: 18),
                      title: const Text(
                        'Tüm Şehirler',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      trailing:
                          current.isEmpty
                              ? const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 20,
                              )
                              : null,
                      onTap: () {
                        ref.read(jobsProvider.notifier).setCityFilter('');
                        Navigator.pop(ctx);
                      },
                    ),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (_, i) {
                          final city = filtered[i];
                          final isSelected =
                              city.toLowerCase() == current.toLowerCase();
                          return ListTile(
                            dense: true,
                            leading: Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color:
                                  isSelected
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                            ),
                            title: Text(
                              city,
                              style: TextStyle(
                                fontWeight:
                                    isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                color:
                                    isSelected ? AppTheme.primaryColor : null,
                              ),
                            ),
                            trailing:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    )
                                    : null,
                            onTap: () {
                              ref
                                  .read(jobsProvider.notifier)
                                  .setCityFilter(city);
                              Navigator.pop(ctx);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showJobMatching(BuildContext context, WidgetRef ref) {
    final profil = ref.read(profilProvider);

    if (!profil.hasCv) {
      AppToast.warning(
        context,
        'İş Eşleştirme için önce bir CV oluşturmanız veya yüklemeniz gerekiyor.',
      );
      return;
    }

    // Job Matching yolculuğuna yönlendir
    context.push('/career/job-matching');
  }
}

// ── AI CV Banner
class _AiCvBanner extends StatelessWidget {
  final bool isDark;
  final int remaining;
  const _AiCvBanner({required this.isDark, required this.remaining});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 12,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AYLIK HAK: $remaining/1',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Yapay Zeka ile\nCV Oluştur',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Profesyonel CV\'niz dakikalar içinde hazır.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.description_rounded,
              color: Colors.white,
              size: 32,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CV Analiz Kartı
class _CvAnalysisCard extends StatelessWidget {
  final bool isDark;
  final bool hasCv;
  const _CvAnalysisCard({required this.isDark, required this.hasCv});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (hasCv ? const Color(0xFF2E7D32) : Colors.orange)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              hasCv ? Icons.analytics_rounded : Icons.warning_amber_rounded,
              color: hasCv ? const Color(0xFF2E7D32) : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CV Analizi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  hasCv
                      ? 'AI analiz raporu oluşturmaya hazır'
                      : 'Analiz için önce CV yüklemelisiniz',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              '2 Jeton',
              style: TextStyle(
                color: Color(0xFF1565C0),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Quick Action Card
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback? onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

// ── Job Card
class _JobCard extends ConsumerStatefulWidget {
  final JobListingModel job;
  final bool isDark;
  const _JobCard({required this.job, required this.isDark});

  @override
  ConsumerState<_JobCard> createState() => _JobCardState();
}

class _JobCardState extends ConsumerState<_JobCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _heartScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.4), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 50),
    ]).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    final job = widget.job;
    _heartController.forward(from: 0);
    ref
        .read(favoritesProvider.notifier)
        .toggleFavorite(
          FavoriteItem(
            id: job.id,
            title: job.title,
            subtitle: '${job.company} - ${job.location ?? ""}',
            category: 'job',
            routePath: '/job-detail',
            extraData: job.toJson(),
            addedAt: DateTime.now(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final isDark = widget.isDark;
    final isFav = ref
        .watch(favoritesProvider)
        .any((e) => e.id == job.id && e.category == 'job');

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.push('/job-detail', extra: job),
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.business_center_rounded,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            job.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            job.company,
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[500],
                            ),
                          ),
                          if (job.code != null && job.code!.isNotEmpty)
                            Text(
                              'İlan No: ${job.code}',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.7,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          else
                            Text(
                              'İlan No: ${JobDetailScreen.getListingCode(job)}',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.7,
                                ),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Animasyonlu favori butonu
                    ScaleTransition(
                      scale: _heartScale,
                      child: GestureDetector(
                        onTap: _toggleFavorite,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color:
                                isFav
                                    ? Colors.red.withValues(alpha: 0.15)
                                    : Colors.transparent,
                            shape: BoxShape.circle,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder:
                                (child, animation) => RotationTransition(
                                  turns: Tween(
                                    begin: 0.5,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  ),
                                ),
                            child: Icon(
                              isFav
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              key: ValueKey(isFav),
                              color: isFav ? Colors.red : Colors.grey[400],
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2E7D32).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Yeni',
                        style: TextStyle(
                          color: Color(0xFF2E7D32),
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _JobTag(
                      label: job.type == 'PUBLIC' ? 'Kamu' : 'Özel Sektör',
                      color:
                          job.type == 'PUBLIC'
                              ? AppTheme.primaryColor
                              : const Color(0xFF7B1FA2),
                    ),
                    const SizedBox(width: 8),
                    if (job.location != null)
                      _JobTag(label: job.location!, color: Colors.grey),
                    const Spacer(),
                    if (job.deadline != null)
                      Flexible(
                        child: Text(
                          '${job.deadline!.day}.${job.deadline!.month}.${job.deadline!.year}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[400],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _JobTag extends StatelessWidget {
  final String label;
  final Color color;
  const _JobTag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

// ── Filter Chip
class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onSelected,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color:
              selected
                  ? AppTheme.primaryColor
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected
                    ? AppTheme.primaryColor
                    : (isDark ? Colors.white24 : Colors.grey.shade300),
            width: 1.2,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color:
                selected
                    ? Colors.white
                    : (isDark ? Colors.white70 : Colors.grey.shade700),
          ),
        ),
      ),
    );
  }
}
