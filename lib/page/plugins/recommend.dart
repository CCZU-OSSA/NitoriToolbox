import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:nitoritoolbox/app/protocol/recommend.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/scrollable.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:url_launcher/url_launcher_string.dart';

class StorePage extends StatefulWidget {
  const StorePage({super.key});

  @override
  State<StatefulWidget> createState() => _StateStorePage();
}

class _StateStorePage extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return SmartFutureBuilder(
        future: recommends(),
        smartbuilder: (context, locals) {
          return ScaffoldPage.scrollable(
              header: banner(
                context,
                image: imagePNG("recommend"),
                title: "应用推荐",
                subtitle: "RECOMMEMD",
              ),
              children: [
                const NitoriAsset("resource/text/markdown/recommend.md"),
                const NitoriTitle("Build-In Packages"),
              ]
                  .castF<Widget>()
                  .expandAll(List.generate(
                    locals.length,
                    (index) => SmartFutureBuilder(
                        future: rootBundle.loadString(locals[index]),
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
                                  titleScale: sa.titleScale,
                                  onPressed: () => launchUrlString(sa.open),
                                  icon: sa.buildIcon());
                              return sa.details != null
                                  ? card.tooltip(sa.details!)
                                  : card;
                            }),
                          );
                        }),
                  ))
                  .expandAll(
                [
                  const NitoriTitle("Local Packages"),
                ],
              ));
        });
  }
}
