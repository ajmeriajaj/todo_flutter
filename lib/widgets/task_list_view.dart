import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_flutter/database/hive_database.dart';
import 'package:todo_flutter/widgets/task_widgets.dart';

class TaskListView extends StatefulWidget {
  final List<HiveDataBase> tasks;
  const TaskListView({super.key, required this.tasks});

  @override
  State<TaskListView> createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  late Box<HiveDataBase> hive;

  @override
  void initState() {
    hive = Hive.box<HiveDataBase>('hiveDataBase');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = widget.tasks;

    return ListView.builder(
      scrollDirection: Axis.vertical,
        itemCount: tasksData.length,
        itemBuilder: (context, index) {
        final task = tasksData[index];
        return TaskWidgets(
            title: task.title,
            date: task.date,
            description: task.description,
            priority: task.priority,
            hive: task,
        );
        }
    );
  }
}
