import 'package:fluent_ui/fluent_ui.dart';

class PaneRouter {
  Map<String, NavigationPaneItem> body = {};
  Map<String, NavigationPaneItem> footer = {};
  final Map<String, int> _nameindex = {};

  int total = -1;

  /// inner page index
  int select = 0;

  Function setState;

  PaneRouter(
      {required this.body, required this.footer, required this.setState}) {
    __allocateID(body);
    __allocateID(footer);
  }

  void pushName(String name) {
    setState(() {
      select = _nameindex.containsKey(name) ? _nameindex[name]! : 0;
    });
  }

  void pop(BuildContext context) {
    Navigator.pop(context);
  }

  /// use to allocate the page id
  void __allocateID(Map<String, NavigationPaneItem> map) {
    for (var element in map.entries) {
      var val = element.value;
      if (val is PaneItem) {
        total++;
        int v = total;
        map[element.key] = val.copyWith(
          onTap: () {
            setState(() {
              select = v;
            });
          },
        );
        _nameindex[element.key] = v;
      }
    }
  }
}
