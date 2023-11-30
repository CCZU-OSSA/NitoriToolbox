import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';
import 'package:nitoritoolbox/app/protocol/application.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class LocalBinPage extends StatefulWidget {
  const LocalBinPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateLocalBinPage();
}

class _StateLocalBinPage extends State<LocalBinPage> {
  late LocalDataManager _dm;
  late ScrollController _scr;
  late ListObserverController _obscr;
  @override
  void initState() {
    super.initState();
    _dm = LocalDataManager.instance(context);
    _scr = ScrollController();
    _obscr = ListObserverController(controller: _scr);
  }

  @override
  Widget build(BuildContext context) {
    var bindir = _dm.getDirectory().subdir("bin-local").check();
    var localpkg = bindir.subfile("pkg.json");
    if (!localpkg.existsSync()) {
      return const Center(
        child: NitoriText(
          "{{ 空 }}",
          size: 40,
        ),
      );
    }
    return SmartFutureBuilder(
      future: () async {
        return (JsonSerializerStatic.decoden(
            await localpkg.readAsString())["packages"] as List);
      }(),
      smartbuilder: (BuildContext context, data) {
        return ListViewObserver(
            controller: _obscr,
            child: ScaffoldPage.scrollable(
                scrollController: _scr,
                header: Button(
                    child: const Text("jump"),
                    onPressed: () => _obscr.animateTo(
                        index: 0,
                        duration: const Duration(seconds: 1),
                        curve: Curves.ease)),
                children: List.generate(
                    data.length,
                    (index) => SmartFutureBuilder(
                        future: () async {
                          return ApplicationList.fromString(await bindir
                              .subfile("${data[index]}/pkg.json")
                              .readAsString());
                        }(),
                        smartbuilder: (context, al) => Column(
                              children: [
                                Card(
                                    child: SizedBox(
                                  width: 100000,
                                  child: Column(
                                    children: [
                                      NitoriText(
                                        al.title,
                                        size: 30,
                                      ),
                                      NitoriText(al.subtitle)
                                    ],
                                  ),
                                )),
                                height05,
                                Wrap(
                                  children: List.generate(
                                      al.apps.length,
                                      (index) => SizedBox(
                                            height: 148,
                                            width: 148,
                                            child: Card(
                                                    child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                al.apps[index].buildIcon(
                                                    context,
                                                    reverse: true,
                                                    localdir: bindir
                                                        .subdir(data[index])),
                                                height05,
                                                NitoriText(
                                                  al.apps[index].title,
                                                  size: 15 *
                                                      (al.apps[index]
                                                              .titleScale ??
                                                          1),
                                                ),
                                                NitoriText(
                                                  al.apps[index].subtitle,
                                                  size: 10,
                                                )
                                              ],
                                            ))
                                                .makeButton(
                                                    onLongPressed: () =>
                                                        Process.run(
                                                            "start",
                                                            [
                                                              bindir
                                                                  .subdir(data[
                                                                      index])
                                                                  .subfile(al
                                                                      .apps[
                                                                          index]
                                                                      .open)
                                                                  .absolute
                                                                  .path
                                                            ],
                                                            runInShell: true))
                                                .tooltip(
                                                    al.apps[index].details ??
                                                        ""),
                                          )),
                                ),
                                height20,
                                const SizedBox(
                                  height: 1000,
                                )
                              ],
                            )))));
      },
    );
  }
}
