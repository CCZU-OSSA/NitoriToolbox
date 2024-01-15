import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateTerminalPage();
}

class _StateTerminalPage extends State<TerminalPage> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Shell shell = ISolateShell();

  static List<String> output = [];

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    scrollController.dispose();
    shell.deactivate();
  }

  void sendProcess(BuildContext context) {
    if (textController.text.isEmpty) {
      return;
    }
    if (!shell.connect) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("请先激活Shell环境")));
      return;
    }

    shell.write(textController.text);
    textController.clear();
  }

  @override
  void initState() {
    super.initState();
    var config = ArcheBus.config;
    if (config.getOr(ConfigKeys.customShell, false)) {
      shell.perferShell = ArcheBus.config.tryGet(ConfigKeys.shellPath);
    }
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
    shell.bind((event) {
      if (event.trim().isNotEmpty) {
        setState(() {
          output.add(event);
          scrollController.jumpTo(
            scrollController.position.maxScrollExtent,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var config = ArcheBus.config;
    return config.getOr(ConfigKeys.dev, false)
        ? Scaffold(
            appBar: AppBar(
                title: Row(children: [
              PopupMenuButton(
                icon: const Icon(Icons.settings),
                initialValue: config.getOr(ConfigKeys.customShell, false),
                onSelected: (value) {
                  if (value == true) {
                    editDialog(
                      context,
                      title: "输入需要使用的Shell文件地址",
                      initial: config.tryGet(ConfigKeys.shellPath),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          config.write(ConfigKeys.customShell, true);
                          config.write(ConfigKeys.shellPath, value);
                          shell.perferShell = value;
                          shell.reload();
                        });
                      }
                    });
                    return;
                  }
                  setState(() {
                    config.write(ConfigKeys.customShell, false);
                    shell.reload();
                  });
                  shell.perferShell = null;
                },
                tooltip: "Shell设置",
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: false,
                    child: Text("使用系统默认Shell"),
                  ),
                  const PopupMenuItem(
                    value: true,
                    child: Text("使用自定义Shell"),
                  )
                ],
              ),
              IconButton(
                  onPressed: () => shell.activate(),
                  icon: const Icon(Icons.play_arrow)),
              IconButton(
                  onPressed: () => shell.deactivate(),
                  icon: const Icon(Icons.stop)),
              IconButton(
                  onPressed: () => setState(() => output.clear()),
                  icon: const Icon(Icons.cleaning_services))
            ])),
            body: ListView(
              controller: scrollController,
              children: output.map((e) => Text(e)).toList(),
            ).padding12(),
            bottomNavigationBar: ListTile(
              title: TextField(
                  controller: textController,
                  onSubmitted: (_) => sendProcess(context),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              trailing: IconButton(
                  onPressed: () => sendProcess(context),
                  icon: const Icon(Icons.send)),
            ),
          )
        : const Center(
            child: Text("已在非开发者模式下禁用"),
          );
  }
}
