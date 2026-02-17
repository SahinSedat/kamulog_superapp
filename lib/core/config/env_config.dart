import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Environment { staging, production }

class EnvConfig {
  static late Environment _environment;

  static Environment get environment => _environment;
  static bool get isProduction => _environment == Environment.production;
  static bool get isStaging => _environment == Environment.staging;

  static Future<void> init({Environment env = Environment.staging}) async {
    _environment = env;
    final fileName = env == Environment.production
        ? '.env.production'
        : '.env.staging';
    await dotenv.load(fileName: fileName);
  }

  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'https://api.kamulog.com';

  static bool get enableSslPinning =>
      dotenv.env['ENABLE_SSL_PINNING']?.toLowerCase() == 'true';

  static String get logLevel =>
      dotenv.env['LOG_LEVEL'] ?? 'error';
}
