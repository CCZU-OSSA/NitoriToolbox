import 'dart:convert';
import 'dart:io';

abstract class AbstractShell {
  Map<String, String>? environment;
  AbstractShell({this.environment});
  String get syspath;
}

mixin ShellIO on AbstractShell {
  Process? process;
  Future<Process> start(String executable, List<String> arguments) async {
    process?.kill();

    var env = environment ?? {"path": ""};
    env["path"] = "${env["path"]}$syspath";
    return process = await Process.start(executable, arguments,
        runInShell: true, environment: env);
  }
}

extension StreamUtf8Decoder on Stream<List<int>> {
  Stream<String> asStringStream() {
    return transform(const Utf8Decoder());
  }
}
