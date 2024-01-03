// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test("Stdin test", () async {
    var p = await Process.start("python", []);
    // write to stdin
    p.stdin.writeln("print('hello world')");
    // Must be closed
    await p.stdin.close();
    await stdout.addStream(p.stdout);
    await stderr.addStream(p.stderr);

    // Real Application LifyCycle Emulator
    await Future.delayed(const Duration(seconds: 5));
  });
}
