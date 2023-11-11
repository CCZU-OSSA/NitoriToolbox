import 'package:nitoritoolbox/core/lang.dart';

class DataHolder<V> {
  V? data;
  bool hasData = false;
  void setData(V data) {
    if (!hasData) {
      this.data = data;
      hasData = true;
    }
  }

  void clear() {
    hasData = false;
    data = null;
  }

  V getData() {
    return data!;
  }

  V? getNullableData() {
    return data;
  }
}

class Device {
  Map data;
  int count = 1;
  Device(this.data);

  bool eq(Device rhs) {
    return data.toString() == rhs.data.toString();
  }

  Device equalMerge(Device rhs) {
    eq(rhs).ifTrue(() {
      count += rhs.count;
      rhs.count = 0;
    });
    return this;
  }
}
