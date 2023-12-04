import 'dart:ui';

import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter_acrylic/flutter_acrylic.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/config.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:nitoritoolbox/page/init.dart';
import 'package:nitoritoolbox/page/plugins/localbin.dart';
import 'package:nitoritoolbox/page/plugins/recommend.dart';
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
import 'package:system_theme/system_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var config = ApplicationConfig("app.config.json");
  await SystemTheme.accentColor.load();
  await Window.initialize();
  doWhenWindowReady(() {
    final win = appWindow;
    win.title = "Nitori Toolbox";
    win.alignment = Alignment.center;
    win.minSize = const Size(700, 550);
    win.show();
  });
  AppLifecycleListener(
    onExitRequested: () async {
      config.writeKey("win_width", appWindow.size.width);
      config.writeKey("win_height", appWindow.size.height);
      return AppExitResponse.exit;
    },
  );
  runApp(Provider.value(
      value: ApplicationBus(config), child: const ApplicationMain()));
}

class ApplicationMain extends StatefulWidget {
  const ApplicationMain({super.key});

  @override
  State<StatefulWidget> createState() => StateApplicationMain();
}

class StateApplicationMain extends State<ApplicationMain> {
  late PaneRouter __router;

  @override
  void initState() {
    super.initState();
    __router = PaneRouter(
      body: {
        "home": PaneItem(
            title: text("主页"),
            icon: const Icon(FluentIcons.home),
            body: const HomePage()),
        "sep0": PaneItemSeparator(),
        "header0": PaneItemHeader(header: const NitoriText("官方插件")),
        "archiver": PaneItem(
            title: text("应用推荐"),
            icon: const Icon(FluentIcons.like),
            body: const RecommendPage()),
        "localbin": PaneItem(
            title: text("本地应用"),
            icon: const Icon(FluentIcons.all_apps),
            body: const LocalBinPage()),
        "sysinfo": PaneItem(
            title: text("系统信息"),
            icon: const Icon(FluentIcons.info),
            body: const SystemInfoPage()),
        "sep1": PaneItemSeparator(),
        "header1": PaneItemHeader(header: const NitoriText("社区插件")),
      },
      footer: {
        "settings": PaneItem(
            title: text("设置"),
            icon: const Icon(FluentIcons.settings),
            body: const SettingsPage()),
        "abouts": PaneItem(
            title: text("关于"),
            icon: const Icon(FluentIcons.chat),
            body: const AboutPage())
      },
      setState: setState,
    );
    ApplicationBus bus = ApplicationBus.instance(context);
    if (bus.config.getOrDefault("save_win_size", false)) {
      appWindow.size = Size(bus.config.getOrDefault("win_width", 600),
          bus.config.getOrDefault("win_height", 450));
    }
  }

  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    bus.appSetState = setState;
    bus.router = __router;
    applyWindowEffect(context);
    var view = NavigationView(
      appBar: NavigationAppBar(
          leading: Image.asset(
            "resource/images/nitori_icon.png",
            height: 32,
            width: 32,
          ),
          title: const Text(
            "Nitori Toolbox",
            style: TextStyle(fontSize: 20),
          )),
      pane: NavigationPane(
          displayMode:
              PaneDisplayMode.values[bus.config.getOrWrite("panedisplay", 4)],
          selected: __router.select,
          items: __router.body.values.toList(),
          footerItems: __router.footer.values.toList()),
    ).renderTheme(context);
    return FluentApp(
        key: rootKey,
        title: 'Nitori Toolbox',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: getThemeMode(context),
        home:
            bus.config.firstuse ? const InitPage().renderTheme(context) : view);
  }
}
