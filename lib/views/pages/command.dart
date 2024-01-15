import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class ExecCommandsPage extends StatefulWidget {
  final ApplicationFeature feature;
  final String? workingDirectory;
  const ExecCommandsPage(
    this.feature, {
    super.key,
    this.workingDirectory,
  });

  @override
  State<StatefulWidget> createState() => StateExecCommandsPage();
}

class StateExecCommandsPage extends State<ExecCommandsPage> {
  final List<String> contents = [];
  late ISolateShell shell;

  @override
  void initState() {
    super.initState();
    shell = ISolateShell(workingDirectory: widget.workingDirectory);
  }

  @override
  void dispose() {
    super.dispose();
    shell.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("控制台"),
      ),
      body: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                  label: const Text("执行"),
                  onPressed: () {
                    shell.bind((data) => setState(() => contents.add(data)));
                    shell.activate();
                    for (var element in widget.feature.run) {
                      shell.write(element);
                    }
                  },
                  icon: const Icon(Icons.play_arrow)),
              Card(
                child: SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: widget.feature.run.map((e) => Text(e)).toList(),
                    )).padding12(),
              ),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: contents.map((e) => Text(e)).toList(),
                  ),
                ).padding12(),
              )
            ],
          )
        ],
      ).padding12(),
    );
  }
}
