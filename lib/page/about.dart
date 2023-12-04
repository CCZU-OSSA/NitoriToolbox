import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/contributor.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:nitoritoolbox/page/init.dart';
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
      ),
      const Contributor(
        "https://avatars.githubusercontent.com/u/139380707",
        home: "https://github.com/Mikotoshire",
        name: "岚裘",
      ),
      const Contributor(
        "https://avatars.githubusercontent.com/u/140062830",
        home: "https://github.com/F22cat",
        name: "SuzumeArashi",
      )
    ]);
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("about"), title: "关于", subtitle: "ABOUT"),
        children: [
          const NitoriTitle("开发者名单"),
          const Contributor(
            "https://avatars.githubusercontent.com/u/150149909",
            home: "https://github.com/CCZU-OSSA",
            name: "常州大学开源软件协会",
          ),
          height20,
          Wrap(alignment: WrapAlignment.center, children: contributors),
          const NitoriTitle("链接"),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              IconButton(
                      icon: const Icon(
                        FontAwesome5Brands.github,
                        size: 80,
                      ),
                      onPressed: () => launchUrlString(
                          "https://github.com/CCZU-OSSA/NitoriToolbox"))
                  .tooltip("项目地址"),
              IconButton(
                      icon: const Icon(
                        FontAwesome5Brands.qq,
                        size: 80,
                      ),
                      onPressed: () => launchUrlString(
                          "http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=7pLS1X9ZExK2yc0OOYtU3_EgxrAO-4HG&authKey=ZcNnuiuKh3sW5HrahOHnlJ0elCdTBX3N1L3wxNXHbmJNu%2BCQ50iivsgL%2FXY4AX%2Ft&noverify=0&group_code=947560153"))
                  .tooltip("QQ群"),
              IconButton(
                      icon: const Icon(
                        FluentIcons.home_solid,
                        size: 80,
                      ),
                      onPressed: () =>
                          launchUrlString("https://cczu-ossa.github.io/home/"))
                  .tooltip("OSSA主页"),
              IconButton(
                      icon: const Icon(
                        FontAwesome5Brands.discord,
                        size: 80,
                      ),
                      onPressed: () =>
                          launchUrlString("https://discord.gg/4GcpTTCh"))
                  .tooltip("Discord频道"),
              IconButton(
                      icon: const Icon(
                        FluentIcons.bug_solid,
                        size: 80,
                      ),
                      onPressed: () => launchUrlString(
                          "https://github.com/CCZU-OSSA/NitoriToolbox/issues"))
                  .tooltip("汇报错误/提供意见"),
              IconButton(
                  icon: const Icon(
                    FluentIcons.book_answers,
                    size: 80,
                  ),
                  onPressed: () {
                    ApplicationBus.instance(context)
                        .router!
                        .pushWidget(context, const InitPage(dopop: true,));
                  }).tooltip("打开用前须知")
            ].joinElementF(width05),
          ),
          const NitoriTitle("开源协议"),
          const Card(child: NitoriAsset("LICENSE"))
        ]);
  }
}
