import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

class AppTheme {
  AppTheme._();

  // ══════════════════════════════════════════════════════════════
  // ── PALE VINTAGE-MODERN PALETTE
  // ══════════════════════════════════════════════════════════════

  // Primary — Soft Blue-Purple
  static const Color primaryColor = Color(0xFF7C8CF8);
  static const Color primaryLight = Color(0xFFB8C1FC);
  static const Color primaryDark = Color(0xFF5A6AE6);

  // Accent — Pastel Green
  static const Color accentColor = Color(0xFF6BCBB4);
  static const Color accentLight = Color(0xFFA8E6CF);
  static const Color accentDark = Color(0xFF4DAF94);

  // Warm — Vintage Orange (For 'İşçi' / Workers)
  static const Color warmColor = Color(0xFFF4A261);
  static const Color warmLight = Color(0xFFF8C98C);
  static const Color warmDark = Color(0xFFE68A3E);

  // Status Colors
  static const Color successColor = Color(0xFF81C995);
  static const Color warningColor = Color(0xFFF7D070);
  static const Color errorColor = Color(0xFFF28B82);
  static const Color infoColor = Color(0xFF8AB4F8);

  // Surface Colors
  static const Color surfaceLight = Color(0xFFFAF8F5);
  static const Color surfaceDark = Color(0xFF1A1D23);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF22262E);

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textSecondaryLight = Color(0xFF9A9BB0);
  static const Color textTertiaryLight = Color(0xFFC4C5D4);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFF8E909F);
  static const Color textTertiaryDark = Color(0xFF5A5C6A);

  // Spacing & Radius
  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 100;

  // ── Gradients ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C8CF8), Color(0xFFB8C1FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF4A261), Color(0xFFF28B82)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF7C8CF8), Color(0xFF6BCBB4)], // Blue to Green
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pastelGradient = LinearGradient(
    colors: [Color(0xFFB8C1FC), Color(0xFFA8E6CF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color purpleAccent = Color(0xFF9D84B7);

  // ── Decorations ──

  static BoxDecoration softCardDecoration({required bool isDark}) {
    return BoxDecoration(
      color: isDark ? const Color(0xFF22262E) : Colors.white,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFEEEDF5),
      ),
      boxShadow: [
        BoxShadow(
          color: const Color(
            0xFF7C8CF8,
          ).withValues(alpha: isDark ? 0.05 : 0.08),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }

  static BoxDecoration glassDecoration({
    required bool isDark,
    BorderRadiusGeometry? borderRadius,
  }) {
    return BoxDecoration(
      color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.7),
      borderRadius: borderRadius ?? BorderRadius.circular(radiusLg),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
      ),
    );
  }

  // ── Helpers ──

  static Color getPrimaryColor(EmploymentType? type) {
    if (type == EmploymentType.isci) {
      return warmColor;
    }
    return primaryColor; // Default for memur, sozlesmeli, null
  }

  // ── Dynamic Theme Builder ──

  static ThemeData getTheme({
    required Brightness brightness,
    EmploymentType? type,
  }) {
    final bool isDark = brightness == Brightness.dark;
    final primary = getPrimaryColor(type);

    final baseTextTheme =
        isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme;

    final bodyText = GoogleFonts.interTextTheme(baseTextTheme);
    final headlineText = GoogleFonts.outfitTextTheme(baseTextTheme);

    final textPrimary = isDark ? textPrimaryDark : textPrimaryLight;
    final textSecondary = isDark ? textSecondaryDark : textSecondaryLight;
    final textTertiary = isDark ? textTertiaryDark : textTertiaryLight;

    final surface = isDark ? surfaceDark : surfaceLight;
    final cardColor = isDark ? cardDark : cardLight;
    final borderColor =
        isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFEEEDF5);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: brightness,
        primary: primary,
        secondary: accentColor,
        tertiary: warmColor,
        surface: surface,
        error: errorColor,
        // Override surface to exact color if seed changes it too much
        // surface: surface,
      ),
      scaffoldBackgroundColor: surface,
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: borderColor),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: textPrimary,
        elevation: 0,
        centerTitle: false,
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
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: primary, width: 1.5),
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
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: headlineText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: bodyText.bodyLarge?.copyWith(color: textPrimary),
        bodyMedium: bodyText.bodyMedium?.copyWith(color: textSecondary),
      ),
      // Add more themes as needed from original file if I missed any critical ones
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }

  // Keep static getters for backward compatibility or default usage
  static ThemeData get lightTheme => getTheme(brightness: Brightness.light);
  static ThemeData get darkTheme => getTheme(brightness: Brightness.dark);
}
