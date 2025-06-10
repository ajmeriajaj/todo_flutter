import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_flutter/database/hive_database.dart';
import 'package:todo_flutter/screen/add_task_screen.dart';
import 'package:todo_flutter/widgets/task_list_view.dart';
import '../responsive.dart';
import '../widgets/filter_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box<HiveDataBase> hive;
  final _searchController = TextEditingController();
  Timer? _timer;
  String _searchQuery = '';
  List<HiveDataBase> _searchTask = [];
  bool isSelected = false;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    hive = Hive.box<HiveDataBase>('hiveDataBase');

    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (_) => setState(() {
          _searchQuery = _searchController.text.trim().toLowerCase();
          _search();
        }),
    );
  }

  void _search() {
    final allTask = hive.values.toList();
    List<HiveDataBase> filteredTasks;


    if (_searchQuery.isEmpty) {
      filteredTasks = allTask;
    } else {
      filteredTasks = allTask.where((task) {
        final name = task.title.toLowerCase();
        return name.contains(_searchQuery) || name.startsWith(_searchQuery);
      }).toList();
    }

    if (_selectedFilter == 'Completed') {
      filteredTasks = filteredTasks.where((task) => task.isDone).toList();
    } else if(_selectedFilter == 'Pending'){
      filteredTasks = filteredTasks.where((task) => !task.isDone).toList();
    }

    _searchTask = filteredTasks;
  }

  void _onFilterChange(String filter) {
    setState(() {
      _selectedFilter = filter;
      _search();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.menu),
        title: Text("Todo"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(13.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SearchBar(
              controller: _searchController,
              hintText: "Search you're looking for",
              leading: Icon(Icons.search),
            ),
            SizedBox(height: 0.017 * getHeight(context),),
            SizedBox(
                height: 0.043 * getHeight(context),
                child: FilterListView(
                  selectedFilter: _selectedFilter,
                  onFilterSelected: _onFilterChange,
                )),
            Expanded(
              child: _searchTask.isEmpty
                  ? Center(child: Text("NO DATA AVAILABLE"),)
                  : TaskListView(tasks: _searchTask)
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                    (context) => AddTaskScreen(),
                )
            );
          },
        child: Icon(Icons.add),
      )
    );
  }
}
