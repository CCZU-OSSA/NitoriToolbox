import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:arche/arche.dart';
import 'package:arche/extensions/io.dart';
import 'package:archive/archive_io.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/views/pages/gallery.dart';

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

      var callback = meta.parse();
      if (callback == null) {
        return (false, "解析 meta.yml 失败\n导入类型可能没有正确标注或对应类型描述存在错误");
      }

      var (dir, can) = callback;

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

  static void _internalExport(SendPort port) {
    ReceivePort rev = ReceivePort();
    rev.listen(
      (message) {
        if (message is (String, String)) {
          var (from, to) = message;
          var target = Directory(from);
          if (!target.existsSync()) {
            port.send(null);
            return;
          }
          var output = OutputFileStream(to);

          var archive =
              createArchiveFromDirectory(target, includeDirName: false);
          var encoder = ZipEncoder();
          encoder.startEncode(output);
          var length = archive.files.length - 1;
          for (var (index, file) in archive.files.indexed) {
            encoder.addFile(file);
            port.send((index + 1) / length);
          }
          encoder.endEncode(
              comment:
                  "The Zip Archive was created By `NitoriToolbox` - https://github.com/CCZU-OSSA/NitoriToolbox");
          output.closeSync();
          rev.close();
          port.send(null);
        }
      },
    );
    port.send(rev.sendPort);
  }

  void export(String package,
      {Function()? onDone, Function(double progress)? onProgress}) async {
    ReceivePort rev = ReceivePort();
    var isolate = await Isolate.spawn(_internalExport, rev.sendPort);
    rev.listen(
      (message) {
        if (message == null) {
          rev.close();
          isolate.kill();
          if (onDone != null) {
            onDone();
          }
        }

        if (message is double && onProgress != null) {
          onProgress(message);
        }

        if (message is SendPort) {
          message.send((package, path));
        }
      },
    );
  }
}
