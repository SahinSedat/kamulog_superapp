import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

// ══════════════════════════════════════════════════════════════
// ── ThemeExtension
// ══════════════════════════════════════════════════════════════

class KamulogThemeData extends ThemeExtension<KamulogThemeData> {
  final LinearGradient primaryGradient;
  final LinearGradient aiGradient;
  final LinearGradient pastelGradient;
  final Color purpleAccent;
  final Color cardColor;
  final Color borderColor;

  const KamulogThemeData({
    required this.primaryGradient,
    required this.aiGradient,
    required this.pastelGradient,
    required this.purpleAccent,
    required this.cardColor,
    required this.borderColor,
  });

  @override
  KamulogThemeData copyWith({
    LinearGradient? primaryGradient,
    LinearGradient? aiGradient,
    LinearGradient? pastelGradient,
    Color? purpleAccent,
    Color? cardColor,
    Color? borderColor,
  }) {
    return KamulogThemeData(
      primaryGradient: primaryGradient ?? this.primaryGradient,
      aiGradient: aiGradient ?? this.aiGradient,
      pastelGradient: pastelGradient ?? this.pastelGradient,
      purpleAccent: purpleAccent ?? this.purpleAccent,
      cardColor: cardColor ?? this.cardColor,
      borderColor: borderColor ?? this.borderColor,
    );
  }

  @override
  KamulogThemeData lerp(
    covariant ThemeExtension<KamulogThemeData>? other,
    double t,
  ) {
    if (other is! KamulogThemeData) return this;
    return KamulogThemeData(
      primaryGradient: t < 0.5 ? primaryGradient : other.primaryGradient,
      aiGradient: t < 0.5 ? aiGradient : other.aiGradient,
      pastelGradient: t < 0.5 ? pastelGradient : other.pastelGradient,
      purpleAccent: Color.lerp(purpleAccent, other.purpleAccent, t)!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── AppTheme — BOLD & VIVID Renk Paleti
// ══════════════════════════════════════════════════════════════

class AppTheme {
  AppTheme._();

  // ── Memur Modu — Deep Blue
  static const Color memurPrimary = Color(0xFF1565C0);
  static const Color memurSecondary = Color(0xFF42A5F5);

  // ── İşçi Modu — Red (Kırmızı)
  static const Color isciPrimary = Color(0xFFC62828);
  static const Color isciSecondary = Color(0xFFEF5350);

  // ── Genel Renkler
  static const Color background = Color(0xFFF5F5F5);
  static const Color surfaceDark = Color(0xFF121212);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF1E1E1E);
  static const Color successColor = Color(0xFF2E7D32);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color warningColor = Color(0xFFF9A825);
  static const Color infoColor = Color(0xFF1565C0);

  // ── Accent — Vivid
  static const Color accentColor = Color(0xFF00C853);
  static const Color accentLight = Color(0xFF69F0AE);
  static const Color accentDark = Color(0xFF00962B);
  static const Color purpleAccent = Color(0xFF7B1FA2);

  // ── Backward-compat aliases
  static const Color primaryColor = memurPrimary;
  static const Color primaryLight = memurSecondary;
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color warmColor = isciPrimary;
  static const Color warmLight = isciSecondary;
  static const Color surfaceLight = background;
  static const Color redAccent = Color(0xFFC62828);
  static const Color blueAccent = Color(0xFF1565C0);

  // ── Text Colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textTertiaryLight = Color(0xFFBDBDBD);
  static const Color textPrimaryDark = Color(0xFFFAFAFA);
  static const Color textSecondaryDark = Color(0xFF9E9E9E);
  static const Color textTertiaryDark = Color(0xFF616161);

  // ── Spacing & Radius
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 100;

  // ── Kırmızı-Mavi Gradient Tema
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFFC62828), Color(0xFF1565C0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFD32F2F), Color(0xFF1976D2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFFB71C1C), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pastelGradient = LinearGradient(
    colors: [Color(0xFFEF5350), Color(0xFF42A5F5)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient splashGradient = LinearGradient(
    colors: [Color(0xFFB71C1C), Color(0xFF880E4F), Color(0xFF0D47A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFFC62828), Color(0xFF1565C0)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ── Decorations

  static BoxDecoration softCardDecoration({required bool isDark}) {
    return BoxDecoration(
      color: isDark ? cardDark : cardLight,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.08)
                : const Color(0xFFE0E0E0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  static BoxDecoration glassDecoration({
    required bool isDark,
    BorderRadiusGeometry? borderRadius,
  }) {
    return BoxDecoration(
      color: (isDark ? Colors.black : Colors.white).withValues(
        alpha: isDark ? 0.6 : 0.85,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(radiusLg),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.08),
      ),
    );
  }

  // ── Helpers

  static Color getPrimaryColor(EmploymentType? type) {
    if (type == EmploymentType.isci) return isciPrimary;
    return memurPrimary;
  }

  static Color getSecondaryColor(EmploymentType? type) {
    if (type == EmploymentType.isci) return isciSecondary;
    return memurSecondary;
  }

  // ── Dynamic Theme Builder

  static ThemeData getTheme({
    required Brightness brightness,
    EmploymentType? type,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final primary = getPrimaryColor(type);
    final secondary = getSecondaryColor(type);

    final baseTextTheme =
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;
    final bodyText = GoogleFonts.interTextTheme(baseTextTheme);
    final headlineText = GoogleFonts.outfitTextTheme(baseTextTheme);

    final textPrimary = isDark ? textPrimaryDark : textPrimaryLight;
    final textSecondary = isDark ? textSecondaryDark : textSecondaryLight;
    final textTertiary = isDark ? textTertiaryDark : textTertiaryLight;
    final surface = isDark ? surfaceDark : background;
    final card = isDark ? cardDark : cardLight;
    final border =
        isDark ? Colors.white.withValues(alpha: 0.1) : const Color(0xFFE0E0E0);

    final isWorker = type == EmploymentType.isci;
    final kamulogExt = KamulogThemeData(
      primaryGradient: isWorker ? warmGradient : primaryGradient,
      aiGradient: aiGradient,
      pastelGradient: pastelGradient,
      purpleAccent: purpleAccent,
      cardColor: card,
      borderColor: border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      extensions: [kamulogExt],
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: secondary,
        surface: surface,
        error: errorColor,
      ),
      scaffoldBackgroundColor: surface,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? surfaceDark : Colors.white,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          elevation: 2,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        hintStyle: GoogleFonts.inter(color: textTertiary, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: 14,
        ),
      ),
      textTheme: bodyText.copyWith(
        headlineLarge: headlineText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: textPrimary,
        ),
        titleLarge: headlineText.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        titleMedium: headlineText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: bodyText.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: bodyText.bodyMedium?.copyWith(color: textSecondary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: isDark ? surfaceDark : Colors.white,
        selectedItemColor: primary,
        unselectedItemColor: textTertiary,
        elevation: 8,
      ),
    );
  }

  static ThemeData get lightTheme => getTheme(brightness: Brightness.light);
  static ThemeData get darkTheme => getTheme(brightness: Brightness.dark);
}
