import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

Future<T?> basicFullScreenDialog<T>({
  required BuildContext context,
  Widget? title,
  Widget? content,
  String confirmLabel = "确认",
  required T Function() confirmData,
  String cancelLabel = "取消",
  required T Function() cancelData,
}) =>
    showDialog<T>(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: title,
        content: content,
        actions: [
          FilledButton.icon(
              onPressed: () => Navigator.pop(context, confirmData()),
              icon: const Icon(Icons.done),
              label: Text(confirmLabel)),
          ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, cancelData()),
              icon: const Icon(Icons.close),
              label: Text(cancelLabel))
        ],
      ),
    );

exitDialog(BuildContext context) => basicFullScreenDialog<AppExitResponse>(
      context: context,
      title: const Text("退出提示"),
      content: const Text("可以前往设置关闭退出提示"),
      confirmData: () => AppExitResponse.exit,
      cancelData: () => AppExitResponse.cancel,
    );

void loadingDialog(BuildContext context) => showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (context) => const Dialog.fullscreen(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ).windowbar(),
    );

Future<String?> editDialog(BuildContext context,
    {String initial = "", String title = "编辑"}) async {
  var controller = TextEditingController(text: initial);
  return await basicFullScreenDialog<String?>(
      context: context,
      title: Text(title),
      content: Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
          controller: controller,
        ),
      ),
      confirmData: () {
        var text = controller.text;
        controller.dispose();
        return text;
      },
      cancelData: () => null);
}
