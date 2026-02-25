import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';

/// Yardım & Destek sayfası — SSS, WhatsApp, iletişim
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // ── WhatsApp Numarası (web panelinden ayarlanacak)
  static const String _whatsappNumber = '905016547534';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Yardım & Destek'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── WhatsApp İletişim Kartı
            _WhatsAppCard(isDark: isDark),
            const SizedBox(height: 24),

            // ── Destek Seçenekleri
            const Text(
              'Destek Seçenekleri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _SupportOptionCard(
              icon: Icons.email_rounded,
              title: 'E-posta Desteği',
              subtitle: 'iletisim@kamulogstk.net',
              color: AppTheme.infoColor,
              isDark: isDark,
              onTap: () => _launchEmail(),
            ),
            const SizedBox(height: 10),
            _SupportOptionCard(
              icon: Icons.bug_report_rounded,
              title: 'Hata Bildir',
              subtitle: 'Uygulama sorunlarını bize bildirin',
              color: AppTheme.errorColor,
              isDark: isDark,
              onTap: () => _launchEmail(subject: 'Hata Bildirimi'),
            ),
            const SizedBox(height: 10),
            _SupportOptionCard(
              icon: Icons.lightbulb_rounded,
              title: 'Öneride Bulunun',
              subtitle: 'Fikirlerinizi duymak isteriz',
              color: AppTheme.warningColor,
              isDark: isDark,
              onTap: () => _launchEmail(subject: 'Uygulama Önerisi'),
            ),
            const SizedBox(height: 24),

            // ── SSS (Sıkça Sorulan Sorular)
            const Text(
              'Sıkça Sorulan Sorular',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 12),
            _FaqItem(
              question: 'Premium abonelik nasıl satın alınır?',
              answer:
                  'Profilinizde "Üyelik & Abonelik" butonuna dokunarak abonelik '
                  'planlarını görebilirsiniz. Aylık veya yıllık plan seçerek '
                  'Apple App Store / Google Play Store üzerinden ödeme yapabilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Becayiş başvurusu nasıl yapılır?',
              answer:
                  'Ana sayfadaki "Becayiş" menüsüne girerek yer değiştirme '
                  'ilanlarını görüntüleyebilir ve eşleşme talebi gönderebilirsiniz. '
                  'Eşleşme sonuçları anlık bildirimlerle size iletilir.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'AI CV oluşturma hakkım bitti, ne yapmalıyım?',
              answer:
                  'Tüm kullanıcılar ayda 1 kez ücretsiz AI CV oluşturabilir. '
                  'Ek kullanım için jeton satın alabilir veya Premium aboneliğe '
                  'geçerek sınırsız erişim sağlayabilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Hesabımı nasıl silebilirim?',
              answer:
                  'Profil > Gizlilik & Güvenlik > Hesabı Sil adımlarını izleyerek '
                  'hesap silme talebinde bulunabilirsiniz. Talebiniz 30 gün içinde '
                  'işleme alınır.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Bildirimler gelmiyor, ne yapmalıyım?',
              answer:
                  'Profil > Bildirim Ayarları bölümünden bildirim tercihlerinizi '
                  'kontrol edin. Ayrıca cihaz ayarlarından Kamulog uygulamasının '
                  'bildirim izninin açık olduğundan emin olun.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Danışmanlık randevusu nasıl alınır?',
              answer:
                  'Ana sayfadaki "Danışmanlık" menüsünden hukuk, kariyer ve '
                  'psikolojik destek danışmanlarını görüntüleyerek randevu '
                  'oluşturabilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Aboneliği nasıl iptal edebilirim?',
              answer:
                  'Profil > Üyelik & Abonelik sayfasında "Aboneliği İptal Et" '
                  'butonuna dokunarak iptal işlemini başlatabilirsiniz. '
                  'İptal işlemi Apple/Google mağaza ayarları üzerinden gerçekleşir.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Jeton (kredi) sistemi nasıl çalışır?',
              answer:
                  'Her yeni kullanıcıya 20 jeton hediye edilir. AI CV oluşturma, '
                  'iş analizi ve bazı premium özellikler jeton ile kullanılır. '
                  'Jetonlarınız bittiğinde Profil > Üyelik & Abonelik bölümünden '
                  'ek jeton satın alabilir veya Premium aboneliğe geçebilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Maaş hesaplama aracı nasıl kullanılır?',
              answer:
                  'Ana sayfadaki "Maaş Hesaplama" seçeneğinden mevcut maaşınızı, '
                  'derece ve kademe bilgilerinizi girerek güncel maaş hesaplamanızı '
                  'yapabilirsiniz. Memur ve işçi maaş hesaplamaları desteklenmektedir.',
              isDark: isDark,
            ),
            _FaqItem(
              question:
                  'STK ve sendika özelliklerinden nasıl yararlanabilirim?',
              answer:
                  'Ana sayfadaki "STK" menüsünden sendika ve sivil toplum '
                  'kuruluşlarının etkinliklerini takip edebilir, üyelik '
                  'başvurularını görüntüleyebilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Verilerim güvende mi?',
              answer:
                  'Evet. Tüm verileriniz endüstri standardı şifreleme yöntemleri '
                  'ile korunur. SSL/TLS protokolleri kullanılarak iletişim güvenliği '
                  'sağlanır. KVKK kapsamında veri güvenliği politikalarımıza '
                  'Gizlilik & Güvenlik bölümünden erişebilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Birden fazla cihazda kullanabilir miyim?',
              answer:
                  'Evet, Kamulog hesabınızla birden fazla cihazda oturum açabilirsiniz. '
                  'Verileriniz tüm cihazlarınız arasında senkronize edilir.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Profil bilgilerimi nasıl güncellerim?',
              answer:
                  'Profil sayfanızın sağ üst köşesindeki düzenleme butonuna '
                  'dokunarak kişisel bilgilerinizi, iletişim adresinizi ve kariyer '
                  'detaylarınızı güncelleyebilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Favorilere nasıl ilan eklerim?',
              answer:
                  'İlan detay sayfasında sağ üst köşedeki kalp ikonuna dokunarak '
                  'ilanı favorilerinize ekleyebilirsiniz. Favorilerinize '
                  'Profil > Favorilerim bölümünden erişebilirsiniz.',
              isDark: isDark,
            ),
            _FaqItem(
              question: 'Uygulama çöküyor veya yavaş çalışıyor, ne yapmalıyım?',
              answer:
                  'Öncelikle uygulamanın en güncel sürümünü kullandığınızdan emin olun. '
                  'Sorun devam ederse uygulamayı kapatıp yeniden başlatın. '
                  'Çözülmezse "Hata Bildir" seçeneğinden bize yazın, en kısa sürede yardımcı olalım.',
              isDark: isDark,
            ),
            _FaqItem(
              question:
                  'Aylık Premium ve Yıllık Premium arasındaki fark nedir?',
              answer:
                  'Her iki plan da aynı özellikleri sunar: sınırsız mesajlaşma, AI CV, '
                  'sınırsız becayiş inceleme ve +1000 kredi. Yıllık planda %17 '
                  'tasarruf edersiniz. Aylık plandan yıllığa istediğiniz zaman yükseltebilirsiniz.',
              isDark: isDark,
            ),
            const SizedBox(height: 24),

            // ── Alt Bilgi
            Center(
              child: Column(
                children: [
                  Text(
                    'Yanıt süremiz genellikle 24 saat içindedir.',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Kamulog Destek Ekibi',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white54 : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail({String? subject}) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'iletisim@kamulogstk.net',
      queryParameters: subject != null ? {'subject': subject} : null,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// ══════════════════════════════════════════════════════════════
// ── WhatsApp İletişim Kartı
// ══════════════════════════════════════════════════════════════

class _WhatsAppCard extends StatelessWidget {
  final bool isDark;
  const _WhatsAppCard({required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.message_rounded,
                  color: Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'WhatsApp Destek Hattı',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Canlı destek için bize ulaşın',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openWhatsApp(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF25D366),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              icon: const Icon(Icons.open_in_new_rounded, size: 18),
              label: const Text(
                'WhatsApp\'ta Yazın',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openWhatsApp(BuildContext context) async {
    const phone = HelpSupportScreen._whatsappNumber;
    final uri = Uri.parse(
      'https://wa.me/$phone?text=Merhaba, Kamulog uygulaması hakkında destek almak istiyorum.',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('WhatsApp açılamadı')));
      }
    }
  }
}

// ══════════════════════════════════════════════════════════════
// ── Destek Seçenek Kartı
// ══════════════════════════════════════════════════════════════

class _SupportOptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final bool isDark;
  final VoidCallback onTap;

  const _SupportOptionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isDark ? AppTheme.cardDark : Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
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
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? Colors.white30 : Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── SSS Accordion Item
// ══════════════════════════════════════════════════════════════

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  final bool isDark;

  const _FaqItem({
    required this.question,
    required this.answer,
    required this.isDark,
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
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Icon(
            Icons.help_outline_rounded,
            color: AppTheme.primaryColor,
            size: 20,
          ),
          title: Text(
            question,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          children: [
            Text(
              answer,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
