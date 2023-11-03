import 'package:flutter/material.dart';
import 'package:valve_control/models/tasks/helper.dart';
import 'package:valve_control/models/tasks/model.dart';
import 'package:valve_control/screens/add_task_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TasksDBHelper? dbHelper;
  late Future<List<TaskModel>> taskDataList;
  @override
  void initState() {
    super.initState();
    dbHelper = TasksDBHelper();
    loadData();
  }

  loadData() async {
    taskDataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tasks"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: taskDataList,
            builder: (context, AsyncSnapshot<List<TaskModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Tasks Found",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                );
              }
              // todo: populate with list of tasks
              return Placeholder();
            },
          ))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddTaskScreen(),
              )).then((value) => {
                if (value)
                  {
                    setState(() {
                      loadData();
                    })
                  }
              });
        },
      ),
    );
  }
}
