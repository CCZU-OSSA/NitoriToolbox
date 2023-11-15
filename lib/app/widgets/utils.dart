import 'package:fluent_ui/fluent_ui.dart';
import 'package:nitoritoolbox/app/colors.dart';
import 'package:nitoritoolbox/app/widgets/resource.dart';
import 'package:nitoritoolbox/app/widgets/text.dart';

const height05 = SizedBox(
  height: 5,
);

const height20 = SizedBox(
  height: 20,
);

const height40 = SizedBox(
  height: 40,
);

const width05 = SizedBox(
  width: 5,
);

const width20 = SizedBox(
  width: 20,
);

const width40 = SizedBox(
  width: 40,
);

const shrink = SizedBox.shrink();

const loading = Column(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [ProgressRing(), height20, Text("请耐心等待")],
);

Widget banner(BuildContext context,
    {String? image, String? title, String? subtitle}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      width40,
      Column(
        children: [
          height05,
          SizedBox(
              child: Card(
            borderColor: getCurrentThemePriColor(context,
                dark: Colors.white.withOpacity(0.8),
                light: Colors.grey.withOpacity(0.8)),
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(image ?? imagePNG("info")),
          )),
          height20
        ],
      ),
      width40,
      Column(
        children: [
          NitoriText(title ?? "系统信息", size: 40),
          NitoriText(subtitle ?? "SYSTEM INFO", size: 30),
        ],
      )
    ],
  );
}

Container shadow(Widget child,
    {Color? background, BorderRadius? radius, double? height, double? width}) {
  return Container(
    height: height,
    width: width,
    decoration:
        BoxDecoration(color: background, borderRadius: radius, boxShadow: [
      BoxShadow(
          offset: const Offset(0, 8),
          color: Colors.black.withOpacity(0.4),
          blurRadius: 10)
    ]),
    child: child,
  );
}

Widget text(String data,
    {double? size, Color? color, bool selectable = false}) {
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
