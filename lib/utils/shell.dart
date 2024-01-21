import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter_pty/flutter_pty.dart';

typedef MessageHandler<T> = void Function(T data);

abstract class Shell<T> {
  bool connect = false;
  Map<String, String>? perferEnvironment;
  String? perferShell;
  String? workingDirectory;
  final List<MessageHandler<String>> _subscription = [];
  T? container;

  Shell({
    this.perferEnvironment,
    this.perferShell,
    this.workingDirectory,
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

  void bind(MessageHandler<String> handler) {
    _subscription.add(handler);
  }

  void activate() {
    if (connect) {
      deactivate();
    }
    connect = true;
  }

  void deactivate() {
    connect = false;
  }

  void reload() {
    deactivate();
    activate();
  }

  void clearbinds() {
    _subscription.clear();
  }

  void write(String data);

  Map get config => {
        "perferEnvironment": perferEnvironment,
        "perferShell": perferShell,
        "workingDirectory": workingDirectory,
      };
}

class PtyShell extends Shell<Pty> {
  PtyShell({
    super.perferEnvironment,
    super.perferShell,
    super.workingDirectory,
  });

  @override
  void activate() async {
    super.activate();
    container = Pty.start(
      perferShell ?? shell,
      environment: enviroment,
      workingDirectory: workingDirectory,
    );

    container!.output.listen((event) {
      for (var subf in _subscription) {
        subf(utf8.decode(event).displayFilter());
      }
    });
  }

  @override
  void deactivate() {
    super.deactivate();
    container?.kill();
  }

  @override
  void write(String data) {
    container!.write(utf8.encode(data.platformline()));
  }
}

class ISolateShell extends Shell<Isolate> {
  ReceivePort? _rev;
  SendPort? _sed;
  final List<String> _queue = [];
  ISolateShell({
    super.perferEnvironment,
    super.perferShell,
    super.workingDirectory,
  });

  static void _internalShell(SendPort port) {
    ReceivePort rev = ReceivePort();
    late PtyShell shell;
    port.send(rev.sendPort);
    rev.listen((message) {
      if (message is Map) {
        shell = PtyShell(
          perferEnvironment: message["perferEnvironment"],
          perferShell: message["perferShell"],
          workingDirectory: message["workingDirectory"],
        );
        shell.bind((data) => port.send(data));
        shell.activate();
      }

      if (message is String) {
        shell.write(message);
      }
    });
  }

  @override
  void activate() {
    if (connect) {
      deactivate();
    }

    _rev = ReceivePort();
    _rev!.listen(
      (message) {
        if (message is SendPort) {
          message.send(config);
          connect = true;
          _sed = message;

          while (_queue.isNotEmpty) {
            message.send(_queue.removeAt(0));
          }
        }

        if (message is String) {
          for (var subf in _subscription) {
            subf(message);
          }
        }
      },
    );
    Isolate.spawn(_internalShell, _rev!.sendPort)
        .then((value) => container = value);
  }

  @override
  void deactivate() {
    super.deactivate();
    _queue.clear();
    container?.kill();
  }

  @override
  void write(String data) {
    if (connect && _sed != null) {
      _sed!.send(data);
    } else {
      _queue.add(data);
    }
  }
}

extension StringSplit on String {
  List<String> platformlines() {
    if (Platform.isWindows) {
      return split("\r\n");
    } else {
      return split("\n");
    }
  }

  List<String> lines() {
    return split("\n");
  }

  String platformline() {
    if (Platform.isWindows) {
      return "$this\r\n";
    } else {
      return "$this\n";
    }
  }

  String displayFilter() {
    return replaceAllMapped(
            RegExp(r"\x1b\[[\x30-\x3f]*[\x20-\x2f]*[\x40-\x7e]"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b[PX^_].*?\x1b\\"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b\][^\a]*(?:\a|\x1b\\)"), (match) => "")
        .replaceAllMapped(RegExp(r"\x1b[\[\]A-Z\\^_@]"), (match) => "");
  }
}
