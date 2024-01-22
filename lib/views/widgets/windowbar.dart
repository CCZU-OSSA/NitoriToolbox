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
    return Container(
        height: 30,
        decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).colorScheme.background),
        child: Row(children: [
          Expanded(child: MoveWindow()),
          Row(
            children: [
              MinimizeWindowButton(animate: true),
              MaximizeWindowButton(animate: true),
              CloseWindowButton(animate: true),
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
