import 'dart:io';

import 'package:arche/modules/application.dart';
import 'package:arche/modules/widgets.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/models/translators.dart';
import 'package:nitoritoolbox/views/pages/license.dart';
import 'package:nitoritoolbox/views/widgets/config.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';
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
              ConfigSwitchListTile(
                leading: const Icon(Icons.info),
                title: const Text("退出提示"),
                config: config,
                configKey: ConfigKeys.exitConfirm,
              ),
              ConfigSwitchListTile(
                leading: const Icon(Icons.update),
                title: const Text("更新检查"),
                config: config,
                configKey: ConfigKeys.checkUpdate,
              ),
              ConfigSwitchListTile(
                leading: const Icon(Icons.developer_mode),
                title: const Text("开发者模式"),
                config: config,
                configKey: ConfigKeys.dev,
                confirm: () async {
                  return (await basicFullScreenDialog<bool>(
                    title: const Text("警告"),
                    content: const Text("此功能可能会对此计算机造成损害，开启后所有责任与损失均由使用者承担"),
                    context: context,
                    confirmData: () => true,
                    cancelData: () => false,
                  ))!;
                },
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
                trailing: CETPopupMenuButton(
                  translator: trThemeMode,
                  config: config,
                  configKey: ConfigKeys.theme,
                )),
            ListTile(
                leading: const Icon(Icons.label),
                title: const Text("导航栏标签"),
                trailing: CETPopupMenuButton(
                  translator: trNavigationLabelType,
                  config: config,
                  configKey: ConfigKeys.railLabelType,
                )),
            ExpansionTile(
              leading: const Icon(Icons.image),
              title: const Text("背景图片"),
              shape: Border.all(color: Colors.transparent),
              children: [
                ConfigSwitchListTile(
                  title: const Text("开启"),
                  config: config,
                  configKey: ConfigKeys.backgroundImageEnable,
                ),
                ListTile(
                  title: const Text("图片类型"),
                  trailing: CETPopupMenuButton(
                    translator: trBackgroundImageType,
                    config: config,
                    configKey: ConfigKeys.backgroundImageType,
                  ),
                ),
                ListTile(
                  title: const Text("透明度"),
                  subtitle: ValueStateBuilder(
                    initial: ArcheBus.config
                        .getOr(ConfigKeys.backgroundImageOpacity, 0.3),
                    builder: (context, value, update) => Slider(
                      value: value,
                      max: 0.5,
                      onChanged: (value) => update(value),
                      onChangeEnd: (value) =>
                          AppController.refreshAppValueConfig(
                              ConfigKeys.backgroundImageOpacity, value),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text("本地图片"),
                  trailing: Card(
                    child: InkWell(
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                      onTap: () async {
                        AppController.loading();
                        await FilePicker.platform
                            .pickFiles(
                                type: FileType.image, dialogTitle: "选择图片")
                            .then(
                          (value) {
                            if (value != null) {
                              setState(
                                () => AppController.refreshAppValueConfig(
                                  ConfigKeys.backgroundImageLocal,
                                  value.files.first.path,
                                ),
                              );
                            }
                            AppController.pop();
                          },
                        );
                      },
                      child: config.tryGet(ConfigKeys.backgroundImageLocal) ==
                                  null ||
                              !File(config.get(ConfigKeys.backgroundImageLocal))
                                  .existsSync()
                          ? const SizedBox.square(
                              dimension: 120,
                            )
                          : Image.file(
                              File(config.get(ConfigKeys.backgroundImageLocal)),
                            ),
                    ),
                  ),
                ),
                ListTile(
                  title: const Text("网络图片"),
                  trailing: IconButton(
                      onPressed: () async {
                        var value = await editDialog(context,
                            initial: config.getOr(
                                ConfigKeys.backgroundImageNetwork, "https://"));
                        if (value != null) {
                          AppController.refreshAppValueConfig(
                              ConfigKeys.backgroundImageNetwork, value);
                        }
                      },
                      icon: const Icon(Icons.edit)),
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
