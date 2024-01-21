import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';

class WindowBar extends StatelessWidget {
  const WindowBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30,
        decoration:
            BoxDecoration(color: Theme.of(context).colorScheme.background),
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
  const WindowWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppController.controllerVisible
            ? const WindowBar()
            : const SizedBox.shrink(),
        Expanded(child: child),
      ],
    );
  }
}
