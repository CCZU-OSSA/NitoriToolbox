import 'dart:ui';

import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/static/fields.dart';
import 'package:nitoritoolbox/models/static/keys.dart';
import 'package:nitoritoolbox/views/widgets/dialogs.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class AppNavigator {
  static NavigatorState get navigator => Navigator.of(viewkey.currentContext!);
  static StateNavigationView get viewstate => viewkey.currentState!;
  static void pushPage({required WidgetBuilder builder}) {
    navigator.push(
      PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(
          opacity: animation,
          child: child,
        ),
        pageBuilder: (context, animation, secondaryAnimation) =>
            WindowContainer(
          child: builder(context),
        ),
      ),
    );
  }

  static void pushMaterialPage({required WidgetBuilder builder}) {
    navigator.push(MaterialPageRoute(
        builder: (BuildContext context) =>
            WindowContainer(child: builder(context))));
  }

  static void pushHeroPage({required RoutePageBuilder builder, Object? tag}) {
    navigator.push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            WindowContainer(
          child: Hero(
            tag: tag ?? "",
            child: builder(context, animation, secondaryAnimation),
          ),
        ),
      ),
    );
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
          ? (await exitDialog(viewkey.currentContext!) ??
              AppExitResponse.cancel)
          : AppExitResponse.exit;
    });
  }

  static void refreshAppEnumConfig(String key, Enum target) {
    refreshAppValueConfig(key, target.index);
  }

  static bool controllerVisible = true;

  static void setControllerVisible({bool visible = true}) {
    controllerVisible = visible;
    rootKey.currentState!.refresh();
  }

  static void refreshAppValueConfig<V>(String key, V value) {
    ArcheBus.config.write(key, value);
    refreshApp();
  }

  static void loading() {
    loadingDialog(viewkey.currentContext!);
  }

  static void loadingDo<T>(
    ProgressControllerFunction? function, {
    bool useLinear = false,
    bool autoPop = true,
  }) {
    loadingDialog(
      viewkey.currentContext!,
      useLinear: useLinear,
      controller: (context, updateText, updateProgress) async {
        if (function != null) {
          await function(context, updateText, updateProgress);
        }
        if (autoPop) {
          pop();
        }
      },
    );
  }

  static void pop([Object? result]) {
    navigator.pop(result);
  }
}
