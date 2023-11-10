import 'dart:collection';
import 'dart:convert';
import 'dart:ffi';

// ignore: depend_on_referenced_packages
import 'package:ffi/ffi.dart';
import 'package:nitoritoolbox/core/abc/dynlib.dart';

class HardwareQuery extends FFI {
  @override
  String path() {
    return "./nitori_core.dll";
  }

  DynamicLibrary? __library;
  Pointer<Utf8> Function(Pointer<Utf8> target)? _query;
  Pointer<Utf8> Function()? _version;
  String version = "未安装";
  bool installed = false;

  HardwareQuery() {
    __library = getDynamicLib();
    if (__library != null) {
      installed = true;
      _version = __library!
          .lookup<NativeFunction<Pointer<Utf8> Function()>>("version")
          .asFunction();
      version = _version!().toDartString();
      _query = __library!
          .lookup<NativeFunction<Pointer<Utf8> Function(Pointer<Utf8>)>>(
              "query")
          .asFunction();
    }
  }

  HashMap<String, dynamic>? query(List<String> target) {
    if (_query != null) {
      return jsonDecode(_query!(jsonEncode({"target": target}).toNativeUtf8())
          .toDartString());
    }
    return null;
  }
}
