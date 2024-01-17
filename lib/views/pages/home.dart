import 'package:flutter/material.dart';
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
            onPressed: () => windowManager.setFullScreen(true),
            child: const Text("Full Screen"))
      ],
    ).padding12();
  }
}
