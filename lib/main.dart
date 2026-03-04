import 'package:flutter/material.dart';
import 'package:mood_tracker/screens/settings_screen.dart';
import 'package:mood_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'screens/feelings_list.dart';
import 'screens/feeling_screen.dart';
import 'data/hive_service.dart';
import 'screens/ai_companion_screen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: "assets/.env");
  } catch (e) {
    print("Ошибка загрузки .env файла: $e");
  }

  await HiveService.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {

        final colorScheme = ColorScheme.fromSeed(
          seedColor: themeProvider.currentColorTheme.seedColor,
          brightness: themeProvider.currentBrightness,
        );

        final darkColorScheme = ColorScheme.fromSeed(
          seedColor: themeProvider.currentColorTheme.seedColor,
          brightness: Brightness.dark,
        );

        return MaterialApp(
          title: 'Эмоции',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: colorScheme,
          ),
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: darkColorScheme,
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          initialRoute: '/',
          routes: {
            '/': (context) => HomeScreen(),
            '/feelingsList': (context) => FeelingsList(),
            '/feelingScreen': (context) => FeelingScreen(),
            '/aiCompanionScreen': (context) => AiCompanionScreen(),
            '/settingsScreen': (context) => SettingsScreen(),
            '/editScreen' : (context) => EditScreen(),
          },
        );
      },
    );
  }
}