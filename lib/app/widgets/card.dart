import 'package:fluent_ui/fluent_ui.dart';

class CardListTile extends ListTile {
  const CardListTile({
    super.key,
    super.tileColor,
    super.shape = kDefaultListTileShape,
    super.leading,
    super.title,
    super.subtitle,
    super.trailing,
    super.onPressed,
    super.focusNode,
    super.autofocus = false,
    super.semanticLabel,
    super.cursor,
    super.contentAlignment = CrossAxisAlignment.center,
    super.contentPadding = kDefaultListTilePadding,
  });
  @override
  Widget build(BuildContext context) {
    return Card(child: super.build(context));
  }
}
