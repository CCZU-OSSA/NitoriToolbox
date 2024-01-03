import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/block.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/models/enums.dart';
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
  Shell shell = Shell();
  List<Widget> get viewContent => output
      .map<Widget>((e) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText("User : ${e.title}"),
                Card(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      SelectableText.rich(TextSpan(
                          children: e.contents
                              .map(
                                (e) => TextSpan(
                                  text: "${e.$2}\n",
                                  style: TextStyle(
                                    color: e.$1 ? null : Colors.red,
                                  ),
                                ),
                              )
                              .toList())),
                      e.status == TaskStatus.block
                          ? const CircularProgressIndicator()
                          : e.status == TaskStatus.done
                              ? const Icon(Icons.done)
                              : const Icon(Icons.cancel),
                    ]).padding12())
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
    if (output.isNotEmpty && output.last.status != TaskStatus.done) {
      output.last.status = TaskStatus.cancel;
    }

    var block = Block(title: textController.text, contents: []);
    setState(() {
      output.add(block);
    });

    shell.start(textController.text, []).then((value) {
      subscribe(Stream<List<int>> stream, bool ok) => stream.listen(
            (event) {
              var text = UnionDecoder.instance.convert(event).trim();

              if (text.isNotEmpty) {
                setState(() {
                  output[index].add(ok, text);
                });
              }

              scrollController.animateTo(
                  scrollController.position.maxScrollExtent,
                  duration: Durations.medium4,
                  curve: Curves.linear);
            },
            onDone: () => setState(
              () => block.status = TaskStatus.done,
            ),
          );

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
            appBar: AppBar(
              title: PopupMenuButton(
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
                        });
                      }
                    });
                    return;
                  }
                  setState(() {
                    config.write(ConfigKeys.customShell, false);
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
            ),
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
