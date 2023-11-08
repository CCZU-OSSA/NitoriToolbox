import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingState();
}

class _SettingState extends State<SettingsPage> {
  double? opacity;
  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    opacity ??= bus.config.getOrWrite("opacity", 0.9);
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("settings"), title: "设置", subtitle: "SETTINGS"),
        children: [
          title("外观设置", level: 2),
          Card(
              child: ListTile(
            leading: const Icon(FluentIcons.color),
            title: text("应用主题"),
            subtitle: text("Theme"),
            trailing: DropDownButton(
                title: text(getThememodeTranslate(context)),
                items: [
                  MenuFlyoutItem(
                      text: text(translateThememode(ThemeMode.system)),
                      onPressed: () => setState(() {
                            bus.appSetState!(() {
                              bus.config.writeKey("thememode", 0);
                            });
                          })),
                  MenuFlyoutItem(
                      text: text(translateThememode(ThemeMode.dark)),
                      onPressed: () => setState(() {
                            bus.appSetState!(() {
                              bus.config.writeKey("thememode", -1);
                            });
                          })),
                  MenuFlyoutItem(
                      text: text(translateThememode(ThemeMode.light)),
                      onPressed: () => setState(() {
                            bus.appSetState!(() {
                              bus.config.writeKey("thememode", 1);
                            });
                          })),
                ]),
          )),
          height05,
          Card(
              child: ListTile(
            leading: const Icon(FluentIcons.graph_symbol),
            title: text("背景透明度"),
            subtitle: text("Opacity"),
            trailing: Slider(
                value: opacity!,
                max: 1,
                min: 0,
                onChanged: (double value) => setState(() {
                      opacity = double.parse(value.toStringAsFixed(2));
                    }),
                onChangeEnd: (value) => bus.appSetState!(() {
                      bus.config.writeKey("opacity", opacity);
                    })),
          ))
        ]);
  }
}
