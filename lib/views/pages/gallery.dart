import 'dart:io';

import 'package:arche/arche.dart';
import 'package:arche/extensions/iter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/controller/appdata.dart';
import 'package:nitoritoolbox/models/version.dart';
import 'package:nitoritoolbox/models/yaml.dart';
import 'package:nitoritoolbox/utils/shell.dart';
import 'package:nitoritoolbox/views/widgets/builder.dart';
import 'package:nitoritoolbox/views/widgets/extension.dart';
import 'package:nitoritoolbox/views/widgets/markdown.dart';

const Size galleryButtonSize = Size.square(120);

class ApplicationFeaturePage extends StatefulWidget {
  final ApplicationFeature feature;
  final Application application;
  final String? workingDirectory;
  const ApplicationFeaturePage({
    super.key,
    required this.application,
    required this.feature,
    this.workingDirectory,
  });

  @override
  State<StatefulWidget> createState() => _StateApplicationFeaturePage();
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
          Visibility(
            visible: application.details.isNotEmpty,
            child: Card(
              child: MarkdownBlockWidget(application.details),
            ),
          ),
          Center(
            child: Wrap(
              children: application.features
                  .map(
                    (feature) => CardButton(
                      onTap: () => AppController.pushPage(
                        builder: (context) => ApplicationFeaturePage(
                          feature: feature,
                          application: application,
                          workingDirectory: application.path,
                        ),
                      ),
                      size: const Size.square(80),
                      child: feature.cover.build(size: 56),
                    ),
                  )
                  .toList(),
            ),
          )
        ],
      ).padding12(),
    );
  }
}

class ApplicationStepView extends StatefulWidget {
  final ApplicationFeatureStep step;
  final Shell shell;
  const ApplicationStepView({
    super.key,
    required this.step,
    required this.shell,
  });

  @override
  State<StatefulWidget> createState() => _StateApplicationStepView();
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
          Visibility(
            visible: environment.details.isNotEmpty,
            child: Card(
              child: MarkdownBlockWidget(environment.details),
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
          Visibility(
            visible: environment.includes.overwrite.isNotEmpty,
            child: const ListTile(
              title: Text("覆写变量"),
            ),
          ),
          Visibility(
            visible: environment.includes.overwrite.isNotEmpty,
            child: Card(
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
          ),
        ],
      ).padding12(),
    );
  }
}

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateGalleryPage();
}

class _StateApplicationFeaturePage extends State<ApplicationFeaturePage> {
  late ISolateShell shell;

  @override
  Widget build(BuildContext context) {
    var galleryManager = ArcheBus.bus.of<GalleryManager>();
    return galleryManager.environments.widgetBuilder(
      snapshotLoading(
        builder: (data) {
          Map<String, String> env = {
            "PATH": Platform.environment["PATH"].toString()
          };
          var missEnvironments = [];
          var require = widget.application.environments.map((name) {
            var filter = data.where((add) => add.name == name);
            if (filter.isEmpty) {
              missEnvironments.add(name);
            } else {
              return filter.first;
            }
          }).toList();
          if (missEnvironments.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    missEnvironments.map((e) => Text("缺失环境: $e")).toList(),
              ),
            );
          }
          for (var reqenv in require) {
            var includes = reqenv!.includes;
            env.addAll(includes.overwrite);
            env["PATH"] = "${includes.paths.join()}${env["PATH"]}";
          }

          shell = ISolateShell(
              workingDirectory: widget.application.path,
              perferEnvironment: env);
          return Scaffold(
            appBar: AppBar(
              title: const Text("控制台"),
            ),
            body: ListView(
              children: widget.feature.steps
                  .map((e) => ApplicationStepView(
                        step: e,
                        shell: shell,
                      ))
                  .toList(),
            ).padding12(),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    try {
      shell.deactivate();
    } catch (_) {}
  }

  @override
  void initState() {
    super.initState();
  }
}

class _StateApplicationStepView extends State<ApplicationStepView> {
  final List<String> contents = [];

  void add(String data) {
    setState(() {
      contents.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    var shell = widget.shell;
    return Column(
      children: [
        Visibility(
          visible: widget.step.details.isNotEmpty,
          child: MarkdownBlockWidget(widget.step.details),
        ),
        Card(
          color: Theme.of(context).colorScheme.surfaceVariant,
          child: Column(
            children: [
              Row(children: [
                ElevatedButton.icon(
                    label: const Text("执行"),
                    onPressed: () {
                      contents.clear();
                      add("正在激活Pty...");
                      shell.clearbinds();
                      shell.bind(add);
                      shell.activate();
                      for (var command in widget.step.run) {
                        shell.write(command);
                      }
                    },
                    icon: const Icon(Icons.play_arrow)),
                ElevatedButton.icon(
                    onPressed: () => setState(() => shell.deactivate()),
                    icon: const Icon(Icons.stop),
                    label: const Text("停止")),
                ElevatedButton.icon(
                    onPressed: () => setState(() => contents.clear()),
                    icon: const Icon(Icons.cleaning_services),
                    label: const Text("清空"))
              ]),
              Card(
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.step.run.map((e) => Text(e)).toList(),
                  ).padding12(),
                ),
              ),
              Card(
                child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  child: ListView(
                    children: contents.map((e) => Text(e)).toList(),
                  ).padding12(),
                ),
              )
            ],
          ).padding12(),
        )
      ],
    ).padding12();
  }
}

class _StateGalleryPage extends State<GalleryPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    GalleryManager galleryManager = ArcheBus.bus.of();
    return NavigationView(
      items: [
        NavigationItem(
          icon: const Icon(Icons.apps),
          label: "应用",
          page: GalleryContent(
            data: galleryManager.applications,
            onTap: (data) => showModalBottomSheet(
              context: context,
              builder: (context) => SizedBox.expand(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Text(
                        "应用列表",
                        style: TextStyle(fontSize: 24),
                      ).padding12(),
                      Wrap(
                        children: data.includes
                            .map(
                              (app) => CardButton(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                                size: galleryButtonSize,
                                onTap: () => AppController.pushPage(
                                  builder: (context) =>
                                      ApplicationPage(application: app),
                                ),
                                child: app.cover.build(size: 70.0),
                              ),
                            )
                            .cast<Widget>()
                            .toList(),
                      ),
                    ],
                  ),
                ).padding12(),
              ),
            ),
          ),
        ),
        NavigationItem(
          icon: const Icon(Icons.code),
          label: "环境",
          page: GalleryContent(
            data: galleryManager.environments,
            onTap: (data) => AppController.pushPage(
              builder: (context) => EnvironmentPage(environment: data),
            ),
          ),
        ),
        NavigationItem(
          icon: const Icon(Icons.book),
          label: "文档",
          page: GalleryContent(
            data: galleryManager.documents,
            onTap: (data) => AppController.pushPage(
              builder: (context) => DocumentPage(documents: data),
            ),
          ),
        ),
      ],
      direction: Axis.vertical,
      reversed: true,
      vertical:
          const NavigationVerticalConfig(surfaceTintColor: Colors.transparent),
    );
  }
}

