import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kamulog_superapp/core/theme/app_theme.dart';
import 'package:kamulog_superapp/core/utils/helpers.dart';
import 'package:kamulog_superapp/core/widgets/common_widgets.dart';
import 'package:kamulog_superapp/features/auth/presentation/providers/auth_provider.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:kamulog_superapp/core/storage/local_storage_service.dart';

class PhoneInputScreen extends ConsumerStatefulWidget {
  const PhoneInputScreen({super.key});

  @override
  ConsumerState<PhoneInputScreen> createState() => _PhoneInputScreenState();
}

class _PhoneInputScreenState extends ConsumerState<PhoneInputScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _phoneMask = MaskTextInputFormatter(
    mask: '### ### ## ##',
    filter: {'#': RegExp(r'[0-9]')},
  );

  bool _userAgreementAccepted = false;
  bool _kvkkAccepted = false;

  late final AnimationController _animController;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_userAgreementAccepted || !_kvkkAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Devam etmek icin sozlesmeleri onaylamaniz gerekiyor.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Onaylari kayit altina al
    LocalStorageService.saveConsent(userAgreement: true, kvkk: true);

    final phone = _phoneMask.getUnmaskedText();
    final formattedPhone = Formatters.formatPhoneForApi(phone);
    ref.read(authProvider.notifier).sendOtp(formattedPhone);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    ref.listen<AuthState>(authProvider, (previous, next) {
      if (next.status == AuthStatus.otpSent) {
        context.push('/otp');
      } else if (next.status == AuthStatus.error && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: AppTheme.errorColor,
          ),
        );
        ref.read(authProvider.notifier).clearError();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingLg),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 60),

                      // Logo
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: AppTheme.primaryColor.withValues(
                                  alpha: 0.35,
                                ),
                                blurRadius: 30,
                                offset: const Offset(0, 12),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.auto_awesome,
                            size: 38,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingLg),

                      // Title
                      Text(
                        'Kamulog',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ücretli çalışan platformu',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.textTheme.bodyMedium?.color,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),

                      // Phone field label
                      Text(
                        'Telefon Numaranız',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Phone field
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [_phoneMask],
                        autofocus: true,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                        validator:
                            (v) => Validators.validatePhone(
                              _phoneMask.getUnmaskedText(),
                            ),
                        decoration: InputDecoration(
                          hintText: '5XX XXX XX XX',
                          prefixIcon: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '🇹🇷',
                                  style: const TextStyle(fontSize: 20),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '+90',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  width: 1.5,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    color:
                                        isDark
                                            ? Colors.white.withValues(
                                              alpha: 0.1,
                                            )
                                            : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          prefixIconConstraints: const BoxConstraints(
                            minWidth: 0,
                            minHeight: 0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'WhatsApp doğrulaması için telefon numaranızı girin',
                        style: TextStyle(
                          fontSize: 12,
                          color: theme.textTheme.bodyMedium?.color,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXl),

                      // Submit button
                      KamulogButton(
                        text: 'Dogrulama Kodu Gonder',
                        onPressed: _submit,
                        isLoading: authState.status == AuthStatus.loading,
                        icon: Icons.sms_outlined,
                      ),
                      const SizedBox(height: 16),

                      // ── Kullanici Sozlesmesi Onayi
                      _AgreementCheckbox(
                        value: _userAgreementAccepted,
                        label: 'Kullanici Sozlesmesini',
                        linkText: 'okudum ve kabul ediyorum.',
                        onChanged:
                            (v) => setState(
                              () => _userAgreementAccepted = v ?? false,
                            ),
                        onLinkTap:
                            () => _showAgreementDialog(
                              context,
                              'Kullanici Sozlesmesi',
                              _userAgreementText,
                            ),
                      ),
                      const SizedBox(height: 4),

                      // ── KVKK Onayi
                      _AgreementCheckbox(
                        value: _kvkkAccepted,
                        label: 'KVKK Aydinlatma Metnini',
                        linkText: 'okudum ve kabul ediyorum.',
                        onChanged:
                            (v) => setState(() => _kvkkAccepted = v ?? false),
                        onLinkTap:
                            () => _showAgreementDialog(
                              context,
                              'KVKK Aydinlatma Metni',
                              _kvkkText,
                            ),
                      ),

                      const SizedBox(height: AppTheme.spacingLg),

                      // Info card
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppTheme.infoColor.withValues(alpha: 0.06),
                          borderRadius: BorderRadius.circular(
                            AppTheme.radiusMd,
                          ),
                          border: Border.all(
                            color: AppTheme.infoColor.withValues(alpha: 0.12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppTheme.infoColor.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.shield_outlined,
                                size: 18,
                                color: AppTheme.infoColor,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Güvenli doğrulama kodu WhatsApp üzerinden gönderilecektir.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppTheme.infoColor.withValues(
                                    alpha: 0.85,
                                  ),
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacingXxl),

                      // Legal links
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LegalLink(text: 'Gizlilik', onTap: () {}),
                          _DotSeparator(),
                          _LegalLink(text: 'KVKK', onTap: () {}),
                          _DotSeparator(),
                          _LegalLink(text: 'Kullanım Koşulları', onTap: () {}),
                        ],
                      ),
                      const SizedBox(height: AppTheme.spacingMd),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAgreementDialog(
    BuildContext context,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: double.maxFinite,
              height: MediaQuery.of(context).size.height * 0.5,
              child: SingleChildScrollView(
                child: Text(
                  content,
                  style: const TextStyle(fontSize: 13, height: 1.5),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Kapat'),
              ),
            ],
          ),
    );
  }

  static const String _userAgreementText = '''
KULLANICI SOZLESMESI

1. TARAFLAR
Bu sozlesme, Kamulog uygulamasini kullanan kullanici ("Kullanici") ile Kamulog platformu ("Platform") arasinda akdedilmistir.

2. HIZMET TANIMI
Platform, ucretli calisanlar icin kariyer yonetimi, is ilanlari eslestirme, ozgecmis olusturma ve danismanlik hizmetleri sunmaktadir.

3. KULLANICI YUKUMLULUKLERI
- Kullanici, dogru ve guncel bilgiler saglamakla yukumludur.
- Hesap guvenliginden kullanici sorumludur.
- Platform uzerinden yasa disi faaliyetler yapilamaz.
- Ucuncu sahislarin haklarini ihlal eden icerikler paylasilamaz.

4. PLATFORM HAKLARI
- Platform, hizmet icerigini ve fiyatlandirmayi degistirme hakkini sakli tutar.
- Kurallara uymayan hesaplar askiya alinabilir veya kapatilabilir.
- Platform, kullanici verilerini gizlilik politikasina uygun olarak isler.

5. ABONELIK VE ODEME
- Premium abonelik ucretleri uygulama magazalari uzerinden tahsil edilir.
- Iptal islemi magazalarin belirleidigi kurallara tabidir.
- Iade politikasi magazalarin kurallarina uygun olarak uygulanir.

6. SORUMLULUK SINIRLAMASI
- Platform, hizmetin kesintisiz oldugunu garanti etmez.
- AI tabanli oneriler bilgilendirme amaclidir, kesin sonuc garanti edilmez.

7. UYUSMAZLIK
Bu sozlesmeden kaynakli uyusmazliklarda Turkiye Cumhuriyeti kanunlari uygulanir.
''';

  static const String _kvkkText = '''
KISISEL VERILERIN KORUNMASI AYDINLATMA METNI

6698 sayili Kisisel Verilerin Korunmasi Kanunu ("KVKK") geregince, kisisel verilerinizin islenmesine iliskin sizi bilgilendirmek istiyoruz.

1. VERI SORUMLUSU
Kamulog platformu, kisisel verilerinizin veri sorumlusudur.

2. ISLENEN KISISEL VERILER
- Kimlik bilgileri: Ad, soyad, TC Kimlik numarasi
- Iletisim bilgileri: Telefon numarasi, e-posta adresi
- Lokasyon bilgileri: Sehir, ilce
- Mesleki bilgiler: Calisma durumu, kurum, unvan, kidem yili
- Belge bilgileri: Yuklenen CV ve belgeler
- Kullanim verileri: Uygulama ici etkilesimler

3. VERILERIN ISLENME AMACLARI
- Kullanici hesabinin olusturulmasi ve yonetimi
- Kariyer hizmetlerinin sunulmasi
- AI tabanli is eslestirme ve CV analizi
- Yasal yukumluluklerin yerine getirilmesi
- Hizmet kalitesinin iyilestirilmesi

4. VERILERIN AKTARIMI
Kisisel verileriniz;
- Yasal yukumlulukler kapsaminda yetkili kurumlara,
- Hizmet saglayicilara (sunucu, bulut hizmetleri),
- Odeme islemleri icin odeme hizmet saglayicilarina aktarilabilir.

5. VERI SAKLAMA SURESI
Kisisel verileriniz, islenme amacinin gerektirdigi sure boyunca ve yasal saklama yukululukleri kapsaminda muhafaza edilir.

6. HAKLARINIZ
KVKK Madde 11 uyarinca asagidaki haklara sahipsiniz:
- Verilerinizin islenip islenmedigini ogrenme
- Verilerinizin islenmissse buna iliskin bilgi talep etme
- Verilerinizin silinmesini veya yok edilmesini isteme
- Verilerinizin duzeltilmesini isteme

Bu haklarinizi kullanmak icin uygulama ici iletisim kanallari uzerinden bize ulasabilirsiniz.
''';
}

class _LegalLink extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _LegalLink({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.7),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _DotSeparator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Container(
        width: 3,
        height: 3,
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

class _AgreementCheckbox extends StatelessWidget {
  final bool value;
  final String label;
  final String linkText;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onLinkTap;

  const _AgreementCheckbox({
    required this.value,
    required this.label,
    required this.linkText,
    required this.onChanged,
    required this.onLinkTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryColor,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: GestureDetector(
            onTap: onLinkTap,
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodyMedium?.color,
                ),
                children: [
                  TextSpan(text: label),
                  const TextSpan(text: ' '),
                  TextSpan(
                    text: linkText,
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
