import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controllers/navigator.dart';

void showLicensePageWithBar({
  required BuildContext context,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  bool useRootNavigator = false,
}) {
  AppNavigator.pushPage(
    builder: (BuildContext context) => LicensePage(
      applicationName: applicationName,
      applicationVersion: applicationVersion,
      applicationIcon: applicationIcon,
      applicationLegalese: applicationLegalese,
    ),
  );
}
