import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'themeMode';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final storedThemeMode = prefs.getString(_themeModeKey);
    if (storedThemeMode == null) {
      return ThemeMode.system;
    }
    return ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$storedThemeMode',
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    final prefs = ref.read(sharedPreferencesProvider);
    state = themeMode;
    await prefs.setString(_themeModeKey, themeMode.name);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError(); // Will be overridden in main.dart
});

final themeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(
  ThemeNotifier.new,
);
