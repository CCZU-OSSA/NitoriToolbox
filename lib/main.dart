import 'package:arche/arche.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/models/static/keys.dart';
import 'package:nitoritoolbox/utils/github.dart';
import 'package:nitoritoolbox/views/pages/gallery.dart';
import 'package:nitoritoolbox/views/pages/home.dart';
import 'package:nitoritoolbox/views/pages/settings.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/views/pages/terminal.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var data = AppData("AppData");
  ArcheBus.bus
      .provide(data)
      .provide(data.config())
      .provide(GithubRepository(ApplicationInfo.githubRepoName));
  runApp(MainApplication());
  AppController.initLifeCycleListener();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = ApplicationInfo.applicationName;
    win.show();
    if (ArcheBus.config.getOr(ConfigKeys.checkUpdate, false)) {
      //GithubRepository gr = ArcheBus.bus.of();
      //gr.version();
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
                    label: Text("Home"),
                    page: HomePage()),
                NavigationItem(
                  icon: Icon(Icons.apps),
                  label: Text("Gallery"),
                  page: GalleryPage(),
                ),
                NavigationItem(
                  icon: Icon(Icons.terminal),
                  label: Text("Terminal"),
                  page: TerminalPage(),
                ),
                NavigationItem(
                  name: "Settings",
                  icon: Icon(Icons.settings),
                  label: Text("Settings"),
                  page: SettingsPage(),
                )
              ],
              config: NavigationRailConfig(
                  labelType: NavigationRailLabelType
                      .values[config.getOr(ConfigKeys.railLabelType, 0)]),
            ))));
      },
    );
  }
}
