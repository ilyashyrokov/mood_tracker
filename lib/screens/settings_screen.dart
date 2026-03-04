import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../themes/theme_colors.dart';
import '../themes/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Оформление',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: themeProvider.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.amber[100],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                themeProvider.isDarkMode
                                    ? Icons.nightlight_round
                                    : Icons.wb_sunny,
                                color: themeProvider.isDarkMode
                                    ? Colors.amber[200]
                                    : Colors.amber[800],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Темная тема',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  themeProvider.isDarkMode ? 'Включена' : 'Выключена',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Switch(
                          value: themeProvider.isDarkMode,
                          onChanged: (_) => themeProvider.toggleBrightness(),
                          activeThumbColor: Theme.of(context).colorScheme.primary,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            const Text(
              'Цвет акцента',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Сетка цветов
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: availableThemes.length,
              itemBuilder: (context, index) {
                final theme = availableThemes[index];
                return Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    final isSelected = themeProvider.currentColorTheme.seedColor == theme.seedColor;

                    return GestureDetector(
                      onTap: () => themeProvider.setColorTheme(theme),
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.seedColor,
                          shape: BoxShape.circle,
                          border: isSelected
                              ? Border.all(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            width: 3,
                          )
                              : null,
                          boxShadow: isSelected
                              ? [
                            BoxShadow(
                              color: theme.seedColor.withOpacity(0.5),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                              : null,
                        ),
                        child: isSelected
                            ? Center(
                          child: Icon(
                            Icons.check,
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            size: 24,
                          ),
                        )
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}