import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class TerminalPage extends StatefulWidget {
  const TerminalPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateTerminalPage();
}

class _StateTerminalPage extends State<TerminalPage> {
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();
  Shell shell = Shell();
  static List<List<String>> output = [];

  @override
  void dispose() {
    super.dispose();
    textController.dispose();
    scrollController.dispose();
    shell.process?.kill();
  }

  void sendProcess() {
    if (textController.text.isEmpty) {
      return;
    }
    int index = output.length;
    output.add([textController.text]);
    shell.start(textController.text, []).then((value) {
      value.stdout.asStringStream().listen((event) {
        setState(() {
          if (event.trim().isNotEmpty) {
            output[index].add(event.trim());
          }
        });
        scrollController.animateTo(scrollController.position.maxScrollExtent,
            duration: Durations.medium4, curve: Curves.linear);
      });
    });
    textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var config = ArcheBus.config;
    return config.getOr(ConfigKeys.dev, false)
        ? Scaffold(
            body: ListView(
                    controller: scrollController,
                    children: output
                        .map<Widget>((e) => Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SelectableText("User : ${e[0]}"),
                                  Card(
                                      child: SelectableText(
                                              e.sublist(1).join("\n"))
                                          .padding12())
                                ]))
                        .toList())
                .padding12(),
            bottomNavigationBar: ListTile(
              title: TextField(
                  controller: textController,
                  onSubmitted: (_) => sendProcess(),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  )),
              trailing: IconButton(
                  onPressed: () => sendProcess(), icon: const Icon(Icons.send)),
            ),
          )
        : const Center(
            child: Text("已在非开发者模式下禁用"),
          );
  }
}
