import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';

class SingleApplication extends JsonSerializer implements TypeMap {
  final dynamic icon;
  final String title;
  final String subtitle;
  final String? background;
  final String open;
  final String? details;
  final bool usefonticon;
  static final empty = SingleApplication();

  SingleApplication({
    this.title = "",
    this.subtitle = "",
    this.background,
    this.icon = "",
    this.open = "",
    this.details,
    this.usefonticon = false,
  });

  @override
  Map<K, V> toMap<K, V>() {
    return {
      "title": title,
      "subtitle": subtitle,
      "background": background,
      "icon": icon,
      "usefonticon": usefonticon,
      "open": open,
      "details": details
    }.cast<K, V>();
  }

  static SingleApplication fromString(String data) {
    return fromMap(JsonSerializerStatic.decode(data));
  }

  static SingleApplication fromMap(Map data) {
    return SingleApplication(
      title: data["title"],
      subtitle: data["subtitle"],
      background: data["background"],
      icon: data["icon"],
      open: data["open"],
      details: data["details"],
      usefonticon: data["usefonticon"] ?? false,
    );
  }

  Widget buildIcon() {
    if (!usefonticon) {
      return Image.network(
        icon,
        height: 45,
        width: 45,
      );
    } else {
      return Icon(
        IconData(
          int.parse(icon["code"]),
          fontFamily: icon["fontfamily"],
          fontPackage: icon["fontpackage"],
        ),
        color: Colors.grey,
        size: 45,
      );
    }
  }
}

class ApplicationList extends JsonSerializer implements TypeMap {
  final List<SingleApplication> apps;
  final String title;
  final String subtitle;
  static final empty = ApplicationList([]);

  ApplicationList(
    this.apps, {
    this.title = "",
    this.subtitle = "",
  });

  static ApplicationList fetch() {
    throw UnimplementedError("TODO");
  }

  @override
  Map<K, V> toMap<K, V>() {
    return {
      "apps": apps.map((e) => e.toMap()).toList(),
      "title": title,
      "subtitle": subtitle
    }.cast<K, V>();
  }

  static ApplicationList fromString(String data) {
    Map<String, dynamic> map = JsonSerializerStatic.decode(data);
    return ApplicationList(
      List.generate(map["apps"].length,
          (index) => SingleApplication.fromMap(map["apps"][index])),
      title: map["title"],
      subtitle: map["subtitle"],
    );
  }
}
