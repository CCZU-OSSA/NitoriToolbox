import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/widgets/contributor.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateAboutPage();
}

class _StateAboutPage extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> contributors = ([
      const Contributor(
        "https://avatars.githubusercontent.com/u/88923783",
        home: "https://github.com/H2Sxxa",
        name: "H2Sxxa",
        role: "程序 / 美术",
      ),
      const Contributor(
        "https://avatars.githubusercontent.com/u/139380707",
        home: "https://github.com/Mikotoshire",
        name: "岚裘",
        role: "贡献者",
      ),
      const Contributor(
        "https://avatars.githubusercontent.com/u/140062830",
        home: "https://github.com/F22cat",
        name: "SuzumeArashi",
        role: "贡献者",
      )
    ]);
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("about"), title: "关于", subtitle: "ABOUT"),
        children: [
          title("开发者名单"),
          const Contributor(
            "https://avatars.githubusercontent.com/u/150149909",
            home: "https://github.com/CCZU-OSSA",
            name: "常州大学开源软件协会",
            role: "(CCZU OSSA)",
          ),
          height20,
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: contributors.joinElement(const SizedBox(
                width: 15,
              ))),
          title("链接"),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.github,
                    size: 80,
                  ),
                  onPressed: () => launchUrlString(
                      "https://github.com/CCZU-OSSA/NitoriToolbox")),
              width05,
              IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.qq,
                    size: 80,
                  ),
                  onPressed: () => launchUrlString(
                      "http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=7pLS1X9ZExK2yc0OOYtU3_EgxrAO-4HG&authKey=ZcNnuiuKh3sW5HrahOHnlJ0elCdTBX3N1L3wxNXHbmJNu%2BCQ50iivsgL%2FXY4AX%2Ft&noverify=0&group_code=947560153")),
              width05,
              IconButton(
                  icon: const Icon(
                    FluentIcons.bug_solid,
                    size: 80,
                  ),
                  onPressed: () => launchUrlString(
                      "https://github.com/CCZU-OSSA/NitoriToolbox/issues"))
            ],
          ),
          title("开源协议"),
          Card(
              child: FutureBuilder(
            future: rootBundle.loadString("LICENSE"),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return NitoriText(snapshot.data!);
              } else {
                return loading;
              }
            },
          ))
        ]);
  }
}
