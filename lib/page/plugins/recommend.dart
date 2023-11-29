import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:nitoritoolbox/app/abc/serial.dart';
import 'package:nitoritoolbox/app/protocol/application.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/scrollable.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:url_launcher/url_launcher_string.dart';

class RecommendPage extends StatefulWidget {
  const RecommendPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateRecommendPage();
}

class _StateRecommendPage extends State<RecommendPage> {
  Widget buildView(ApplicationList applicationList, {Directory? localdir}) {
    return NitoriHorizonScrollView(
      title: applicationList.title,
      subtitle: applicationList.subtitle,
      content: List.generate(applicationList.apps.length, (index) {
        var sa = applicationList.apps[index];
        var card = SquareCard(
            title: sa.title,
            subtitle: sa.subtitle,
            titleScale: sa.titleScale,
            onPressed: () => launchUrlString(sa.open),
            icon: sa.buildIcon(localdir: localdir));
        return sa.details != null ? card.tooltip(sa.details!) : card;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    var dm = LocalDataManager.instance(context);
    var rd = dm.getDirectory().subdir("recommend-local").check();
    var localpkg = rd.subfile("pkg.json");
    return SmartFutureBuilder(future: () async {
      return (JsonSerializerStatic.decode(await rootBundle.loadString(
              "resource/data/recommend/pkg.json"))["packages"] as List)
          .map((e) => "resource/data/recommend/$e/pkg.json")
          .toList();
    }(), smartbuilder: (context, locals) {
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
                    smartbuilder: (context, data) =>
                        buildView(ApplicationList.fromString(data))),
              ))
              .expandAll(localpkg.existsSync()
                  ? [
                      const NitoriTitle("Local Packages"),
                    ].castF<Widget>().expandAll(ListUtils.generatefrom(
                      JsonSerializerStatic.decoden(localpkg.readAsStringSync())[
                          "packages"] as List<String>,
                      (v) => SmartFutureBuilder(
                          future: rd.subfile("$v/pkg.json").readAsString(),
                          smartbuilder: (context, data) => buildView(
                              ApplicationList.fromString(data),
                              localdir: rd.subdir(v)))))
                  : []));
    });
  }
}
