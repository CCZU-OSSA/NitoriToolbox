import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateSettingsPage();
}

class _StateSettingsPage extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            Card(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const ListTile(
                  title: Text("主题"),
                ),
                ListTile(
                  title: const Text("颜色主题"),
                  trailing: DropdownButton(
                      value: 0,
                      alignment: Alignment.center,
                      underline: const SizedBox.shrink(),
                      borderRadius: BorderRadius.circular(4),
                      items: const [
                        DropdownMenuItem(
                          child: Text("亮色"),
                          value: 0,
                        ),
                        DropdownMenuItem(child: Text("暗色"), value: 1),
                        DropdownMenuItem(child: Text("跟随系统"), value: 2)
                      ],
                      onChanged: (v) {}),
                ),
                ListTile()
              ],
            ))
          ],
        ));
  }
}
