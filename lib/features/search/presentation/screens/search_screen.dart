import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Uygulama içi arama ekranı — AI destekli
/// Ayrı modül: features/search/ — ileride ayrı DB entegrasyonu
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';
  String _selectedCategory = 'Tümü';

  static const _categories = [
    'Tümü',
    'Becayiş',
    'Kariyer',
    'Danışmanlık',
    'STK',
    'Duyurular',
    'AI Asistan',
  ];

  @override
  void initState() {
    super.initState();
    // Açılınca otomatik klavye
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<_SearchResult> get _filteredResults {
    if (_query.isEmpty) return [];
    final q = _query.toLowerCase();
    return _allResults.where((r) {
      final matchesCategory =
          _selectedCategory == 'Tümü' || r.category == _selectedCategory;
      final matchesQuery =
          r.title.toLowerCase().contains(q) ||
          r.description.toLowerCase().contains(q) ||
          r.category.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final results = _filteredResults;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: _buildSearchField(isDark),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(fontSize: 14)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Kategori filtreleri
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = cat == _selectedCategory;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppTheme.primaryColor
                              : (isDark ? Colors.white10 : Colors.grey[100]),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      cat,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // Sonuçlar
          Expanded(
            child:
                _query.isEmpty
                    ? _buildPopularSearches(isDark)
                    : results.isEmpty
                    ? _buildNoResults()
                    : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: results.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        return _SearchResultCard(
                          result: results[index],
                          isDark: isDark,
                          onTap: () => _handleResultTap(results[index]),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(bool isDark) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(left: 4),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _focusNode,
        onChanged: (v) => setState(() => _query = v),
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Becayiş, kariyer, danışmanlık ara...',
          hintStyle: TextStyle(fontSize: 14, color: Colors.grey[400]),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey[400],
            size: 20,
          ),
          suffixIcon:
              _query.isNotEmpty
                  ? GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() => _query = '');
                    },
                    child: Icon(
                      Icons.close_rounded,
                      color: Colors.grey[400],
                      size: 18,
                    ),
                  )
                  : Container(
                    margin: const EdgeInsets.all(4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppTheme.aiGradient,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                        SizedBox(width: 3),
                        Text(
                          'AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }

  Widget _buildPopularSearches(bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Popüler Aramalar',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _popularSearches.map((s) {
                  return GestureDetector(
                    onTap: () {
                      _searchController.text = s;
                      setState(() => _query = s);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white10 : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 24),
          const Text(
            'Son Aramalar',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 12),
          ..._recentSearches.map(
            (s) => ListTile(
              leading: const Icon(Icons.history, size: 20),
              title: Text(s, style: const TextStyle(fontSize: 14)),
              dense: true,
              contentPadding: EdgeInsets.zero,
              onTap: () {
                _searchController.text = s;
                setState(() => _query = s);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 12),
          Text(
            '"$_query" için sonuç bulunamadı',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _handleResultTap(_SearchResult result) {
    if (result.route != null) {
      context.push(result.route!);
    }
  }
}

class _SearchResultCard extends StatelessWidget {
  final _SearchResult result;
  final bool isDark;
  final VoidCallback onTap;

  const _SearchResultCard({
    required this.result,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: result.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(result.icon, color: result.color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    result.description,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: result.color.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                result.category,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: result.color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResult {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final Color color;
  final String? route;

  const _SearchResult({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.route,
  });
}

const _popularSearches = [
  'Becayiş ilanları',
  'Maaş hesaplama',
  'İş ilanları',
  'Danışmanlık',
  'STK üyelik',
  'CV oluştur',
];

const _recentSearches = [
  'İstanbul becayiş',
  'Milli Eğitim ilanları',
  'Hukuk danışmanlığı',
];

const _allResults = [
  _SearchResult(
    title: 'Becayiş İlanı Oluştur',
    description: 'Yeni becayiş ilanı verin, eşleşmeleri takip edin',
    category: 'Becayiş',
    icon: Icons.swap_horiz_rounded,
    color: Color(0xFF2E7D32),
  ),
  _SearchResult(
    title: 'Becayiş Eşleşmelerim',
    description: 'Mevcut eşleşmelerinizi görüntüleyin',
    category: 'Becayiş',
    icon: Icons.people_alt_rounded,
    color: Color(0xFF2E7D32),
  ),
  _SearchResult(
    title: 'Kariyer İlanları',
    description: 'Güncel kamu ve özel sektör iş ilanları',
    category: 'Kariyer',
    icon: Icons.work_rounded,
    color: Color(0xFF1565C0),
  ),
  _SearchResult(
    title: 'Maaş Hesaplama',
    description: 'Kamu çalışanı maaş ve ek ödeme hesaplaması',
    category: 'Kariyer',
    icon: Icons.calculate_rounded,
    color: Color(0xFF1565C0),
    route: '/salary-calculator',
  ),
  _SearchResult(
    title: 'Hukuk Danışmanlığı',
    description: 'Çalışma hukuku ve idare hukuku uzmanları',
    category: 'Danışmanlık',
    icon: Icons.gavel_rounded,
    color: Color(0xFFE65100),
    route: '/consultation',
  ),
  _SearchResult(
    title: 'Kariyer Danışmanlığı',
    description: 'Profesyonel kariyer koçluğu hizmeti',
    category: 'Danışmanlık',
    icon: Icons.support_agent_rounded,
    color: Color(0xFFE65100),
    route: '/consultation',
  ),
  _SearchResult(
    title: 'STK Üyelik Başvurusu',
    description: 'Sivil toplum kuruluşlarına üyelik',
    category: 'STK',
    icon: Icons.groups_rounded,
    color: Color(0xFF7B1FA2),
  ),
  _SearchResult(
    title: 'CV Oluşturucu',
    description: 'AI destekli profesyonel CV oluşturma',
    category: 'AI Asistan',
    icon: Icons.description_rounded,
    color: Color(0xFF0D47A1),
  ),
  _SearchResult(
    title: 'Kamu Duyuruları',
    description: 'Güncel kamu personeli haberleri ve duyurular',
    category: 'Duyurular',
    icon: Icons.campaign_rounded,
    color: Color(0xFFC62828),
  ),
  _SearchResult(
    title: 'AI Kariyer Önerisi',
    description: 'Yapay zeka ile kişiselleştirilmiş kariyer planı',
    category: 'AI Asistan',
    icon: Icons.auto_awesome,
    color: Color(0xFF0D47A1),
  ),
  _SearchResult(
    title: 'Profilim',
    description: 'Kişisel bilgilerinizi düzenleyin',
    category: 'Kariyer',
    icon: Icons.person_rounded,
    color: Color(0xFF00695C),
    route: '/profile',
  ),
];
