import 'dart:io';

import 'package:flutter/services.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';
import 'package:nitoritoolbox/core/lang.dart';

const String root = "resource";

String image(String name) {
  return "$root/images/$name";
}

String imagePNG(String name) {
  return "$root/images/$name.png";
}

Future<List<String>> recommends() async {
  return (JsonSerializerStatic.decode(await rootBundle
          .loadString("resource/data/recommend/pkg.json"))["packages"] as List)
      .map((e) => "resource/data/recommend/$e.json")
      .toList();
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

  
}
