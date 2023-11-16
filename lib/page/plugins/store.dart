import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateStorePage();
}

class _StateStorePage extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    var ctrl = ScrollController();
    return ScaffoldPage.scrollable(
        header: banner(
          context,
          image: "resource/images/store.png",
          title: "商店",
          subtitle: "STORE",
        ),
        children: [
          Card(
              child: Scrollbar(
                  thumbVisibility: false,
                  controller: ctrl,
                  child: SingleChildScrollView(
                    controller: ctrl,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        const Column(children: [
                          NitoriText(
                            "基础组合包",
                            size: 45,
                          ),
                          NitoriText(
                            "BASIC",
                            size: 20,
                          )
                        ]),
                        SquareCard(
                          title: "7-ZIP",
                          subtitle: "解压缩",
                          icon: const Icon(FontAwesomeIcons.fileZipper),
                          onPressed: () {},
                        ),
                      ].joinElement<Widget>(width20),
                    ),
                  )))
        ]);
  }
}
