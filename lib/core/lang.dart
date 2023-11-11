extension JoinEx<T> on List<T> {
  List<T> joinElement(T sep) {
    if (length > 1) {
      for (var i = 1; i < length; i++) {
        insert(i, sep);
        i++;
      }
    }
    return this;
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
