import 'dart:convert';

import 'package:archive/archive_io.dart';

const String ext = ".ntrpkg";

class NitoriPackage {
  final String path;
  const NitoriPackage(this.path);

  String? get meta {
    try {
      final inputStream = InputFileStream(path);
      var archive = ZipDecoder().decodeBuffer(inputStream);
      var meta = archive.findFile("meta.yml");
      if (meta == null) {
        return null;
      }

      return utf8.decode(meta.content);
    } catch (e) {
      return null;
    }
  }
}
