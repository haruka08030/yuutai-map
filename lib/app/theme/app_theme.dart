import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:flutter_stock/app/theme/app_colors.dart';

export 'app_colors.dart';

TextTheme _refinedTextTheme(TextTheme base) {
  return base.copyWith(
    headlineLarge: base.headlineLarge?.copyWith(
      letterSpacing: -0.25,
      height: 1.2,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      letterSpacing: -0.25,
      height: 1.25,
    ),
    titleLarge: base.titleLarge?.copyWith(
      letterSpacing: -0.2,
      height: 1.3,
    ),
    titleMedium: base.titleMedium?.copyWith(
      letterSpacing: -0.15,
      height: 1.35,
    ),
    bodyLarge: base.bodyLarge?.copyWith(height: 1.45),
    bodyMedium: base.bodyMedium?.copyWith(height: 1.45),
    bodySmall: base.bodySmall?.copyWith(height: 1.4),
    labelLarge: base.labelLarge?.copyWith(letterSpacing: 0.1),
    labelMedium: base.labelMedium?.copyWith(letterSpacing: 0.15),
  );
}

class AppTheme {
  /// カード・シート・ボタン（大）などで使用
  static const double borderRadius = 16.0;

  /// ボタン・入力欄・チップなどで使用
  static const double radiusSmall = 12.0;

  /// セカンダリカラー（編集・リンクなど）。プライマリと同系の Teal 600 でトーン統一
  static const Color _lightSecondary = Color(0xFF0D9488);

  /// 廃止: UI では使用しない。ColorScheme の必須項目のため primary と同じにしている
  static const Color _lightTertiary = Color(0xFF24A19C);

  /// セカンダリカラー（Dark）
  static const Color _darkSecondary = Color(0xFF2DD4BF);

  /// 廃止: UI では使用しない。primary と同じにしている
  static const Color _darkTertiary = Color(0xFF24A19C);

  static ThemeData get light {
    final base = ThemeData.light(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF24A19C), // Greenish-blue
        primary: const Color(0xFF24A19C),
        secondary: _lightSecondary,
        tertiary: _lightTertiary,
        surface: const Color(0xFFFFFFFF),
        error: const Color(0xFFEF4444),
      ),
      scaffoldBackgroundColor: const Color(0xFFF9FAFB), // Gray 50
      // iOS: San Francisco / Android: Outfit。共通で letterSpacing・行間を整え信頼感・可読性を向上
      textTheme: _refinedTextTheme(
        Platform.isIOS
            ? base.textTheme
            : GoogleFonts.outfitTextTheme(base.textTheme),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF111827)),
        titleTextStyle: Platform.isIOS
            ? base.appBarTheme.titleTextStyle?.copyWith(
                  color: const Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )
            : GoogleFonts.outfit(
                color: const Color(0xFF111827),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0.5,
        shadowColor: Color(0x0A000000),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          side: BorderSide(color: Color(0xFFE5E7EB), width: 1),
        ),
        color: Color(0xFFFFFFFF),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF24A19C), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF6B7280)),
      ),
      extensions: [AppColors.light],
    );
  }

  static ThemeData get dark {
    final base = ThemeData.dark(useMaterial3: true);
    return base.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF24A19C), // Greenish-blue
        brightness: Brightness.dark,
        primary: const Color(0xFF24A19C),
        secondary: _darkSecondary,
        tertiary: _darkTertiary,
        surface: const Color(0xFF111827), // Gray 900
        error: const Color(0xFFF87171),
      ),
      scaffoldBackgroundColor: const Color(0xFF030712), // Gray 950
      textTheme: _refinedTextTheme(
        Platform.isIOS
            ? base.textTheme
            : GoogleFonts.outfitTextTheme(base.textTheme),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: base.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFFF9FAFB)),
        titleTextStyle: Platform.isIOS
            ? base.appBarTheme.titleTextStyle?.copyWith(
                  color: const Color(0xFFF9FAFB),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ) ??
                const TextStyle(
                  color: Color(0xFFF9FAFB),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                )
            : GoogleFonts.outfit(
                color: const Color(0xFFF9FAFB),
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        shadowColor: Color(0x1AFFFFFF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
          side: BorderSide(color: Color(0xFF374151), width: 1),
        ),
        color: Color(0xFF1F2937),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusSmall),
          ),
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1F2937),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF374151)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusSmall),
          borderSide: const BorderSide(color: Color(0xFF24A19C), width: 2),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9CA3AF)),
      ),
      extensions: [AppColors.dark],
    );
  }

  // Convenience getters
  static Color secondaryTextColor(BuildContext context) =>
      Theme.of(context).extension<AppColors>()?.secondaryText ??
      AppColors.light.secondaryText;
  static Color secondaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.secondary;

  /// 廃止: tertiary の代わりに primary を返す（UI では tertiary を使用しない）
  static Color tertiaryColor(BuildContext context) =>
      Theme.of(context).colorScheme.primary;
  static Color benefitChipBackgroundColor(BuildContext context) =>
      Theme.of(context).extension<AppColors>()?.benefitChipBackground ??
      AppColors.light.benefitChipBackground;
  static Color dividerColor(BuildContext context) =>
      Theme.of(context).extension<AppColors>()?.divider ??
      AppColors.light.divider;
  static Color placeholderColor(BuildContext context) =>
      Theme.of(context).extension<AppColors>()?.placeholder ??
      AppColors.light.placeholder;
  static Color chipForegroundColor(BuildContext context) =>
      Theme.of(context).extension<AppColors>()?.chipForeground ??
      AppColors.light.chipForeground;
}
