import 'dart:ui';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/dataclass.dart';
import 'package:nitoritoolbox/models/keys.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class AppController {
  static NavigatorState get navigator => Navigator.of(viewkey.currentContext!);
  static void pushMaterialPage({required WidgetBuilder builder}) {
    navigator.push(MaterialPageRoute(
        builder: (BuildContext context) =>
            WindowContainer(child: builder(context))));
  }

  static T viewContextBuilder<T>(
          {required T Function(BuildContext context) builder}) =>
      builder(viewkey.currentContext!);
  static void refreshApp() {
    rootKey.currentState!.refresh();
  }

  static void initLifeCycleListener() {
    AppLifecycleListener(onExitRequested: () async {
      return ArcheBus.config.getOr(ConfigKeys.exitConfirm, false)
          ? (await exitdialog() ?? AppExitResponse.cancel)
          : AppExitResponse.exit;
    });
  }

  static void refreshAppEnumConfig(String key, Enum target) {
    ArcheBus.config.write(key, target.index);
    refreshApp();
  }
}
