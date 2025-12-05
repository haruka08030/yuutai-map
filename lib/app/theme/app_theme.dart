import 'package:flutter/material.dart';

/// Custom colors extension for the app theme
/// This allows us to define custom colors that work with both light and dark themes
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.secondaryText,
    required this.divider,
    required this.placeholder,
    required this.benefitChipBackground,
    required this.editActionBackground,
    required this.deleteActionBackground,
    required this.deleteActionForeground,
    required this.googleButtonBackground,
    required this.googleButtonForeground,
    required this.appleButtonBackground,
    required this.appleButtonForeground,
    required this.drawerHeaderBackground,
    required this.drawerHeaderForeground,
    required this.skeletonBase,
    required this.passwordWeak,
    required this.passwordMedium,
    required this.passwordStrong,
    required this.passwordIndicatorBackground,
  });

  final Color secondaryText;
  final Color divider;
  final Color placeholder;
  final Color benefitChipBackground;
  final Color editActionBackground;
  final Color deleteActionBackground;
  final Color deleteActionForeground;
  final Color googleButtonBackground;
  final Color googleButtonForeground;
  final Color appleButtonBackground;
  final Color appleButtonForeground;
  final Color drawerHeaderBackground;
  final Color drawerHeaderForeground;
  final Color skeletonBase;
  final Color passwordWeak;
  final Color passwordMedium;
  final Color passwordStrong;
  final Color passwordIndicatorBackground;

  @override
  AppColors copyWith({
    Color? secondaryText,
    Color? divider,
    Color? placeholder,
    Color? benefitChipBackground,
    Color? editActionBackground,
    Color? deleteActionBackground,
    Color? deleteActionForeground,
    Color? googleButtonBackground,
    Color? googleButtonForeground,
    Color? appleButtonBackground,
    Color? appleButtonForeground,
    Color? drawerHeaderBackground,
    Color? drawerHeaderForeground,
    Color? skeletonBase,
    Color? passwordWeak,
    Color? passwordMedium,
    Color? passwordStrong,
    Color? passwordIndicatorBackground,
  }) {
    return AppColors(
      secondaryText: secondaryText ?? this.secondaryText,
      divider: divider ?? this.divider,
      placeholder: placeholder ?? this.placeholder,
      benefitChipBackground: benefitChipBackground ?? this.benefitChipBackground,
      editActionBackground: editActionBackground ?? this.editActionBackground,
      deleteActionBackground: deleteActionBackground ?? this.deleteActionBackground,
      deleteActionForeground: deleteActionForeground ?? this.deleteActionForeground,
      googleButtonBackground: googleButtonBackground ?? this.googleButtonBackground,
      googleButtonForeground: googleButtonForeground ?? this.googleButtonForeground,
      appleButtonBackground: appleButtonBackground ?? this.appleButtonBackground,
      appleButtonForeground: appleButtonForeground ?? this.appleButtonForeground,
      drawerHeaderBackground: drawerHeaderBackground ?? this.drawerHeaderBackground,
      drawerHeaderForeground: drawerHeaderForeground ?? this.drawerHeaderForeground,
      skeletonBase: skeletonBase ?? this.skeletonBase,
      passwordWeak: passwordWeak ?? this.passwordWeak,
      passwordMedium: passwordMedium ?? this.passwordMedium,
      passwordStrong: passwordStrong ?? this.passwordStrong,
      passwordIndicatorBackground: passwordIndicatorBackground ?? this.passwordIndicatorBackground,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      benefitChipBackground: Color.lerp(benefitChipBackground, other.benefitChipBackground, t)!,
      editActionBackground: Color.lerp(editActionBackground, other.editActionBackground, t)!,
      deleteActionBackground: Color.lerp(deleteActionBackground, other.deleteActionBackground, t)!,
      deleteActionForeground: Color.lerp(deleteActionForeground, other.deleteActionForeground, t)!,
      googleButtonBackground: Color.lerp(googleButtonBackground, other.googleButtonBackground, t)!,
      googleButtonForeground: Color.lerp(googleButtonForeground, other.googleButtonForeground, t)!,
      appleButtonBackground: Color.lerp(appleButtonBackground, other.appleButtonBackground, t)!,
      appleButtonForeground: Color.lerp(appleButtonForeground, other.appleButtonForeground, t)!,
      drawerHeaderBackground: Color.lerp(drawerHeaderBackground, other.drawerHeaderBackground, t)!,
      drawerHeaderForeground: Color.lerp(drawerHeaderForeground, other.drawerHeaderForeground, t)!,
      skeletonBase: Color.lerp(skeletonBase, other.skeletonBase, t)!,
      passwordWeak: Color.lerp(passwordWeak, other.passwordWeak, t)!,
      passwordMedium: Color.lerp(passwordMedium, other.passwordMedium, t)!,
      passwordStrong: Color.lerp(passwordStrong, other.passwordStrong, t)!,
      passwordIndicatorBackground: Color.lerp(passwordIndicatorBackground, other.passwordIndicatorBackground, t)!,
    );
  }

  /// Light theme colors
  static const light = AppColors(
    secondaryText: Color(0xFFAFAFAF),
    divider: Color(0xFFE0E0E0),
    placeholder: Color(0xFFAFAFAF),
    benefitChipBackground: Color(0x1A7990F8),
    editActionBackground: Color(0xFF2196F3), // Material Blue
    deleteActionBackground: Color(0xFFF44336), // Material Red
    deleteActionForeground: Color(0xFFFFFFFF),
    googleButtonBackground: Color(0xFFFFFFFF),
    googleButtonForeground: Color(0xFF000000),
    appleButtonBackground: Color(0xFF000000),
    appleButtonForeground: Color(0xFFFFFFFF),
    drawerHeaderBackground: Color(0xFF2196F3), // Material Blue
    drawerHeaderForeground: Color(0xFFFFFFFF),
    skeletonBase: Color(0xFFE0E0E0),
    passwordWeak: Color(0xFFF44336), // Red
    passwordMedium: Color(0xFFFF9800), // Orange
    passwordStrong: Color(0xFF4CAF50), // Green
    passwordIndicatorBackground: Color(0xFFE0E0E0),
  );

  /// Dark theme colors
  static const dark = AppColors(
    secondaryText: Color(0xFF8F8F8F),
    divider: Color(0xFF424242),
    placeholder: Color(0xFF8F8F8F),
    benefitChipBackground: Color(0x33BB86FC),
    editActionBackground: Color(0xFF64B5F6), // Lighter blue for dark mode
    deleteActionBackground: Color(0xFFEF5350), // Lighter red for dark mode
    deleteActionForeground: Color(0xFFFFFFFF),
    googleButtonBackground: Color(0xFF1E1E1E),
    googleButtonForeground: Color(0xFFFFFFFF),
    appleButtonBackground: Color(0xFFFFFFFF),
    appleButtonForeground: Color(0xFF000000),
    drawerHeaderBackground: Color(0xFF1976D2), // Darker blue for dark mode
    drawerHeaderForeground: Color(0xFFFFFFFF),
    skeletonBase: Color(0xFF424242),
    passwordWeak: Color(0xFFEF5350), // Lighter red
    passwordMedium: Color(0xFFFFB74D), // Lighter orange
    passwordStrong: Color(0xFF66BB6A), // Lighter green
    passwordIndicatorBackground: Color(0xFF424242),
  );
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2A7DE1),
        surface: Color(0xFFFFFFFF),
        error: Color(0xFFF44336),
      ),
      scaffoldBackgroundColor: const Color(0xFFFFFFFF),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        surfaceTintColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Color(0xDE000000)), // black87
        titleTextStyle: TextStyle(
          color: Color(0xDE000000), // black87
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(dense: false),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.light,
      ],
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF90CAF9),
        surface: Color(0xFF121212),
        error: Color(0xFFEF5350),
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        elevation: 0,
        surfaceTintColor: Color(0xFF1E1E1E),
        iconTheme: IconThemeData(color: Color(0xB3FFFFFF)), // white70
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(dense: false),
      extensions: const <ThemeExtension<dynamic>>[
        AppColors.dark,
      ],
    );
  }

  // Convenience getters for backward compatibility
  static Color secondaryTextColor(BuildContext context) {
    return Theme.of(context).extension<AppColors>()?.secondaryText 
+      ?? AppColors.light.secondaryText;
  }

  static Color benefitChipBackgroundColor(BuildContext context) {
    return Theme.of(context).extension<AppColors>()?.benefitChipBackground 
+      ?? AppColors.light.benefitChipBackground;
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).extension<AppColors>()?  .divider 
+      ?? AppColors.light.divider;
  }

  static Color placeholderColor(BuildContext context) {
    return Theme.of(context).extension<AppColors>()?.placeholder 
+      ?? AppColors.light.placeholder;
  }
}
