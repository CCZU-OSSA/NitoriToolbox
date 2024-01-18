import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/models/static/keys.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:window_manager/window_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateHomePage();
}

class _StateHomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        FilledButton(
            onPressed: () {
              windowManager.setFullScreen(true);
              AppController.setControllerVisible(visible: false);
              windowManager.setResizable(false);
              rootKey.currentState!.refresh();
            },
            child: const Text("Full Screen")),
        FilledButton(
            onPressed: () {
              windowManager.setFullScreen(false);
              windowManager.setResizable(true);
              AppController.setControllerVisible(visible: true);
              rootKey.currentState!.refresh();
            },
            child: const Text("Exit Full Screen"))
      ],
    ).padding12();
  }
}
