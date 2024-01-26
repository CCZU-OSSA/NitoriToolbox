import 'package:arche/extensions/iter.dart';

typedef VersionType = (int, int, int);

extension Version on (int, int, int) {
  int get first => $1;
  int get middle => $2;
  int get last => $3;
  int compareTo(VersionType other) {
    return sum - other.sum;
  }

  int get sum => $1 * 100 + $2 * 10 + $3;
  bool operator >(VersionType other) => compareTo(other) > 0;
  bool operator >=(VersionType other) => compareTo(other) >= 0;
  bool operator <(VersionType other) => compareTo(other) < 0;
  bool operator <=(VersionType other) => compareTo(other) <= 0;

  static VersionType fromIterator(Iterator<int> version) =>
      (version.next()!, version.next()!, version.next()!);
  static VersionType fromIterable(Iterable<int> version) =>
      fromIterator(version.iterator);
  static VersionType fromString(String version) {
    if (version.startsWith("v")) {
      version = version.substring(1);
    }
    return fromIterable(version.split(".").map((e) => int.parse(e)));
  }

  static VersionType? parse(version) {
    if (version is String) {
      return fromString(version);
    }
    if (version is Iterable<int>) {
      return fromIterable(version);
    }
    if (version is Iterator<int>) {
      return fromIterator(version);
    }
    return null;
  }

  String format() {
    return "v$first.$middle.$last";
  }
}
