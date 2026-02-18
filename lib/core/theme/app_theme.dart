import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ══════════════════════════════════════════════════════════════
  // ── PASTEL VINTAGE-MODERN RENK PALETİ
  // ══════════════════════════════════════════════════════════════

  // Primary — Soft Mavi-Mor
  static const Color primaryColor = Color(0xFF7C8CF8);
  static const Color primaryLight = Color(0xFFB8C1FC);
  static const Color primaryDark = Color(0xFF5A6AE6);

  // Accent — Pastel Yeşil
  static const Color accentColor = Color(0xFF6BCBB4);
  static const Color accentLight = Color(0xFFA8E6CF);
  static const Color accentDark = Color(0xFF4DAF94);

  // Warm — Vintage Turuncu
  static const Color warmColor = Color(0xFFF4A261);
  static const Color warmLight = Color(0xFFF8C98C);
  static const Color warmDark = Color(0xFFE68A3E);

  // Purple — Soft Mor Accent
  static const Color purpleAccent = Color(0xFFB39DDB);
  static const Color purpleLight = Color(0xFFD1C4E9);
  static const Color purpleDark = Color(0xFF9575CD);

  // Status Colors — Pastel Tones
  static const Color successColor = Color(0xFF81C995);
  static const Color warningColor = Color(0xFFF7D070);
  static const Color errorColor = Color(0xFFF28B82);
  static const Color infoColor = Color(0xFF8AB4F8);

  // ── Surface Colors ──
  static const Color surfaceLight = Color(0xFFFAF8F5); // Warm cream
  static const Color surfaceDark = Color(0xFF1A1D23); // Deep anthracite
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF22262E);
  static const Color surfaceWarmLight = Color(0xFFFFF5EB); // Warm beige
  static const Color surfaceWarmDark = Color(0xFF2A2520);
  static const Color surfaceCoolLight = Color(0xFFF0F3FF); // Cool blue tint
  static const Color surfaceCoolDark = Color(0xFF1D2030);

  // ── Text Colors ──
  static const Color textPrimaryLight = Color(0xFF2D3142); // Soft dark blue
  static const Color textSecondaryLight = Color(
    0xFF9A9BB0,
  ); // Muted purple-gray
  static const Color textTertiaryLight = Color(0xFFC4C5D4);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFF8E909F);
  static const Color textTertiaryDark = Color(0xFF5A5C6A);

  // ══════════════════════════════════════════════════════════════
  // ── GRADIENTLER — Soft geçişler
  // ══════════════════════════════════════════════════════════════

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF7C8CF8), Color(0xFFB8C1FC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF7C8CF8), Color(0xFF6BCBB4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF4A261), Color(0xFFF28B82)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pastelGradient = LinearGradient(
    colors: [Color(0xFFB8C1FC), Color(0xFFA8E6CF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient purpleGradient = LinearGradient(
    colors: [Color(0xFFB39DDB), Color(0xFF7C8CF8)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient oceanGradient = LinearGradient(
    colors: [Color(0xFF8AB4F8), Color(0xFF6BCBB4)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient subtleGradient = LinearGradient(
    colors: [Color(0xFFFAF8F5), Color(0xFFF0F3FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkAiGradient = LinearGradient(
    colors: [Color(0xFF5A6AE6), Color(0xFF4DAF94)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ══════════════════════════════════════════════════════════════
  // ── SPACİNG SİSTEMİ
  // ══════════════════════════════════════════════════════════════

  static const double spacingXs = 4;
  static const double spacingSm = 8;
  static const double spacingMd = 16;
  static const double spacingLg = 24;
  static const double spacingXl = 32;
  static const double spacingXxl = 48;

  // ── Border Radius ──
  static const double radiusSm = 8;
  static const double radiusMd = 14;
  static const double radiusLg = 20;
  static const double radiusXl = 28;
  static const double radiusFull = 100;

  // ══════════════════════════════════════════════════════════════
  // ── GLASSMORPHISM HELPERS
  // ══════════════════════════════════════════════════════════════

  /// Glassmorphism decoration with blur effect
  static BoxDecoration glassDecoration({
    required bool isDark,
    double borderRadius = radiusLg,
    double opacity = 0.75,
  }) {
    return BoxDecoration(
      color:
          isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.white.withValues(alpha: opacity),
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.08)
                : Colors.white.withValues(alpha: 0.6),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Soft shadow card decoration
  static BoxDecoration softCardDecoration({
    required bool isDark,
    double borderRadius = radiusLg,
  }) {
    return BoxDecoration(
      color: isDark ? cardDark : cardLight,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFEEEDF5),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.12 : 0.03),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        if (!isDark)
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.03),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── LIGHT THEME
  // ══════════════════════════════════════════════════════════════

  static ThemeData get lightTheme {
    final bodyText = GoogleFonts.interTextTheme(ThemeData.light().textTheme);
    final headlineText = GoogleFonts.outfitTextTheme(
      ThemeData.light().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        primary: primaryColor,
        secondary: accentColor,
        tertiary: warmColor,
        surface: surfaceLight,
        error: errorColor,
      ),
      scaffoldBackgroundColor: surfaceLight,
      textTheme: bodyText.copyWith(
        headlineLarge: headlineText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
          letterSpacing: -0.5,
        ),
        headlineMedium: headlineText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
          letterSpacing: -0.3,
        ),
        headlineSmall: headlineText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimaryLight,
        ),
        titleLarge: headlineText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleMedium: headlineText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        titleSmall: bodyText.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        bodyLarge: bodyText.bodyLarge?.copyWith(color: textPrimaryLight),
        bodyMedium: bodyText.bodyMedium?.copyWith(color: textSecondaryLight),
        bodySmall: bodyText.bodySmall?.copyWith(color: textSecondaryLight),
        labelLarge: bodyText.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryLight,
        ),
        labelMedium: bodyText.labelMedium?.copyWith(color: textSecondaryLight),
        labelSmall: bodyText.labelSmall?.copyWith(color: textTertiaryLight),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: surfaceLight,
        foregroundColor: textPrimaryLight,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimaryLight,
          letterSpacing: -0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        color: cardLight,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: const BorderSide(color: Color(0xFFEEEDF5)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          side: BorderSide(
            color: primaryColor.withValues(alpha: 0.25),
            width: 1.5,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFEEEDF5)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: Color(0xFFEEEDF5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.inter(color: textTertiaryLight, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondaryLight, fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFF0EFF5),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withValues(alpha: 0.06),
        selectedColor: primaryColor.withValues(alpha: 0.12),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primaryColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: BorderSide.none,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  // ── DARK THEME
  // ══════════════════════════════════════════════════════════════

  static ThemeData get darkTheme {
    final bodyText = GoogleFonts.interTextTheme(ThemeData.dark().textTheme);
    final headlineText = GoogleFonts.outfitTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
        primary: primaryLight,
        secondary: accentLight,
        tertiary: warmLight,
        surface: surfaceDark,
        error: errorColor,
      ),
      scaffoldBackgroundColor: surfaceDark,
      textTheme: bodyText.copyWith(
        headlineLarge: headlineText.headlineLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
          letterSpacing: -0.5,
        ),
        headlineMedium: headlineText.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
          letterSpacing: -0.3,
        ),
        headlineSmall: headlineText.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: textPrimaryDark,
        ),
        titleLarge: headlineText.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        titleMedium: headlineText.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        titleSmall: bodyText.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        bodyLarge: bodyText.bodyLarge?.copyWith(color: textPrimaryDark),
        bodyMedium: bodyText.bodyMedium?.copyWith(color: textSecondaryDark),
        bodySmall: bodyText.bodySmall?.copyWith(color: textSecondaryDark),
        labelLarge: bodyText.labelLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: textPrimaryDark,
        ),
        labelMedium: bodyText.labelMedium?.copyWith(color: textSecondaryDark),
        labelSmall: bodyText.labelSmall?.copyWith(color: textTertiaryDark),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: surfaceDark,
        foregroundColor: textPrimaryDark,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: GoogleFonts.outfit(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: textPrimaryDark,
          letterSpacing: -0.5,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: 64,
        backgroundColor: cardDark,
        surfaceTintColor: Colors.transparent,
        indicatorColor: Colors.transparent,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
      cardTheme: CardThemeData(
        color: cardDark,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryLight,
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryLight,
          padding: const EdgeInsets.symmetric(
            horizontal: spacingLg,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMd),
          ),
          side: BorderSide(
            color: primaryLight.withValues(alpha: 0.25),
            width: 1.5,
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: cardDark,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMd),
          borderSide: const BorderSide(color: primaryLight, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: spacingMd,
          vertical: 14,
        ),
        hintStyle: GoogleFonts.inter(color: textTertiaryDark, fontSize: 14),
        labelStyle: GoogleFonts.inter(color: textSecondaryDark, fontSize: 14),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryLight,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.05),
        thickness: 1,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryLight.withValues(alpha: 0.08),
        selectedColor: primaryLight.withValues(alpha: 0.2),
        labelStyle: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: primaryLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusFull),
        ),
        side: BorderSide.none,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMd),
        ),
      ),
    );
  }
}
