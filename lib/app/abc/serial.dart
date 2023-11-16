import 'dart:convert';

import 'package:nitoritoolbox/app/abc/io.dart';

class JsonSerializer implements Serializer {
  @override
  Map<K, V> decode<K, V, I>(I data) {
    return jsonDecode(data.toString());
  }

  @override
  String encode<K, V>(Map<K, V> map) {
    return jsonEncode(map);
  }
}

abstract class TypeMap {
  Map<K, V> toMap<K, V>();
}
