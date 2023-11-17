import 'package:nitoritoolbox/app/abc/serial.dart';

enum IconType { images, icon }

String iconType2String(IconType type) {
  switch (type) {
    case IconType.icon:
      return "icon";
    default:
      return "image";
  }
}

class SingleApplication extends JsonSerializer implements TypeMap {
  final IconType iconType;
  final String title;
  final String subtitle;
  final String background;
  static final empty = SingleApplication("", "", "", IconType.icon);

  SingleApplication(this.title, this.subtitle, this.background, this.iconType);

  @override
  Map<K, V> toMap<K, V>() {
    return {
      "iconType": iconType2String(iconType),
      "title": title,
      "subtitle": subtitle,
      "background": background
    }.cast<K, V>();
  }

  static SingleApplication fromString(String data) {
    return fromMap(JsonSerializerStatic.decode(data));
  }

  static SingleApplication fromMap(Map data) {
    return SingleApplication(
        data["title"], data["subtitle"], data["background"], IconType.images);
  }
}

class ApplicationList extends JsonSerializer implements TypeMap {
  final List<SingleApplication> apps;
  static final empty = ApplicationList([]);

  ApplicationList(this.apps);

  static ApplicationList fetch() {
    return fromString("{data}");
  }

  @override
  Map<K, V> toMap<K, V>() {
    return {"apps": apps.map((e) => e.toMap()).toList()}.cast<K, V>();
  }

  static ApplicationList fromString(String data) {
    List<Map> apps = JsonSerializerStatic.decode(data)["apps"];
    return ApplicationList(List.generate(
        apps.length, (index) => SingleApplication.fromMap(apps[index])));
  }
}
