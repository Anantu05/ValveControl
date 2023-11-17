import 'package:flutter/material.dart';
import 'package:valve_control/models/tasks/helper.dart';
import 'package:valve_control/models/tasks/model.dart';
import 'package:valve_control/screens/add_task_screen.dart';
import 'package:valve_control/components/toggle_switch.dart';

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
                  int valveId = snapshot.data![index].id!.toInt();
                  String valveName = snapshot.data![index].name!.toString();
                  String valveTime = snapshot.data![index].time!.toString();
                  return Dismissible(
                    key: ValueKey<int>(valveId),
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
                        dbHelper!.delete(valveId);
                        loadData();
                        snapshot.data!.remove(snapshot.data![index]);
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
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: ListTile(
                                    contentPadding: EdgeInsets.all(10),
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 10),
                                      child: Text(valveTime),
                                    ),
                                    subtitle: Text(
                                      valveTime,
                                      style: TextStyle(fontSize: 17),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(right: 10.0),
                                  child: ToggleSwitch(
                                    initialValue:
                                        false, // todo: query for current state
                                    onToggle: (value) {
                                      // todo: query to set state of value
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  );
                },
              );
              // todo: populate with list of tasks
              //return Placeholder();
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
