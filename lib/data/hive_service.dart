import 'package:hive_flutter/hive_flutter.dart';
import 'package:mood_tracker/models/feeling_data.dart';
import 'package:mood_tracker/models/emotions_adapter.dart';
import 'package:mood_tracker/models/theme_settings.dart';

class HiveService {
  static const String _feelingsBoxName = 'feelings';
  static const String _settingsBoxName = 'app_settings';

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(EmotionsAdapter());
    Hive.registerAdapter(FeelingDataAdapter());
    Hive.registerAdapter(ThemeSettingsAdapter());

    await Hive.openBox<FeelingData>(_feelingsBoxName);
    await Hive.openBox(_settingsBoxName);
  }

  static Box<FeelingData> get feelingsBox => Hive.box<FeelingData>(_feelingsBoxName);

  static Box get settingsBox => Hive.box(_settingsBoxName);


  static const String _themeSettingsKey = 'theme_settings';

  static Future<void> saveThemeSettings(ThemeSettings settings) async {
    await settingsBox.put(_themeSettingsKey, settings);
  }

  static ThemeSettings loadThemeSettings() {
    final settings = settingsBox.get(_themeSettingsKey);
    if (settings != null) {
      return settings as ThemeSettings;
    }
    return ThemeSettings.default_();
  }


  static Future<void> saveColorThemeIndex(int index) async {
    final currentSettings = loadThemeSettings();
    final newSettings = ThemeSettings(
      colorThemeIndex: index,
      isDarkMode: currentSettings.isDarkMode,
    );
    await saveThemeSettings(newSettings);
  }

  static Future<void> saveDarkMode(bool isDark) async {
    final currentSettings = loadThemeSettings();
    final newSettings = ThemeSettings(
      colorThemeIndex: currentSettings.colorThemeIndex,
      isDarkMode: isDark,
    );
    await saveThemeSettings(newSettings);
  }

  static int getCurrentColorThemeIndex() {
    return loadThemeSettings().colorThemeIndex;
  }

  static bool getCurrentDarkMode() {
    return loadThemeSettings().isDarkMode;
  }
}