import 'dart:io';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/models/enums.dart';
import 'package:nitoritoolbox/utils/platform_windows.dart';
import 'package:nitoritoolbox/views/widgets/windowbar.dart';

extension NitoriWidgetExtension on Widget {
  Widget padding12() {
    return padding(12);
  }

  Widget padding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget windowbar() {
    return WindowWidget(child: this);
  }

  Widget background() {
    var config = ArcheBus.config;

    if (!config.getOr(ConfigKeys.backgroundImageEnable, false)) {
      return this;
    }

    ImageProvider? image;

    switch (BackgroundImageType
        .values[config.getOr(ConfigKeys.backgroundImageType, 0)]) {
      case BackgroundImageType.wallpaper:
        var wallpaper = getWallPaperPath();
        if (wallpaper == null) {
          image = null;
        } else {
          var f = File(wallpaper);
          image = !f.existsSync() ? null : FileImage(f);
        }
        break;
      case BackgroundImageType.local:
        var wallpaper = config.tryGet(ConfigKeys.backgroundImageLocal);
        if (wallpaper == null) {
          image = null;
        } else {
          var f = File(wallpaper);
          image = !f.existsSync() ? null : FileImage(f);
        }
        break;
      case BackgroundImageType.network:
        var url = config.tryGet(ConfigKeys.backgroundImageNetwork);
        if (url == null) {
          image = null;
        } else {
          image = NetworkImage(url);
        }

        break;
    }

    return Stack(children: [
      this,
      IgnorePointer(
          child: image == null
              ? const SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: config.getOr(
                              ConfigKeys.backgroundImageOpacity, 0.4),
                          image: image)),
                  child: const SizedBox.expand()))
    ]);
  }
}

class WindowContainer extends StatelessWidget {
  final Widget child;
  const WindowContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return WindowWidget(child: child).background();
  }
}
