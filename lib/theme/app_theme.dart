import 'package:flutter/material.dart';

/// Design tokens inspired by Mobbin Design System (from DESIGN.md)
/// Strict monochrome canvas, 0-shadow elevation, stadium pills, and Saans/Inter typography.
class AppColors {
  // Brand & Ink
  static const Color primary = Color(0xFF141414);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color ink = Color(0xFF141414);
  static const Color inkSoft = Color(0xFF262626);

  // Text
  static const Color textMuted = Color(0xFF707070);
  static const Color textFaint = Color(0xFFADADAD);

  // Surfaces & Backgrounds
  static const Color canvas = Color(0xFFFFFFFF);
  static const Color canvasSoft = Color(0xFFF3F3F3);
  static const Color field = Color(0xFFF0F0F0);
  static const Color appBarGrey = Color(0xFFE5E7EB); // رمادي للأب بار
  static const Color bottomNavGrey = Color(0xFFF6F7F9); // رمادي فاتح للبوتم بار

  // Hairlines & Borders
  static const Color hairlineSoft = Color(0xFFF0F0F0);
  static const Color hairline = Color(0xFFE0E0E0);

  // Commercial Accent (Reserved ONLY for commercial signals like "Popular" or savings badges)
  // NEVER use decoratively or for standard CTAs!
  static const Color accent = Color(0xFF0066FF);
}

class AppRadius {
  static const double none = 0.0;
  static const double sm = 16.0;
  static const double md = 24.0;
  static const double full = 9999.0;

  static const BorderRadius roundedSm = BorderRadius.all(Radius.circular(sm));
  static const BorderRadius roundedMd = BorderRadius.all(Radius.circular(md));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(full));
}

class AppSpacing {
  static const double xxs = 4.0;
  static const double xs = 8.0;
  static const double sm = 12.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double section = 80.0;
  static const double sectionLg = 120.0;
}

class AppTypography {
  // Headline font weights: 650 (chunky/semibold-bold), Body: 450 (regular-medium), Subtitles: 300 (light)
  static const TextStyle display = TextStyle(
    fontSize: 48.0, // Scaled for mobile
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle heading1 = TextStyle(
    fontSize: 36.0,
    fontWeight: FontWeight.w700,
    height: 1.05,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 28.0,
    fontWeight: FontWeight.w700,
    height: 1.13,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle heading4 = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w700,
    height: 1.25,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle title = TextStyle(
    fontSize: 17.0,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle bodyLg = TextStyle(
    fontSize: 18.0,
    fontWeight: FontWeight.w300,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle body = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w400,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle bodySm = TextStyle(
    fontSize: 13.0,
    fontWeight: FontWeight.w400,
    height: 1.43,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );

  static const TextStyle link = TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.w600,
    height: 1.38,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle label = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w600,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    height: 1.33,
    letterSpacing: 0,
    color: AppColors.textMuted,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.canvas,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        surface: AppColors.canvas,
        onSurface: AppColors.ink,
      ),
      fontFamily: 'Inter',
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.heading4,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          textStyle: AppTypography.link.copyWith(color: AppColors.onPrimary),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.canvas,
          foregroundColor: AppColors.ink,
          elevation: 0,
          side: const BorderSide(color: AppColors.hairline, width: 1),
          shape: const StadiumBorder(),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 14),
          textStyle: AppTypography.link,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.field,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.ink, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        hintStyle: AppTypography.bodySm.copyWith(color: AppColors.textFaint),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairlineSoft,
        thickness: 1,
        space: 1,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.canvas,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.roundedMd,
          side: BorderSide(color: AppColors.hairlineSoft, width: 1),
        ),
      ),
    );
  }
}
