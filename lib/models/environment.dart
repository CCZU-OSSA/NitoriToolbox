import 'package:yaml/yaml.dart';

extension _YamlSerializer on String {
  YamlMap yaml() {
    return loadYaml(this);
  }
}

abstract class _ReadOnlyLoader<T> {
  T loadm(Map data);
}

mixin _ReadOnlyLoaderYamlMixin<T> on _ReadOnlyLoader<T> {
  T loads(String data) {
    return loadm(data.yaml());
  }
}

class Application extends _ReadOnlyLoader<Application>
    with _ReadOnlyLoaderYamlMixin {
  late final String name;
  late final String launchPath;

  @override
  Application loadm(Map data) {
    return this
      ..name = data["name"] ?? "Unknown App"
      ..launchPath = data["launchPath"]!;
  }
}

class ApplicationPackage extends _ReadOnlyLoader<ApplicationPackage>
    with _ReadOnlyLoaderYamlMixin {
  late final String name;
  late final List<Application> manifest;

  @override
  ApplicationPackage loadm(Map data) {
    return this
      ..name = data[""] ?? "Unknown Apps"
      ..manifest = (data["manifest"] as YamlList)
          .map((yaml) => Application().loadm(yaml))
          .toList();
  }
}
