// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Kamulog';

  @override
  String get login => 'Log In';

  @override
  String get register => 'Register';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get phoneHint => '5XX XXX XX XX';

  @override
  String get sendCode => 'Send Verification Code';

  @override
  String get verificationCode => 'Verification Code';

  @override
  String get verifyCode => 'Verify';

  @override
  String get resendCode => 'Resend Code';

  @override
  String resendCodeIn(int seconds) {
    return 'Resend in $seconds seconds';
  }

  @override
  String get otpSentMessage => 'Verification code sent via WhatsApp';

  @override
  String get otpExpiry => 'Code expires in 10 minutes';

  @override
  String get logout => 'Log Out';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get home => 'Home';

  @override
  String get stk => 'NGO';

  @override
  String get becayis => 'Transfer';

  @override
  String get career => 'Career';

  @override
  String get consultation => 'Consultation';

  @override
  String get announcements => 'Announcements';

  @override
  String get forum => 'Forum';

  @override
  String get groups => 'Groups';

  @override
  String get notifications => 'Notifications';

  @override
  String get search => 'Search';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get apply => 'Apply';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get close => 'Close';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get ok => 'OK';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get noData => 'No data to display';

  @override
  String get retry => 'Retry';

  @override
  String get connectionError => 'No internet connection';

  @override
  String get serverError => 'Server error occurred';

  @override
  String get sessionExpired => 'Session expired';

  @override
  String get jobListings => 'Job Listings';

  @override
  String get myApplications => 'My Applications';

  @override
  String get myCvs => 'My CVs';

  @override
  String get favorites => 'Favorites';

  @override
  String get createTicket => 'Create Ticket';

  @override
  String get myTickets => 'My Tickets';

  @override
  String get transferRequests => 'Transfer Requests';

  @override
  String get createTransfer => 'Create Request';

  @override
  String get myTransfers => 'My Requests';

  @override
  String get matches => 'Matches';

  @override
  String get messages => 'Messages';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get language => 'Language';

  @override
  String get about => 'About';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get kvkk => 'KVKK Notice';

  @override
  String get version => 'Version';

  @override
  String get city => 'City';

  @override
  String get institution => 'Institution';

  @override
  String get position => 'Position';

  @override
  String get allCities => 'All Cities';

  @override
  String get allInstitutions => 'All Institutions';

  @override
  String get selectCity => 'Select City';

  @override
  String get selectInstitution => 'Select Institution';
}
