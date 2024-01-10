import 'package:yaml/yaml.dart';

extension _YamlSerializer on String {
  YamlMap yaml() {
    return loadYaml(this);
  }
}

abstract class MapLoader<T> {
  T loadm(Map data);

}

mixin YamlMapLoader<T> on MapLoader<T> {
  T loads(String data) {
    return loadm(data.yaml());
  }
}

class Application extends MapLoader<Application> with YamlMapLoader {
  late final String name;
  late final String version;
  late final String launchPath;

  @override
  Application loadm(Map data) {
    return this
      ..name = data["name"] ?? "Unknown App"
      ..version = data["version"] ?? "Unknown Version"
      ..launchPath = data["launchPath"]!;
  }
}

class ApplicationPackage extends MapLoader<ApplicationPackage>
    with YamlMapLoader {
  late final String name;
  late final String version;
  late final List<Application> manifest;

  @override
  ApplicationPackage loadm(Map data) {
    return this
      ..name = data["name"] ?? "Unknown Apps"
      ..version = data["version"] ?? "v1.0.0"
      ..manifest = (data["manifest"] as Iterable)
          .map((m) => Application().loadm(m))
          .toList();
  }
}

class Document extends MapLoader<Document> with YamlMapLoader {
  late String name;
  late String content;

  @override
  Document loadm(Map data) {
    // TODO: implement loadm
    throw UnimplementedError();
  }
}

class DocumentPackage extends MapLoader<DocumentPackage> with YamlMapLoader {
  late final List<Document> documents;

  @override
  DocumentPackage loadm(Map data) {
    return DocumentPackage();
  }
}
