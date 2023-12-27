import 'package:arche/arche.dart';
import 'package:nitoritoolbox/models/keys.dart';

class AppController {
  static void refreshApp() {
    rootKey.currentState!.refresh();
  }

  static void refreshAppConfig(String key, Enum theme) {
    ArcheBus.config.write(key, theme.index);
    refreshApp();
  }
}
