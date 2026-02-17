import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @appName.
  ///
  /// In tr, this message translates to:
  /// **'Kamulog'**
  String get appName;

  /// No description provided for @login.
  ///
  /// In tr, this message translates to:
  /// **'Giriş Yap'**
  String get login;

  /// No description provided for @register.
  ///
  /// In tr, this message translates to:
  /// **'Kayıt Ol'**
  String get register;

  /// No description provided for @phoneNumber.
  ///
  /// In tr, this message translates to:
  /// **'Telefon Numarası'**
  String get phoneNumber;

  /// No description provided for @phoneHint.
  ///
  /// In tr, this message translates to:
  /// **'5XX XXX XX XX'**
  String get phoneHint;

  /// No description provided for @sendCode.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama Kodu Gönder'**
  String get sendCode;

  /// No description provided for @verificationCode.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama Kodu'**
  String get verificationCode;

  /// No description provided for @verifyCode.
  ///
  /// In tr, this message translates to:
  /// **'Doğrula'**
  String get verifyCode;

  /// No description provided for @resendCode.
  ///
  /// In tr, this message translates to:
  /// **'Kodu Tekrar Gönder'**
  String get resendCode;

  /// No description provided for @resendCodeIn.
  ///
  /// In tr, this message translates to:
  /// **'{seconds} saniye sonra tekrar gönder'**
  String resendCodeIn(int seconds);

  /// No description provided for @otpSentMessage.
  ///
  /// In tr, this message translates to:
  /// **'Doğrulama kodu WhatsApp üzerinden gönderildi'**
  String get otpSentMessage;

  /// No description provided for @otpExpiry.
  ///
  /// In tr, this message translates to:
  /// **'Kod 10 dakika içinde geçerliliğini yitirecektir'**
  String get otpExpiry;

  /// No description provided for @logout.
  ///
  /// In tr, this message translates to:
  /// **'Çıkış Yap'**
  String get logout;

  /// No description provided for @profile.
  ///
  /// In tr, this message translates to:
  /// **'Profil'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In tr, this message translates to:
  /// **'Ayarlar'**
  String get settings;

  /// No description provided for @home.
  ///
  /// In tr, this message translates to:
  /// **'Ana Sayfa'**
  String get home;

  /// No description provided for @stk.
  ///
  /// In tr, this message translates to:
  /// **'STK'**
  String get stk;

  /// No description provided for @becayis.
  ///
  /// In tr, this message translates to:
  /// **'Becayiş'**
  String get becayis;

  /// No description provided for @career.
  ///
  /// In tr, this message translates to:
  /// **'Kariyer'**
  String get career;

  /// No description provided for @consultation.
  ///
  /// In tr, this message translates to:
  /// **'Danışmanlık'**
  String get consultation;

  /// No description provided for @announcements.
  ///
  /// In tr, this message translates to:
  /// **'Duyurular'**
  String get announcements;

  /// No description provided for @forum.
  ///
  /// In tr, this message translates to:
  /// **'Forum'**
  String get forum;

  /// No description provided for @groups.
  ///
  /// In tr, this message translates to:
  /// **'Gruplar'**
  String get groups;

  /// No description provided for @notifications.
  ///
  /// In tr, this message translates to:
  /// **'Bildirimler'**
  String get notifications;

  /// No description provided for @search.
  ///
  /// In tr, this message translates to:
  /// **'Ara'**
  String get search;

  /// No description provided for @filter.
  ///
  /// In tr, this message translates to:
  /// **'Filtrele'**
  String get filter;

  /// No description provided for @sort.
  ///
  /// In tr, this message translates to:
  /// **'Sırala'**
  String get sort;

  /// No description provided for @apply.
  ///
  /// In tr, this message translates to:
  /// **'Uygula'**
  String get apply;

  /// No description provided for @cancel.
  ///
  /// In tr, this message translates to:
  /// **'İptal'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In tr, this message translates to:
  /// **'Kaydet'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In tr, this message translates to:
  /// **'Sil'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In tr, this message translates to:
  /// **'Düzenle'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In tr, this message translates to:
  /// **'Oluştur'**
  String get create;

  /// No description provided for @close.
  ///
  /// In tr, this message translates to:
  /// **'Kapat'**
  String get close;

  /// No description provided for @yes.
  ///
  /// In tr, this message translates to:
  /// **'Evet'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In tr, this message translates to:
  /// **'Hayır'**
  String get no;

  /// No description provided for @ok.
  ///
  /// In tr, this message translates to:
  /// **'Tamam'**
  String get ok;

  /// No description provided for @error.
  ///
  /// In tr, this message translates to:
  /// **'Hata'**
  String get error;

  /// No description provided for @success.
  ///
  /// In tr, this message translates to:
  /// **'Başarılı'**
  String get success;

  /// No description provided for @loading.
  ///
  /// In tr, this message translates to:
  /// **'Yükleniyor...'**
  String get loading;

  /// No description provided for @noData.
  ///
  /// In tr, this message translates to:
  /// **'Gösterilecek veri bulunamadı'**
  String get noData;

  /// No description provided for @retry.
  ///
  /// In tr, this message translates to:
  /// **'Tekrar Dene'**
  String get retry;

  /// No description provided for @connectionError.
  ///
  /// In tr, this message translates to:
  /// **'İnternet bağlantısı bulunamadı'**
  String get connectionError;

  /// No description provided for @serverError.
  ///
  /// In tr, this message translates to:
  /// **'Sunucu hatası oluştu'**
  String get serverError;

  /// No description provided for @sessionExpired.
  ///
  /// In tr, this message translates to:
  /// **'Oturumunuzun süresi dolmuş'**
  String get sessionExpired;

  /// No description provided for @jobListings.
  ///
  /// In tr, this message translates to:
  /// **'İş İlanları'**
  String get jobListings;

  /// No description provided for @myApplications.
  ///
  /// In tr, this message translates to:
  /// **'Başvurularım'**
  String get myApplications;

  /// No description provided for @myCvs.
  ///
  /// In tr, this message translates to:
  /// **'CV\'lerim'**
  String get myCvs;

  /// No description provided for @favorites.
  ///
  /// In tr, this message translates to:
  /// **'Favorilerim'**
  String get favorites;

  /// No description provided for @createTicket.
  ///
  /// In tr, this message translates to:
  /// **'Talep Oluştur'**
  String get createTicket;

  /// No description provided for @myTickets.
  ///
  /// In tr, this message translates to:
  /// **'Taleplerim'**
  String get myTickets;

  /// No description provided for @transferRequests.
  ///
  /// In tr, this message translates to:
  /// **'Becayiş Talepleri'**
  String get transferRequests;

  /// No description provided for @createTransfer.
  ///
  /// In tr, this message translates to:
  /// **'Talep Oluştur'**
  String get createTransfer;

  /// No description provided for @myTransfers.
  ///
  /// In tr, this message translates to:
  /// **'Taleplerim'**
  String get myTransfers;

  /// No description provided for @matches.
  ///
  /// In tr, this message translates to:
  /// **'Eşleşmeler'**
  String get matches;

  /// No description provided for @messages.
  ///
  /// In tr, this message translates to:
  /// **'Mesajlar'**
  String get messages;

  /// No description provided for @darkMode.
  ///
  /// In tr, this message translates to:
  /// **'Karanlık Mod'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In tr, this message translates to:
  /// **'Dil'**
  String get language;

  /// No description provided for @about.
  ///
  /// In tr, this message translates to:
  /// **'Hakkında'**
  String get about;

  /// No description provided for @privacyPolicy.
  ///
  /// In tr, this message translates to:
  /// **'Gizlilik Politikası'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In tr, this message translates to:
  /// **'Kullanım Koşulları'**
  String get termsOfService;

  /// No description provided for @kvkk.
  ///
  /// In tr, this message translates to:
  /// **'KVKK Aydınlatma Metni'**
  String get kvkk;

  /// No description provided for @version.
  ///
  /// In tr, this message translates to:
  /// **'Versiyon'**
  String get version;

  /// No description provided for @city.
  ///
  /// In tr, this message translates to:
  /// **'Şehir'**
  String get city;

  /// No description provided for @institution.
  ///
  /// In tr, this message translates to:
  /// **'Kurum'**
  String get institution;

  /// No description provided for @position.
  ///
  /// In tr, this message translates to:
  /// **'Pozisyon'**
  String get position;

  /// No description provided for @allCities.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Şehirler'**
  String get allCities;

  /// No description provided for @allInstitutions.
  ///
  /// In tr, this message translates to:
  /// **'Tüm Kurumlar'**
  String get allInstitutions;

  /// No description provided for @selectCity.
  ///
  /// In tr, this message translates to:
  /// **'Şehir Seçin'**
  String get selectCity;

  /// No description provided for @selectInstitution.
  ///
  /// In tr, this message translates to:
  /// **'Kurum Seçin'**
  String get selectInstitution;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
