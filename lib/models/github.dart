import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/models/static/keys.dart';
import 'package:nitoritoolbox/models/version.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';
import 'package:nitoritoolbox/views/widgets/markdown.dart';
import 'package:url_launcher/url_launcher_string.dart';

class GithubRepository {
  final String repo;
  late String _api;
  GithubRepository(this.repo) {
    _api = "https://api.github.com/repos/$repo";
  }

  Future<Map?> release() async {
    var client = Dio();
    var resp = await client.get("$_api/releases");
    List data = resp.data;
    if (data.isEmpty) {
      return null;
    }
    return data[0];
  }

  Future<ReleaseData?> checkUpdate() async {
    var data = await release();

    if (data != null) {
      return ReleaseData(
          changeLog: data["body"],
          name: data["name"],
          newVersion: Version.fromString(data["tag_name"]) >
              ApplicationInfo.applicationVersion);
    }

    return null;
  }

  Future<void> updateDialog() async {
    var data = await checkUpdate();
    if (data != null) {
      if (data.newVersion) {
        await basicFullScreenDialog(
          context: viewkey.currentContext!,
          title: Text(data.name),
          content: MarkdownBlockWidget(data.changeLog),
          confirmData: () => launchUrlString(
              "https://github.com/CCZU-OSSA/NitoriToolbox/releases/latest"),
          cancelData: () {},
        );
      } else {
        ScaffoldMessenger.of(viewkey.currentContext!)
            .showSnackBar(const SnackBar(content: Text("已是最新版本!")));
      }
      return;
    }

    ScaffoldMessenger.of(viewkey.currentContext!)
        .showSnackBar(const SnackBar(content: Text("检查更新失败!")));
  }
}

class ReleaseData {
  final bool newVersion;
  final String changeLog;
  final String name;
  ReleaseData(
      {required this.name, required this.changeLog, this.newVersion = true});
}
