import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class SoftWare extends StatelessWidget {
  const SoftWare({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => AppController.pop(),
        ),
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
      ).padding12(),
    );
  }
}
