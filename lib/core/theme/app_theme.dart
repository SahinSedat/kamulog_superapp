import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kamulog_superapp/core/constants/enums.dart';

// ══════════════════════════════════════════════════════════════
// ── ThemeExtension — Kamulog'a özel ekstra tema verileri
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
// ── AppTheme — Spec 02'ye Uygun Renk Paleti
// ══════════════════════════════════════════════════════════════

class AppTheme {
  AppTheme._();

  // ── Memur Modu (Official Blue) — Spec 02
  static const Color memurPrimary = Color(0xFF5D8AA8); // Air Force Blue
  static const Color memurSecondary = Color(0xFFB0C4DE); // Light Steel Blue
  static const Color memurAccent = Color(0xFFFFFFFF); // White Cards

  // ── İşçi Modu (Warm Earth) — Spec 02
  static const Color isciPrimary = Color(0xFFC19A6B); // Desert Sand
  static const Color isciSecondary = Color(0xFFE6CCB2); // Almond
  static const Color isciAccent = Color(0xFF1F2933); // Dark Text

  // ── Genel Renkler — Spec 02
  static const Color background = Color(0xFFF4F6F8); // Göz yormayan gri-beyaz
  static const Color surfaceDark = Color(0xFF1A1D23);
  static const Color cardLight = Color(0xFFFFFFFF);
  static const Color cardDark = Color(0xFF22262E);
  static const Color successColor = Color(0xFF27AE60); // Spec 02
  static const Color errorColor = Color(0xFFEB5757); // Spec 02
  static const Color warningColor = Color(0xFFF7D070);
  static const Color infoColor = Color(0xFF5D8AA8);

  // ── Text Colors
  static const Color textPrimaryLight = Color(0xFF2D3142);
  static const Color textSecondaryLight = Color(0xFF9A9BB0);
  static const Color textTertiaryLight = Color(0xFFC4C5D4);
  static const Color textPrimaryDark = Color(0xFFF2F2F7);
  static const Color textSecondaryDark = Color(0xFF8E909F);
  static const Color textTertiaryDark = Color(0xFF5A5C6A);

  // ── Spacing & Radius
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

  // ── Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5D8AA8), Color(0xFFB0C4DE)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFC19A6B), Color(0xFFE6CCB2)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient aiGradient = LinearGradient(
    colors: [Color(0xFF5D8AA8), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient pastelGradient = LinearGradient(
    colors: [Color(0xFFB0C4DE), Color(0xFFA8E6CF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const Color purpleAccent = Color(0xFF9D84B7);

  // ── Backward-compatible aliases (eski widget'lar için)
  static const Color primaryColor = memurPrimary;
  static const Color primaryLight = memurSecondary;
  static const Color primaryDark = Color(0xFF4A7494);
  static const Color accentColor = Color(0xFF6BCBB4);
  static const Color accentLight = Color(0xFFA8E6CF);
  static const Color accentDark = Color(0xFF4DAF94);
  static const Color warmColor = isciPrimary;
  static const Color warmLight = isciSecondary;
  static const Color surfaceLight = background;

  // ── Decorations

  static BoxDecoration softCardDecoration({required bool isDark}) {
    return BoxDecoration(
      color: isDark ? cardDark : cardLight,
      borderRadius: BorderRadius.circular(radiusLg),
      border: Border.all(
        color:
            isDark
                ? Colors.white.withValues(alpha: 0.05)
                : const Color(0xFFE8EBF0),
      ),
      boxShadow: [
        BoxShadow(
          color: memurPrimary.withValues(alpha: isDark ? 0.05 : 0.08),
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
      color: (isDark ? Colors.black : Colors.white).withValues(
        alpha: isDark ? 0.6 : 0.8,
      ),
      borderRadius: borderRadius ?? BorderRadius.circular(radiusLg),
      border: Border.all(
        color: (isDark ? Colors.white : Colors.black).withValues(alpha: 0.05),
      ),
    );
  }

  // ── Helpers

  static Color getPrimaryColor(EmploymentType? type) {
    if (type == EmploymentType.isci) return isciPrimary;
    return memurPrimary; // Default: memur, sozlesmeli, null
  }

  static Color getSecondaryColor(EmploymentType? type) {
    if (type == EmploymentType.isci) return isciSecondary;
    return memurSecondary;
  }

  // ── Dynamic Theme Builder — Spec 02'ye uygun

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
        isDark ? Colors.white.withValues(alpha: 0.08) : const Color(0xFFE8EBF0);

    // ThemeExtension data
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
        tertiary: isWorker ? isciAccent : memurAccent,
        surface: surface,
        error: errorColor,
      ),
      scaffoldBackgroundColor: surface,
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
          side: BorderSide(color: border),
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
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLg),
        ),
      ),
    );
  }

  // Backward compatibility
  static ThemeData get lightTheme => getTheme(brightness: Brightness.light);
  static ThemeData get darkTheme => getTheme(brightness: Brightness.dark);
}
