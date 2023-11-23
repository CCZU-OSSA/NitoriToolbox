import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:nitoritoolbox/core/typed.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contributor extends StatefulWidget {
  final String avatar;
  final String? home;
  final String? name;
  final String? role;
  const Contributor(this.avatar, {super.key, this.home, this.name, this.role});

  @override
  State<StatefulWidget> createState() => _ContributorState();
}

class _ContributorState extends State<Contributor> {
  double prograss = 0;
  DataHolder<ImageProvider> data = DataHolder();

  void _prograssData(BuildContext context) async {
    var f = ApplicationBus.instance(context)
        .dataManager
        .getDirectory()
        .subdir("cache")
        .check()
        .subfile(base64.encode(utf8.encode(widget.avatar)));
    try {
      if (!await f.exists()) {
        await Dio().download(
          widget.avatar,
          f.absolute.path,
          onReceiveProgress: (count, total) {
            if (mounted) {
              setState(() {
                prograss = count / total;
              });
            } else {
              prograss = count / total;
            }
          },
        );
      }

      data.setData(MemoryImage(await f.readAsBytes()));
    } catch (e) {
      data.setData(const AssetImage("resource/images/avatar.png"));
    }
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    _prograssData(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => widget.home != null ? launchUrlString(widget.home!) : (),
        child: Column(children: [
          data.hasData
              ? Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: data.getData(),
                      ),
                      borderRadius: BorderRadius.circular(1000),
                      boxShadow: [
                        data.getData() is AssetImage
                            ? const BoxShadow(color: Colors.transparent)
                            : BoxShadow(
                                offset: const Offset(0, 3),
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10)
                      ]),
                  child: const SizedBox(
                    height: 80,
                    width: 80,
                  ),
                )
              : ProgressRing(value: prograss),
          height05,
          NitoriText(widget.name ?? "匿名"),
          height05,
          NitoriText(widget.role ?? "贡献者")
        ]));
  }
}
