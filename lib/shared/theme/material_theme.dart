import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ── Palette base ──
  static const Color obsidianNight = Color(0xFF1A1A0D);
  static const Color copalBrown = Color(0xFF3D1F0A);
  static const Color amateParchment = Color(0xFFF5F0DC);
  static const Color midBrown = Color(0xFF8B6A4A);
  static const Color maizeGold = Color(0xFFE8940A);
  static const Color sacredJade = Color(0xFF1A5C3A);
  static const Color warmAmber = Color(0xFFC8591A);

  // ── Gradientes ──
  static const Color headerStart = Color(0xFF8B3A0A);
  static const Color headerEnd = Color(0xFF3D1A08);

  // ── Categorías ──
  static const Color categoryLeyenda = Color(0xFF1A5C3A);
  static const Color categoryTradicion = Color(0xFFC8591A);
  static const Color categoryHistoria = Color(0xFF8B4513);
  static const Color categoryRitual = Color(0xFF7B3F8C);
  static const Color categoryCancion = Color(0xFF1A6B8A);
  static const Color categoryPersonaje = Color(0xFF5A6B1A);

  static Color categoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'leyenda':
        return categoryLeyenda;
      case 'tradición':
      case 'tradicion':
        return categoryTradicion;
      case 'historia':
        return categoryHistoria;
      case 'ritual':
        return categoryRitual;
      case 'canción':
      case 'cancion':
        return categoryCancion;
      case 'personaje':
        return categoryPersonaje;
      default:
        return sacredJade;
    }
  }

  // ── Texto ──
  static const Color textOnDarkTitle = Color(0xFFF5E6C8);
  static const Color textOnDarkBody = Color(0xFFD4C4A0);
  static const Color textOnLightTitle = Color(0xFF2D1A0A);
  static const Color textOnLightBody = Color(0xFF5A3A20);

  // ── Navegación ──
  static const Color navBackground = Color(0xFF2D1A0A);
  static const Color navActive = Color(0xFFE8940A);
  static const Color navInactive = Color(0xFFB8A88A);

  // ── Inputs ──
  static const Color inputBorder = Color(0xFF8B2020);

  // ── Varios ──
  static const Color cardBorder = Color(0xFFE0D8C0);
}

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

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color get surface => isDark ? AppColors.obsidianNight : AppColors.amateParchment;
  Color get card => isDark ? AppColors.copalBrown : Colors.white;
  Color get appBarBg => isDark ? AppColors.obsidianNight : AppColors.amateParchment;
  Color get appBarDarkBg => isDark ? AppColors.obsidianNight : AppColors.copalBrown;
  Color get navBg => AppColors.navBackground;

  Color get textPrimary => isDark ? AppColors.textOnDarkTitle : AppColors.textOnLightTitle;
  Color get textBody => isDark ? AppColors.textOnDarkBody : AppColors.textOnLightBody;
  Color get textSecondary => AppColors.midBrown;
  Color get textOnWhite => isDark ? AppColors.textOnDarkTitle : AppColors.textOnLightTitle;

  Color get inputFill => isDark ? AppColors.copalBrown : Colors.white;

  Color get border => AppColors.cardBorder;
  Color get headerStart => AppColors.headerStart;
  Color get headerEnd => AppColors.headerEnd;
  Color get sacredJade => AppColors.sacredJade;
  Color get maizeGold => AppColors.maizeGold;
  Color get warmAmber => AppColors.warmAmber;
  Color get midBrown => AppColors.midBrown;
  Color get copalBrown => AppColors.copalBrown;
}
