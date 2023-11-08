import 'package:fluent_ui/fluent_ui.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';

class SystemInfoPage extends StatelessWidget {
  const SystemInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DeviceInfoPlugin().windowsInfo,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          WindowsDeviceInfo info = snapshot.data!;
          return ScaffoldPage.scrollable(header: banner(context), children: [
            height40,
            title("用户", level: 2),
            Card(child: Text("${info.userName}@${info.computerName}")),
            height20,
            title("系统", level: 2),
            Card(
                child: Text(
                    "${info.productName} ${info.displayVersion} Build.${info.buildNumber}")),
            height20,
            title("账户", level: 2),
            Card(child: Text(info.registeredOwner)),
            height20,
            Card(
              child: Text(
                  "${info.numberOfCores}核 内存${(info.systemMemoryInMegabytes / 1024).toString()}G"),
            ),
          ]);
        } else {
          return const ProgressRing();
        }
      },
    );
  }
}
