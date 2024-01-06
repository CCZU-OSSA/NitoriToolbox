import 'package:flutter/material.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateHomePage();
}

class _StateHomePage extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [],
    ).padding12();
  }
}
