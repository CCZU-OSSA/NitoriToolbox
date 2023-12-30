import 'package:arche/extensions/iter.dart';
import 'package:arche/modules/application.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';

/// EnumTranslatorConfigMenuButton
class ETCPopupMenuButton<T> extends StatefulWidget {
  final Translator<Enum, String> translator;
  final ArcheConfig config;
  final String configKey;
  final String? tooltip;
  final int initialindex;
  final Widget? icon;
  const ETCPopupMenuButton({
    super.key,
    required this.translator,
    required this.config,
    required this.configKey,
    this.initialindex = 0,
    this.icon,
    this.tooltip,
  });

  @override
  State<StatefulWidget> createState() => _StateETCPopupMenuButton();
}

class _StateETCPopupMenuButton<T> extends State<ETCPopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: widget.icon,
      tooltip: widget.tooltip ?? "显示菜单",
      initialValue: widget.translator
          .keys[widget.config.getOr(widget.configKey, widget.initialindex)],
      onSelected: (value) => setState(
          () => AppController.refreshAppEnumConfig(widget.configKey, value)),
      itemBuilder: (context) => ListExt.generatefrom(
        widget.translator.keys,
        functionFactory: (value) => PopupMenuItem(
          value: value,
          child: Text(widget.translator.translation(value).toString()),
        ),
      ),
    );
  }
}
