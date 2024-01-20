import 'dart:io';

import 'package:arche/arche.dart';
import 'package:arche/extensions/io.dart';
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
  GalleryManager(this.initialDirectory);
  Directory get applicationsDir =>
      initialDirectory.subDirectory("applications").check();
  Directory get environmentsDir =>
      initialDirectory.subDirectory("environments").check();
  Directory get documentsDir =>
      initialDirectory.subDirectory("documents").check();
  static GalleryManager get manager => ArcheBus.bus.of();

  final FutureLazyDynamicCan<List<ApplicationPackage>> applications =
      FutureLazyDynamicCan(
          builder: () =>
              collect(manager.applicationsDir, ApplicationPackage().loads));

  final FutureLazyDynamicCan<List<Environment>> environments =
      FutureLazyDynamicCan(
          builder: () => collect(manager.environmentsDir, Environment().loads));

  static Future<List<T>> collect<T extends MetaEntity<T>>(Directory directory,
      T Function(String data, String path) converter) async {
    return directory
        .list()
        .where((fs) =>
            fs.statSync().type == FileSystemEntityType.directory &&
            fs.subFile("meta.yml").existsSync())
        .map((e) => converter(
              e.subFile("meta.yml").readAsStringSync(),
              e.absolute.path,
            ))
        .toList();
  }
}
