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
  void Function(Pointer<Utf8> pathto)? _generateInfo;
  void Function(Pointer<Utf8> name, Pointer<Utf8> pathto)? _makeInfoName;
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
      _generateInfo = __library!
          .lookup<NativeFunction<Void Function(Pointer<Utf8>)>>("generate_info")
          .asFunction();
      _makeInfoName = __library!
          .lookup<NativeFunction<Void Function(Pointer<Utf8>, Pointer<Utf8>)>>(
              "make_info_name")
          .asFunction();
    }
  }

  void makeInfoName(String name, String pathto) {
    if (_makeInfoName != null) {
      _makeInfoName!(name.toNativeUtf8(), pathto.toNativeUtf8());
    }
  }

  void generateInfo(String name, String pathto) {
    if (_generateInfo != null) {
      _generateInfo!(pathto.toNativeUtf8());
    }
  }
}
