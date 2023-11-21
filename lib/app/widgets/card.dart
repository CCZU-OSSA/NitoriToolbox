import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';

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
  final String title;
  final String subtitle;
  final String button;
  final String? background;
  final Widget icon;
  final Function() onPressed;
  const SquareCard(
      {super.key,
      this.size = 256,
      this.button = "OPEN",
      this.background,
      required this.title,
      required this.subtitle,
      required this.onPressed,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomLeft, children: [
      SizedBox(
        height: size,
        width: size,
        child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("resource/images/nitori_icon.png"),
                  opacity: 0.5)),
          child: Card(
            borderRadius: BorderRadius.circular(8),
            child: const SizedBox.expand(),
          ),
        ),
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: background == null
                ? BorderRadius.circular(8)
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8)),
            color: getCurrentThemePriColor(context)),
        child: SizedBox(
          height: background == null ? size : size / 2.5,
          width: size,
        ),
      ),
      SizedBox(
        width: size,
        height: size,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    offset: Offset(0, size / 24),
                    blurRadius: size / 24,
                    color: Colors.black.withOpacity(0.4))
              ]),
              child: Card(
                backgroundColor: Colors.white,
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(width: size / 4, height: size / 4, child: icon),
              ),
            ),
            SizedBox(
              width: size / 12,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                NitoriText(
                  title,
                  size: size / 2 / 10 * 3,
                ),
                NitoriText(
                  subtitle,
                  color: Colors.white,
                  size: size / 2 / 10,
                ),
              ],
            )
          ],
        ),
      ),
      SizedBox(
        height: size / 2.5,
        width: size,
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
          Button(onPressed: onPressed, child: NitoriText(button)),
          SizedBox(
            width: size / 12 * 1.8,
          )
        ]),
      )
    ]);
  }
}
