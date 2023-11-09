import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class SystemInfoPage extends StatelessWidget {
  const SystemInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    return ScaffoldPage.scrollable(
      header: banner(context),
      children: [
      ],
    );
  }
}
