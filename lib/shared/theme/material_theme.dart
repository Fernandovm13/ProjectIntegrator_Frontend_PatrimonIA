import 'package:flutter/material.dart';
import 'app_colors.dart';

class MaterialTheme {
  final TextTheme textTheme;

  MaterialTheme(this.textTheme);

  ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.sacredJade,
        onPrimary: Colors.white,
        secondary: AppColors.maizeGold,
        onSecondary: Colors.white,
        surface: AppColors.amateParchment,
        onSurface: AppColors.textOnLightTitle,
        error: Color(0xFFBA1A1A),
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.amateParchment,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.amateParchment,
        foregroundColor: AppColors.textOnLightTitle,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navBackground,
        indicatorColor: AppColors.navActive.withValues(alpha: 0.2),
      ),
    );
  }

  ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.sacredJade,
        onPrimary: Colors.white,
        secondary: AppColors.maizeGold,
        onSecondary: Colors.white,
        surface: AppColors.copalBrown,
        onSurface: AppColors.textOnDarkTitle,
        error: Color(0xFFFFB4AB),
      ),
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.obsidianNight,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.obsidianNight,
        foregroundColor: AppColors.textOnDarkTitle,
        elevation: 0,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.copalBrown,
        surfaceTintColor: AppColors.copalBrown,
        elevation: 0,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.navBackground,
        indicatorColor: AppColors.navActive.withValues(alpha: 0.2),
      ),
    );
  }
}
