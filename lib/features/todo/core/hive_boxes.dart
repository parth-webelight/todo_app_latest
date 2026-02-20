import 'package:hive_flutter/adapters.dart';

class HiveBoxes {
  static Box getToDoBox() => Hive.box('todoBox');
}