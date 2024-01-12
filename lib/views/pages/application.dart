import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:nitoritoolbox/views/widgets/markdown.dart';

class ApplicationPage extends StatelessWidget {
  final Application application;
  const ApplicationPage({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("应用详情"),
      ),
      body: ListView(
        children: [
          Card(
              child: ListTile(
            leading: const Icon(Icons.terminal),
            title: Text(application.name),
            subtitle: Text(application.version),
          )),
          Card(
            child: MarkdownBlockWidget(
              data: application.details,
            ),
          ),
          Center(
              child: Wrap(
            children: List.generate(
              20,
              (index) => CardButton(
                onTap: () {},
                size: const Size.square(120),
                child: const Text("启动"),
              ),
            ),
          ))
        ],
      ).padding12(),
    );
  }
}
