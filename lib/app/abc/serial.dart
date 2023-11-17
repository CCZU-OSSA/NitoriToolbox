import 'dart:convert';

import 'package:nitoritoolbox/app/abc/io.dart';

class JsonSerializer implements Serializer {
  @override
  Map<K, V> decode<K, V, I>(I data) {
    return JsonSerializerStatic.decode<K, V, I>(data);
  }

  @override
  String encode<K, V>(Map<K, V> map) {
    return JsonSerializerStatic.encode<K, V>(map);
  }
}

extension JsonSerializerStatic on JsonSerializer {
  static Map<K, V> decode<K, V, I>(I data) {
    return jsonDecode(data.toString());
  }

  static String encode<K, V>(Map<K, V> map) {
    return jsonEncode(map);
  }
}

abstract class TypeMap {
  Map<K, V> toMap<K, V>();
}

extension TypeMapImpl on TypeMap {
  static TypeMap fromString(String data) {
    throw UnimplementedError();
  }

  static TypeMap fromMap(Map data) {
    throw UnimplementedError();
  }
}
