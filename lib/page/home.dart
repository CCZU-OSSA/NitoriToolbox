import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var bus = ApplicationBus.instance(context);
    return ScaffoldPage.scrollable(children: [
      Card(
          borderColor: getCurrentThemePriColor(context,
              dark: Colors.white.withOpacity(0.8),
              light: Colors.grey.withOpacity(0.8)),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              NitoriText("NITORI",
                  isdisplay: true,
                  size: 60,
                  color:
                      Colors.blue.withOpacity(0.8).lerpWith(Colors.white, 0.1)),
              NitoriText("TOOLBOX",
                  isdisplay: true,
                  size: 60,
                  color: getCurrentThemePriColor(context,
                      dark: Colors.white.withOpacity(0.8),
                      light: Colors.grey.withOpacity(0.8)))
            ],
          )),
      height40,
      const NitoriTitle("欢迎使用 Nitori Toolbox", level: 1),
      Button(
          child: const NitoriText("前往设置"),
          onPressed: () {
            bus.router?.pushName("settings");
          })
    ]);
  }
}
