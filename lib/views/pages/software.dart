import 'package:flutter/material.dart';

class SoftWare extends StatelessWidget {
  const SoftWare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("详细信息"),
      ),
      body: ListView(
        children: const [
          Card(
              child: ListTile(
            leading: Icon(Icons.abc),
            title: Text("软件"),
            subtitle: Text("SoftWare"),
          )),
          Card(
            child: SizedBox(
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
