import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/ffi.dart';
import 'package:nitoritoolbox/core/lang.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<SettingsPage> {
  double? opacity;
  double? bgOpactiy;
  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    opacity ??= bus.config.getOrWrite("opacity", 0.9);
    bgOpactiy ??= bus.config.getOrWrite("custom_bg_opactiy", 0.2);
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("settings"), title: "设置", subtitle: "SETTINGS"),
        children: [
          const NitoriTitle("通用设置", level: 2),
          CardListTile(
            leading: const Icon(FluentIcons.size_legacy),
            title: const NitoriText("保存窗口大小"),
            subtitle: const NitoriText("Save Window Size"),
            trailing: ToggleSwitch(
                checked: bus.config.getOrWrite("save_win_size", false),
                onChanged: (v) => setState(() {
                      bus.config.writeKey("save_win_size", v);
                    })),
          ),
          CardListTile(
            leading: const Icon(FluentIcons.broom),
            title: const NitoriText("缓存"),
            subtitle: const NitoriText("Cache"),
            trailing: Row(children: [
              NitoriText(() {
                var cache =
                    bus.dataManager.getDirectory().subdir("cache").check();
                if (cache.existsSync()) {
                  double total = 0;
                  cache.listSync(recursive: true).forEach((element) {
                    var status = element.statSync();
                    if (status.type == FileSystemEntityType.file) {
                      total += status.size / 1024 / 1024;
                    }
                  });
                  return "${total.toStringAsFixed(2)}MB";
                }
                return "0.00MB";
              }()),
              width20,
              Button(
                  child: const NitoriText("清空"),
                  onPressed: () {
                    setState(() {
                      bus.dataManager
                          .getDirectory()
                          .subdir("cache")
                          .check()
                          .listSync(recursive: true)
                          .forEach((element) => element.delete());
                    });
                  })
            ]),
          ),
          const NitoriTitle("内核设置", level: 2),
          CardListTile(
            title: const NitoriText("内核版本"),
            subtitle: const NitoriText("Core Version"),
            leading: const Icon(FluentIcons.cube_shape_solid),
            trailing: NitoriText(bus.nitoriCore.version,
                color: bus.nitoriCore.installed ? null : Colors.red),
          ),
          bus.nitoriCore.installed ? shrink : height05,
          bus.nitoriCore.installed
              ? shrink
              : CardListTile(
                  leading: const Icon(FluentIcons.installation),
                  title: const NitoriText("安装内核"),
                  subtitle: const NitoriText("Install Core"),
                  trailing: Button(
                      child: const NitoriText("选择"),
                      onPressed: () {
                        FilePicker.platform.pickFiles(
                          allowMultiple: false,
                          type: FileType.custom,
                          allowedExtensions: ["dll"],
                        ).then((value) => setState(() {
                              bus.appSetState!(() {
                                if (value != null) {
                                  File(value.paths[0]!)
                                      .copySync("./nitori_core.dll");
                                  bus.nitoriCore = NitoriCore();
                                }
                              });
                            }));
                      }),
                ),
          height40,
          const NitoriTitle("外观设置", level: 2),
          CardListTile(
            leading: const Icon(FluentIcons.color),
            title: const NitoriText("应用主题"),
            subtitle: const NitoriText("Theme"),
            trailing: DropDownButton(
              menuColor: getCurrentThemePriColor(context),
              title: NitoriText(getThememodeTranslate(context)),
              items: List.generate(
                  3,
                  (index) => MenuFlyoutItem(
                        text: NitoriText(
                            translateThememode(ThemeMode.values[index])),
                        onPressed: () => setState(() {
                          bus.appSetState!(() {
                            bus.config.writeKey("thememode", index);
                          });
                        }),
                      )),
            ),
          ),
          CardListTile(
            leading: const Icon(FluentIcons.graph_symbol),
            title: const NitoriText("背景透明度"),
            subtitle: const NitoriText("Opacity"),
            trailing: Slider(
                value: opacity!,
                label: "$opacity",
                max: 1,
                min: 0,
                onChanged: (double value) => setState(() {
                      opacity = double.parse(value.toStringAsFixed(2));
                    }),
                onChangeEnd: (value) => bus.appSetState!(() {
                      bus.config.writeKey("opacity", opacity);
                    })),
          ),
          CardListTile(
            title: const NitoriText("窗口材质"),
            subtitle: const NitoriText("Material"),
            leading: const Icon(FluentIcons.cube_shape),
            trailing: DropDownButton(
                menuColor: getCurrentThemePriColor(context),
                title: NitoriText(getWindowEffectTranslate(context)),
                items: List.generate(
                  5,
                  (index) => MenuFlyoutItem(
                      text: NitoriText(translateWindowEffect(index)),
                      onPressed: () => setState(() {
                            bus.appSetState!(() {
                              bus.config.writeKey("wineffect", index);
                            });
                          })),
                )),
          ),
          Card(
              child: Expander(
                  trailing: ToggleSwitch(
                      checked: bus.config.getOrWrite("use_custom_bg", false),
                      onChanged: (bool v) => setState(() {
                            bus.appSetState!(
                                () => bus.config.writeKey("use_custom_bg", v));
                          })),
                  header: const Row(
                    children: [
                      height20,
                      Icon(FluentIcons.image_pixel),
                      SizedBox(
                        width: 10,
                      ),
                      NitoriText("背景图片"),
                      height20
                    ],
                  ),
                  content: Column(
                    children: [
                      ListTile(
                        title: const NitoriText("图片透明度"),
                        trailing: Slider(
                            value: bgOpactiy!,
                            max: 1,
                            min: 0,
                            onChanged: (double value) => setState(() {
                                  bgOpactiy =
                                      double.parse(value.toStringAsFixed(2));
                                }),
                            onChangeEnd: (value) => bus.appSetState!(() {
                                  bus.config
                                      .writeKey("custom_bg_opactiy", bgOpactiy);
                                })),
                      ),
                      height05,
                      ListTile(
                        title: const NitoriText("背景图片类型"),
                        trailing: Row(
                          children: [
                            RadioButton(
                                checked:
                                    bus.config.getOrWrite("bg_type", 0) == 0,
                                content: const NitoriText("系统壁纸"),
                                onChanged: (v) {
                                  setState(() {
                                    bus.appSetState!(() {
                                      bus.config.writeKey("bg_type", 0);
                                    });
                                  });
                                }),
                            width20,
                            RadioButton(
                                checked:
                                    bus.config.getOrWrite("bg_type", 0) == 1,
                                content: const NitoriText("本地图片"),
                                onChanged: (v) {
                                  setState(() {
                                    bus.appSetState!(() {
                                      bus.config.writeKey("bg_type", 1);
                                    });
                                  });
                                }),
                            width20,
                            RadioButton(
                                checked:
                                    bus.config.getOrWrite("bg_type", 0) == 2,
                                content: const NitoriText("网络图片"),
                                onChanged: (v) {
                                  setState(() {
                                    bus.appSetState!(() {
                                      bus.config.writeKey("bg_type", 2);
                                    });
                                  });
                                })
                          ],
                        ),
                      ),
                      height05,
                      ListTile(
                        leading: const NitoriText("本地图片地址", size: 16),
                        title: Button(
                            child: const NitoriText("更换"),
                            onPressed: () {
                              FilePicker.platform
                                  .pickFiles(
                                      type: FileType.image,
                                      allowMultiple: false)
                                  .then((value) => setState(() {
                                        bus.appSetState!(() {
                                          if (value != null) {
                                            bus.config.writeKey(
                                                "bg_path", value.paths[0]);
                                          }
                                        });
                                      }));
                            }),
                        trailing: SizedBox(
                          width: 400,
                          child: NitoriText(
                              bus.config.getOrDefault("bg_path", ""),
                              size: 12),
                        ),
                      ),
                      height05,
                      ListTile(
                          title: const NitoriText("网络图片地址"),
                          trailing: SizedBox(
                              width: 300,
                              child: TextBox(
                                  onSubmitted: (v) {
                                    setState(() {
                                      bus.appSetState!(() {
                                        bus.config.writeKey("bg_url", v);
                                      });
                                    });
                                  },
                                  placeholder:
                                      bus.config.getOrWrite("bg_url", "")))),
                    ],
                  )))
        ]);
  }
}
