import 'package:win32_registry/win32_registry.dart';

String? getWallPaperPath() {
  const desktopKey = r'Control Panel\Desktop';
  final key = Registry.openPath(RegistryHive.currentUser, path: desktopKey);
  var res = key.getValueAsString("WallPaper");
  key.close();
  return res;
}
