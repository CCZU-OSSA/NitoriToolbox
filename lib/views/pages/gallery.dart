import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appdata.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateGalleryPage();
}

class _StateGalleryPage extends State<GalleryPage> {
  late GalleryManager manager;
  int selected = 0;
  @override
  void initState() {
    super.initState();
    manager = ArcheBus.bus.of<AppData>().galleryManager;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Padding(
              padding: const EdgeInsets.only(left: 120, right: 120),
              child: NavigationBar(
                indicatorColor: Colors.transparent,
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                onDestinationSelected: (value) => setState(() {
                  selected = value;
                }),
                selectedIndex: selected,
                destinations: const [
                  NavigationDestination(
                      label: "Application", icon: Icon(Icons.apps)),
                  NavigationDestination(
                      label: "Environment", icon: Icon(Icons.code)),
                  NavigationDestination(
                      label: "Document", icon: Icon(Icons.book)),
                ],
              ))),
      body: ListView(children: [
        Center(
          child: Wrap(
            children: List.generate(
                100,
                (index) => const Card(
                      child: SizedBox.square(
                        dimension: 100,
                      ),
                    )),
          ),
        )
      ]),
    );
  }
}
