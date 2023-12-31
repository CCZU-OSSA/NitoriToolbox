import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
import 'package:nitoritoolbox/models/enums.dart';
import 'package:nitoritoolbox/views/pages/software.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<StatefulWidget> createState() => _StateGalleryPage();
}

class _StateGalleryPage extends State<GalleryPage> {
  @override
  Widget build(BuildContext context) {
    return Wrap(children: [
      Material(
        child: Hero(
          tag: HeroTag.navigator,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox.square(
                dimension: 128,
              ),
              onTap: () => AppController.pushHeroPage(
                  builder: (context, animation, secondaryAnimation) =>
                      const SoftWare()),
            ),
          ),
        ),
      ),
    ]);
  }
}
