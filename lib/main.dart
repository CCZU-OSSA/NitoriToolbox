import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/page/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
            theme: ThemeData.light(useMaterial3: true)
                .copyWith(colorScheme: lightDynamic),
            darkTheme: ThemeData.dark(useMaterial3: true)
                .copyWith(colorScheme: darkDynamic),
            themeMode: ThemeMode.system,
            home: Scaffold(
              appBar: AppBar(
                title: const Text("Nitori ToolBox"),
              ),
              body: Row(
                children: [
                  NavigationRail(
                      extended: true,
                      destinations: const [
                        NavigationRailDestination(
                          icon: Icon(Icons.home),
                          label: Text("Home"),
                        ),
                        NavigationRailDestination(
                            icon: Icon(Icons.settings), label: Text("Settings"))
                      ],
                      selectedIndex: 0),
                  const Expanded(
                    child: HomePage(),
                  )
                ],
              ),
            ));
      },
    );
  }
}
