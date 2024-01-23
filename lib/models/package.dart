import 'dart:convert';

import 'package:arche/arche.dart';
import 'package:arche/extensions/io.dart';
import 'package:archive/archive_io.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/views/pages/gallery.dart';

const String ext = ".ntipkg";

class NitoriPackage {
  final String path;

  const NitoriPackage(this.path);

  ImportMetaData? get meta {
    try {
      final inputStream = InputFileStream(path);
      var archive = ZipDecoder().decodeBuffer(inputStream);
      var meta = archive.findFile("meta.yml");
      if (meta == null) {
        return null;
      }

      var data = ImportMetaData().loads(utf8.decode(meta.content));
      inputStream.closeSync();
      return data;
    } catch (e) {
      return null;
    }
  }

  Future<(bool, String)> import() async {
    try {
      var meta = this.meta;
      if (meta == null) {
        return (false, "缺失 meta.yml\n可能由于此文件不属于可导入的文件，或者可能由于错误的打包造成");
      }

      var (dir, can) = meta.parse();
      if (dir == null || can == null) {
        return (false, "解析 meta.yml 失败\n导入类型可能没有正确标注或对应类型描述存在错误");
      }

      var target = dir.subDirectory(meta.name);
      if (target.existsSync()) {
        return (false, "存在重复的文件夹 ${target.path}");
      }

      await target.create();
      var stream = InputFileStream(path);
      await extractArchiveToDiskAsync(
        ZipDecoder().decodeBuffer(stream),
        target.absolute.path,
        asyncWrite: true,
      );

      await stream.close();
      await can.reload();
      if (ArcheBus.bus.has<StateGalleryContent<dynamic>>()) {
        ArcheBus.bus.of<StateGalleryContent<dynamic>>().mountRefresh();
      }

      return (true, "");
    } catch (e) {
      return (false, e.toString());
    }
  }
}
