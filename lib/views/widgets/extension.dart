import 'dart:io';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/static/enums.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/models/platform/platform_windows.dart';
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

    return Stack(
      children: [
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
                        image: image),
                  ),
                  child: const SizedBox.expand(),
                ),
        )
      ],
    );
  }
}

class WindowContainer extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const WindowContainer({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return WindowWidget(
      backgroundColor: backgroundColor,
      child: child,
    ).background();
  }
}
