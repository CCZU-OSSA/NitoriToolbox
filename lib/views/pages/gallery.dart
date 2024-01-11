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
    return const NavigationView(
      items: [
        NavigationItem(
            icon: Icon(Icons.apps),
            page: Text("Hello 1"),
            label: "Application"),
        NavigationItem(
            icon: Icon(Icons.code),
            page: Text("Hello 2"),
            label: "Environment"),
        NavigationItem(
          icon: Icon(Icons.book),
          page: Card(child: SizedBox.expand()),
          label: "Document",
        ),
      ],
      direction: Axis.vertical,
      reversed: true,
      vertical: NavigationVerticalConfig(surfaceTintColor: Colors.transparent),
    );
  }
}
