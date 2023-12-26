import 'package:arche/widgets/material.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/data/keys.dart';
import 'package:nitoritoolbox/page/home.dart';
import 'package:nitoritoolbox/page/settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApplication());
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

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
            theme: ThemeData(
                fontFamily: "GlowSans",
                brightness: Brightness.light,
                useMaterial3: true,
                colorScheme: lightDynamic,
                typography: Typography.material2021()),
            darkTheme: ThemeData(
                fontFamily: "GlowSans",
                brightness: Brightness.dark,
                useMaterial3: true,
                colorScheme: darkDynamic,
                typography: Typography.material2021()),
            themeMode: ThemeMode.system,
            home: Scaffold(
                appBar: PreferredSize(
                    preferredSize: const Size.fromHeight(32),
                    child: Row(children: [
                      Expanded(child: MoveWindow()),
                      Row(
                        children: [
                          MinimizeWindowButton(animate: true),
                          MaximizeWindowButton(animate: true),
                          CloseWindowButton(animate: true),
                        ],
                      ),
                    ])),
                body: NavigationView(
                  key: rootKey,
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
                )));
      },
    );
  }
}
