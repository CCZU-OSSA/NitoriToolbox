import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/ffi.dart';

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
          title("通用设置", level: 2),
          CardListTile(
            title: text("缓存"),
            subtitle: text("Cache"),
            trailing: Row(children: [
              text(() {
                var cache = Directory("cache");
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
                  child: text("清空"),
                  onPressed: () {
                    setState(() {
                      var cache = Directory("cache");
                      cache
                          .listSync(recursive: true)
                          .forEach((element) => element.delete());
                    });
                  })
            ]),
          ),
          title("内核设置", level: 2),
          CardListTile(
            title: text("内核版本"),
            subtitle: text("Core Version"),
            leading: const Icon(FluentIcons.cube_shape_solid),
            trailing: text(bus.nitoriCore.version,
                color: bus.nitoriCore.installed ? null : Colors.red),
          ),
          bus.nitoriCore.installed ? shrink : height05,
          bus.nitoriCore.installed
              ? shrink
              : CardListTile(
                  leading: const Icon(FluentIcons.installation),
                  title: text("安装内核"),
                  subtitle: text("Install Core"),
                  trailing: Button(
                      child: text("选择"),
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
          title("外观设置", level: 2),
          CardListTile(
            leading: const Icon(FluentIcons.color),
            title: text("应用主题"),
            subtitle: text("Theme"),
            trailing: DropDownButton(
              title: text(getThememodeTranslate(context)),
              items: List.generate(
                  3,
                  (index) => MenuFlyoutItem(
                        text: text(translateThememode(ThemeMode.values[index])),
                        onPressed: () => setState(() {
                          bus.appSetState!(() {
                            bus.config.writeKey("thememode", index);
                          });
                        }),
                      )),
            ),
          ),
          height05,
          CardListTile(
            leading: const Icon(FluentIcons.graph_symbol),
            title: text("背景透明度"),
            subtitle: text("Opacity"),
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
          height05,
          Card(
              child: ListTile(
            title: text("窗口材质"),
            subtitle: text("Material"),
            leading: const Icon(FluentIcons.cube_shape),
            trailing: DropDownButton(
                title: text(getWindowEffectTranslate(context)),
                items: List.generate(
                  5,
                  (index) => MenuFlyoutItem(
                      text: text(translateWindowEffect(index)),
                      onPressed: () => setState(() {
                            bus.appSetState!(() {
                              bus.config.writeKey("wineffect", index);
                            });
                          })),
                )),
          )),
          height05,
          Card(
              child: Expander(
                  trailing: ToggleSwitch(
                      checked: bus.config.getOrWrite("use_custom_bg", false),
                      onChanged: (bool v) => setState(() {
                            bus.appSetState!(
                                () => bus.config.writeKey("use_custom_bg", v));
                          })),
                  header: Row(
                    children: [
                      height20,
                      const Icon(FluentIcons.image_pixel),
                      const SizedBox(
                        width: 10,
                      ),
                      text("背景图片"),
                      height20
                    ],
                  ),
                  content: Column(
                    children: [
                      ListTile(
                        title: text("图片透明度"),
                        trailing: Slider(
                            value: bgOpactiy!,
                            label: "$bgOpactiy",
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
                        title: text("背景图片类型"),
                        trailing: Row(
                          children: [
                            RadioButton(
                                checked:
                                    bus.config.getOrWrite("bg_type", 0) == 0,
                                content: text("系统壁纸"),
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
                                content: text("本地图片"),
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
                                content: text("网络图片"),
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
                        leading: text("本地图片地址", size: 16),
                        title: Button(
                            child: text("更换"),
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
                          child: text(bus.config.getOrDefault("bg_path", ""),
                              size: 12),
                        ),
                      ),
                      height05,
                      ListTile(
                          title: text("网络图片地址"),
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
