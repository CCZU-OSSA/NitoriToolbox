import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return ListView(
      children: [
        SizedBox(
          width: width,
          child: const FittedBox(
            fit: BoxFit.cover,
            child: Column(
              children: [],
            ),
          ),
        ),
      ],
    );
  }
}
