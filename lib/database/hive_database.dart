import 'package:hive/hive.dart';
part 'hive_database.g.dart';

@HiveType(typeId: 0)
class HiveDataBase extends HiveObject {
  @HiveField(0)
  late String title;

  @HiveField(1)
  late String date;

  @HiveField(2)
  late String description;

  @HiveField(3)
  String priority;

  @HiveField(4)
  bool isDone;

  HiveDataBase({
    required this.title,
    required this.date,
    required this.description,
    required this.priority,
    this.isDone = false
  });
}
