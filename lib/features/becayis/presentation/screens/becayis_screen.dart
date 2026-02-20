import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

class BecayisScreen extends ConsumerStatefulWidget {
  const BecayisScreen({super.key});

  @override
  ConsumerState<BecayisScreen> createState() => _BecayisScreenState();
}

class _BecayisScreenState extends ConsumerState<BecayisScreen> {
  String? _selectedCity;
  String? _selectedInstitution;
  String? _selectedProfession;
  final _searchController = TextEditingController();

  final _cities = [
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
  ];

  final _institutions = [
    'Milli Eğitim Bakanlığı',
    'Sağlık Bakanlığı',
    'Adalet Bakanlığı',
    'İçişleri Bakanlığı',
    'Maliye Bakanlığı',
    'Tarım ve Orman Bakanlığı',
    'Çevre Bakanlığı',
  ];

  final _professions = [
    'Hemşire',
    'Öğretmen',
    'VHKİ',
    'Güvenlik',
    'Memur',
    'Teknisyen',
    'Şoför',
    'Mühendis',
  ];

  // Sahibinden-style categories
  static const _categories = [
    _CategoryItem(
      'Sağlık',
      Icons.local_hospital_rounded,
      Color(0xFFC62828),
      '3.245',
    ),
    _CategoryItem('Eğitim', Icons.school_rounded, Color(0xFF1565C0), '8.120'),
    _CategoryItem('Adalet', Icons.gavel_rounded, Color(0xFF4A148C), '1.890'),
    _CategoryItem('Güvenlik', Icons.shield_rounded, Color(0xFF2E7D32), '2.456'),
    _CategoryItem(
      'Maliye',
      Icons.account_balance_rounded,
      Color(0xFFE65100),
      '1.230',
    ),
    _CategoryItem('Tarım', Icons.agriculture_rounded, Color(0xFF33691E), '980'),
    _CategoryItem('İçişleri', Icons.domain_rounded, Color(0xFF0D47A1), '1.567'),
    _CategoryItem(
      'Diğer',
      Icons.more_horiz_rounded,
      Color(0xFF616161),
      '4.312',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // ── Search Bar — sahibinden style
        Container(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.surfaceDark : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Search
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Şehir, kurum veya unvan ara...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppTheme.primaryColor,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.tune_rounded,
                      color: AppTheme.primaryColor,
                    ),
                    onPressed: () => _showFilterSheet(context),
                  ),
                  filled: true,
                  fillColor:
                      isDark ? AppTheme.cardDark : const Color(0xFFF5F5F5),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // ── Filter Chips
              SizedBox(
                height: 34,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _FilterChip(
                      label: _selectedCity ?? 'Şehir',
                      icon: Icons.location_on_outlined,
                      isActive: _selectedCity != null,
                      onTap: () => _showCityPicker(context),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: _selectedInstitution ?? 'Kurum',
                      icon: Icons.business_outlined,
                      isActive: _selectedInstitution != null,
                      onTap: () => _showInstitutionPicker(context),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: _selectedProfession ?? 'Meslek',
                      icon: Icons.badge_outlined,
                      isActive: _selectedProfession != null,
                      onTap: () => _showProfessionPicker(context),
                    ),
                    if (_selectedCity != null ||
                        _selectedInstitution != null ||
                        _selectedProfession != null) ...[
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Temizle',
                        icon: Icons.clear,
                        isActive: false,
                        color: AppTheme.errorColor,
                        onTap:
                            () => setState(() {
                              _selectedCity = null;
                              _selectedInstitution = null;
                              _selectedProfession = null;
                            }),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),

        // ── Content
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(0),
            children: [
              // ── Category Grid (sahibinden tarzı)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    const Text(
                      'Kategoriler',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Toplam 23.800 ilan',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 0.85,
                  children:
                      _categories
                          .map((cat) => _CategoryTile(category: cat))
                          .toList(),
                ),
              ),

              const Divider(height: 24),

              // ── Recent Listings Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Text(
                      'Son İlanlar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.sort, size: 16),
                      label: const Text(
                        'Sırala',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),

              // ── Listing Cards (sahibinden-style compact)
              ...List.generate(10, (index) {
                return _BecayisListingCard(
                  index: index,
                  cities: _cities,
                  institutions: _institutions,
                  professions: _professions,
                  isDark: isDark,
                );
              }),

              const SizedBox(height: 80), // FAB space
            ],
          ),
        ),
      ],
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            maxChildSize: 0.9,
            minChildSize: 0.5,
            expand: false,
            builder: (ctx, scrollController) {
              return Padding(
                padding: const EdgeInsets.all(24),
                child: ListView(
                  controller: scrollController,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Detaylı Filtre',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildFilterSection(
                      'Şehir',
                      _cities,
                      _selectedCity,
                      (v) => setState(() => _selectedCity = v),
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Kurum',
                      _institutions,
                      _selectedInstitution,
                      (v) => setState(() => _selectedInstitution = v),
                    ),
                    const SizedBox(height: 16),
                    _buildFilterSection(
                      'Meslek',
                      _professions,
                      _selectedProfession,
                      (v) => setState(() => _selectedProfession = v),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Filtrele'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }

  Widget _buildFilterSection(
    String title,
    List<String> items,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              items.map((item) {
                final isActive = selected == item;
                return ChoiceChip(
                  label: Text(
                    item,
                    style: TextStyle(
                      fontSize: 12,
                      color: isActive ? Colors.white : null,
                    ),
                  ),
                  selected: isActive,
                  selectedColor: AppTheme.primaryColor,
                  onSelected: (v) => onChanged(v ? item : null),
                );
              }).toList(),
        ),
      ],
    );
  }

  void _showCityPicker(BuildContext context) => _showPickerSheet(
    context,
    'Şehir Seçin',
    _cities,
    _selectedCity,
    (v) => setState(() => _selectedCity = v),
  );
  void _showInstitutionPicker(BuildContext context) => _showPickerSheet(
    context,
    'Kurum Seçin',
    _institutions,
    _selectedInstitution,
    (v) => setState(() => _selectedInstitution = v),
  );
  void _showProfessionPicker(BuildContext context) => _showPickerSheet(
    context,
    'Meslek Seçin',
    _professions,
    _selectedProfession,
    (v) => setState(() => _selectedProfession = v),
  );

  void _showPickerSheet(
    BuildContext context,
    String title,
    List<String> items,
    String? current,
    ValueChanged<String?> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (ctx) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ...items.map(
                (item) => ListTile(
                  title: Text(item),
                  trailing:
                      current == item
                          ? const Icon(
                            Icons.check_circle,
                            color: AppTheme.primaryColor,
                          )
                          : null,
                  onTap: () {
                    onChanged(item);
                    Navigator.pop(ctx);
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
    );
  }
}

// ── Filter Chip Widget
class _FilterChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color? color;

  const _FilterChip({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryColor;
    return Material(
      color: isActive ? c.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isActive ? c : const Color(0xFFE0E0E0),
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: isActive ? c : Colors.grey),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? c : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Category Tile (sahibinden-style)
class _CategoryTile extends StatelessWidget {
  final _CategoryItem category;
  const _CategoryTile({required this.category});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: category.color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              category.label,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              category.count,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[500],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem {
  final String label;
  final IconData icon;
  final Color color;
  final String count;
  const _CategoryItem(this.label, this.icon, this.color, this.count);
}

// ── Listing Card (sahibinden.com tarzı kompakt)
class _BecayisListingCard extends StatelessWidget {
  final int index;
  final List<String> cities;
  final List<String> institutions;
  final List<String> professions;
  final bool isDark;

  const _BecayisListingCard({
    required this.index,
    required this.cities,
    required this.institutions,
    required this.professions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final fromCity = cities[index % cities.length];
    final toCity = cities[(index + 4) % cities.length];
    final inst = institutions[index % institutions.length];
    final prof = professions[index % professions.length];
    final isNew = index < 3;
    final isPremium = index == 0 || index == 4;
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isPremium
                  ? AppTheme.warningColor.withValues(alpha: 0.5)
                  : (isDark
                      ? Colors.white.withValues(alpha: 0.08)
                      : const Color(0xFFE0E0E0)),
          width: isPremium ? 1.5 : 1,
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: user + badges
                Row(
                  children: [
                    // Avatar
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AppTheme.primaryColor.withValues(
                        alpha: 0.1,
                      ),
                      child: Text(
                        'K${index + 1}',
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 11,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$prof · $inst',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${index + 1} saat önce',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF8F00), Color(0xFFF9A825)],
                          ),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'VIP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    if (isNew && !isPremium)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.successColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'YENİ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),

                // Route: FROM → TO
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(
                      alpha: isDark ? 0.08 : 0.04,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on_rounded,
                        color: AppTheme.errorColor,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        fromCity,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 30,
                                height: 1.5,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: Icon(
                                  Icons.swap_horiz_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 22,
                                ),
                              ),
                              Container(
                                width: 30,
                                height: 1.5,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        toCity,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.flag_rounded,
                        color: AppTheme.successColor,
                        size: 18,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Bottom: actions
                Row(
                  children: [
                    Icon(
                      Icons.visibility_outlined,
                      size: 14,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${(index + 1) * 23}',
                      style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                    ),
                    const Spacer(),
                    _MiniAction(
                      icon: Icons.favorite_border_rounded,
                      label: 'Kaydet',
                      onTap: () {},
                    ),
                    const SizedBox(width: 12),
                    _MiniAction(
                      icon: Icons.message_outlined,
                      label: 'Mesaj',
                      onTap: () {},
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

class _MiniAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MiniAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: AppTheme.primaryColor),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
