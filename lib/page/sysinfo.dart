import 'dart:collection';
import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/ffi.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:nitoritoolbox/core/typed.dart';

class SystemInfoPage extends StatefulWidget {
  const SystemInfoPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateSystemInfoPage();
}

class _StateSystemInfoPage extends State<SystemInfoPage> {
  static void _entryPoint(SendPort port) async {
    NitoriCore core = NitoriCore();
    port.send(core.query([
      "Win32_OperatingSystem",
      "Win32_BaseBoard",
      "Win32_Processor",
      "Win32_PhysicalMemory"
    ])!["data"]);
  }

  DataHolder<Map> dataHolder = DataHolder();

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
    if (!dataHolder.hasData) {
      var port = ReceivePort();
      port.listen((v) {
        if (v is Map) {
          if (mounted) {
            setState(() {
              dataHolder.setData(v);
              port.close();
            });
          }
        }
      });
      Isolate.spawn(_entryPoint, port.sendPort);
      return loading;
    }

    Map data = dataHolder.getData();
    var sysinfo = data["Win32_OperatingSystem"][0];
    var baseboard = data["Win32_BaseBoard"][0];
    var processor = data["Win32_Processor"][0];

    Map<String, Device> phimemory = HashMap();
    var sumsize = 0;
    for (var i in data["Win32_PhysicalMemory"]) {
      String key = i["PartNumber"];
      bool v = phimemory.containsKey(key);
      v.ifTrue(() => phimemory[key]!.count += 1);
      v.ifFalse(() => phimemory[key] = Device({
            "Manufacturer": i["Manufacturer"],
            "Capacity": i["Capacity"],
            "ConfiguredClockSpeed": i["ConfiguredClockSpeed"],
            "Speed": i["Speed"]
          }));
      sumsize += i["Capacity"] as int;
    }

    return ScaffoldPage.scrollable(header: banner(context), children: [
      title("软件信息"),
      Card(
          child: ListTile(
        leading: const Icon(FontAwesomeIcons.computer),
        title: text("本机名称"),
        subtitle: text("Machine Name"),
        trailing: text(sysinfo["CSName"], selectable: true),
      )),
      height05,
      Card(
          child: ListTile(
              leading: const Icon(FluentIcons.info_solid),
              title: text("系统版本"),
              subtitle: text("System Version"),
              trailing: text("${sysinfo["Caption"]}#${sysinfo["Version"]}",
                  selectable: true))),
      height05,
      Card(
          child: ListTile(
              leading: const Icon(FluentIcons.cube_shape_solid),
              title: text("系统架构"),
              subtitle: text("System Arch"),
              trailing: text(sysinfo["OSArchitecture"], selectable: true))),
      height05,
      Card(
          child: ListTile(
        leading: const Icon(FluentIcons.user_window),
        title: text("注册用户"),
        subtitle: text("Registered User"),
        trailing: text(sysinfo["RegisteredUser"], selectable: true),
      )),
      height20,
      title("硬件信息"),
      Expander(
          leading: const Icon(FluentIcons.view_dashboard),
          header: text("基板 ${baseboard["Product"]}"),
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
          leading: const Icon(Feather.cpu),
          header: text("处理器 ${processor["Name"]}"),
          content: Column(
            children: [
              ListTile(
                title: text("制造商"),
                subtitle: text("Manufacturer"),
                trailing: text(processor["Manufacturer"], selectable: true),
              ),
              ListTile(
                title: text("名称"),
                subtitle: text("Name"),
                trailing: text(processor["Name"], selectable: true),
              ),
              ListTile(
                title: text("描述"),
                subtitle: text("Description"),
                trailing: text(processor["Description"], selectable: true),
              ),
              ListTile(
                title: text("核心数"),
                subtitle: text("Number Of Cores"),
                trailing: text(processor["NumberOfCores"].toString(),
                    selectable: true),
              ),
              ListTile(
                title: text("频率 (当前/最大)"),
                subtitle: text("Clock Speed(Current/Max)"),
                trailing: text(
                    "${processor["CurrentClockSpeed"] / 1000}GHz / ${processor["MaxClockSpeed"] / 1000}GHz",
                    selectable: true),
              )
            ],
          )),
      height05,
      Expander(
          leading: const Icon(FontAwesomeIcons.memory),
          header: text("内存 ${sumsize / 1073741824}G"),
          content: Column(
            children: List<Widget>.generate(phimemory.keys.length, (index) {
              var mdata = phimemory.values.toList()[index];
              var totalsize = mdata.data["Capacity"] * mdata.count;
              return Expander(
                  header: text(
                      "${phimemory.keys.toList()[index]} ${totalsize / 1073741824}G - ${totalsize / sumsize * 100}%",
                      selectable: true),
                  content: Column(
                    children: [
                      ListTile(
                        title: text("制造商"),
                        subtitle: text("Manufacturer"),
                        trailing: text(
                            phimemory.values
                                .toList()[index]
                                .data["Manufacturer"],
                            selectable: true),
                      ),
                      ListTile(
                        title: text("数量"),
                        subtitle: text("Number"),
                        trailing: text(mdata.count.toString()),
                      ),
                      ListTile(
                        title: text("内存大小"),
                        subtitle: text("Sum"),
                        trailing: text(
                            "${mdata.data["Capacity"]} * ${mdata.count} = ${mdata.data["Capacity"] * mdata.count} = ${totalsize}G",
                            selectable: true),
                      ),
                      ListTile(
                        title: text("频率 (实际/标称)"),
                        subtitle: text("Clock Speed(Real/Configured)"),
                        trailing: text(
                            "${mdata.data["ConfiguredClockSpeed"]} / ${mdata.data["Speed"]}MHz"),
                      )
                    ],
                  ));
            }).joinElement(height05),
          ))
    ]);
  }
}
