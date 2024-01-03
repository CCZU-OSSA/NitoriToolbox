import 'package:nitoritoolbox/models/enums.dart';

class Block {
  String title;
  List<(bool, String)> contents;
  TaskStatus status = TaskStatus.block;

  Block({required this.title, required this.contents});

  void add(bool ok, String value) {
    contents.add((ok, value));
  }
}
