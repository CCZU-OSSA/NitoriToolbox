import 'package:arche/extensions/iter.dart';
import 'package:arche/modules/application.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';

/// ConfigEnumTranslatorPopupMenuButton
class CETPopupMenuButton<T> extends StatefulWidget {
  final Translator<Enum, String> translator;
  final ArcheConfig config;
  final String configKey;
  final String? tooltip;
  final int initial;
  final Widget? icon;
  const CETPopupMenuButton({
    super.key,
    required this.translator,
    required this.config,
    required this.configKey,
    this.initial = 0,
    this.icon,
    this.tooltip,
  });

  @override
  State<StatefulWidget> createState() => _StateCETPopupMenuButton();
}

class _StateCETPopupMenuButton<T> extends State<CETPopupMenuButton<T>> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: widget.icon,
      tooltip: widget.tooltip ?? "显示菜单",
      initialValue: widget.translator
          .keys[widget.config.getOr(widget.configKey, widget.initial)],
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

class ConfigSwitchListTile extends StatefulWidget {
  final ArcheConfig config;
  final String configKey;
  final bool initial;
  final Widget? title;
  final Widget? leading;
  final Widget? subtitle;
  const ConfigSwitchListTile(
      {super.key,
      required this.config,
      required this.configKey,
      this.title,
      this.leading,
      this.subtitle,
      this.initial = false});

  @override
  State<StatefulWidget> createState() => _StateConfigSwitch();
}

class _StateConfigSwitch extends State<ConfigSwitchListTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: widget.title,
      subtitle: widget.subtitle,
      leading: widget.leading,
      trailing: Switch(
          value: widget.config.getOr(widget.configKey, widget.initial),
          onChanged: (value) => setState(() =>
              AppController.refreshAppValueConfig(widget.configKey, value))),
    );
  }
}
