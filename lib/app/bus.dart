import 'dart:io';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/abc/io.dart';
import 'package:nitoritoolbox/app/config.dart';
import 'package:nitoritoolbox/app/log.dart';
import 'package:nitoritoolbox/app/resource.dart';
import 'package:nitoritoolbox/app/router/router.dart';
import 'package:nitoritoolbox/core/ffi.dart';
import 'package:provider/provider.dart';

class ApplicationBus {
  ApplicationConfig config = ApplicationConfig("app.config.json");
  ApplicationLogger logger = ApplicationLogger();
  NitoriCore nitoriCore = NitoriCore();
  PaneRouter? router;
  late LocalDataManager dataManager;
  static final Map<String, dynamic> env = Platform.environment;

  Function(void Function())? appSetState;

  ApplicationBus() {
    dataManager = LocalDataManager(config.getOrDefault("data_path", "locals"));
  }

  static ApplicationBus instance(BuildContext context) {
    return Provider.of<ApplicationBus>(context, listen: false);
  }
}
