import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Hakkında sayfası — versiyon, lisanslar, yasal bilgiler
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const String _appVersion = '1.0.0';
  static const String _buildNumber = '1';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hakkında'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),

            // ── Uygulama Logosu & Bilgileri
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shield_rounded,
                color: Colors.white,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Kamulog',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Text(
              'Sürüm $_appVersion ($_buildNumber)',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white54 : Colors.black54,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Kamu ve özel sektör çalışanları için\nkapsamlı kariyer platformu',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
            ),
            const SizedBox(height: 32),

            // ── Özellikler
            _InfoSection(
              title: 'Özellikler',
              isDark: isDark,
              items: const [
                _InfoRow(
                  Icons.swap_horiz_rounded,
                  'Becayiş eşleştirme sistemi',
                ),
                _InfoRow(
                  Icons.work_rounded,
                  'Kariyer fırsatları ve iş ilanları',
                ),
                _InfoRow(
                  Icons.auto_awesome_rounded,
                  'AI destekli CV oluşturma',
                ),
                _InfoRow(
                  Icons.support_agent_rounded,
                  'Online danışmanlık hizmetleri',
                ),
                _InfoRow(Icons.groups_rounded, 'STK ve sendika yönetimi'),
                _InfoRow(
                  Icons.newspaper_rounded,
                  'Güncel haberler ve duyurular',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Yasal Bilgiler
            _InfoSection(
              title: 'Yasal',
              isDark: isDark,
              items: [
                _ActionRow(
                  Icons.description_rounded,
                  'Kullanıcı Sözleşmesi',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Kullanıcı Sözleşmesi yakında eklenecek'),
                      ),
                    );
                  },
                ),
                _ActionRow(
                  Icons.privacy_tip_rounded,
                  'Gizlilik Politikası',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gizlilik Politikası yakında eklenecek'),
                      ),
                    );
                  },
                ),
                _ActionRow(
                  Icons.cookie_rounded,
                  'Çerez Politikası',
                  isDark: isDark,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Çerez Politikası yakında eklenecek'),
                      ),
                    );
                  },
                ),
                _ActionRow(
                  Icons.article_rounded,
                  'Açık Kaynak Lisansları',
                  isDark: isDark,
                  onTap: () {
                    showLicensePage(
                      context: context,
                      applicationName: 'Kamulog',
                      applicationVersion: 'v$_appVersion',
                      applicationLegalese:
                          '© 2026 Kamulog. Tüm hakları saklıdır.',
                      applicationIcon: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.shield_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ── Geliştirici Bilgileri
            _InfoSection(
              title: 'Geliştirici',
              isDark: isDark,
              items: const [
                _InfoRow(Icons.business_rounded, 'Kamulog Teknoloji A.Ş.'),
                _InfoRow(Icons.location_on_rounded, 'Türkiye'),
                _InfoRow(Icons.email_rounded, 'info@kamulog.com'),
                _InfoRow(Icons.language_rounded, 'www.kamulog.com'),
              ],
            ),
            const SizedBox(height: 32),

            // ── Telif Hakkı
            Text(
              '© 2026 Kamulog. Tüm hakları saklıdır.',
              style: TextStyle(
                fontSize: 12,
                color: isDark ? Colors.white38 : Colors.black38,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Flutter ile ❤️ yapıldı',
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white24 : Colors.black26,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Bilgi Bölümü Container'ı
// ══════════════════════════════════════════════════════════════

class _InfoSection extends StatelessWidget {
  final String title;
  final bool isDark;
  final List<Widget> items;

  const _InfoSection({
    required this.title,
    required this.isDark,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppTheme.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Bilgi Satırı (sadece gösterim)
// ══════════════════════════════════════════════════════════════

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppTheme.primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? Colors.white70 : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Aksiyon Satırı (tıklanabilir)
// ══════════════════════════════════════════════════════════════

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;
  final VoidCallback onTap;

  const _ActionRow(
    this.icon,
    this.text, {
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 18, color: AppTheme.primaryColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isDark ? Colors.white30 : Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
