import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/core/translator.dart';

enum LogLevel { info, warn, error }

var levelColorTR = Translator<Enum, Color>(LogLevel.values)
    .setTranslate(LogLevel.error, Colors.red)
    .setTranslate(LogLevel.warn, Colors.yellow)
    .defaultName(Colors.green);

class Log {
  String time;
  LogLevel level;
  String message;
  Log(this.level, this.message, this.time);

  @override
  String toString() {
    return "$time $level $message";
  }
}

class ApplicationLogger {
  final List<Log> _logs = [];

  void log(LogLevel level, String message) {
    Log log = Log(level, message, DateTime.now().toString());
    debugPrint(log.toString());
    _logs.add(log);
  }

  void info(String message) => log(LogLevel.info, message);
  void warn(String message) => log(LogLevel.warn, message);
  void error(String message) => log(LogLevel.error, message);

  List<Log> getLogs() {
    return _logs;
  }
}
