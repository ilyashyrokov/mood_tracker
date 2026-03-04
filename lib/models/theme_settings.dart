// lib/models/theme_settings.dart
import 'package:hive/hive.dart';

part 'theme_settings.g.dart';

@HiveType(typeId: 2)
class ThemeSettings {
  @HiveField(0)
  final int colorThemeIndex;

  @HiveField(1)
  final bool isDarkMode;

  ThemeSettings({
    required this.colorThemeIndex,
    required this.isDarkMode,
  });


  factory ThemeSettings.default_() {
    return ThemeSettings(
      colorThemeIndex: 0,
      isDarkMode: false,
    );
  }
}