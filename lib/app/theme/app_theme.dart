import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2A7DE1)),
        useMaterial3: true,
        listTileTheme: const ListTileThemeData(dense: false),
      );
}
