import 'package:flutter/material.dart';

class AppColors {
  final Color seedColor;
  final Color? primary;
  final Color? secondary;
  final Color? background;
  final Color? surface;
  final Color? error;
  final Brightness brightness;

  final Color? textPrimary;
  final Color? textSecondary;
  final Color? textOnPrimary;

  final Color? disabled;
  final Color? divider;

  const AppColors({
    required this.seedColor,
    this.primary,
    this.secondary,
    this.background,
    this.surface,
    this.error,
    this.textPrimary,
    this.textSecondary,
    this.textOnPrimary,
    this.disabled,
    this.divider,
    this.brightness = Brightness.light,
  });

  AppColors darkVersion() {
    return AppColors(seedColor: seedColor, brightness: Brightness.dark);
  }
}

const AppColors greenTheme = AppColors(seedColor: Colors.green);
const AppColors blueTheme = AppColors(seedColor: Colors.blue);
const AppColors redTheme = AppColors(seedColor: Colors.red);
const AppColors yellowTheme = AppColors(seedColor: Colors.yellow);
const AppColors pinkTheme = AppColors(seedColor: Colors.pink);
const AppColors purpleTheme = AppColors(seedColor: Colors.deepPurple);
const AppColors orangeTheme = AppColors(seedColor: Colors.orangeAccent);
const AppColors tealTheme = AppColors(seedColor: Colors.teal);

final List<AppColors> availableThemes = [
  greenTheme,
  blueTheme,
  redTheme,
  yellowTheme,
  pinkTheme,
  purpleTheme,
  orangeTheme,
  tealTheme,
];
