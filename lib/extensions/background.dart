import 'dart:io';

import 'package:flutter/material.dart';

extension Background on Widget {
  Widget background() {
    return Stack(
      children: [
        this,
        IgnorePointer(
            child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  opacity: 0.15,
                  fit: BoxFit.cover,
                  image: FileImage(File(
                      "C:/Users/h2sxx/Desktop/image/Pixiv/e9ff88a62bf1bc2395a63d120fb81766.png")))),
          child: const SizedBox.expand(),
        )),
      ],
    );
  }
}
