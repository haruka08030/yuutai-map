import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _themeModeKey = 'themeMode';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier(this._prefs) : super(ThemeMode.system) {
    _loadThemeMode();
  }

  final SharedPreferences _prefs;

  void _loadThemeMode() {
    final storedThemeMode = _prefs.getString(_themeModeKey);
    if (storedThemeMode == null) {
      state = ThemeMode.system;
      return;
    }
    state = ThemeMode.values.firstWhere(
      (e) => e.toString() == 'ThemeMode.$storedThemeMode',
      orElse: () => ThemeMode.system,
    );
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = themeMode;
    await _prefs.setString(_themeModeKey, themeMode.name);
  }
}

final sharedPreferencesProvider = Provider<SharedPreferences>((_) {
  throw UnimplementedError(); // Will be overridden in main.dart
});

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeNotifier(prefs);
});
