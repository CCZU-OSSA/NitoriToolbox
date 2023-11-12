import 'dart:convert';
import 'dart:ffi';

import 'package:ffi/ffi.dart';
import 'package:nitoritoolbox/core/abc/dynlib.dart';

class NitoriCore extends FFI {
  @override
  String path() {
    return "./nitori_core.dll";
  }

  DynamicLibrary? __library;
  Pointer<Utf8> Function(Pointer<Utf8> target)? _query;
  Pointer<Utf8> Function()? _version;
  Pointer<Utf8> Function()? _getmontiors;
  String version = "未安装";
  List monitors = [];
  bool installed = false;

  NitoriCore() {
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
      _getmontiors = __library!
          .lookup<NativeFunction<Pointer<Utf8> Function()>>("get_montiors")
          .asFunction();
      monitors = jsonDecode(_getmontiors!().toDartString())["data"];
    }
  }

  Map<String, dynamic>? query(List<String> target) {
    if (_query != null) {
      return jsonDecode(_query!(jsonEncode({"target": target}).toNativeUtf8())
          .toDartString());
    }
    return null;
  }

  Map<String, dynamic>? querySingle(String target) {
    return query([target]);
  }
}
