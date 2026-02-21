import 'package:flutter/material.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Haber modülü — web yönetim panelinden güncellenecek
/// Ayrı modül: features/news/ — ileride ayrı API/DB entegrasyonu
class NewsSection extends StatelessWidget {
  const NewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Başlık
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(
                Icons.newspaper_rounded,
                size: 18,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(width: 6),
              const Text(
                'Güncel Haberler',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // Tüm haberlere git
                },
                child: Text(
                  'Tümü →',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Haber kartları — yatay scroll
        SizedBox(
          height: 220,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _sampleNews.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final news = _sampleNews[index];
              return _NewsCard(news: news, isDark: isDark);
            },
          ),
        ),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  final NewsItem news;
  final bool isDark;

  const _NewsCard({required this.news, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showNewsDetail(context, news);
      },
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFEEEEEE),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resim alanı
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: news.gradientColors,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(14),
                ),
              ),
              child: Stack(
                children: [
                  // Arka plan deseni
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(
                      news.icon,
                      size: 80,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  // Üst badge
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        news.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  // Tarih
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Text(
                      news.date,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontSize: 10,
                      ),
                    ),
                  ),
                  // İkon
                  Center(
                    child: Icon(
                      news.icon,
                      size: 36,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
            ),
            // İçerik
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      news.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Icons.source_outlined,
                          size: 12,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          news.source,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 10,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showNewsDetail(BuildContext context, NewsItem news) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            height: MediaQuery.of(ctx).size.height * 0.85,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Üst resim
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: news.gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -20,
                        bottom: -20,
                        child: Icon(
                          news.icon,
                          size: 120,
                          color: Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      Center(
                        child: Icon(
                          news.icon,
                          size: 56,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            news.category,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // İçerik
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              news.date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.source_outlined,
                              size: 14,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              news.source,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          news.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          news.content,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}

/// Haber veri modeli — web panelinden gelecek
class NewsItem {
  final String id;
  final String title;
  final String content;
  final String category;
  final String source;
  final String date;
  final IconData icon;
  final List<Color> gradientColors;

  const NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.source,
    required this.date,
    required this.icon,
    required this.gradientColors,
  });
}

/// Örnek haberler — gerçekte API'den gelecek
const _sampleNews = [
  NewsItem(
    id: '1',
    title: 'Kamu Çalışanlarına Yeni Zam Düzenlemesi Yürürlüğe Girdi',
    content:
        'Cumhurbaşkanlığı kararnamesiyle kamu çalışanlarının maaşlarına yapılacak zam oranları belirlendi. Yeni düzenlemeye göre memur ve işçi maaşlarında belirli oranlarda artış yapılacak.\n\nYeni düzenleme kapsamında 4/A, 4/B ve 4/D çalışanlarının tamamı ek ödeme artışından faydalanacak. Detaylar Resmi Gazete\'de yayımlandı.',
    category: 'Maaş',
    source: 'Resmi Gazete',
    date: '21 Şub 2026',
    icon: Icons.payments_rounded,
    gradientColors: [Color(0xFF1565C0), Color(0xFF0D47A1)],
  ),
  NewsItem(
    id: '2',
    title: 'Becayiş Başvuru Dönemi 1 Mart\'ta Başlıyor',
    content:
        'Kamu kurumları arası yer değişikliği (becayiş) başvuru dönemi 1 Mart 2026 tarihinde açılıyor. Bu dönemde memur ve sözleşmeli personel becayiş başvurusu yapabilecek.\n\nBaşvurular Kamulog platformu üzerinden online olarak yapılabilecek.',
    category: 'Becayiş',
    source: 'Kamulog',
    date: '20 Şub 2026',
    icon: Icons.swap_horiz_rounded,
    gradientColors: [Color(0xFF2E7D32), Color(0xFF1B5E20)],
  ),
  NewsItem(
    id: '3',
    title: 'Kamu İşçileri İçin Toplu Sözleşme Görüşmeleri Başladı',
    content:
        'Kamu işçileri için yeni dönem toplu iş sözleşmesi görüşmeleri başladı. Sendikalar ve işveren tarafı masaya oturdu.\n\nGörüşmelerde temel ücret artışı, sosyal haklar ve iş güvencesi konuları ele alınıyor.',
    category: 'Sendika',
    source: 'Memur Sen',
    date: '19 Şub 2026',
    icon: Icons.groups_rounded,
    gradientColors: [Color(0xFFE65100), Color(0xFFBF360C)],
  ),
  NewsItem(
    id: '4',
    title: 'Yeni KPSS Sınav Tarihleri Açıklandı',
    content:
        'ÖSYM, 2026 yılı KPSS sınav takvimini açıkladı. Lisans, ön lisans ve ortaöğretim sınavları belirtilen tarihlerde yapılacak.\n\nAdaylar başvurularını ÖSYM resmi sitesi üzerinden gerçekleştirebilecek.',
    category: 'Sınav',
    source: 'ÖSYM',
    date: '18 Şub 2026',
    icon: Icons.school_rounded,
    gradientColors: [Color(0xFF7B1FA2), Color(0xFF4A148C)],
  ),
  NewsItem(
    id: '5',
    title: 'İş Kanunu Değişikliği: Uzaktan Çalışma Hakkı Genişletildi',
    content:
        'İş Kanunu\'nda yapılan değişiklikle uzaktan çalışma hakkı genişletildi. Yeni düzenlemeye göre belirli koşulları sağlayan çalışanlar uzaktan çalışma talep edebilecek.',
    category: 'Hukuk',
    source: 'TBMM',
    date: '17 Şub 2026',
    icon: Icons.gavel_rounded,
    gradientColors: [Color(0xFFC62828), Color(0xFF8E0000)],
  ),
];
