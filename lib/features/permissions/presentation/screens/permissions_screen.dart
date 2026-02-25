import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Gizlilik & Güvenlik — Politikalar, izinler ve hesap yönetimi
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  // ── Toggle durumları
  bool _analyticsEnabled = true;
  bool _crashReportsEnabled = true;
  bool _personalizedAds = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Gizlilik & Güvenlik'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ═══ BÖLÜM 1: Gizlilik Politikaları
            _SectionTitle(
              icon: Icons.shield_outlined,
              title: 'Gizlilik Politikaları',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _PolicyTile(
              icon: Icons.article_outlined,
              title: 'Gizlilik Politikası',
              subtitle: 'Kişisel verilerinizin nasıl korunduğunu öğrenin',
              isDark: isDark,
              onTap:
                  () => _showPolicyDialog(
                    context,
                    isDark,
                    'Gizlilik Politikası',
                    _privacyPolicyText,
                  ),
            ),
            _PolicyTile(
              icon: Icons.description_outlined,
              title: 'Kullanım Koşulları',
              subtitle: 'Uygulama kullanım şartları ve kuralları',
              isDark: isDark,
              onTap:
                  () => _showPolicyDialog(
                    context,
                    isDark,
                    'Kullanım Koşulları',
                    _termsOfUseText,
                  ),
            ),
            _PolicyTile(
              icon: Icons.cookie_outlined,
              title: 'Çerez Politikası',
              subtitle: 'Çerez ve izleme teknolojileri hakkında',
              isDark: isDark,
              onTap:
                  () => _showPolicyDialog(
                    context,
                    isDark,
                    'Çerez Politikası',
                    _cookiePolicyText,
                  ),
            ),
            _PolicyTile(
              icon: Icons.security_outlined,
              title: 'KVKK Aydınlatma Metni',
              subtitle: '6698 sayılı Kişisel Verilerin Korunması Kanunu',
              isDark: isDark,
              onTap:
                  () => _showPolicyDialog(
                    context,
                    isDark,
                    'KVKK Aydınlatma Metni',
                    _kvkkText,
                  ),
            ),
            const SizedBox(height: 24),

            // ═══ BÖLÜM 2: Veri Yönetimi
            _SectionTitle(
              icon: Icons.tune_rounded,
              title: 'Veri Tercihleri',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _ToggleTile(
              icon: Icons.analytics_outlined,
              title: 'Kullanım Analitikleri',
              subtitle: 'Uygulamayı iyileştirmemize yardımcı olun',
              value: _analyticsEnabled,
              isDark: isDark,
              onChanged: (val) => setState(() => _analyticsEnabled = val),
            ),
            _ToggleTile(
              icon: Icons.bug_report_outlined,
              title: 'Çökme Raporları',
              subtitle: 'Otomatik hata raporları gönder',
              value: _crashReportsEnabled,
              isDark: isDark,
              onChanged: (val) => setState(() => _crashReportsEnabled = val),
            ),
            _ToggleTile(
              icon: Icons.ads_click_outlined,
              title: 'Kişiselleştirilmiş İçerik',
              subtitle: 'İlgi alanlarınıza göre öneriler al',
              value: _personalizedAds,
              isDark: isDark,
              onChanged: (val) => setState(() => _personalizedAds = val),
            ),
            const SizedBox(height: 24),

            // ═══ BÖLÜM 3: Hesap Güvenliği
            _SectionTitle(
              icon: Icons.lock_outline_rounded,
              title: 'Hesap Güvenliği',
              isDark: isDark,
            ),
            const SizedBox(height: 12),
            _PolicyTile(
              icon: Icons.phonelink_lock_outlined,
              title: 'Oturum Bilgileri',
              subtitle: 'Aktif oturumlarınızı görüntüleyin',
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Tek aktif oturum: Bu cihaz')),
                );
              },
            ),
            _PolicyTile(
              icon: Icons.download_rounded,
              title: 'Verilerimi İndir',
              subtitle: 'Tüm kişisel verilerinizin bir kopyasını alın',
              isDark: isDark,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Veri dışa aktarma talebi alındı. E-posta ile gönderilecek.',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // ═══ BÖLÜM 4: Hesap Silme
            _SectionTitle(
              icon: Icons.warning_amber_rounded,
              title: 'Tehlikeli Bölge',
              isDark: isDark,
              color: AppTheme.errorColor,
            ),
            const SizedBox(height: 12),
            _PolicyTile(
              icon: Icons.delete_outline,
              title: 'Hesabımı Sil',
              subtitle: 'Hesabınızı ve tüm verilerinizi kalıcı olarak silin',
              isDark: isDark,
              isDestructive: true,
              onTap: () => _showDeleteAccountDialog(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  // ── Politika Dialog
  void _showPolicyDialog(
    BuildContext context,
    bool isDark,
    String title,
    String content,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (ctx) => Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.surfaceDark : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Drag handle
                Padding(
                  padding: const EdgeInsets.only(top: 12, bottom: 8),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.shield_rounded,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close_rounded),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Content
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.7,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // ── Hesap Silme Dialog
  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Text('Hesabı Sil'),
            content: const Text(
              'Hesabınızı silmek istediğinize emin misiniz?\n\n'
              '• Tüm kişisel bilgileriniz silinir\n'
              '• Abonelikleriniz iptal edilir\n'
              '• CV ve belgeleriniz kaldırılır\n'
              '• Bu işlem geri alınamaz\n\n'
              'Silme talebi 30 gün içinde işleme alınır.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Vazgeç'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Hesap silme talebi gönderildi. 30 gün içinde işleme alınacak.',
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Hesabımı Sil',
                  style: TextStyle(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── Politika Metinleri
  // ══════════════════════════════════════════════════════════════

  static const String _privacyPolicyText = '''
Gizlilik Politikası
Son Güncelleme: 25 Şubat 2026

Kamulog uygulaması olarak kişisel verilerinizin güvenliği bizim için en önemli önceliklerden biridir.

1. Toplanan Veriler
• Kimlik bilgileri (ad, soyad, TC kimlik numarası)
• İletişim bilgileri (telefon numarası, e-posta)
• Konum bilgileri (il, ilçe)
• Kariyer bilgileri (kurum, unvan, çalışma süresi)
• Belge ve CV bilgileri
• Uygulama kullanım verileri

2. Verilerin Kullanım Amacı
• Kullanıcı hesabının oluşturulması ve yönetimi
• Becayiş eşleştirme hizmetinin sunulması
• AI destekli CV oluşturma ve iş analizi
• Kariyer fırsatlarının kişiselleştirilmesi
• Danışmanlık hizmetlerinin sağlanması
• Uygulama güvenliğinin sağlanması
• Yasal yükümlülüklerin yerine getirilmesi

3. Veri Güvenliği
Verileriniz endüstri standardı şifreleme yöntemleri ile korunmaktadır. SSL/TLS protokolleri kullanılarak iletişim güvenliği sağlanır. Verilerinize yalnızca yetkili personel erişebilir.

4. Üçüncü Taraflarla Paylaşım
Kişisel verileriniz, açık rızanız olmaksızın üçüncü taraflarla paylaşılmaz. Yasal zorunluluklar dışında hiçbir verini paylaşılmaz.

5. Haklarınız
• Verilerinize erişim talep etme
• Verilerinizin düzeltilmesini isteme
• Verilerinizin silinmesini talep etme
• Veri işlemenin kısıtlanmasını isteme
• Veri taşınabilirliği hakkı

İletişim: iletisim@kamulogstk.net
''';

  static const String _termsOfUseText = '''
Kullanım Koşulları
Son Güncelleme: 25 Şubat 2026

Kamulog uygulamasını kullanarak aşağıdaki koşulları kabul etmiş sayılırsınız.

1. Hizmet Tanımı
Kamulog, kamu ve özel sektör çalışanlarına becayiş eşleştirme, kariyer danışmanlığı, AI destekli CV oluşturma ve iş analizi hizmetleri sunan bir mobil platformdur.

2. Hesap Oluşturma
• Hesap oluşturmak için gerçek ve güncel bilgiler verilmelidir.
• Her kullanıcı yalnızca bir hesap açabilir.
• Hesap bilgileri başkalarıyla paylaşılmamalıdır.
• 18 yaşından küçükler uygulama kullanamaz.

3. Kullanım Kuralları
• Uygulama yalnızca yasal amaçlarla kullanılmalıdır.
• Sahte veya yanıltıcı bilgi paylaşılmamalıdır.
• Diğer kullanıcılara saygılı davranılmalıdır.
• Uygulamanın güvenliğini tehlikeye atacak faaliyetler yasaktır.
• Otomatik veri toplama araçları kullanılamaz.

4. Abonelik ve Ödeme
• Premium abonelikler Apple App Store ve Google Play Store üzerinden işlenir.
• Abonelik iptali mağaza ayarlarından yapılır.
• İade koşulları ilgili mağazanın politikalarına tabidir.

5. Fikri Mülkiyet
Uygulamadaki tüm içerik, tasarım ve yazılım Kamulog Teknoloji'ye aittir. İzinsiz kopyalama, dağıtma veya değiştirilmesi yasaktır.

6. Sorumluluk Sınırı
Kamulog, üçüncü taraf içeriklerinden, becayiş eşleştirmelerinin sonuçlarından ve danışmanlık hizmetlerinde verilen görüşlerden kaynaklanan zararlardan sorumlu tutulamaz.

7. Değişiklikler
Kullanım koşulları önceden bildirim yapılarak değiştirilebilir. Devam eden kullanım, yeni koşulların kabulü anlamına gelir.

İletişim: iletisim@kamulogstk.net
''';

  static const String _cookiePolicyText = '''
Çerez Politikası
Son Güncelleme: 25 Şubat 2026

1. Çerez Nedir?
Çerezler, uygulamanın cihazınızda sakladığı küçük veri dosyalarıdır. Uygulama deneyiminizi iyileştirmek ve tercihlerinizi hatırlamak için kullanılır.

2. Kullandığımız Çerez Türleri

Zorunlu Çerezler:
• Oturum yönetimi ve kimlik doğrulama
• Güvenlik ayarları ve tercihler
• Uygulama dil seçimi

İşlevsel Çerezler:
• Kullanıcı tercihlerinin hatırlanması
• Son görüntülenen ilanların kaydedilmesi
• Arama geçmişi

Analitik Çerezler:
• Uygulama kullanım istatistikleri
• Performans ölçümleri
• Hata raporları

3. Çerez Yönetimi
Ayarlar > Gizlilik & Güvenlik > Veri Tercihleri bölümünden analitik ve kişiselleştirme çerezlerini açıp kapatabilirsiniz.

4. Üçüncü Taraf Çerezleri
Ödeme işlemleri için Apple ve Google mağazalarının çerez politikaları geçerlidir.

İletişim: iletisim@kamulogstk.net
''';

  static const String _kvkkText = '''
KVKK Aydınlatma Metni
Son Güncelleme: 25 Şubat 2026

6698 Sayılı Kişisel Verilerin Korunması Kanunu kapsamında hazırlanmıştır.

Veri Sorumlusu: Kamulog Teknoloji

1. Kişisel Verilerin İşlenme Amacı
• Üyelik hesabının oluşturulması
• Becayiş hizmetlerinin yürütülmesi
• İş ilanları ve kariyer fırsatlarının sunulması
• AI destekli hizmetlerin sağlanması
• Yasal yükümlülüklerin yerine getirilmesi
• Müşteri memnuniyeti çalışmaları

2. İşlenen Kişisel Veri Kategorileri
• Kimlik bilgileri
• İletişim bilgileri
• Mesleki bilgiler
• Finansal bilgiler (abonelik işlemleri)
• Cihaz ve konum bilgileri

3. Kişisel Verilerin Aktarılması
Verileriniz; yasal zorunluluklar kapsamında yetkili kamu kurum ve kuruluşlarına, ödeme işlemleri için ödeme hizmet sağlayıcılarına ve hukuki uyuşmazlıklar kapsamında yetkili mercilere aktarılabilir.

4. Kişisel Veri Toplamanın Yöntemi ve Hukuki Sebebi
Verileriniz; mobil uygulama, telefon doğrulaması ve anket formları aracılığıyla toplanmaktadır. Hukuki sebepler: açık rıza, sözleşmenin ifası, kanuni yükümlülük.

5. Veri Sahibinin Hakları (Madde 11)
• Kişisel verilerin işlenip işlenmediğini öğrenme
• İşlenmişse bilgi talep etme
• İşlenme amacını ve amacına uygun kullanılıp kullanılmadığını öğrenme
• Yurt içinde/yurt dışında aktarıldığı kişileri bilme
• Eksik veya yanlış işlenmiş verilerin düzeltilmesini isteme
• Kanunun 7. maddesi kapsamında silinmesini veya yok edilmesini isteme
• Düzeltme/silme işlemlerinin aktarıldığı üçüncü kişilere bildirilmesini isteme
• Münhasıran otomatik sistemler ile analiz edilmesi sonucu aleyhinize bir sonuç ortaya çıkması durumunda itiraz etme
• Kanuna aykırı işlenmesi sebebiyle zarara uğramanız halinde tazminat talep etme

Başvuru: iletisim@kamulogstk.net
''';
}

// ══════════════════════════════════════════════════════════════
// ── Bölüm Başlığı
// ══════════════════════════════════════════════════════════════

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final Color? color;

  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.isDark,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primaryColor;
    return Row(
      children: [
        Icon(icon, size: 18, color: c),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Politika Tile
// ══════════════════════════════════════════════════════════════

class _PolicyTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDark;
  final bool isDestructive;

  const _PolicyTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.isDark,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final tileColor =
        isDestructive
            ? AppTheme.errorColor
            : (isDark ? Colors.white70 : Colors.black87);
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isDestructive
                  ? AppTheme.errorColor.withValues(alpha: 0.2)
                  : (isDark ? Colors.white10 : Colors.grey.shade200),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: (isDestructive ? AppTheme.errorColor : AppTheme.primaryColor)
                .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 18,
            color: isDestructive ? AppTheme.errorColor : AppTheme.primaryColor,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: tileColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.black45,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: isDark ? Colors.white30 : Colors.grey.shade400,
        ),
        onTap: onTap,
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Toggle Tile
// ══════════════════════════════════════════════════════════════

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final bool isDark;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.isDark,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey.shade200,
        ),
      ),
      child: SwitchListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        secondary: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: AppTheme.primaryColor),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? Colors.white38 : Colors.black45,
          ),
        ),
        value: value,
        activeThumbColor: AppTheme.primaryColor,
        onChanged: onChanged,
      ),
    );
  }
}
