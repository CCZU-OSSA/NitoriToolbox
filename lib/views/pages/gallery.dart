import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/models/version.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/views/pages/command.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:nitoritoolbox/views/widgets/markdown.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateGalleryPage();
}

const Size galleryButtonSize = Size.square(120);

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
        const NavigationItem(
          icon: Icon(Icons.get_app),
          label: "Import",
          page: Text("开发中"),
        ),
        NavigationItem(
          icon: const Icon(Icons.apps),
          page: Wrap(
            children: galleryManager.applications.value
                .map(
                  (data) => CardButton(
                    size: galleryButtonSize,
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
                            children: data.includes
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
        NavigationItem(
          icon: const Icon(Icons.code),
          label: "Environment",
          page: Wrap(
            children: galleryManager.environments.value
                .map(
                  (data) => CardButton(
                    size: galleryButtonSize,
                    child: data.cover.build(),
                    onTap: () => AppController.pushPage(
                      builder: (context) => EnvironmentPage(
                        environment: data,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
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

class ApplicationPage extends StatelessWidget {
  final Application application;
  const ApplicationPage({super.key, required this.application});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("应用详情"),
      ),
      body: ListView(
        children: [
          Card(
              child: ListTile(
            leading: const Icon(Icons.terminal),
            title: Text(application.name),
            subtitle: Text(application.version.format()),
          )),
          Card(
            child: MarkdownBlockWidget(
              data: application.details,
            ),
          ),
          Center(
              child: Wrap(
                  children: application.features
                      .map(
                        (feature) => CardButton(
                          onTap: () => AppController.pushPage(
                            builder: (context) => ExecCommandsPage(
                              feature: feature,
                              application: application,
                              workingDirectory: application.path,
                            ),
                          ),
                          size: const Size.square(80),
                          child: feature.cover.build(size: 56),
                        ),
                      )
                      .toList()))
        ],
      ).padding12(),
    );
  }
}

class EnvironmentPage extends StatelessWidget {
  final Environment environment;
  const EnvironmentPage({super.key, required this.environment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("环境详情")),
      body: ListView(
        children: [
          Card(
              child: ListTile(
            leading: const Icon(Icons.terminal),
            title: Text(environment.name),
            subtitle: Text(environment.version.format()),
          )),
          Card(
            child: MarkdownBlockWidget(
              data: environment.details,
            ),
          ),
          const ListTile(
            title: Text("Path"),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: environment.includes.paths.map((e) => Text(e)).toList(),
            ).padding12(),
          ),
          const ListTile(
            title: Text("覆写变量"),
          ),
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: environment.includes.overwrite.entries
                  .map(
                    (e) => ListTile(
                      title: Text(e.key),
                      subtitle: Text(e.value),
                    ),
                  )
                  .toList(),
            ).padding12(),
          ),
        ],
      ).padding12(),
    );
  }
}
