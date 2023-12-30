import 'dart:io';

import 'package:flutter/material.dart';
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
    var wallpaper = getWallPaperPath();
    return Stack(children: [
      this,
      IgnorePointer(
          child: wallpaper == null
              ? const SizedBox.shrink()
              : Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          opacity: 0.1,
                          image: FileImage(File(wallpaper)))),
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
