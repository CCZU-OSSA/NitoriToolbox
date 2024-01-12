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

class Application extends MetaEntity<Application> {
  late final String name;
  late final String version;
  late final String details;

  @override
  Application loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"] ?? "Unknown App"
      ..details = data["details"] ?? "Empty"
      ..version = data["version"] ?? "Unknown Version";
  }
}

class ApplicationPackage extends MetaEntity<ApplicationPackage> {
  late final String name;
  late final String version;
  late final List<Application> manifest;

  @override
  ApplicationPackage loadm(Map data, [String? path]) {
    return super.loadm(data, path)
      ..name = data["name"] ?? "Unknown Apps"
      ..version = data["version"] ?? "v1.0.0"
      ..manifest = (data["manifest"] as YamlList? ?? [])
          .map((m) => Application().loadm(m))
          .toList();
  }
}

class Environment {}

class Document extends MetaEntity<Document> {
  late String name;
  late String content;

  @override
  Document loadm(Map data, [String? path]) {
    throw UnimplementedError();
  }
}

class DocumentPackage extends MetaEntity<DocumentPackage> {
  late final List<Document> documents;

  @override
  DocumentPackage loadm(Map data, [String? path]) {
    return DocumentPackage();
  }
}
