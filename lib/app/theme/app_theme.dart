import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF2A7DE1),
        surface: Colors.white,
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
        background: Color(0xFF121212),
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
}
