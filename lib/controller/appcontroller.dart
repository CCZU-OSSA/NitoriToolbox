import 'dart:ui';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/configkeys.dart';
import 'package:nitoritoolbox/models/keys.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';

class AppController {
  static NavigatorState get navigator => Navigator.of(viewkey.currentContext!);
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

  static void refreshAppConfig(String key, Enum theme) {
    ArcheBus.config.write(key, theme.index);
    refreshApp();
  }
}
