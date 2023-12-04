class Translator<T, V> {
  late Map _index;
  final List<T> _e;
  V? defaultValue;

  Translator(this._e) {
    this._index = {for (var v in this._e) v: null};
  }

  Translator defaultName(V s) {
    defaultValue = s;
    return this;
  }

  Translator setTranslate(T e, V s) {
    _index[e] = s;
    return this;
  }

  int convertIndex(T e) {
    return _index.keys.toList().indexOf(e);
  }

  V getTranslate(T e) {
    return _index.containsKey(e) && _index[e] != null
        ? _index[e]
        : defaultValue;
  }

  V getTranslateIndex(int i) {
    Enum e = _index.keys.toList()[i];
    return _index.containsKey(e) && _index[e] != null
        ? _index[e]
        : defaultValue;
  }
}
