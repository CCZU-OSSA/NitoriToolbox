class Translator<T> {
  late Map _index;
  final List<T> _e;
  String? defaultValue;

  Translator(this._e) {
    this._index = {for (var v in this._e) v: null};
  }
  
  Translator defaultName(String s) {
    defaultValue = s;
    return this;
  }

  Translator setTranslate(T e, String s) {
    _index[e] = s;
    return this;
  }

  int convertIndex(T e) {
    return _index.keys.toList().indexOf(e);
  }
  String getTranslate(T e) {
    return _index.containsKey(e) && _index[e] != null ? _index[e] : defaultValue;
  }

  String getTranslateIndex(int i) {
    Enum e = _index.keys.toList()[i];
    return _index.containsKey(e) && _index[e] != null ? _index[e] : defaultValue;
  }
}
