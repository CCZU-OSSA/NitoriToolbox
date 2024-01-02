// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget


import 'package:flutter_test/flutter_test.dart';
import 'package:nitoritoolbox/utils/shell_abc.dart';
import 'package:nitoritoolbox/utils/shell_windows.dart';

void main() {
  test("Chore test", () async {
    var shell = Shell(environment: {
      "path": "D:\\WorkSpace\\python\\Remilia\\.venv\\Scripts;"
    });
    var p = await shell.start("where.exe", ["python"]);
    p.stdout.asStringStream().listen(print);
    await Future.delayed(const Duration(seconds: 2));
  });
}
