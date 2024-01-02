import 'dart:io';

import 'package:arche/extensions/io.dart';
import 'package:arche/modules/application.dart';

class AppData {
  late Directory initialDirectory;

  AppData(String path) {
    initialDirectory = Directory(path).check();
  }

  ArcheConfig config() {
    return ArcheConfig.path(initialDirectory.subPath("app.config.json"));
  }
}
