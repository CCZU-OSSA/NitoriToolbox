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

class SquareCard extends StatelessWidget {
  final double size;
  const SquareCard({super.key, this.size = 240});

  @override
  Widget build(BuildContext context) {
    return Card(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: size,
          width: size,
          child: const Row(),
        ));
  }
}
