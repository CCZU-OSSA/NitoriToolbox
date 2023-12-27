
import 'package:arche/arche.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/models/keys.dart';
import 'package:nitoritoolbox/views/pages/home.dart';
import 'package:nitoritoolbox/views/pages/settings.dart';
import 'package:nitoritoolbox/models/configkeys.dart';
import 'package:nitoritoolbox/views/widgets/appbar.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var data = AppData("AppData");
  ArcheBus.bus.provide(data).provide(data.config());
  runApp(const AppEntryPoint());
  AppController.initLifeCycleListener();
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = 'Nitori Toolbox';
    win.show();
  });
}

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return MainApplication(
      key: rootKey,
    );
  }
}

class MainApplication extends StatefulWidget {
  const MainApplication({super.key});
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
            home: WindowWidget(
                child: Scaffold(
                    body: NavigationView(
              key: viewkey,
              items: const [
                NavigationItem(
                    icon: Icon(Icons.home),
                    label: Text("Home"),
                    page: HomePage()),
                NavigationItem(
                    icon: Icon(Icons.settings),
                    label: Text("Settings"),
                    page: SettingsPage())
              ],
              config: NavigationRailConfig(
                  labelType: NavigationRailLabelType
                      .values[config.getOr(ConfigKeys.raillabelType, 0)]),
            ))));
      },
    );
  }
}
