import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/ffi.dart';

class SystemInfoPage extends StatefulWidget {
  const SystemInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateSystemInfoPage();
}

class _StateSystemInfoPage extends State<SystemInfoPage> {
  static void generateInfos(SendPort port) async {
    NitoriCore core = NitoriCore();
    port.send(core.query([
      "Win32_OperatingSystem",
      "Win32_BaseBoard",
      "Win32_Processor"
    ])!["data"]);
  }

  bool hasData = false;
  Map? data;

  @override
  Widget build(BuildContext context) {
    ApplicationBus bus = ApplicationBus.instance(context);
    NitoriCore core = bus.nitoriCore;

    if (!core.installed) {
      return ScaffoldPage.scrollable(children: [
        Center(child: text("内核未安装", color: Colors.red, size: 32)),
        height20,
        Center(
            child:
                text("设置 -> 内核设置 -> 安装内核 -> 安装 -> 选择nitori_core.dll", size: 24))
      ]);
    }
    if (!hasData) {
      var port = ReceivePort();
      port.listen((message) {
        setState(() {
          hasData = true;
          data = message;
        });
      });
      Isolate.spawn(generateInfos, port.sendPort);
      return loading;
    }

    var sysinfo = data!["Win32_OperatingSystem"][0];
    var baseboard = data!["Win32_BaseBoard"][0];
    return ScaffoldPage.scrollable(header: banner(context), children: [
      title("软件信息"),
      Card(
          child: ListTile(
              title: text("系统版本"),
              subtitle: text("System Version"),
              trailing: text("${sysinfo["Caption"]}#${sysinfo["Version"]}",
                  selectable: true))),
      height05,
      Card(
          child: ListTile(
              title: text("系统架构"),
              subtitle: text("System Arch"),
              trailing: text(sysinfo["OSArchitecture"], selectable: true))),
      height05,
      Card(
          child: ListTile(
        title: text("注册用户"),
        subtitle: text("Registered User"),
        trailing: text(sysinfo["RegisteredUser"], selectable: true),
      )),
      height20,
      title("硬件信息"),
      Expander(
          header: text(baseboard["Caption"]),
          content: Column(
            children: [
              ListTile(
                title: text("制造商"),
                subtitle: text("Manufacturer"),
                trailing: text(baseboard["Manufacturer"], selectable: true),
              ),
              ListTile(
                title: text("产品型号"),
                subtitle: text("Product"),
                trailing: text(baseboard["Product"], selectable: true),
              ),
              ListTile(
                title: text("产品版本"),
                subtitle: text("Version"),
                trailing: text(baseboard["Version"], selectable: true),
              )
            ],
          )),
      height05,
      Expander(
          header: text("处理器"),
          content: const Column(
            children: [],
          ))
    ]);
  }
}
