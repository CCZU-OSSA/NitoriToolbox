import 'dart:io';

import 'package:arche/extensions/io.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/version.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:yaml/yaml.dart';

abstract class MetaEntity<T extends MetaEntity<T>> {
  late final String path;
  T loadm(Map data, [String? path]) {
    return (this..path = data["path"] ?? path ?? "") as T;
  }

  T loads(String data, [String? path]) {
    return loadm(loadYaml(data), path);
  }
}

abstract interface class Widgetlize {
  Widget build({double? size});
}

abstract interface class Parser<T> {
  T parse(data, [String? path]);
}

class RichCover extends MetaEntity<RichCover>
    implements Widgetlize, Parser<RichCover> {
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

  @override
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

class CoverIcon extends MetaEntity<CoverIcon>
    implements Widgetlize, Parser<CoverIcon?> {
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

  @override
  CoverIcon? parse(data, [String? path]) {
    if (data == null) {
      return null;
    }

    return CoverIcon().loadm(data, path);
  }
}

class CoverImage extends MetaEntity<CoverImage>
    implements Widgetlize, Parser<CoverImage?> {
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

  @override
  CoverImage? parse(data, [String? path]) {
    if (data == null) {
      return null;
    }

    return CoverImage().loadm(data, path);
  }
}

class ApplicationFeatureStep extends MetaEntity<ApplicationFeatureStep> {
  late final String details;
  late final List<String> run;

  @override
  ApplicationFeatureStep loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..details = data["details"] ?? ""
      ..run = (data["run"] as String).lines();
  }
}

class ApplicationFeature extends MetaEntity<ApplicationFeature> {
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

class Application extends MetaEntity<Application> {
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

class ApplicationPackage extends MetaEntity<ApplicationPackage> {
  late final String name;
  late final VersionType version;
  late final RichCover cover;
  late final List<Application> includes;

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

class Environment extends MetaEntity<Environment> {
  late final String name;
  late final VersionType version;
  late final String details;
  late final EnvironmentIncludes includes;
  late final RichCover cover;
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

class EnvironmentIncludes extends MetaEntity<EnvironmentIncludes> {
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

class ImportMeta extends MetaEntity<ImportMeta> {
  late final String type;

  @override
  ImportMeta loadm(Map data, [String? path]) {
    return super.loadm(data, path)..type = data["type"]!;
  }
}
