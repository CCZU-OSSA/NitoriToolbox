abstract class IO {
  String read();
  void write(dynamic data);
}

abstract class Serializer {
  String encode<K, V>(Map<K, V> map);
  Map<K, V> decode<K, V, I>(I data);
}

abstract class KVIO extends IO implements Serializer {}

extension KVImpl on KVIO {
  dynamic readKey(String key) {
    return toMap()[key];
  }

  Map toMap() {
    return decode(read());
  }

  void writeKey(String key, dynamic value) {
    var data = decode(read());
    data[key] = value;
    write(encode(data));
  }

  V getOrWrite<V>(String key, V value) {
    Map map = toMap();
    if (map.containsKey(key)) {
      return map[key];
    } else {
      writeKey(key, value);
      return value;
    }
  }

  V getOrDefault<V>(String key, V value) {
    Map map = toMap();
    if (map.containsKey(key)) {
      return map[key];
    } else {
      return value;
    }
  }
}
