import 'dart:convert';
import 'dart:io';

import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter_pty/flutter_pty.dart';

typedef MessageHandler = void Function(List<int> data);

abstract class Environment<T> {
  late T container;
  bool connect = false;
  Map<String, String>? perferEnvironment;
  String? perferShell;
  Environment({
    this.perferEnvironment,
    this.perferShell,
  });

  String get shell {
    if (Platform.isMacOS || Platform.isLinux) {
      return Platform.environment['SHELL'] ?? 'bash';
    }
    if (Platform.isWindows) {
      return 'cmd.exe';
    }
    return 'sh';
  }

  Map<String, String> get enviroment {
    var env = Map<String, String>.from(perferEnvironment ?? {});
    for (var element in Platform.environment.entries) {
      env[element.key] = "${env[element.key] ?? ""}${element.value}";
    }
    return env;
  }

  void write(String data);

  void bind(MessageHandler handler);

  void deactivate() {
    connect = false;
  }

  void activate() async {
    connect = true;
  }

  void reload() async {
    deactivate();
    activate();
  }
}

class EnvProcess extends Environment<Process> {
  final List<MessageHandler> _stdouthandler = [];
  final List<MessageHandler> _stderrhandler = [];

  EnvProcess({
    super.perferEnvironment,
    super.perferShell,
  });

  @override
  void write(String data) {
    container.stdin.write(data);
    container.stdin.flush();
  }

  @override
  Future<Process> activate(
      {String executable = "", List<String>? arguments}) async {
    super.activate();
    if (perferShell == null) {
      container = await Process.start(executable, arguments ?? []);
    } else {
      List<String> arg = arguments ?? [];
      arg.insert(0, executable);
      container = await Process.start(perferShell!, arg);
    }
    container.stdout.listen(
      (event) {
        for (var h in _stdouthandler) {
          h(event);
        }
      },
      onDone: () => deactivate(),
    );
    container.stderr.listen(
      (event) {
        for (var h in _stderrhandler) {
          h(event);
        }
      },
      onDone: () => deactivate(),
    );

    return container;
  }

  @override
  void deactivate() async {
    super.deactivate();
    container.stdin.close().then((value) => container.kill());
  }

  @override
  void bind(MessageHandler handler,
      {bool handleStdin = true, bool handleStderr = true}) {
    if (handleStdin) {
      _stdouthandler.add(handler);
    }

    if (handleStderr) {
      _stderrhandler.add(handler);
    }
  }
}

class EnvPty extends Environment<Pty> {
  final List<MessageHandler> _subscription = [];
  EnvPty({
    super.perferEnvironment,
    super.perferShell,
  });

  @override
  Future<Pty> activate() async {
    super.activate();
    container = Pty.start(perferShell ?? shell, environment: enviroment);
    container.resize(30, 80);

    container.output.listen((event) {
      for (var f in _subscription) {
        f(event);
      }
    });

    return container;
  }

  @override
  void bind(MessageHandler handler) {
    _subscription.add(handler);
  }

  @override
  void deactivate() {
    super.deactivate();
    container.kill();
  }

  @override
  void write(String data) {
    container.write(utf8.encode(data.platformline()));
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

extension StringSplit on String {
  List<String> splitlines() {
    if (Platform.isWindows) {
      return split("\r\n");
    } else {
      return split("\n");
    }
  }

  String platformline() {
    if (Platform.isWindows) {
      return "$this\r\n";
    } else {
      return "$this\n";
    }
  }
}
