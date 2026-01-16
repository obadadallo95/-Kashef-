import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/logger_service.dart';

/// Provider for the Theme Controller
final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(ThemeController.new);

class ThemeController extends Notifier<ThemeMode> {
  static const String _themeKey = 'theme_mode';

  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.system;
  }

  Future<void> _loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themeKey);
      
      if (savedTheme != null) {
        if (savedTheme == ThemeMode.light.toString()) {
          state = ThemeMode.light;
        } else if (savedTheme == ThemeMode.dark.toString()) {
          state = ThemeMode.dark;
        } else {
          state = ThemeMode.system;
        }
      }
    } catch (e, stack) {
      ref.read(loggerProvider).error('Failed to load theme preference', e, stack);
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themeKey, mode.toString());
      ref.read(loggerProvider).info('Theme changed to: $mode');
    } catch (e, stack) {
      ref.read(loggerProvider).error('Failed to save theme preference', e, stack);
    }
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}
