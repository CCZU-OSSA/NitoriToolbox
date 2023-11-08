import 'package:fluent_ui/fluent_ui.dart';

class PaneRouter {
  List<NavigationPaneItem> body = [];
  List<NavigationPaneItem> footer = [];
  int total = -1;
  int select = 0;

  Function setState;

  PaneRouter(
      {required this.body, required this.footer, required this.setState}) {
    __allocateID(body);
    __allocateID(footer);
  }

  void __allocateID(List<NavigationPaneItem> list) {
    int ct = 0;
    for (var element in list) {
      if (element is PaneItem) {
        total++;
        int v = total;
        list[ct] = element.copyWith(
          onTap: () {
            setState(() {
              select = v;
            });
          },
        );
      }
      ct++;
    }
  }
}
