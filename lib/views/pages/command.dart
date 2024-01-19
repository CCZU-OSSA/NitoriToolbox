import 'dart:io';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class ExecCommandsPage extends StatefulWidget {
  final ApplicationFeature feature;
  final Application application;
  final String? workingDirectory;
  const ExecCommandsPage({
    super.key,
    required this.application,
    required this.feature,
    this.workingDirectory,
  });

  @override
  State<StatefulWidget> createState() => StateExecCommandsPage();
}

class StateExecCommandsPage extends State<ExecCommandsPage> {
  final List<String> contents = [];
  late ISolateShell shell;
  late final List<String> missEnvironments;

  @override
  void initState() {
    super.initState();

    var galleryManager = ArcheBus.bus.of<GalleryManager>();
    Map<String, String> env = {};
    missEnvironments = [];
    env.addAll(Platform.environment);
    var additional = galleryManager.environments.value;
    var require = widget.application.environments.map((name) {
      var filter = additional.where((add) => add.name == name);
      if (filter.isEmpty) {
        missEnvironments.add(name);
      } else {
        return filter.first;
      }
    }).toList();
    if (missEnvironments.isNotEmpty) {
      return;
    }
    for (var reqenv in require) {
      var includes = reqenv!.includes;
      env.addAll(includes.overwrite);
      env["PATH"] = "${includes.paths.join()}${env["PATH"]}";
    }

    shell = ISolateShell(
        workingDirectory: widget.workingDirectory, perferEnvironment: env);
    shell.bind((data) => setState(() => contents.add(data.trim())));
  }

  @override
  void dispose() {
    super.dispose();
    try {
      shell.deactivate();
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("控制台"),
      ),
      body: missEnvironments.isNotEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    missEnvironments.map((e) => Text("缺失环境: $e")).toList(),
              ),
            )
          : ListView(
              children: [
                Row(children: [
                  ElevatedButton.icon(
                      label: const Text("执行"),
                      onPressed: () {
                        if (!shell.connect) {
                          shell.activate();
                        }
                        for (var element in widget.feature.run) {
                          shell.write(element);
                        }
                      },
                      icon: const Icon(Icons.play_arrow)),
                  ElevatedButton.icon(
                      onPressed: () => setState(() => shell.deactivate()),
                      icon: const Icon(Icons.stop),
                      label: const Text("停止")),
                  ElevatedButton.icon(
                      onPressed: () => setState(() => contents.clear()),
                      icon: const Icon(Icons.cleaning_services),
                      label: const Text("清空"))
                ]),
                Card(
                  child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:
                            widget.feature.run.map((e) => Text(e)).toList(),
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
            ).padding12(),
    );
  }
}
