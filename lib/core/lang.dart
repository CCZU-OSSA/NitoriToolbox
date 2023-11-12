extension JoinExra<T> on List<T> {
  List<RT> joinElement<RT>(RT sep) {
    List<RT> res = List.from(this);
    if (length > 1) {
      for (var i = 1, c = 0; c < length; i += 2, c++) {
        res.insert(i, sep);
      }
    }
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
