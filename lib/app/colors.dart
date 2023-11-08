import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mui;
import 'package:nitoritoolbox/app/config.dart';
import 'package:system_theme/system_theme.dart';

mui.ThemeData getMUITheme(BuildContext context) {
  return mui.Theme.of(context);
}

FluentThemeData getFUITheme(BuildContext context) {
  return FluentTheme.of(context);
}

bool isDark(BuildContext context) {
  return getBrightness(context) == Brightness.dark;
}

bool isLight(BuildContext context) {
  return getBrightness(context) == Brightness.light;
}

String translateThememode(ThemeMode mode) {
  switch (mode) {
    case ThemeMode.dark:
      return "🌙深色模式";
    case ThemeMode.light:
      return "🔆浅色模式";
    default:
      return "🌗跟随系统";
  }
}

String getThememodeTranslate(BuildContext context) {
  return translateThememode(getThemeMode(context));
}

FluentThemeData darkTheme = FluentThemeData.dark().copyWith(
    accentColor: SystemTheme.accentColor.accent.toAccentColor(),
    typography: Typography.fromBrightness(color: Colors.white.withOpacity(0.87))
        .apply(fontFamily: "Default"));

FluentThemeData lightTheme = FluentThemeData.light().copyWith(
    accentColor: SystemTheme.accentColor.accent.toAccentColor(),
    typography: Typography.fromBrightness(color: Colors.black.withOpacity(0.87))
        .apply(fontFamily: "Default"));
