import 'dart:io';

import 'package:arche/arche.dart';
import 'package:arche/extensions/io.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controllers/navigator.dart';
import 'package:nitoritoolbox/controllers/appdata.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/models/static/keys.dart';
import 'package:nitoritoolbox/models/github.dart';
import 'package:nitoritoolbox/views/pages/gallery.dart';
import 'package:nitoritoolbox/views/pages/home.dart';
import 'package:nitoritoolbox/views/pages/settings.dart';
import 'package:nitoritoolbox/views/pages/terminal.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:window_manager/window_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  var data = AppData(Directory("AppData").check());
  ArcheBus.bus
      .provide(data)
      .provide(data.config)
      .provide(data.galleryManager)
      .provide(GithubRepository(ApplicationInfo.githubRepoName));
  runApp(MainApplication());
  AppNavigator.initLifeCycleListener();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = ApplicationInfo.applicationName;
    win.show();
    if (ArcheBus.config.getOr(ConfigKeys.checkUpdate, false)) {
      GithubRepository gr = ArcheBus.bus.of();
      AppNavigator.loadingDo((context, updateText, updateProgress) async {
        updateText("正在检查更新");
        await gr.updateDialog();
      });
    }
  });
}

class MainApplication extends StatefulWidget {
  MainApplication() : super(key: rootKey);
  @override
  State<StatefulWidget> createState() => StateMainApplication();
}

class StateMainApplication extends State<MainApplication> {
  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var config = ArcheBus.config;
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          theme: ThemeData(
              fontFamily: "GlowSans",
              brightness: Brightness.light,
              useMaterial3: true,
              colorScheme: lightDynamic,
              appBarTheme:
                  const AppBarTheme(surfaceTintColor: Colors.transparent),
              typography: Typography.material2021()),
          darkTheme: ThemeData(
              fontFamily: "GlowSans",
              brightness: Brightness.dark,
              useMaterial3: true,
              colorScheme: darkDynamic,
              appBarTheme:
                  const AppBarTheme(surfaceTintColor: Colors.transparent),
              typography: Typography.material2021()),
          themeMode: ThemeMode.values[config.getOr(ConfigKeys.theme, 2)],
          home: WindowContainer(
            child: Scaffold(
              body: NavigationView(
                key: viewkey,
                items: const [
                  NavigationItem(
                      icon: Icon(Icons.home),
                      label: "主页",
                      page: HomePage(),
                      name: "home"),
                  NavigationItem(
                    icon: Icon(Icons.apps),
                    label: "应用",
                    page: GalleryPage(),
                    name: "apps",
                  ),
                  NavigationItem(
                    icon: Icon(Icons.terminal),
                    label: "终端",
                    page: TerminalPage(),
                    name: "terminal",
                  ),
                  NavigationItem(
                    name: "settings",
                    icon: Icon(Icons.settings),
                    label: "设置",
                    page: SettingsPage(),
                  )
                ],
                labelType: NavigationLabelType
                    .values[config.getOr(ConfigKeys.labelType, 0)],
              ),
            ),
          ),
        );
      },
    );
  }
}
