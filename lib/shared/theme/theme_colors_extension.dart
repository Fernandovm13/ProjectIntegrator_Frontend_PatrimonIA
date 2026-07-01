import 'package:flutter/material.dart';
import 'app_colors.dart';

extension ThemeColors on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  // ── Superficies ──
  Color get surface => isDark ? AppColors.obsidianNight : AppColors.amateParchment;
  Color get card => isDark ? AppColors.copalBrown : Colors.white;
  Color get appBarBg => isDark ? AppColors.obsidianNight : AppColors.amateParchment;
  Color get appBarDarkBg => isDark ? AppColors.obsidianNight : AppColors.copalBrown;
  Color get navBg => AppColors.navBackground;

  // ── Textos ──
  Color get textPrimary => isDark ? AppColors.textOnDarkTitle : AppColors.textOnLightTitle;
  Color get textBody => isDark ? AppColors.textOnDarkBody : AppColors.textOnLightBody;
  Color get textSecondary => AppColors.midBrown;
  Color get textOnWhite => isDark ? AppColors.textOnDarkTitle : AppColors.textOnLightTitle;

  // ── Inputs ──
  Color get inputFill => isDark ? AppColors.copalBrown : Colors.white;

  // ── Varios ──
  Color get border => AppColors.cardBorder;
  Color get headerStart => AppColors.headerStart;
  Color get headerEnd => AppColors.headerEnd;
  Color get sacredJade => AppColors.sacredJade;
  Color get maizeGold => AppColors.maizeGold;
  Color get warmAmber => AppColors.warmAmber;
  Color get midBrown => AppColors.midBrown;
  Color get copalBrown => AppColors.copalBrown;
}
