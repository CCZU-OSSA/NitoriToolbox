import 'dart:collection';
import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
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
      "Win32_PhysicalMemory",
      "Win32_VideoController",
      "Win32_NetworkAdapter",
      "Win32_SoundDevice"
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

    var videoctrs = data["Win32_VideoController"];
    List networkadapter = (data["Win32_NetworkAdapter"] as List)
        .where(
          (element) =>
              element["NetEnabled"] == true &&
              element["PhysicalAdapter"] == true,
        )
        .toList();

    List soundDevices = data["Win32_SoundDevice"];
    //debugPrint(jsonEncode(soundDevices));

    return ScaffoldPage.scrollable(header: banner(context), children: [
      title("软件信息"),
      CardListTile(
        leading: const Icon(FontAwesomeIcons.computer),
        title: text("本机名称"),
        subtitle: text("Machine Name"),
        trailing: text(sysinfo["CSName"], selectable: true),
      ),
      height05,
      CardListTile(
          leading: const Icon(FluentIcons.info_solid),
          title: text("系统版本"),
          subtitle: text("System Version"),
          trailing: text("${sysinfo["Caption"]}#${sysinfo["Version"]}",
              selectable: true)),
      height05,
      CardListTile(
          leading: const Icon(FluentIcons.cube_shape_solid),
          title: text("系统架构"),
          subtitle: text("System Arch"),
          trailing: text(sysinfo["OSArchitecture"], selectable: true)),
      height05,
      CardListTile(
        leading: const Icon(FluentIcons.user_window),
        title: text("注册用户"),
        subtitle: text("Registered User"),
        trailing: text(sysinfo["RegisteredUser"], selectable: true),
      ),
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
                    "${phimemory.keys.toList()[index]} ${totalsize / 1073741824}G(${totalsize / sumsize * 100}%) ${mdata.data["ConfiguredClockSpeed"]}/${mdata.data["Speed"]}MHz",
                    selectable: true,
                  ),
                  content: Column(
                    children: [
                      ListTile(
                        title: text("制造商"),
                        subtitle: text("Manufacturer"),
                        trailing: text(
                          phimemory.values.toList()[index].data["Manufacturer"],
                          selectable: true,
                        ),
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
                          "${mdata.data["Capacity"]} * ${mdata.count} = ${mdata.data["Capacity"] * mdata.count} = ${totalsize / 1073741824}G",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("频率 (实际/标称)"),
                        subtitle: text("Clock Speed(Real/Configured)"),
                        trailing: text(
                          "${mdata.data["ConfiguredClockSpeed"]} / ${mdata.data["Speed"]}MHz",
                          selectable: true,
                        ),
                      )
                    ],
                  ));
            }).joinElement(height05),
          )),
      height05,
      Expander(
          leading: const Icon(FluentIcons.screen),
          header: text(
              "显卡 ${videoctrs[0]["Name"]} ${videoctrs[0]["AdapterRAM"] / 1073741824}G"),
          content: Column(
            children: List.generate(videoctrs.length, (index) {
              return Expander(
                  header: text(videoctrs[index]["Name"]),
                  content: Column(
                    children: [
                      ListTile(
                        title: text("分辨率"),
                        subtitle: text("Resolution"),
                        trailing: text(
                            "${videoctrs[index]["CurrentHorizontalResolution"]} x ${videoctrs[index]["CurrentVerticalResolution"]}"),
                      ),
                      ListTile(
                        title: text("视频模式"),
                        subtitle: text("Video Mode"),
                        trailing: text(
                          "${videoctrs[index]["VideoModeDescription"]}",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("视频处理器"),
                        subtitle: text("Video Processor"),
                        trailing: text(
                          "${videoctrs[index]["VideoProcessor"]}",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("适配器内存"),
                        subtitle: text("Adapter RAM"),
                        trailing: text(
                          "${videoctrs[index]["AdapterRAM"] / 1073741824}GB",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("刷新率 (最小/当前/最大)"),
                        subtitle: text("Refresh Rate(Min/Current/Max)"),
                        trailing: text(
                          "${videoctrs[index]["MinRefreshRate"]} / ${videoctrs[index]["CurrentRefreshRate"]} / ${videoctrs[index]["MaxRefreshRate"]}",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("适配器DAC类型"),
                        subtitle: text("Adapter DAC Type"),
                        trailing: text(
                          "${videoctrs[index]["AdapterDACType"]}",
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("驱动版本"),
                        subtitle: text("Driver Version"),
                        trailing: text(
                          "${videoctrs[index]["DriverVersion"]}",
                          selectable: true,
                        ),
                      ),
                    ],
                  ));
            }).joinElement<Widget>(height05),
          )),
      height05,
      Expander(
          leading: const Icon(Feather.monitor),
          header: text("显示器 ${core.monitors[0]["driver_id"]}"),
          content: Column(
            children: List.generate(
                core.monitors.length,
                (index) => Expander(
                    header: text(core.monitors[index]["driver_id"],
                        selectable: true),
                    content: ListTile(
                      title: text("ID"),
                      trailing:
                          text(core.monitors[index]["id"], selectable: true),
                    ))).joinElement<Widget>(height05),
          )),
      height05,
      Expander(
        leading: const Icon(FontAwesomeIcons.internetExplorer),
        header: text(
            "网络适配器 ${networkadapter.isEmpty ? "无" : networkadapter[0]["Name"]}"),
        content: Column(
          children: List.generate(
              networkadapter.length,
              (index) => Expander(
                  header: text(networkadapter[index]["Name"]),
                  content: Column(
                    children: [
                      ListTile(
                        title: text("制造商"),
                        subtitle: text("Manufacturer"),
                        trailing: text(
                          networkadapter[index]["Manufacturer"],
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("MAC地址"),
                        subtitle: text("MAC Address"),
                        trailing: text(
                          networkadapter[index]["MACAddress"],
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("适配器类型"),
                        subtitle: text("Adapter Type"),
                        trailing: text(
                          networkadapter[index]["AdapterType"],
                          selectable: true,
                        ),
                      ),
                      ListTile(
                        title: text("速度"),
                        subtitle: text("Speed"),
                        trailing: text(
                          "${(networkadapter[index]["Speed"] / 8 / 1024 / 1024 as double).toStringAsFixed(2)}MB/S",
                          selectable: true,
                        ),
                      ),
                    ],
                  ))).joinElement<Widget>(height05),
        ),
      ),
      height05,
      Expander(
          leading: const Icon(FluentIcons.microphone),
          header: text("声音设备"),
          content: Column(
            children: List.generate(
                    soundDevices.length,
                    (index) =>
                        Expander(header: text("data"), content: text("data")))
                .joinElement<Widget>(height05),
          ))
    ]);
  }
}
