import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';
import 'package:nitoritoolbox/app/widgets/utils.dart';
import 'package:nitoritoolbox/core/lang.dart';
import 'package:scrollview_observer/scrollview_observer.dart';

class NitoriHorizonScrollView extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> content;
  const NitoriHorizonScrollView(
      {super.key, this.title = "", this.subtitle = "", required this.content});

  @override
  Widget build(BuildContext context) {
    var ctrl = ScrollController();
    return Card(
        child: Scrollbar(
            thumbVisibility: false,
            controller: ctrl,
            child: SingleChildScrollView(
              controller: ctrl,
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Column(children: [
                    NitoriText(
                      title,
                      size: 45,
                    ),
                    NitoriText(
                      subtitle,
                      size: 20,
                    )
                  ]),
                ].castF<Widget>().expandAll(content).joinElement(width20),
              ),
            )));
  }
}

extension ObsListView on ScaffoldPage {
  ListViewObserver observer({ListObserverController? controller}) {
    return ListViewObserver(
        controller: controller ?? ListObserverController(), child: this);
  }
}