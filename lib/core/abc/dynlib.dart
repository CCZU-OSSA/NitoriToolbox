import 'dart:ffi';
import 'dart:io';

abstract class FFI {
  String path();
}

extension FFIImpl on FFI {
  bool exists() {
    return File(path()).existsSync();
  }

  DynamicLibrary? getDynamicLib() {
    if (!exists()) {
      return null;
    }
    return DynamicLibrary.open(path());
  }
}

