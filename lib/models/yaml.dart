import 'dart:io';

import 'package:arche/arche.dart';
import 'package:arche/extensions/io.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controllers/appdata.dart';
import 'package:nitoritoolbox/models/version.dart';
import 'package:nitoritoolbox/controllers/shell.dart';
import 'package:yaml/yaml.dart';

abstract class YamlMetaData<T extends YamlMetaData<T>> {
  late final String path;
  T loadm(Map data, [String? path]) {
    return (this..path = data["path"] ?? path ?? "") as T;
  }

  T loads(String data, [String? path]) {
    return loadm(loadYaml(data), path);
  }

  T? load(data, [String? path]) {
    if (data is Map) {
      return loadm(data, path ?? "");
    } else if (data is String) {
      return loads(data, path ?? "");
    }
    return null;
  }

  bool check(data) {
    try {
      if (load(data) == null) {
        return false;
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}

abstract interface class Widgetlize {
  Widget build({double? size});
}

abstract mixin class Package<T> {
  late final String name;
  late final RichCover cover;
  late final VersionType version;
  late final T includes;
}

abstract class YamlMetaPackage<S, T extends YamlMetaPackage<S, T>>
    extends YamlMetaData<T> with Package<S> {}

class RichCover extends YamlMetaData<RichCover> implements Widgetlize {
  String? text;
  CoverIcon? icon;
  CoverImage? image;
  @override
  RichCover loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..text = data["text"]
      ..image = CoverImage().parse(data["image"], path)
      ..icon = CoverIcon().parse(data["icon"], path);
  }

  RichCover parse(data, [String? path]) {
    if (data is String) {
      return this..text = data;
    }

    return loadm(data, path);
  }

  @override
  Widget build({double? size}) {
    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      (icon ?? image)?.build(size: size) ?? const SizedBox.shrink(),
      text != null ? Text(text!) : const SizedBox.shrink(),
    ]);
  }
}

class CoverIcon extends YamlMetaData<CoverIcon> implements Widgetlize {
  late final int codePoint;
  late final String fontFamily;
  late final String? fontPackage;

  @override
  CoverIcon loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..codePoint = (data["code"] ?? data["codePoint"])!
      ..fontFamily = data["fontFamily"] ?? "MaterialIcons"
      ..fontPackage = data["fontPackage"];
  }

  @override
  Widget build({double? size}) {
    return Icon(
      IconData(codePoint, fontFamily: fontFamily, fontPackage: fontPackage),
      size: size,
    );
  }

  CoverIcon? parse(data, [String? path]) {
    if (data == null) {
      return null;
    }

    return CoverIcon().loadm(data, path);
  }
}

class CoverImage extends YamlMetaData<CoverImage> implements Widgetlize {
  String? network;
  String? local;

  @override
  Widget build({double? size}) {
    ImageProvider? provider;
    if (network != null) {
      provider = NetworkImage(network!);
    }

    if (local != null) {
      provider = FileImage(File(path).subFile(local!));
    }

    return Image(
      image: provider ?? const AssetImage("resource/images/document.jpg"),
      width: size,
      height: size,
    );
  }

  CoverImage? parse(data, [String? path]) {
    if (data == null) {
      return null;
    }

    return CoverImage().loadm(data, path);
  }
}

class ApplicationFeatureStep extends YamlMetaData<ApplicationFeatureStep> {
  late final String details;
  late final List<String> run;

  @override
  ApplicationFeatureStep loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..details = data["details"] ?? ""
      ..run = (data["run"] as String).lines();
  }
}

class ApplicationFeature extends YamlMetaData<ApplicationFeature> {
  late final String name;
  late final RichCover cover;
  late final List<ApplicationFeatureStep> steps;

  @override
  ApplicationFeature loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"]!
      ..steps = (data["steps"] as YamlList)
          .map((data) => ApplicationFeatureStep().loadm(data, path))
          .toList()
      ..cover = RichCover().parse(data["cover"] ?? name, path);
  }
}

class Application extends YamlMetaData<Application> {
  late final String name;
  late final RichCover cover;
  late final VersionType version;
  late final String details;
  late final List<String> environments;
  late final List<ApplicationFeature> features;

