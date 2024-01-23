// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget

import 'package:arche/arche.dart';
import 'package:flutter_test/flutter_test.dart';

class Demo<T> {
  T data;
  Demo(this.data);
}

void main() {
  test("Test", () {
    ArcheBus().provide<Demo<dynamic>>(Demo(1));
    print(ArcheBus().has<Demo>());
  });
}
