import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:nitoritoolbox/app/protocol/store.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/scrollable.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateStorePage();
}

class _StateStorePage extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
        header: banner(
          context,
          image: "resource/images/store.png",
          title: "商店",
          subtitle: "STORE",
        ),
        children: [
          const NitoriAsset("resource/text/markdown/store.md"),
          const NitoriTitle("Build-In Packages"),
          SmartFutureBuilder(
              future: rootBundle.loadString("resource/data/store/daily.json"),
              smartbuilder: (context, data) {
                var al = ApplicationList.fromString(data);
                return NitoriHorizonScrollView(
                  title: al.title,
                  subtitle: al.subtitle,
                  content: List.generate(al.apps.length, (index) {
                    var sa = al.apps[index];
                    var card = SquareCard(
                        title: sa.title,
                        subtitle: sa.subtitle,
                        background: sa.background,
                        onPressed: () => launchUrlString(sa.open),
                        icon: sa.buildIcon());
                    return sa.details != null
                        ? Tooltip(
                            message: sa.details,
                            child: card,
                          )
                        : card;
                  }),
                );
              }),
          const NitoriTitle("Local Packages")
        ]);
  }
}
