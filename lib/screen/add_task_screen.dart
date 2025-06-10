import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:todo_flutter/database/hive_database.dart';
import 'package:todo_flutter/responsive.dart';

class AddTaskScreen extends StatefulWidget {
  final HiveDataBase? hive;
  const AddTaskScreen({super.key, this.hive});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late Box<HiveDataBase> hive;
  final _titleController = TextEditingController();
  final _dateController = TextEditingController();
  final _descriptionController = TextEditingController();
  String selectedValue = 'High'; // default value
  List<String> priorityList = ['High', 'Medium', 'Low', 'Note'];


  @override
  void initState() {
    super.initState();
    hive = Hive.box<HiveDataBase>('hiveDataBase');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  bool addTask(String title, String date, String description) {
    if(title.isEmpty) {
      Fluttertoast.showToast(msg: "add title");
      return false;
    } else if (date.isEmpty) {
      Fluttertoast.showToast(msg: "add date");
      return false;
    } else if (description.isEmpty) {
      Fluttertoast.showToast(msg: "add description");
      return false;
    } else {
      final title = _titleController.text;
      final date = _dateController.text;
      final description = _descriptionController.text;

      final taskData = HiveDataBase(
          title: title, date: date, description: description, priority: selectedValue);

      hive.add(taskData);
      Fluttertoast.showToast(msg: "Task Added Successfully");
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "title",
                border: OutlineInputBorder(),
              ),
              maxLines: 1,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 0.013 * getHeight(context)),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: "due Date",
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
              onTap: () async {
                DateTime? pickDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickDate != null) {
                  String formatedDate =
                      '${pickDate.day}/${pickDate.month}/${pickDate.year}';
                  _dateController.text = formatedDate;
                }
              },
            ),
            SizedBox(height: 0.013 * getHeight(context)),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: "description",
                border: OutlineInputBorder(),
              ),
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 0.013 * getHeight(context)),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 13 * getResponsive(context)),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: DropdownButton<String>(
                value: selectedValue,
                  items: priorityList.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                        child: Text(value),
                    );
                  },).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedValue = newValue!;
                    });
                  },
              ),
            ),
            SizedBox(height: 0.013 * getHeight(context)),
            ElevatedButton(
              onPressed: () {
                final title = _titleController.text;
                final date = _dateController.text;
                final description = _descriptionController.text;

                bool success = addTask(title, date, description);
                if (success) {
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: StadiumBorder(),
                minimumSize: Size(double.infinity, 0.050 * getHeight(context)),
              ),
              child: Text(
                "Add Task",
                style: TextStyle(
                  fontSize: 15 * getResponsive(context),
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
