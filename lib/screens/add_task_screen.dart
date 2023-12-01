import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:valve_control/components/datetime.dart';
import 'package:valve_control/components/toggle_switch.dart';
import 'package:valve_control/models/tasks/helper.dart';
import 'package:valve_control/models/tasks/model.dart';
import 'package:valve_control/models/valve/helper.dart';
import 'package:valve_control/models/valve/model.dart';
import 'package:valve_control/requests/valve_switch_request.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

@pragma('vm:entry-point')
void toggle(int id, Map<String, dynamic> params) async {
  List<ValveModel> valveDataList = await ValveDBHelper().getDataList();
  print(params);
  ValveModel valve =
      valveDataList.firstWhere((element) => element.name == params['name']);
  ValveStatusRequest().get(valve.ip ?? '192.168.0.0', params['state']);
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  TasksDBHelper? dbHandler;
  TimeOfDay time = TimeOfDay(hour: 10, minute: 30);
  bool state = true;
  late Future<List<TaskModel>> tasksDataList;
  final nameController = TextEditingController();
  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHandler = TasksDBHelper();
    loadData();
  }

  loadData() async {
    tasksDataList = dbHandler!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Task"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 100),
        child: SingleChildScrollView(
            child: Column(children: [
          Form(
            key: _fromKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: nameController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Name",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Enter Name";
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${time.hour}:${time.minute}',
                          style: TextStyle(fontSize: 32),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                            onPressed: () async {
                              TimeOfDay? newTime = await showTimePicker(
                                context: context,
                                initialTime: time,
                              );
                              if (newTime == null) return;
                              setState(() => time = newTime);
                            },
                            child: const Text("Pick Your Time",
                                style: TextStyle(
                                  color: Colors.white,
                                )))
                      ],
                    )),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: ToggleSwitch(
                      initialValue: state,
                      onToggle: (value) {
                        setState(() => state = value);
                      }),
                )
              ],
            ),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Material(
                  color: Colors.red[400],
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        nameController.clear();
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 55,
                      width: 120,
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.green[400],
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      if (_fromKey.currentState!.validate()) {
                        String name = nameController.text;
                        dbHandler!
                            .insert(TaskModel(
                                name: name,
                                time: timeOfDayToISO8601(time),
                                state: state ? "on" : "off"))
                            .then((value) => {
                                  (() {
                                    DateTime now = DateTime.now();
                                    DateTime dateTime = DateTime(
                                        now.year,
                                        now.month,
                                        now.day,
                                        time.hour,
                                        time.minute);

                                    AndroidAlarmManager.periodic(
                                        const Duration(minutes: 1),
                                        value.id ?? 0,
                                        toggle,
                                        // startAt: dateTime,
                                        params: {
                                          'name': name,
                                          'state': state
                                        }).then((value) => print(
                                        '=============================================\n=============================================\n=============================================\n=============================================\n=============================================\n=============================================\n=============================================\n=============================================\n=============================================\n============================================Scheduled============================================='));
                                  })()
                                });
                        Navigator.of(context).pop(true);
                        nameController.clear();
                      }
                    },
                    child: Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      height: 55,
                      width: 120,
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ])),
      ),
    );
  }
}
