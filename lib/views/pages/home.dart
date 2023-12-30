import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/views/pages/software.dart';

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
        Wrap(
            children: List.generate(
                1,
                (index) => Material(
                    child: Card(
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () => AppController.pushMaterialPage(
                                builder: (context) => const SoftWare()),
                            child: const SizedBox.square(
                              dimension: 128,
                              child: Center(
                                child: Text("Hello"),
                              ),
                            )))))),
      ],
    );
  }
}
