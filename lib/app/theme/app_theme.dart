import 'package:flutter/material.dart';

class AppTheme {
  // Common color values that might be used across themes
  static const Color _lightGreyText = Color(0xffafafaf); // for secondary text
  static const Color _lightDivider = Color(0xFFE0E0E0); // for dividers
  static const Color _mediumGreyPlaceholder = Color(0xFFAFAFAF); // for placeholders/icons
  static const Color _translucentPurpleBlue = Color(0x1a7990f8); // for benefit chip background (light)

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2A7DE1),
        surface: Colors.white,
        // Add custom colors to ColorScheme if they are part of the system
        // Or access them via AppTheme static getters
      ),
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(
          color: Colors.black87,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(dense: false),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF90CAF9), // Lighter blue for dark theme
        surface: Color(0xFF121212), // Darker surface
      ),
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E), // Darker AppBar
        elevation: 0,
        surfaceTintColor: Color(0xFF1E1E1E),
        iconTheme: IconThemeData(color: Colors.white70), // Lighter icons
        titleTextStyle: TextStyle(
          color: Colors.white, // Lighter text
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: const ListTileThemeData(dense: false),
    );
  }

  // Define static getters for easy access to theme-dependent colors
  static Color secondaryTextColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightGreyText
        : const Color(0xFF8F8F8F); // Dark mode equivalent
  }

  static Color benefitChipBackgroundColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _translucentPurpleBlue
        : const Color(0x33BB86FC); // Dark mode equivalent for a translucent accent
  }

  static Color dividerColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _lightDivider
        : const Color(0xFF424242); // Dark mode equivalent
  }

  static Color placeholderColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? _mediumGreyPlaceholder
        : const Color(0xFF8F8F8F); // Dark mode equivalent
  }
}
