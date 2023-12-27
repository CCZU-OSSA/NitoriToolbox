import 'package:flutter/material.dart';
import 'package:nitoritoolbox/views/widgets/appbar.dart';

extension NitoriWidgetExtension on Widget {
  Widget padding12() {
    return padding(12);
  }

  Widget padding(double value) {
    return Padding(
      padding: EdgeInsets.all(value),
      child: this,
    );
  }

  Widget windowbar() {
    return WindowWidget(child: this);
  }
}
