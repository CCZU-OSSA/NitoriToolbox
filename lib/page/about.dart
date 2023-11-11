import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/widgets/contributor.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateAboutPage();
}

class _StateAboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("about"), title: "关于", subtitle: "ABOUT"),
        children: [
          title("开发者名单"),
          const Row(
            children: [
              Contributor(
                "https://avatars.githubusercontent.com/u/88923783",
                home: "https://github.com/H2Sxxa",
                name: "H2Sxxa",
                role: "程序 / 美术",
              )
            ],
          ),
          title("源代码"),
          title("链接")
        ]);
  }
}
