import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/core/lang.dart';

const String root = "resource";

String image(String name) {
  return "$root/images/$name";
}

String imagePNG(String name) {
  return "$root/images/$name.png";
}

class LocalDataManager {
  String path;
  LocalDataManager(this.path);

  Directory getDirectory() {
    return Directory(path).check();
  }

  void move(Directory target) {
    // path = target.absolute.path;
    throw UnimplementedError("TODO");
  }

  static LocalDataManager instance(BuildContext context) {
    return ApplicationBus.instance(context).dataManager;
  }
}
