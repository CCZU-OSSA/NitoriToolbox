import 'dart:io';

import 'package:nitoritoolbox/utils/shell_abc.dart';

class Shell extends AbstractShell with ShellIO {
  Shell({super.environment});
  @override
  String get syspath => Platform.environment["path"] ?? "";
}
