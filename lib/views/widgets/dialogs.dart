import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

exitdialog(BuildContext context) => showDialog<AppExitResponse>(
      barrierDismissible: false,
      context: context,
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

void loadingdialog(BuildContext context) => showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Dialog.fullscreen(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ).windowbar(),
    );

Future<String?> editdialog(BuildContext context, {String initial = ""}) async {
  var controller = TextEditingController(text: initial);
  return await showDialog<String?>(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("编辑"),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
        ),
      ),
      actions: [
        FilledButton.icon(
            onPressed: () => Navigator.pop(context, controller.text),
            icon: const Icon(Icons.check),
            label: const Text("完成")),
        ElevatedButton.icon(
          onPressed: () => Navigator.pop(context, null),
          icon: const Icon(Icons.close),
          label: const Text("取消"),
        )
      ],
    ),
  );
}
