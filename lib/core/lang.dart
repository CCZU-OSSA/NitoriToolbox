import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';

extension ListUtils<T> on List<T> {
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

  static List<RT> generatefrom<I, RT>(List<I> v, RT Function(I) generator) {
    return List.generate(v.length, (index) => generator(v[index]));
  }

  List<T> expandT(T i) {
    add(i);
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

extension DirUtils on Directory {
  Directory check({bool recursive = true}) {
    if (!absolute.existsSync() ||
        absolute.statSync().type != FileSystemEntityType.directory) {
      absolute.createSync(recursive: recursive);
    }
    return this;
  }

  Directory subdir(String name) {
    return Directory(subpath(name));
  }

  String subpath(String name) {
    return "${absolute.path}/$name";
  }

  File subfile(String name) {
    return File(subpath(name));
  }

  Directory move(Directory target) {
    throw UnimplementedError("TODO");
  }
}

extension TooltipUtils on Widget {
  Tooltip tooltip(String message) {
    return Tooltip(
      message: message,
      child: this,
    );
  }
}