  @override
  Application loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"] ?? "Unknown App"
      ..cover = RichCover().parse(data["cover"] ?? name, path)
      ..details = data["details"] ?? ""
      ..version = Version.fromString(data["version"] ?? "1.0.0")
      ..environments = ((data["environments"] as YamlList?) ?? []).cast()
      ..features = (data["features"] as YamlList? ?? [])
          .map((e) => ApplicationFeature().loadm(e, path))
          .toList();
  }
}

class ApplicationPackage
    extends YamlMetaPackage<List<Application>, ApplicationPackage> {
  @override
  ApplicationPackage loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"] ?? "Unknown Apps"
      ..version = Version.fromString(data["version"] ?? "1.0.0")
      ..cover = RichCover().parse(data["cover"] ?? name, path)
      ..includes = (data["includes"] as YamlList? ?? [])
          .map((m) => Application().loadm(m, path))
          .toList();
  }
}

class Environment extends YamlMetaPackage<EnvironmentIncludes, Environment> {
  late final String details;
  @override
  Environment loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"]!
      ..version = Version.fromString(data["version"] ?? "1.0.0")
      ..cover = RichCover().parse(data["cover"] ?? name, path)
      ..details = data["details"] ?? ""
      ..includes = EnvironmentIncludes().loadm(data["includes"], path);
  }
}

class EnvironmentIncludes extends YamlMetaData<EnvironmentIncludes> {
  late final List<String> paths;
  late final Map<String, String> overwrite;
  @override
  EnvironmentIncludes loadm(Map data, [String? path]) {
    var root = Directory(path ?? "");
    return super.loadm(data, path)
      ..overwrite = ((data["overwrite"] as YamlMap?) ?? {})
          .map((key, value) => MapEntry(key.toString(), value.toString()))
      ..paths = (((data["paths"] as YamlList?)?.toList() ?? []).cast())
          .map((pth) => "${root.absolute.subPath(pth)};")
          .toList();
  }
}

class Documents extends YamlMetaPackage<List<DocumentEntry>, Documents> {
  @override
  Documents loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"]
      ..version = Version.fromString(data["version"] ?? "1.0.0")
      ..cover = RichCover().parse(data["cover"] ?? name, path)
      ..includes = ((data["includes"] as YamlList?) ?? [])
          .map((data) => DocumentEntry().loadm(data, path))
          .toList();
  }
}

class DocumentEntry extends YamlMetaData<DocumentEntry> {
  late final String name;
  late final String loacation;
  @override
  DocumentEntry loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"]
      ..loacation = "${path!}//${data["location"]}";
  }
}

enum ImportMetaType {
  app,
  env,
  doc,
}

class ImportMetaData extends YamlMetaData<ImportMetaData> {
  late final ImportMetaType type;
  late final String name;
  late final Map _inner;
  @override
  ImportMetaData loadm(Map data, [String? path]) {
    _inner = data;
    data = data["import"];
    switch (data["type"]!) {
      case "app":
        type = ImportMetaType.app;
        break;
      case "env":
        type = ImportMetaType.env;
        break;
      case "doc":
        type = ImportMetaType.doc;
        break;
      default:
        throw Exception("Unknown Import Type");
    }

    return super.loadm(data, path)..name = data["name"] ?? _inner["name"]!;
  }

  (Directory?, FutureLazyDynamicCan<List<YamlMetaPackage>>?) parse() {
    GalleryManager galleryManager = ArcheBus.bus.of();
    var error = (null, null);
    switch (type) {
      case ImportMetaType.app:
        return ApplicationPackage().check(_inner)
            ? (galleryManager.applicationsDir, galleryManager.applications)
            : error;
      case ImportMetaType.env:
        return Environment().check(_inner)
            ? (galleryManager.environmentsDir, galleryManager.environments)
            : error;
      case ImportMetaType.doc:
        return Documents().check(_inner)
            ? (galleryManager.documentsDir, galleryManager.documents)
            : error;
      default:
        return (null, null);
    }
  }
}
