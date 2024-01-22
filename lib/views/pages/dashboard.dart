import 'package:arche/arche.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        const ListTile(
          title: Text("仪表盘"),
        ),
        SizedBox(
          width: width,
          child: const FittedBox(
            fit: BoxFit.cover,
            child: Column(
              children: [
                Row(
                  children: [
                    CardButton(
                      size: Size.square(120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [Icon(FontAwesomeIcons.book), Text("使用说明")],
                      ),
                    ),
                    CardButton(
                      size: Size.square(120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.github),
                          Text("开源地址"),
                        ],
                      ),
                    ),
                    CardButton(
                      size: Size.square(120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.bookOpen),
                          Text("使用协议")
                        ],
                      ),
                    ),
                    CardButton(
                      size: Size.square(120),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.bookOpen),
                          Text("免责声明")
                        ],
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
