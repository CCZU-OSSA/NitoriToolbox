import 'dart:convert';

import 'package:arche/arche.dart';
import 'package:fast_gbk/fast_gbk.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/block.dart';
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
  List<Widget> get viewContent => output
      .map<Widget>((e) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText("User : ${e.title}"),
                Card(
                    child: SelectableText.rich(TextSpan(
                            children: e.contents.indexed
                                .map((v) {
                                  var (i, j) = v.$2;
                                  if (v.$1 != e.contents.length - 1) {
                                    j += "\n";
                                  }
                                  return (i, j);
                                })
                                .map(
                                  (e) => TextSpan(
                                    text: e.$2,
                                    style: TextStyle(
                                      color: e.$1 ? null : Colors.red,
                                    ),
                                  ),
                                )
                                .toList()))
                        .padding12())
              ]))
      .toList();

  static List<Block> output = [];

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
    var block = Block(title: textController.text, contents: []);
    setState(() {
      output.add(block);
    });
    shell.start(textController.text, []).then((value) {
      subscribe(Stream<List<int>> stream, bool ok) => stream.listen((event) {
            String text;
            try {
              text = utf8.decode(event);
            } catch (e) {
              text = gbk.decode(event);
            }
            setState(() {
              if (text.trim().isNotEmpty) {
                output[index].add(ok, text.trim());
              }
            });

            scrollController.animateTo(
                scrollController.position.maxScrollExtent,
                duration: Durations.medium4,
                curve: Curves.linear);
          });
      subscribe(value.stdout, true);
      subscribe(value.stderr, false);
    });
    textController.clear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(
        scrollController.position.maxScrollExtent,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    var config = ArcheBus.config;
    return config.getOr(ConfigKeys.dev, false)
        ? Scaffold(
            body: ListView(
              controller: scrollController,
              children: viewContent,
            ).padding12(),
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
