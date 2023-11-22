import 'package:flutter/services.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';

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
