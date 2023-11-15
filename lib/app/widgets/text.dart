import 'package:fluent_ui/fluent_ui.dart';
import 'package:markdown_widget/widget/markdown.dart';

class NitoriText extends StatelessWidget {
  final bool selectable;
  final bool isdisplay;
  final String data;
  final double? size;
  final Color? color;
  final FontStyle? fontStyle;
  const NitoriText(this.data,
      {super.key,
      this.selectable = false,
      this.isdisplay = false,
      this.size,
      this.color,
      this.fontStyle});

  @override
  Widget build(BuildContext context) {
    var style = TextStyle(
        fontFamily: isdisplay ? "Display" : "Default",
        fontSize: size,
        color: color,
        fontStyle: fontStyle);
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

class NitoriTitle extends StatelessWidget {
  final String data;
  final int level;
  const NitoriTitle(this.data, {super.key, this.level = 2});

  @override
  Widget build(BuildContext context) {
    return MarkdownWidget(
      data: "${"#" * level} $data",
      shrinkWrap: true,
    );
  }
}
