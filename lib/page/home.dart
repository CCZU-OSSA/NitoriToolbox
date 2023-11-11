import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(children: [
      Card(
          borderColor: isDark(context)
              ? Colors.white.withOpacity(0.8)
              : Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              displaytitle("NITORI",
                  color:
                      Colors.blue.withOpacity(0.8).lerpWith(Colors.white, 0.1)),
              displaytitle("TOOLBOX",
                  color: isDark(context)
                      ? Colors.white.withOpacity(0.8)
                      : Colors.black.withOpacity(0.8))
            ],
          )),
      height40,
      title("欢迎使用 Nitori Toolbox", level: 1)
    ]);
  }
}
