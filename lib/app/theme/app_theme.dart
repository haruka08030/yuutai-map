import 'package:flutter/material.dart';
import 'package:flutter_stock/app/theme/tokens.dart';

class AppTheme {
  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppTokens.seed),
  );

  static final dark = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppTokens.seed,
      brightness: Brightness.dark,
    ),
  );
}
