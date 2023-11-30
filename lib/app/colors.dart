import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as mui;
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:nitoritoolbox/app/i18n.dart';
import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:system_theme/system_theme.dart';

mui.ThemeData getMUITheme(BuildContext context) {
  return mui.Theme.of(context);
}

FluentThemeData getFUITheme(BuildContext context) {
  return FluentTheme.of(context);
}

ThemeMode getThemeMode(BuildContext context) {
  switch (ApplicationBus.instance(context).config.getOrWrite("thememode", 0)) {
    case 0:
      return ThemeMode.system;
    case 1:
      return ThemeMode.light;
    case 2:
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

Brightness getBrightness(BuildContext context) {
  switch (getThemeMode(context)) {
    case ThemeMode.dark:
      return Brightness.dark;
    case ThemeMode.light:
      return Brightness.light;
    default:
      return MediaQuery.platformBrightnessOf(context);
  }
}

bool isDark(BuildContext context) {
  return getBrightness(context) == Brightness.dark;
}

bool isLight(BuildContext context) {
  return getBrightness(context) == Brightness.light;
}

Color getCurrentThemePriColor(BuildContext context,
    {Color? dark, Color? light, bool reverse = false}) {
  return isDark(context) != reverse
      ? dark ?? Colors.grey
      : light ?? Colors.white;
}

FluentThemeData darkTheme = FluentThemeData.dark().copyWith(
    accentColor: SystemTheme.accentColor.accent.toAccentColor(),
    typography: Typography.fromBrightness(color: Colors.white.withOpacity(0.87))
        .apply(fontFamily: "Default"));

FluentThemeData lightTheme = FluentThemeData.light().copyWith(
    accentColor: SystemTheme.accentColor.accent.toAccentColor(),
    typography: Typography.fromBrightness(color: Colors.black.withOpacity(0.87))
        .apply(fontFamily: "Default"));

String getWindowsWallpaper() {
  return Directory(
          "${ApplicationBus.env["USERPROFILE"]}/AppData/Roaming/Microsoft/Windows/Themes/CachedFiles")
      .listSync()[0]
      .absolute
      .path;
}

File? getWallpaperFile(BuildContext context) {
  ApplicationBus bus = ApplicationBus.instance(context);
  switch (bus.config.getOrWrite("bg_type", 0)) {
    case 1:
      if (File(bus.config.getOrWrite("bg_path", "")).existsSync()) {
        return File(bus.config.getOrWrite("bg_path", ""));
      } else {
        return null;
      }
    default:
      return File(getWindowsWallpaper());
  }
}

DecorationImage? getWallpaper(BuildContext context) {
  ApplicationBus bus = ApplicationBus.instance(context);
  if (!bus.config.getOrWrite("use_custom_bg", false) ||
      getWallpaperFile(context) == null) {
    return null;
  }
  ImageProvider image;
  if (bus.config.getOrDefault("bg_type", 0) == 2) {
    var url = bus.config.getOrDefault("bg_url", "");
    if (url == "") {
      return null;
    }
    image = NetworkImage(url);
  } else {
    image = FileImage(getWallpaperFile(context)!);
  }

  return DecorationImage(
      fit: BoxFit.cover,
      opacity: bus.config.getOrWrite("custom_bg_opactiy", 0.2),
      image: image);
}

void applyWindowEffect(BuildContext context) async {
  Window.setEffect(
      effect: supportEffects[
          ApplicationBus.instance(context).config.getOrWrite("wineffect", 0)],
      dark: isDark(context));
}
