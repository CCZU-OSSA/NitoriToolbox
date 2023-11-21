extension JoinExra<T> on List<T> {
  List<RT> joinElementF<RT>(RT sep) {
    List<RT> res = List.from(this);
    if (length > 1) {
      for (var i = 1, c = 1; c < length; i += 2, c++) {
        res.insert(i, sep);
      }
    }
    return res;
  }

  List<T> joinElement(T sep) {
    var len_ = length;
    if (len_ > 1) {
      for (var i = 1, c = 1; c < len_; i += 2, c++) {
        insert(i, sep);
      }
    }
    return this;
  }

  List<T> expandAll(Iterable<T> i) {
    addAll(i);
    return this;
  }

  List<RT> castF<RT>() {
    List<RT> res = [];
    res.addAll(this as Iterable<RT>);
    return res;
  }
}

extension FPBool on bool {
  RT? ifTrue<RT>(RT Function() F) {
    return this ? F() : null;
  }

  RT? ifFalse<RT>(RT Function() F) {
    return !this ? F() : null;
  }
}

extension FPObj on Object {
  RT then<RT>(RT Function() F) {
    return F();
  }

  RT? eqThen<RT>(Object rhs, RT Function() F) {
    return this == rhs ? F() : null;
  }
}
