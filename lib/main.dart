import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/page/plugins/sysinfo.dart';
import 'package:provider/provider.dart';

import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/router/router.dart';
import 'package:nitoritoolbox/app/widgets/keys.dart';
import 'package:nitoritoolbox/page/settings.dart';
import 'package:nitoritoolbox/page/home.dart';
import 'package:nitoritoolbox/page/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Window.initialize();
  doWhenWindowReady(() {
    final win = appWindow;
    win.title = "Nitori Toolbox";
    win.alignment = Alignment.center;
    win.minSize = const Size(600, 450);
    win.show();
  });
  runApp(
      Provider.value(value: ApplicationBus(), child: const ApplicationMain()));
}

class ApplicationMain extends StatefulWidget {
  const ApplicationMain({super.key});

  @override
  State<StatefulWidget> createState() => StateApplicationMain();
}

class StateApplicationMain extends State<ApplicationMain> {
  PaneRouter? __router;

  @override
  void initState() {
    super.initState();
    __router ??= PaneRouter(body: [
      PaneItem(
          title: text("主页"),
          icon: const Icon(FluentIcons.home),
          body: const HomePage()),
      PaneItemSeparator(),
      PaneItemHeader(header: const NitoriText("官方插件")),
      PaneItem(
          title: text("系统信息"),
          icon: const Icon(FluentIcons.info),
          body: const SystemInfoPage()),
      PaneItemSeparator(),
      PaneItemHeader(header: const NitoriText("社区插件"))
    ], footer: [
      PaneItem(
          title: text("设置"),
          icon: const Icon(FluentIcons.settings),
          body: const SettingsPage()),
      PaneItem(
          title: text("关于"),
          icon: const Icon(FluentIcons.chat),
          body: const AboutPage())
    ], setState: setState);
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    bus.appSetState = setState;
    bus.router = __router;
    applyWindowEffect(context);
    return FluentApp(
        key: rootKey,
        title: 'Nitori Toolbox',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: getThemeMode(context),
        home: NavigationPaneTheme(
            data: NavigationPaneThemeData(
                backgroundColor: isDark(context)
                    ? Colors.grey
                        .withOpacity(bus.config.getOrWrite("opacity", 0.9))
                    : Colors.white
                        .withOpacity(bus.config.getOrWrite("opacity", 0.9))),
            child: Container(
                decoration: BoxDecoration(image: getWallpaper(context)),
                child: NavigationView(
                  appBar: const NavigationAppBar(
                      leading: Icon(FontAwesomeIcons.microsoft),
                      title: Text(
                        "Nitori Toolbox",
                        style: TextStyle(fontSize: 20),
                      )),
                  pane: NavigationPane(
                      selected: __router!.select,
                      items: __router!.body,
                      footerItems: __router!.footer),
                ))));
  }
}
