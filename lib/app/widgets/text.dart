import 'package:fluent_ui/fluent_ui.dart';

class NitoriText extends StatelessWidget {
  final bool selectable;
  final String data;
  final double? size;
  final Color? color;

  const NitoriText(this.data,
      {super.key, this.selectable = false, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(fontFamily: "Default", fontSize: size, color: color);
    return selectable
        ? SelectableText(
            data,
            style: style,
          )
        : Text(
            data,
            style: style,
          );
  }
}
