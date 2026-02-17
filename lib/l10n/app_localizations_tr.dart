// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appName => 'Kamulog';

  @override
  String get login => 'Giriş Yap';

  @override
  String get register => 'Kayıt Ol';

  @override
  String get phoneNumber => 'Telefon Numarası';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get sendCode => 'Doğrulama Kodu Gönder';

  @override
  String get verificationCode => 'Doğrulama Kodu';

  @override
  String get verifyCode => 'Doğrula';

  @override
  String get resendCode => 'Kodu Tekrar Gönder';

  @override
  String resendCodeIn(int seconds) {
    return '$seconds saniye sonra tekrar gönder';
  }

  @override
  String get otpSentMessage => 'Doğrulama kodu WhatsApp üzerinden gönderildi';

  @override
  String get otpExpiry => 'Kod 10 dakika içinde geçerliliğini yitirecektir';

  @override
  String get logout => 'Çıkış Yap';

  @override
  String get profile => 'Profil';

  @override
  String get settings => 'Ayarlar';

  @override
  String get home => 'Ana Sayfa';

  @override
  String get stk => 'STK';

  @override
  String get becayis => 'Becayiş';

  @override
  String get career => 'Kariyer';

  @override
  String get consultation => 'Danışmanlık';

  @override
  String get announcements => 'Duyurular';

  @override
  String get forum => 'Forum';

  @override
  String get groups => 'Gruplar';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get search => 'Ara';

  @override
  String get filter => 'Filtrele';

  @override
  String get sort => 'Sırala';

  @override
  String get apply => 'Uygula';

  @override
  String get cancel => 'İptal';

  @override
  String get save => 'Kaydet';

  @override
  String get delete => 'Sil';

  @override
  String get edit => 'Düzenle';

  @override
  String get create => 'Oluştur';

  @override
  String get close => 'Kapat';

  @override
  String get yes => 'Evet';

  @override
  String get no => 'Hayır';

  @override
  String get ok => 'Tamam';

  @override
  String get error => 'Hata';

  @override
  String get success => 'Başarılı';

  @override
  String get loading => 'Yükleniyor...';

  @override
  String get noData => 'Gösterilecek veri bulunamadı';

  @override
  String get retry => 'Tekrar Dene';

  @override
  String get connectionError => 'İnternet bağlantısı bulunamadı';

  @override
  String get serverError => 'Sunucu hatası oluştu';

  @override
  String get sessionExpired => 'Oturumunuzun süresi dolmuş';

  @override
  String get jobListings => 'İş İlanları';

  @override
  String get myApplications => 'Başvurularım';

  @override
  String get myCvs => 'CV\'lerim';

  @override
  String get favorites => 'Favorilerim';

  @override
  String get createTicket => 'Talep Oluştur';

  @override
  String get myTickets => 'Taleplerim';

  @override
  String get transferRequests => 'Becayiş Talepleri';

  @override
  String get createTransfer => 'Talep Oluştur';

  @override
  String get myTransfers => 'Taleplerim';

  @override
  String get matches => 'Eşleşmeler';

  @override
  String get messages => 'Mesajlar';

  @override
  String get darkMode => 'Karanlık Mod';

  @override
  String get language => 'Dil';

  @override
  String get about => 'Hakkında';

  @override
  String get privacyPolicy => 'Gizlilik Politikası';

  @override
  String get termsOfService => 'Kullanım Koşulları';

  @override
  String get kvkk => 'KVKK Aydınlatma Metni';

  @override
  String get version => 'Versiyon';

  @override
  String get city => 'Şehir';

  @override
  String get institution => 'Kurum';

  @override
  String get position => 'Pozisyon';

  @override
  String get allCities => 'Tüm Şehirler';

  @override
  String get allInstitutions => 'Tüm Kurumlar';

  @override
  String get selectCity => 'Şehir Seçin';

  @override
  String get selectInstitution => 'Kurum Seçin';
}