class GalleryContent<T> extends StatefulWidget {
  final FutureLazyDynamicCan<List<T>> data;
  final void Function(T data) onTap;
  const GalleryContent({
    super.key,
    required this.data,
    required this.onTap,
  });

  @override
  State<StatefulWidget> createState() => _StateGalleryContent<T>();
}

class _StateGalleryContent<T> extends State<GalleryContent<T>> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        children: [
          FloatingActionButton(
            heroTag: "reload",
            child: const Icon(Icons.refresh),
            onPressed: () => widget.data.reload().then(
                  (value) => setState(
                    () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("刷新完成"))),
                  ),
                ),
          ),
          FloatingActionButton(
            heroTag: "import",
            child: const Icon(Icons.get_app),
            onPressed: () => widget.data.reload().then(
                  (value) => setState(
                    () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text("刷新完成"))),
                  ),
                ),
          ),
        ],
      ),
      body: widget.data.widgetBuilder(
        snapshotLoading(
          builder: (data) => SingleChildScrollView(
            child: Wrap(
              children: data
                  .map(
                    (entry) => CardButton(
                      size: const Size.square(120),
                      child: ((entry as dynamic).cover as RichCover)
                          .build(size: 84),
                      onTap: () => widget.onTap(entry),
                    ),
                  )
                  .toList(),
            ).padding12(),
          ),
        ),
      ),
    );
  }
}

class DocumentPage extends StatefulWidget {
  final Documents documents;
  const DocumentPage({
    super.key,
    required this.documents,
  });

  @override
  State<StatefulWidget> createState() => _StateDocumentPage();
}

class _StateDocumentPage extends State<DocumentPage>
    with IndexedNavigatorStateMixin {
  late ScrollController controller;
  bool fabVisible = true;
  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    controller.addListener(() {
      setState(() {
        fabVisible =
            controller.position.userScrollDirection == ScrollDirection.forward;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(),
        title: Text(widget.documents.documents[currentIndex].name),
      ),
      floatingActionButton: AnimatedOpacity(
          duration: Durations.medium4,
          opacity: fabVisible ? 1 : 0,
          child: AnimatedRotation(
            duration: Durations.medium4,
            turns: fabVisible ? 0.5 : 0,
            child: Builder(
              builder: (context) => FloatingActionButton(
                child: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    fabVisible = true;
                  });
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          )),
      drawer: NavigationDrawer(
        selectedIndex: currentIndex,
        onDestinationSelected: pushIndex,
        children: <Widget>[
          ListTile(
            title: Text(widget.documents.name),
            subtitle: Text(widget.documents.version.format()),
          )
        ].addAllThen(
          widget.documents.documents.mapEnumerate(
            (index, entry) => NavigationDrawerDestination(
              icon: Visibility(
                  visible: index == currentIndex,
                  child: const Icon(Icons.arrow_right)),
              label: Text(entry.name),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: File(widget.documents.documents[currentIndex].loacation)
            .readAsString(),
        builder: snapshotLoading(
          builder: (data) {
            return SingleChildScrollView(
              controller: controller,
              child: MarkdownBlockWidget(
                data.toString(),
              ).padding12(),
            );
          },
        ),
      ),
    );
  }
}
