import 'package:arche/modules/application.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/models/translators.dart';
import 'package:nitoritoolbox/views/pages/license.dart';
import 'package:nitoritoolbox/views/widgets/buttons.dart';
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
                leading: const Icon(Icons.info),
                title: const Text("退出提示"),
                trailing: Switch(
                  value: config.getOr(ConfigKeys.exitConfirm, false),
                  onChanged: (value) => setState(() {
                    config.write(ConfigKeys.exitConfirm, value);
                  }),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.update),
                title: const Text("更新检查"),
                trailing: Switch(
                  value: config.getOr(ConfigKeys.checkUpdate, false),
                  onChanged: (value) => setState(() {
                    config.write(ConfigKeys.checkUpdate, value);
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
                trailing: ETCPopupMenuButton(
                  icon: const Icon(Icons.edit),
                  translator: trThemeMode,
                  config: config,
                  configKey: ConfigKeys.theme,
                )),
            ListTile(
                leading: const Icon(Icons.label),
                title: const Text("导航栏标签"),
                trailing: ETCPopupMenuButton(
                  icon: const Icon(Icons.edit),
                  translator: trNavigationLabelType,
                  config: config,
                  configKey: ConfigKeys.railLabelType,
                )),
            ExpansionTile(
              leading: const Icon(Icons.image),
              title: const Text("背景图片"),
              shape: Border.all(color: Colors.transparent),
              children: [
                ListTile(
                  title: const Text("图片类型"),
                  trailing: ETCPopupMenuButton(
                    translator: trBackgroundImageType,
                    config: config,
                    configKey: ConfigKeys.backgroundImageType,
                  ),
                ),
              ],
            ),
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
                        applicationName: ApplicationInfo.applicationName,
                        applicationVersion: ApplicationInfo.applicationVersion,
                        applicationLegalese:
                            ApplicationInfo.applicationLegalese),
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
              ListTile(
                leading: const Icon(FontAwesomeIcons.bug),
                title: const Text("汇报错误"),
                trailing: IconButton(
                    onPressed: () => launchUrlString(
                        "https://github.com/CCZU-OSSA/NitoriToolbox/issues"),
                    icon: const Icon(Icons.public)),
              ),
              ExpansionTile(
                leading: const Icon(Icons.chat),
                title: const Text("用户交流"),
                shape: Border.all(color: Colors.transparent),
                children: [
                  ListTile(
                    leading: const Icon(FontAwesomeIcons.qq),
                    title: const Text("QQ"),
                    trailing: IconButton(
                        onPressed: () => launchUrlString(
                            "http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=6wgGLJ_NmKQl7f9Ws6JAprbTwmG9Ouei&authKey=g7bXX%2Bn2dHlbecf%2B8QfGJ15IFVOmEdGTJuoLYfviLg7TZIsZCu45sngzZfL3KktN&noverify=0&group_code=947560153"),
                        icon: const Icon(Icons.public)),
                  ),
                  ListTile(
                    leading: const Icon(Icons.discord),
                    title: const Text("Discord"),
                    trailing: IconButton(
                        onPressed: () =>
                            launchUrlString("https://discord.gg/zqhURaJ8"),
                        icon: const Icon(Icons.public)),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
