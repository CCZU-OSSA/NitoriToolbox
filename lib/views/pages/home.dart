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
      children: [
        Card(
            child: const Center(
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "NITORI",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 42,
                  fontStyle: FontStyle.italic),
            ),
            Text(
              "TOOLBOX",
              style: TextStyle(fontSize: 42, fontStyle: FontStyle.italic),
            )
          ]),
        ).padding12()),
        Wrap(
            children: List.generate(
                1,
                (index) => Material(
                    child: Card(
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {},
                            child: const SizedBox.square(
                              dimension: 128,
                              child: Center(
                                child: Text("Hello"),
                              ),
                            )))))),
      ],
    ).padding12();
  }
}
