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

  SingleApplication(this.title, this.subtitle, this.background,
      {required this.iconType});

  @override
  Map<K, V> toMap<K, V>() {
    return {
      "iconType": iconType2String(iconType),
      "title": title,
      "subtitle": subtitle,
      "background": background
    }.cast<K, V>();
  }
}

class ApplicationList {
  static ApplicationList fetch() {
    return ApplicationList();
  }
}
