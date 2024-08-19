import 'package:hive_flutter/hive_flutter.dart';

part 'todo.g.dart';

@HiveType(typeId: 0)
class Todo extends HiveObject {
  @HiveField(0)
  String name = "";

  @HiveField(1)
  DateTime? created;

  @HiveField(2)
  bool done = false;
}
