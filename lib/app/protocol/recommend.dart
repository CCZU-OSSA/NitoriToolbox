import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';

class SingleApplication extends JsonSerializer implements TypeMap {
  final dynamic icon;
  final String title;
  final String subtitle;
  final String open;
  final bool usefonticon;
  final bool usefaicon;
  final double? titleScale;
  final String? background;
  final String? details;
  static final empty = SingleApplication();

  SingleApplication({
    this.title = "",
    this.subtitle = "",
    this.background,
    this.titleScale = 1,
    this.icon,
    this.open = "",
    this.details,
    this.usefonticon = false,
    this.usefaicon = false,
  });

  @override
  Map<K, V> toMap<K, V>() {
    return {
      "title": title,
      "titleScale": titleScale,
      "subtitle": subtitle,
      "background": background,
      "icon": icon,
      "usefonticon": usefonticon,
      "usefaicon": usefaicon,
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
      usefaicon: data["usefaicon"] ?? false,
      titleScale: data["titleScale"] ?? 1.0,
    );
  }

  Widget buildIcon() {
    if (icon == null) {
      return const Icon(
        FontAwesome5Solid.icons,
        color: Colors.grey,
        size: 45,
      );
    }
    if (!usefonticon) {
      return Image.network(
        icon,
        height: 45,
        width: 45,
      );
    } else {
      var data = IconData(
        int.parse(icon["code"]),
        fontFamily: icon["fontfamily"],
        fontPackage: icon["fontpackage"],
      );
      return usefaicon
          ? FaIcon(
              data,
              color: Colors.grey,
              size: 45,
            )
          : Icon(
              data,
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
