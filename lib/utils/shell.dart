import 'dart:convert';
import 'dart:io';

import 'package:fast_gbk/fast_gbk.dart';

class Shell {
  Map<String, String>? environment;
  String? perferShell;
  Shell({
    this.environment,
    this.perferShell,
  });
  String get syspath => Platform.environment["PATH"] ?? "";
  Process? process;
  IOSink? get currentStdin => process?.stdin;
  Future<Process> start(String executable, List<String> arguments) async {
    var env = environment ?? {"path": ""};
    env["path"] = "${env["path"]}$syspath";

    if (perferShell != null) {
      arguments.insert(0, executable);
      return process =
          await Process.start(perferShell!, arguments, environment: env);
    } else {
      return process = await Process.start(executable, arguments,
          runInShell: true, environment: env);
    }
  }
}

final class UnionDecoder extends Converter<List<int>, String> {
  static const UnionDecoder instance = UnionDecoder();

  static const List<Converter<List<int>, String>> _conventers = [
    Utf8Decoder(),
    GbkDecoder()
  ];

  const UnionDecoder();

  @override
  String convert(List<int> input) {
    for (var decoder in _conventers) {
      try {
        return decoder.convert(input);
      } catch (_) {}
    }
    return "Decode Error";
  }
}

extension StreamUtf8Decoder on Stream<List<int>> {
  Stream<String> asStringStream() {
    return transform(const UnionDecoder());
  }
}
