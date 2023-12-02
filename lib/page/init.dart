import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class InitPage extends StatelessWidget {
  const InitPage({super.key});

  @override
  Widget build(BuildContext context) {
    ApplicationBus.instance(context).config.writeKey("know_to_use", true);
    return Container(
        decoration: BoxDecoration(
            color: getCurrentThemePriColor(context),
            image: getWallpaper(context)),
        child: ScaffoldPage.scrollable(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "resource/images/nitori_icon.png",
                width: 120,
                height: 120,
              ),
              height20,
              const NitoriText(
                "用前须知",
                size: 48,
              ),
              height05,
              const SizedBox(
                width: 450,
                height: 500,
                child: Card(
                  child: SingleChildScrollView(
                    child: NitoriAsset("resource/text/markdown/init.md"),
                  ),
                ),
              ),
              height20,
              FilledButton(
                  child: const NitoriText(
                    "已了解",
                    size: 16,
                  ),
                  onPressed: () =>
                      ApplicationBus.instance(context).appSetState!(() {
                        ApplicationBus.instance(context)
                            .config
                            .writeKey("know_to_use", true);
                      }))
            ],
          )
        ]));
  }
}
