import 'package:flutter/material.dart';
import 'package:nitoritoolbox/controller/appcontroller.dart';
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
          tag: 0,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox.square(
                dimension: 128,
              ),
              onTap: () => AppController.pushHeroPage(
                  builder: (context, animation, secondaryAnimation) =>
                      const SoftWare(),
                  tag: 0),
            ),
          ),
        ),
      ),
      Material(
        child: Hero(
          tag: 1,
          child: Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              child: const SizedBox.square(
                dimension: 128,
              ),
              onTap: () => AppController.pushHeroPage(
                builder: (context, animation, secondaryAnimation) =>
                    const SoftWare(),
                tag: 1,
              ),
            ),
          ),
        ),
      ),
    ]);
  }
}
