import 'package:arche/modules/application.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/models/configkeys.dart';
import 'package:nitoritoolbox/views/pages/license.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateSettingsPage();
}

class _StateSettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    var config = ArcheBus.config;
    return ListView(
      children: [
        const ListTile(
          title: Text("通用"),
        ),
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: const Text("退出前确认"),
                trailing: Switch(
                  value: config.getOr(ConfigKeys.exitConfirm, false),
                  onChanged: (value) => setState(() {
                    config.write(ConfigKeys.exitConfirm, value);
                  }),
                ),
              )
            ],
          ),
        ),
        const ListTile(
          title: Text("外观"),
        ),
        Card(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.color_lens),
              title: const Text("主题模式"),
              trailing: PopupMenuButton<ThemeMode>(
                initialValue:
                    ThemeMode.values[config.getOr(ConfigKeys.theme, 2)],
                tooltip: "主题模式",
                icon: const Icon(Icons.edit),
                onSelected: (ThemeMode theme) => setState(
                  () => AppController.refreshAppConfig(ConfigKeys.theme, theme),
                ),
                itemBuilder: (BuildContext context) => const [
                  PopupMenuItem(
                    value: ThemeMode.light,
                    child: Text('浅色'),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.dark,
                    child: Text('深色'),
                  ),
                  PopupMenuItem(
                    value: ThemeMode.system,
                    child: Text('系统'),
                  ),
                ],
              ),
            ),
            ListTile(
                leading: const Icon(Icons.label),
                title: const Text("导航栏标签"),
                trailing: PopupMenuButton<NavigationRailLabelType>(
                  icon: const Icon(Icons.edit),
                  tooltip: "导航栏标签",
                  onSelected: (NavigationRailLabelType type) => setState(
                    () => AppController.refreshAppConfig(
                        ConfigKeys.raillabelType, type),
                  ),
                  initialValue: NavigationRailLabelType
                      .values[config.getOr(ConfigKeys.raillabelType, 0)],
                  itemBuilder: (context) => const [
                    PopupMenuItem(
                        value: NavigationRailLabelType.none, child: Text("空")),
                    PopupMenuItem(
                        value: NavigationRailLabelType.selected,
                        child: Text("选中")),
                    PopupMenuItem(
                        value: NavigationRailLabelType.all, child: Text("全部")),
                  ],
                ))
          ],
        )),
        const ListTile(
          title: Text("关于"),
        ),
        Card(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.book),
                title: const Text("许可证"),
                trailing: IconButton(
                    onPressed: () => showLicensePageWithBar(
                        context: context,
                        applicationName: "Nitori Toolbox",
                        applicationVersion: "0.0.1-Preview"),
                    icon: const Icon(Icons.navigate_next)),
              ),
              const ListTile(
                leading: Icon(Icons.person),
                title: Text("贡献者"),
              ),
              ListTile(
                leading: const Icon(FontAwesomeIcons.github),
                title: const Text("开源地址"),
                trailing: IconButton(
                    onPressed: () => launchUrlString(
                        "https://github.com/CCZU-OSSA/NitoriToolbox"),
                    icon: const Icon(Icons.public)),
              ),
            ],
          ),
        ),
      ],
    ).padding12();
  }
}
