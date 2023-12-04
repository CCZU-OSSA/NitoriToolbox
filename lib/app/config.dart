import 'dart:convert';
import 'dart:io';

import 'package:nitoritoolbox/app/abc/io.dart';

class ApplicationConfig implements KVIO {
  String configPath;
  bool firstuse = false;
  ApplicationConfig(this.configPath) {
    if (!File(configPath).existsSync()) {
      firstuse = true;
      File(configPath).writeAsStringSync("{}");
    }
  }

  @override
  String encode<K, V>(Map<K, V> map) {
    return jsonEncode(map);
  }

  @override
  Map<K, V> decode<K, V, I>(I data) {
    return jsonDecode(data.toString());
  }

  @override
  String read() {
    return File(configPath).readAsStringSync();
  }

  @override
  void write(data) {
    File(configPath).writeAsStringSync(data.toString());
  }
}
