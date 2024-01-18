import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/views/pages/application.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateGalleryPage();
}

class _StateGalleryPage extends State<GalleryPage>
    with TickerProviderStateMixin {
  late GalleryManager manager;
  int selected = 0;

  get size => null;
  @override
  void initState() {
    super.initState();
    manager = ArcheBus.bus.of();
  }

  @override
  Widget build(BuildContext context) {
    GalleryManager galleryManager = ArcheBus.bus.of();
    return NavigationView(
      items: [
        NavigationItem(
          icon: const Icon(Icons.apps),
          page: Wrap(
            children: galleryManager.applications.value
                .map(
                  (data) => CardButton(
                    size: const Size.square(120),
                    child: data.cover.build(size: 84),
                    onTap: () => showModalBottomSheet(
                      context: context,
                      builder: (context) => SizedBox.expand(
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const Text(
                            "应用列表",
                            style: TextStyle(fontSize: 24),
                          ).padding12(),
                          Wrap(
                            children: data.manifest
                                .map((app) => CardButton(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                    size: const Size.square(100),
                                    onTap: () => AppController.pushPage(
                                          builder: (context) =>
                                              ApplicationPage(application: app),
                                        ),
                                    child: app.cover.build(size: 70)))
                                .toList(),
                          ),
                        ])).padding12(),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
          label: "Application",
        ),
        const NavigationItem(
          icon: Icon(Icons.code),
          page: Text("开发中"),
          label: "Environment",
        ),
        const NavigationItem(
          icon: Icon(Icons.book),
          page: Text("开发中"),
          label: "Document",
        ),
      ],
      direction: Axis.vertical,
      reversed: true,
      vertical:
          const NavigationVerticalConfig(surfaceTintColor: Colors.transparent),
    );
  }
}
