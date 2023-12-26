import 'package:flutter/material.dart';

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
        Card(
          child: Text("Hello world"),
        )
      ],
    );
  }
}
