// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget

import 'dart:isolate';

import 'package:flutter_test/flutter_test.dart';

enum ISolateShellSignals {
  activate,
  deactivate,
  reload,
}

void main() {
  test("ISolate test", () {});
}
