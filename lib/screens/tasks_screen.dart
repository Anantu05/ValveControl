import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:valve_control/components/datetime.dart';
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
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  int taskId = snapshot.data![index].id!.toInt();
                  String valveName = snapshot.data![index].name!.toString();
                  String unparsedTime = snapshot.data![index].time!.toString();
                  TimeOfDay taskTime = iso8601ToTimeOfDay(unparsedTime);
                  return Dismissible(
                    key: ValueKey<int>(taskId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.redAccent,
                      child: Icon(
                        Icons.delete_forever,
                        color: Colors.white,
                      ),
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        dbHelper!.delete(taskId);
                        loadData();
                        snapshot.data!.remove(snapshot.data![index]);
                        AndroidAlarmManager.cancel(taskId);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          spreadRadius: 1,
                        )
                      ]),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10),
                        title: Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(valveName),
                        ),
                        subtitle: Text(
                          '${taskTime.hour}:${taskTime.minute}',
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                  );
                },
              );
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
                if (value != null && value)
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
