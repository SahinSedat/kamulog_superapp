class ApiEndpoints {
  ApiEndpoints._();

  // ── Auth ──
  static const String sendOtp = '/api/auth/login';
  static const String verifyOtp = '/api/auth/verify-code';
  static const String register = '/api/auth/register';
  static const String verifyRegistration = '/api/auth/verify-registration';
  static const String refreshToken = '/api/auth/refresh-token';
  static const String forgotPassword = '/api/auth/forgot-password';
  static const String resetPassword = '/api/auth/reset-password';
  static const String resendCode = '/api/auth/send-code';

  // ── User Profile ──
  static const String userProfile = '/api/user/profile';
  static const String userCredits = '/api/user/credits';
  static const String subscriptionUsage = '/api/subscription/usage';

  // ── STK ──
  static const String stkList = '/api/public/stk';
  static String stkDetail(String id) => '/api/public/stk/$id';
  static const String stkAnnouncements = '/api/stk/announcements';
  static const String stkForum = '/api/stk/forum';
  static const String stkGroups = '/api/stk/groups';
  static const String stkMembers = '/api/stk/members';
  static const String stkMembershipApply = '/api/public/membership/apply';

  // ── Becayiş ──
  static const String becayisListings = '/api/becayis/listings';
  static String becayisDetail(String id) => '/api/becayis/listings/$id';
  static const String becayisMyRequests = '/api/becayis/my-requests';
  static const String becayisMatch = '/api/becayis/match';
  static const String becayisMessages = '/api/becayis/messages';

  // ── Kariyer ──
  static const String jobs = '/api/jobs';
  static String jobDetail(String id) => '/api/jobs/$id';
  static const String jobAnalyze = '/api/jobs/analyze';
  static const String jobMatch = '/api/jobs/match';
  static const String cvList = '/api/cv';
  static String cvDetail(String id) => '/api/cv/$id';
  static const String cvUploadPdf = '/api/cv/upload-pdf';
  static const String cvExportPdf = '/api/cv/export-pdf';

  // ── Danışmanlık ──
  static const String consultationTickets = '/api/consultation/tickets';
  static String consultationTicketDetail(String id) =>
      '/api/consultation/tickets/$id';
  static const String chat = '/api/chat';
  static const String chatConsultant = '/api/chat/consultant';
  static const String chatUnread = '/api/chat/unread';
  static const String consultantRating = '/api/consultant-rating';

  // ── Utilities ──
  static const String locations = '/api/locations';
  static const String notifications = '/api/notifications';
  static const String legal = '/api/legal';
  static const String slider = '/api/slider';
}

class AppConstants {
  AppConstants._();

  static const String appName = 'Kamulog';
  static const String appVersion = '1.0.0';
  static const int otpLength = 6;
  static const int otpExpiryMinutes = 10;
  static const int apiTimeoutSeconds = 30;
  static const int maxRetryAttempts = 3;
  static const int paginationLimit = 20;
  static const String defaultLocale = 'tr';
  static const String phonePrefix = '+90';
  static const int phoneDigitCount = 10;
}
