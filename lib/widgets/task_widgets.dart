import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_flutter/database/hive_database.dart';
import 'package:todo_flutter/responsive.dart';

class TaskWidgets extends StatefulWidget {
  final String title;
  final String date;
  final String description;
  final String priority;
  final HiveDataBase hive;

  const TaskWidgets({
    super.key,
    required this.title,
    required this.date,
    required this.description,
    required this.priority,
    required this.hive
  });

  @override
  State<TaskWidgets> createState() => _TaskWidgetsState();
}

class _TaskWidgetsState extends State<TaskWidgets> {
  late Box<HiveDataBase> hive;
  Timer? _timer;
  bool isChecked = false;

  @override
  void initState() {
    hive = Hive.box<HiveDataBase>('hiveDataBase');
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    super.initState();
  }

  void deleteTask(HiveDataBase hive) async {
    final deletedTaskIndex = this.hive.values.toList().indexOf(hive);

    await hive.delete();

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Task ${hive.title} deleted'),
          duration: Duration(seconds: 6),
          action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                final newTask = HiveDataBase(
                    title: hive.title,
                    date: hive.date,
                    description: hive.description,
                    priority: hive.priority
                );

                this.hive.add(newTask);
                setState(() {});
              },
          ),
        )
    );
    setState(() {});
  }

  void toggleTaskDone() {
    widget.hive.isDone = !widget.hive.isDone;
    widget.hive.save();
    setState(() {});
  }
  
  void showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Do you want to delete data'),
        content: Text(widget.title),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => {
              Navigator.pop(context, 'OK'),
              deleteTask(widget.hive),
            },
            child: const Text('DELETE'),
          ),
        ],
      ),
    );
  }
  
  void showCannotDeleteSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      )
    );
  }

  void taskDeleteLogic() {
    if(widget.hive.priority.toLowerCase() == 'note') {
      showDeleteDialog();
    }  else if(widget.hive.priority.toLowerCase() == 'high') {
      if(widget.hive.isDone) {
        showDeleteDialog();
      } else {
        showCannotDeleteSnackBar('High priority task can be deleted after completion');
      }
    } else if(widget.hive.priority.toLowerCase() == 'low'
        || widget.hive.priority.toLowerCase() == 'medium') {
      showDeleteDialog();
    } else {
      showCannotDeleteSnackBar('Not find priority : ${widget.hive.priority}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(6.0 * getResponsive(context)),
      child: GestureDetector(
        onLongPress: () {
          taskDeleteLogic();
        },
        child: Column(
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(23),
              ),
              child: ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 23 * getResponsive(context),
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    Card(
                      color: Colors.amber,
                      elevation: 10,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10 * getResponsive(context),
                          vertical: 3 * getResponsive(context),
                        ),
                        child: Text(widget.priority),
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 0.010 * getHeight(context)),
                    Text(
                      'Date : ${widget.date}',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17 * getResponsive(context)),
                    ),
                    SizedBox(height: 0.006 * getHeight(context)),
                    Text('Description : ${widget.description}', style: TextStyle(fontSize: 17 * getResponsive(context))),
                  ],
                ),
                trailing: Checkbox(
                  value: widget.hive.isDone,
                  onChanged: (value) => toggleTaskDone(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
