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

  void push(BuildContext context,
      {required Widget Function(BuildContext) builder}) {
    Navigator.push(context, FluentPageRoute(builder: builder));
  }

  void replaceWidget(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, FluentPageRoute(builder: (context) => widget));
  }

  void pushWidget(BuildContext context, Widget widget) {
    Navigator.push(context, FluentPageRoute(builder: (context) => widget));
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
        if (val is NitoriPaneItemExpander) {
          __allocateID(val.itemmap);
        }
      }
    }
  }
}

class NitoriPaneItemExpander extends PaneItemExpander {
  final Map<String, NavigationPaneItem> itemmap;
  NitoriPaneItemExpander(
      {required super.icon, required this.itemmap, required super.body})
      : super(items: itemmap.values.toList());
}
