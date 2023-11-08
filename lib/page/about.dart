import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.scrollable(
        header: banner(context,
            image: imagePNG("about"), title: "关于", subtitle: "ABOUT"),
        children: const []);
  }
}
