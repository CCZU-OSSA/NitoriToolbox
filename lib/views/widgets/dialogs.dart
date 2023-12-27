import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nitoritoolbox/models/keys.dart';

exitdialog() => showDialog<AppExitResponse>(
      barrierDismissible: false,
      context: viewkey.currentContext!,
      builder: (context) => AlertDialog(
        title: const Text("退出提示"),
        content: const Text("可以前往设置关闭退出提示"),
        actions: [
          FilledButton.icon(
              onPressed: () => Navigator.pop(context, AppExitResponse.exit),
              icon: const Icon(Icons.check),
              label: const Text("退出")),
          ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, AppExitResponse.cancel),
              icon: const Icon(Icons.close),
              label: const Text("取消"))
        ],
      ),
    );
