import 'dart:io';

import 'package:arche/extensions/io.dart';
import 'package:arche/modules/application.dart';
import 'package:nitoritoolbox/models/yaml.dart';

class AppData {
  final Directory initialDirectory;

  const AppData(this.initialDirectory);

  ArcheConfig get config =>
      ArcheConfig.path(initialDirectory.subPath("app.config.json"));

  GalleryManager get galleryManager =>
      GalleryManager(initialDirectory.subDirectory("gallery").check());
}

class GalleryManager {
  final Directory initialDirectory;
  const GalleryManager(this.initialDirectory);
  Directory get applications =>
      initialDirectory.subDirectory("applications").check();
  Directory get environments =>
      initialDirectory.subDirectory("environments").check();
  Directory get documents => initialDirectory.subDirectory("documents").check();

  List<T> collect<T extends YamlMapLoader>(
      Directory directory, T Function(String data) converter) {
    return directory
        .listSync()
        .where((fs) =>
            fs.statSync().type == FileSystemEntityType.directory &&
            fs.subFile("meta.yaml").existsSync())
        .map((e) => converter(e.subFile("meta.yaml").readAsStringSync()))
        .toList();
  }
}
