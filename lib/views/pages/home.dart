import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/controllers/navigator.dart';
import 'package:nitoritoolbox/views/widgets/builder.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:nitoritoolbox/views/widgets/markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static Future<(IconData, String, String)> get deviceData async {
    // TODO Platform `Linux` & `MacOS`
    var plugin = DeviceInfoPlugin();
    if (Platform.isWindows) {
      var platform = await plugin.windowsInfo;
      return (
        FontAwesomeIcons.windows,
        platform.computerName,
        "${platform.productName} - ${platform.displayVersion} Build ${platform.buildNumber}",
      );
    }

    return (Icons.close, "TODO", "TODO");
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: deviceData,
      builder: snapshotLoading<(IconData, String, String)>(
        builder: (data) {
          return ListView(
            children: [
              const ListTile(
                title: Text(
                  "欢迎使用Nitori ToolBox!",
                  style: TextStyle(fontSize: 24),
                ),
              ),
              Card(
                child: ListTile(
                  leading: Icon(
                    data.$1,
                    size: 36,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(
                    data.$2,
                    style: TextStyle(
                        fontSize: 36,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  subtitle: Text(data.$3),
                ).padding12(),
              ),
              Card(
                child: Wrap(
                  spacing: 8,
                  children: [
                    IconButton.filled(
                      onPressed: () => launchUrlString(
                          "https://github.com/CCZU-OSSA/NitoriToolbox/wiki"),
                      icon: const Icon(FontAwesomeIcons.book),
                    ).text("WIKI"),
                    IconButton.filled(
                      onPressed: () => AppNavigator.pushPage(
                        builder: (context) => const AssetTextPage("README.md"),
                      ),
                      icon: const Icon(FontAwesomeIcons.book),
                    ).text("README"),
                    IconButton.filled(
                      onPressed: () => AppNavigator.pushPage(
                        builder: (context) => const AssetTextPage(
                          "LICENSE",
                          markdown: false,
                        ),
                      ),
                      icon: const Icon(FontAwesomeIcons.book),
                    ).text("LICENSE"),
                    IconButton.filled(
                      onPressed: () => launchUrlString(
                          "https://github.com/CCZU-OSSA/NitoriToolbox/issues"),
                      icon: const Icon(Icons.bug_report),
                    ).text("反馈建议"),
                    IconButton.filled(
                      onPressed: () => launchUrlString(
                          "https://github.com/CCZU-OSSA/NitoriToolbox"),
                      icon: const Icon(FontAwesomeIcons.github),
                    ).text("开源仓库"),
                  ],
                ).padding12(),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension _TextBottom on IconButton {
  Widget text(String data) {
    return SizedBox.square(
      dimension: 80,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [this, Text(data, overflow: TextOverflow.ellipsis)],
      ),
    );
  }
}
