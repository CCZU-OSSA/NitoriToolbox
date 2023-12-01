import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/bus.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:nitoritoolbox/core/typed.dart';
import 'package:url_launcher/url_launcher_string.dart';

class Contributor extends StatefulWidget {
  final String avatar;
  final String? home;
  final String? name;
  const Contributor(this.avatar, {super.key, this.home, this.name});

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

      data.setData(FileImage(f));
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
    return Column(children: [
      data.hasData
          ? Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: getCurrentThemePriColor(context, reverse: true),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      offset: const Offset(0, 8),
                      blurRadius: 10)
                ],
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 45,
                backgroundImage: data.getData(),
              ))
          : ProgressRing(value: prograss),
      height05,
      SizedBox(
        width: 100,
        child: NitoriText(widget.name ?? "匿名"),
      ),
    ]).makeButton(
      onPressed: () => widget.home != null ? launchUrlString(widget.home!) : (),
    );
  }
}
