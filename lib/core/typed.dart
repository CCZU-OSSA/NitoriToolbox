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
}
