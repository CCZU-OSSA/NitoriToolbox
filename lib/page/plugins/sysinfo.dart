import 'dart:collection';
import 'dart:isolate';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/card.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
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
      "Win32_SoundDevice",
      "Win32_DiskDrive",
      "Win32_LogicalDisk"
    ])!["data"]);
  }

  DataHolder<Map> dataHolder = DataHolder();

  @override
  Widget build(BuildContext context) {
    try {
      ApplicationBus bus = ApplicationBus.instance(context);
      NitoriCore core = bus.nitoriCore;

      if (!core.installed) {
        return ScaffoldPage.scrollable(children: [
          Center(child: NitoriText("内核未安装", color: Colors.red, size: 32)),
          height20,
          const Center(
              child: NitoriText("设置 -> 内核设置 -> 安装内核 -> 安装 -> 选择nitori_core.dll",
                  size: 24))
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
      List diskdrive = data["Win32_DiskDrive"];
      //debugPrint(jsonEncode(diskdrive));
      return ScaffoldPage.scrollable(header: banner(context), children: [
        const NitoriTitle("软件信息"),
        CardListTile(
          leading: const Icon(FontAwesomeIcons.computer),
          title: const NitoriText("本机名称"),
          subtitle: const NitoriText("Machine Name"),
          trailing: NitoriText(sysinfo["CSName"], selectable: true),
        ),
        height05,
        CardListTile(
            leading: const Icon(FluentIcons.info_solid),
            title: const NitoriText("系统版本"),
            subtitle: const NitoriText("System Version"),
            trailing: NitoriText("${sysinfo["Caption"]}#${sysinfo["Version"]}",
                selectable: true)),
        height05,
        CardListTile(
            leading: const Icon(FluentIcons.cube_shape_solid),
            title: const NitoriText("系统架构"),
            subtitle: const NitoriText("System Arch"),
            trailing: NitoriText(sysinfo["OSArchitecture"], selectable: true)),
        height05,
        CardListTile(
          leading: const Icon(FluentIcons.user_window),
          title: const NitoriText("注册用户"),
          subtitle: const NitoriText("Registered User"),
          trailing: NitoriText(sysinfo["RegisteredUser"], selectable: true),
        ),
        height20,
        const NitoriTitle("硬件信息"),
        Expander(
            leading: const Icon(FluentIcons.view_dashboard),
            header: NitoriText("基板 ${baseboard["Product"]}"),
            content: Column(
              children: [
                ListTile(
                  title: const NitoriText("制造商"),
                  subtitle: const NitoriText("Manufacturer"),
                  trailing:
                      NitoriText(baseboard["Manufacturer"], selectable: true),
                ),
                ListTile(
                  title: const NitoriText("产品型号"),
                  subtitle: const NitoriText("Product"),
                  trailing: NitoriText(baseboard["Product"], selectable: true),
                ),
                ListTile(
                  title: const NitoriText("产品版本"),
                  subtitle: const NitoriText("Version"),
                  trailing: NitoriText(baseboard["Version"], selectable: true),
                )
              ],
            )),
        height05,
        Expander(
            leading: const Icon(Feather.cpu),
            header: NitoriText("处理器 ${processor["Name"]}"),
            content: Column(
              children: [
                ListTile(
                  title: const NitoriText("制造商"),
                  subtitle: const NitoriText("Manufacturer"),
                  trailing:
                      NitoriText(processor["Manufacturer"], selectable: true),
                ),
                ListTile(
                  title: const NitoriText("名称"),
                  subtitle: const NitoriText("Name"),
                  trailing: NitoriText(processor["Name"], selectable: true),
                ),
                ListTile(
                  title: const NitoriText("描述"),
                  subtitle: const NitoriText("Description"),
                  trailing:
                      NitoriText(processor["Description"], selectable: true),
                ),
                ListTile(
                  title: const NitoriText("核心数"),
                  subtitle: const NitoriText("Number Of Cores"),
                  trailing: NitoriText(processor["NumberOfCores"].toString(),
                      selectable: true),
                ),
                ListTile(
                  title: const NitoriText("频率 (当前/最大)"),
                  subtitle: const NitoriText("Clock Speed(Current/Max)"),
                  trailing: NitoriText(
                      "${(processor["CurrentClockSpeed"] / 1000 as double).toStringAsFixed(1)}GHz / ${processor["MaxClockSpeed"] / 1000}GHz",
                      selectable: true),
                )
              ],
            )),
        height05,
        Expander(
            leading: const Icon(FontAwesomeIcons.memory),
            header: NitoriText("内存 ${sumsize / 1073741824}G"),
            content: Column(
              children: List<Widget>.generate(phimemory.keys.length, (index) {
                var mdata = phimemory.values.toList()[index];
                var totalsize = mdata.data["Capacity"] * mdata.count;
                return Expander(
                    header: NitoriText(
                      "${phimemory.keys.toList()[index]} ${totalsize / 1073741824}G(${totalsize / sumsize * 100}%) ${mdata.data["ConfiguredClockSpeed"]}/${mdata.data["Speed"]}MHz",
                      selectable: true,
                    ),
                    content: Column(
                      children: [
                        ListTile(
                          title: const NitoriText("制造商"),
                          subtitle: const NitoriText("Manufacturer"),
                          trailing: NitoriText(
                            phimemory.values
                                .toList()[index]
                                .data["Manufacturer"],
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("数量"),
                          subtitle: const NitoriText("Number"),
                          trailing: NitoriText(mdata.count.toString()),
                        ),
                        ListTile(
                          title: const NitoriText("内存大小"),
                          subtitle: const NitoriText("Sum"),
                          trailing: NitoriText(
                            "${mdata.data["Capacity"]} * ${mdata.count} = ${mdata.data["Capacity"] * mdata.count} = ${totalsize / 1073741824}G",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("频率 (实际/标称)"),
                          subtitle:
                              const NitoriText("Clock Speed(Real/Configured)"),
                          trailing: NitoriText(
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
            header: NitoriText(
                "显卡 ${videoctrs[0]["Name"]} ${videoctrs[0]["AdapterRAM"] == null ? "Null" : "${(videoctrs[0]["AdapterRAM"] / 1073741824 as double).toStringAsFixed(2)}G"}"),
            content: Column(
              children: List.generate(videoctrs.length, (index) {
                return Expander(
                    header: NitoriText(videoctrs[index]["Name"]),
                    content: Column(
                      children: [
                        ListTile(
                          title: const NitoriText("分辨率"),
                          subtitle: const NitoriText("Resolution"),
                          trailing: NitoriText(
                              "${videoctrs[index]["CurrentHorizontalResolution"]} x ${videoctrs[index]["CurrentVerticalResolution"]}"),
                        ),
                        ListTile(
                          title: const NitoriText("视频模式"),
                          subtitle: const NitoriText("Video Mode"),
                          trailing: NitoriText(
                            "${videoctrs[index]["VideoModeDescription"]}",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("视频处理器"),
                          subtitle: const NitoriText("Video Processor"),
                          trailing: NitoriText(
                            "${videoctrs[index]["VideoProcessor"]}",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("适配器内存"),
                          subtitle: const NitoriText("Adapter RAM"),
                          trailing: NitoriText(
                            videoctrs[0]["AdapterRAM"] == null
                                ? "Null"
                                : "${(videoctrs[0]["AdapterRAM"] / 1073741824 as double).toStringAsFixed(2)}G",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("刷新率 (最小/当前/最大)"),
                          subtitle:
                              const NitoriText("Refresh Rate(Min/Current/Max)"),
                          trailing: NitoriText(
                            "${videoctrs[index]["MinRefreshRate"]} / ${videoctrs[index]["CurrentRefreshRate"]} / ${videoctrs[index]["MaxRefreshRate"]}",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("适配器DAC类型"),
                          subtitle: const NitoriText("Adapter DAC Type"),
                          trailing: NitoriText(
                            "${videoctrs[index]["AdapterDACType"]}",
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("驱动版本"),
                          subtitle: const NitoriText("Driver Version"),
                          trailing: NitoriText(
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
            header: NitoriText("显示器 ${core.monitors[0]["driver_id"]}"),
            content: Column(
              children: List.generate(
                  core.monitors.length,
                  (index) => Expander(
                      header: NitoriText(core.monitors[index]["driver_id"],
                          selectable: true),
                      content: ListTile(
                        title: const NitoriText("ID"),
                        trailing: NitoriText(core.monitors[index]["id"],
                            selectable: true),
                      ))).joinElement<Widget>(height05),
            )),
        height05,
        Expander(
            leading: const Icon(FluentIcons.hard_drive),
            header: NitoriText(
                "硬盘 ${(diskdrive.fold(0.toDouble(), (previousValue, element) => previousValue += element["Size"].toDouble()) / 1073741824).toStringAsFixed(2)}G"),
            content: Column(
              children: List.generate(
                  diskdrive.length,
                  (index) => Expander(
                      header: NitoriText(diskdrive[index]["Caption"],
                          selectable: true),
                      content: Column(
                        children: [
                          ListTile(
                              title: const NitoriText("大小"),
                              trailing: NitoriText(
                                  "${(diskdrive[index]["Size"] / 1073741824 as double).toStringAsFixed(2)}G")),
                          ListTile(
                            title: const NitoriText("媒体类型"),
                            trailing: NitoriText(diskdrive[index]["MediaType"]),
                          )
                        ],
                      ))),
            )),
        height05,
        Expander(
          leading: const Icon(FontAwesomeIcons.internetExplorer),
          header: NitoriText(
              "网络适配器 ${networkadapter.isEmpty ? "无" : networkadapter[0]["Name"]}"),
          content: Column(
            children: List.generate(
                networkadapter.length,
                (index) => Expander(
                    header: NitoriText(networkadapter[index]["Name"]),
                    content: Column(
                      children: [
                        ListTile(
                          title: const NitoriText("制造商"),
                          subtitle: const NitoriText("Manufacturer"),
                          trailing: NitoriText(
                            networkadapter[index]["Manufacturer"],
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("MAC地址"),
                          subtitle: const NitoriText("MAC Address"),
                          trailing: NitoriText(
                            networkadapter[index]["MACAddress"],
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("适配器类型"),
                          subtitle: const NitoriText("Adapter Type"),
                          trailing: NitoriText(
                            networkadapter[index]["AdapterType"],
                            selectable: true,
                          ),
                        ),
                        ListTile(
                          title: const NitoriText("速度"),
                          subtitle: const NitoriText("Speed"),
                          trailing: NitoriText(
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
            header: const NitoriText("声音设备"),
            content: Column(
              children: List.generate(
                  soundDevices.length,
                  (index) => Expander(
                      header: NitoriText(soundDevices[index]["Name"],
                          selectable: true),
                      content: Column(
                        children: [
                          ListTile(
                            title: const NitoriText("制造商"),
                            trailing: NitoriText(
                                soundDevices[index]["Manufacturer"],
                                selectable: true),
                          ),
                        ],
                      ))).joinElement<Widget>(height05),
            ))
      ]);
    } catch (e, trace) {
      return Column(children: [
        const NitoriText(
          "发生错误",
          isdisplay: true,
          size: 60,
        ),
        height40,
        NitoriText(e.toString()),
        NitoriText(trace.toString())
      ]);
    }
  }
}
