import 'dart:convert';
import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';

class ApplicationConfig implements KVIO {
  String configPath;

  ApplicationConfig(this.configPath) {
    if (!File(configPath).existsSync()) {
      File(configPath).writeAsStringSync("{}");
    }
  }

  @override
  String encode<K, V>(Map<K, V> map) {
    return jsonEncode(map);
  }

  @override
  Map<K, V> decode<K, V, I>(I data) {
    return jsonDecode(data.toString());
  }

  @override
  String read() {
    return File(configPath).readAsStringSync();
  }

  @override
  void write(data) {
    File(configPath).writeAsStringSync(data.toString());
  }
}

ThemeMode getThemeMode(BuildContext context) {
  switch (ApplicationBus.instance(context).config.getOrWrite("thememode", 0)) {
    case 0:
      return ThemeMode.system;
    case 1:
      return ThemeMode.light;
    case -1:
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