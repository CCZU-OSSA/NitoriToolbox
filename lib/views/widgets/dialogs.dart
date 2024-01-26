import 'dart:async';
import 'dart:ui';

import 'package:arche/arche.dart';
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

typedef ProgressControllerFunction = FutureOr<dynamic> Function(
  BuildContext context,
  ValueChanged<String> updateText,
  ValueChanged<double?> updateProgress,
);

Future<void> loadingDialog(BuildContext context,
    {ProgressControllerFunction? controller, bool useLinear = false}) async {
  await showDialog<void>(
    barrierDismissible: false,
    context: context,
    builder: (context) => Dialog.fullscreen(
      child: Center(
        child: ValueStateBuilder<(double?, String)>(
          initial: (null, ""),
          onInit: (context, state) {
            if (controller != null) {
              controller(
                  context,
                  (data) => state.update((state.value.$1, data)),
                  (data) => state.update((data, state.value.$2)));
            }
          },
          builder: (context, state) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              useLinear
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: LinearProgressIndicator(
                        value: state.value.$1,
                      ))
                  : CircularProgressIndicator(
                      value: state.value.$1,
                    ),
              Visibility(
                visible: state.value.$2.isNotEmpty,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(state.value.$2),
                ),
              )
            ],
          ),
        ),
      ),
    ).windowbar(),
  );
}

Future<String?> editDialog(
  BuildContext context, {
  String initial = "",
  String title = "编辑",
}) async {
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
    cancelData: () => null,
  );
}
