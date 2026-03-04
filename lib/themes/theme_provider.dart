import 'package:flutter/material.dart';
import 'package:mood_tracker/themes/theme_colors.dart';
import 'package:mood_tracker/data/hive_service.dart';

class ThemeProvider extends ChangeNotifier {
  late AppColors _currentColorTheme;
  late Brightness _currentBrightness;

  ThemeProvider() {
    _loadSavedTheme();
  }

  void _loadSavedTheme() {
    final settings = HiveService.loadThemeSettings();

    final safeIndex = settings.colorThemeIndex < availableThemes.length
        ? settings.colorThemeIndex
        : 0;

    _currentColorTheme = availableThemes[safeIndex];
    _currentBrightness = settings.isDarkMode
        ? Brightness.dark
        : Brightness.light;
  }

  AppColors get currentColorTheme => _currentColorTheme;

  Brightness get currentBrightness => _currentBrightness;

  AppColors get currentTheme {
    if (_currentBrightness == Brightness.dark) {
      return _currentColorTheme.darkVersion();
    }
    return _currentColorTheme;
  }

  Future<void> setColorTheme(AppColors theme) async {
    _currentColorTheme = theme;

    final index = availableThemes.indexWhere(
      (t) => t.seedColor == theme.seedColor,
    );
    if (index != -1) {
      await HiveService.saveColorThemeIndex(index);
    }

    notifyListeners();
  }

  Future<void> toggleBrightness() async {
    _currentBrightness = _currentBrightness == Brightness.light
        ? Brightness.dark
        : Brightness.light;

    await HiveService.saveDarkMode(_currentBrightness == Brightness.dark);

    notifyListeners();
  }

  bool get isDarkMode => _currentBrightness == Brightness.dark;
}
