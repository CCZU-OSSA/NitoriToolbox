import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/config.dart';
import 'package:nitoritoolbox/app/log.dart';
import 'package:nitoritoolbox/app/router/router.dart';
import 'package:nitoritoolbox/core/ffi.dart';
import 'package:provider/provider.dart';

class ApplicationBus {
  ApplicationConfig config = ApplicationConfig("app.config.json");
  ApplicationLogger logger = ApplicationLogger();
  NitoriCore nitoriCore = NitoriCore();
  PaneRouter? router;
  static final Map<String, dynamic> env = Platform.environment;

  Function(void Function())? appSetState;

  static ApplicationBus instance(BuildContext context) {
    return Provider.of<ApplicationBus>(context, listen: false);
  }
}
