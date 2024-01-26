import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controllers/navigator.dart';

class WindowBar extends StatelessWidget {
  final Color? backgroundColor;
  const WindowBar({
    super.key,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final themeButtonColors = WindowButtonColors(
        normal: Colors.transparent,
        iconNormal: Theme.of(context).colorScheme.primary,
        mouseOver: const Color(0xFF404040),
        mouseDown: const Color(0xFF202020),
        iconMouseOver: const Color(0xFFFFFFFF),
        iconMouseDown: const Color(0xFFF0F0F0));
    final themeCloseButtonColors = WindowButtonColors(
        mouseOver: const Color(0xFFD32F2F),
        mouseDown: const Color(0xFFB71C1C),
        iconNormal: Theme.of(context).colorScheme.primary,
        iconMouseOver: const Color(0xFFFFFFFF));

    return Container(
        height: 30,
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.background),
        child: Row(children: [
          Expanded(child: MoveWindow()),
          Row(
            children: [
              MinimizeWindowButton(animate: true, colors: themeButtonColors),
              MaximizeWindowButton(animate: true, colors: themeButtonColors),
              CloseWindowButton(animate: true, colors: themeCloseButtonColors),
            ],
          ),
        ]));
  }
}

class WindowWidget extends StatelessWidget {
  final Widget child;
  final Color? backgroundColor;
  const WindowWidget({
    super.key,
    required this.child,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppNavigator.controllerVisible
            ? WindowBar(backgroundColor: backgroundColor)
            : const SizedBox.shrink(),
        Expanded(child: child),
      ],
    );
  }
}
