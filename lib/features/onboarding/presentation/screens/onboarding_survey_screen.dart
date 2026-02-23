import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

/// 3-step survey (removed duplicate employment type step).
/// Steps: Institution → City → Interests
class OnboardingSurveyScreen extends ConsumerStatefulWidget {
  const OnboardingSurveyScreen({super.key});

  @override
  ConsumerState<OnboardingSurveyScreen> createState() =>
      _OnboardingSurveyScreenState();
}

class _OnboardingSurveyScreenState
    extends ConsumerState<OnboardingSurveyScreen> {
  final _pageController = PageController();
  int _currentStep = 0;

  String? _selectedInstitution;
  String? _selectedCity;
  final Set<String> _interests = {};

  static const _totalSteps = 3;

  static const _institutions = [
    'Milli Eğitim Bakanlığı',
    'Sağlık Bakanlığı',
    'Adalet Bakanlığı',
    'İçişleri Bakanlığı',
    'Maliye Bakanlığı',
    'Tarım ve Orman Bakanlığı',
    'Çevre Bakanlığı',
    'Aile Bakanlığı',
    'Ulaştırma Bakanlığı',
    'Savunma Bakanlığı',
    'Diğer',
  ];

  static const _cities = [
    'İstanbul',
    'Ankara',
    'İzmir',
    'Bursa',
    'Antalya',
    'Adana',
    'Konya',
    'Gaziantep',
    'Mersin',
    'Kayseri',
    'Eskişehir',
    'Trabzon',
    'Samsun',
    'Diyarbakır',
    'Erzurum',
    'Malatya',
    'Van',
    'Şanlıurfa',
    'Manisa',
    'Denizli',
  ];

  static const _interestOptions = [
    _InterestItem('Becayiş', Icons.swap_horiz_rounded, Color(0xFF2E7D32)),
    _InterestItem('Kariyer', Icons.work_rounded, Color(0xFF1565C0)),
    _InterestItem(
      'Danışmanlık',
      Icons.support_agent_rounded,
      Color(0xFFE65100),
    ),
    _InterestItem('STK & Sendika', Icons.groups_rounded, Color(0xFF7B1FA2)),
    _InterestItem('Hukuk', Icons.gavel_rounded, Color(0xFFC62828)),
    _InterestItem('Eğitim', Icons.school_rounded, Color(0xFF0D47A1)),
    _InterestItem('Maaş Hesap', Icons.calculate_rounded, Color(0xFF00695C)),
    _InterestItem('Haberler', Icons.newspaper_rounded, Color(0xFF37474F)),
  ];

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _complete();
    }
  }

  Future<void> _complete() async {
    // Seçimleri yerel hafızaya kaydet
    await LocalStorageService.saveSurveyResults(
      institution: _selectedInstitution,
      city: _selectedCity,
      interests: _interests.toList(),
    );
    await LocalStorageService.markSurveyCompleted();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);
    if (mounted) context.go('/login');
  }

  bool get _canProceed {
    switch (_currentStep) {
      case 0:
        return _selectedInstitution != null;
      case 1:
        return _selectedCity != null;
      case 2:
        return _interests.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading:
            _currentStep > 0
                ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_rounded),
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                )
                : null,
        title: Text(
          'Adım ${_currentStep + 1} / $_totalSteps',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / _totalSteps,
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                color: AppTheme.primaryColor,
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (i) => setState(() => _currentStep = i),
              children: [
                _buildInstitutionPage(theme),
                _buildCityPage(theme),
                _buildInterestsPage(theme),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _canProceed ? _next : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    disabledBackgroundColor: AppTheme.primaryColor.withValues(
                      alpha: 0.3,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: _canProceed ? 4 : 0,
                  ),
                  child: Text(
                    _currentStep == _totalSteps - 1 ? 'Tamamla' : 'Devam Et',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 1: Institution
  Widget _buildInstitutionPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Kurumunuz',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hangi kurumda çalışıyorsunuz?',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _institutions.length,
              itemBuilder: (context, index) {
                final inst = _institutions[index];
                final selected = _selectedInstitution == inst;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Material(
                    color:
                        selected
                            ? AppTheme.primaryColor.withValues(alpha: 0.1)
                            : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => setState(() => _selectedInstitution = inst),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color:
                                selected
                                    ? AppTheme.primaryColor
                                    : const Color(0xFFE0E0E0),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.business_rounded,
                              color:
                                  selected
                                      ? AppTheme.primaryColor
                                      : Colors.grey,
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                inst,
                                style: TextStyle(
                                  fontWeight:
                                      selected
                                          ? FontWeight.w700
                                          : FontWeight.w500,
                                  color:
                                      selected ? AppTheme.primaryColor : null,
                                ),
                              ),
                            ),
                            if (selected)
                              const Icon(
                                Icons.check_circle,
                                color: AppTheme.primaryColor,
                                size: 22,
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 2: City
  Widget _buildCityPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Şehriniz',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text('Hangi ilde çalışıyorsunuz?', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 2.2,
              ),
              itemCount: _cities.length,
              itemBuilder: (context, index) {
                final city = _cities[index];
                final selected = _selectedCity == city;
                return Material(
                  color: selected ? AppTheme.primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  elevation: selected ? 3 : 0,
                  child: InkWell(
                    onTap: () => setState(() => _selectedCity = city),
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color:
                              selected
                                  ? AppTheme.primaryColor
                                  : const Color(0xFFE0E0E0),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          city,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight:
                                selected ? FontWeight.w700 : FontWeight.w500,
                            color: selected ? Colors.white : null,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Step 3: Interests
  Widget _buildInterestsPage(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'İlgi Alanlarınız',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Size özel içerik sunabilmemiz için seçin. (Birden fazla)',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.6,
              ),
              itemCount: _interestOptions.length,
              itemBuilder: (context, index) {
                final item = _interestOptions[index];
                final selected = _interests.contains(item.label);
                return Material(
                  color:
                      selected
                          ? item.color.withValues(alpha: 0.1)
                          : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  elevation: selected ? 2 : 0,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (selected) {
                          _interests.remove(item.label);
                        } else {
                          _interests.add(item.label);
                        }
                      });
                    },
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              selected ? item.color : const Color(0xFFE0E0E0),
                          width: selected ? 2 : 1,
                        ),
                      ),
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Icon(item.icon, color: item.color, size: 28),
                              const Spacer(),
                              if (selected)
                                Icon(
                                  Icons.check_circle,
                                  color: item.color,
                                  size: 22,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.label,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: selected ? item.color : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _InterestItem {
  final String label;
  final IconData icon;
  final Color color;
  const _InterestItem(this.label, this.icon, this.color);
}
