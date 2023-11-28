import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';

class LocalBinPage extends StatefulWidget {
  const LocalBinPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateLocalBinPage();
}

class _StateLocalBinPage extends State<LocalBinPage> {
  late LocalDataManager _dm;

  @override
  void initState() {
    super.initState();
    _dm = LocalDataManager.instance(context);
  }

  @override
  Widget build(BuildContext context) {
    var bindir = _dm.getDirectory().subdir("bin").check();
    var localpkg = bindir.subfile("pkg.json");
    if (localpkg.existsSync()) {
      return const Center(
        child: NitoriText(
          "{{ 空 }}",
          size: 40,
        ),
      );
    }
    var onecard = SizedBox(
      height: 148,
      width: 148,
      child: const Card(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FluentIcons.app_icon_default,
            size: 48,
          ),
          height05,
          NitoriText("Application")
        ],
      )).makeButton().tooltip("message"),
    );
    //var _ =
    //    JsonSerializerStatic.decoden(localpkg.readAsStringSync())["packages"];
    return ScaffoldPage.scrollable(header: banner(context), children: [
      const NitoriTitle("应用"),
      Wrap(
        children: [
          onecard,
          onecard,
          onecard,
          onecard,
          onecard,
          onecard,
          onecard,
          onecard,
          onecard
        ],
      )
    ]);
  }
}
