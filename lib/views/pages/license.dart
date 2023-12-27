import 'package:flutter/material.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

void showLicensePageWithBar({
  required BuildContext context,
  String? applicationName,
  String? applicationVersion,
  Widget? applicationIcon,
  String? applicationLegalese,
  bool useRootNavigator = false,
}) {
  Navigator.of(context, rootNavigator: useRootNavigator).push(
    MaterialPageRoute<void>(
      builder: (BuildContext context) => LicensePage(
        applicationName: applicationName,
        applicationVersion: applicationVersion,
        applicationIcon: applicationIcon,
        applicationLegalese: applicationLegalese,
      ).windowbar(),
    ),
  );
}
