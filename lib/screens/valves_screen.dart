import 'package:flutter/material.dart';
import 'package:valve_control/components/toggle_switch.dart';
import 'package:valve_control/models/valve/helper.dart';
import 'package:valve_control/models/valve/model.dart';
import 'package:valve_control/screens/add_valve_screen.dart';

class ValvesScreen extends StatefulWidget {
  const ValvesScreen({super.key});

  @override
  State<ValvesScreen> createState() => _ValvesScreenState();
}

class _ValvesScreenState extends State<ValvesScreen> {
  ValveDBHelper? dbHelper;
  late Future<List<ValveModel>> valveDataList;
  @override
  void initState() {
    super.initState();
    dbHelper = ValveDBHelper();
    loadData();
  }

  loadData() async {
    valveDataList = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valves"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
              child: FutureBuilder(
            future: valveDataList,
            builder: (context, AsyncSnapshot<List<ValveModel>> snapshot) {
              if (!snapshot.hasData || snapshot.data == null) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    "No Valves Found",
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
                  String valveIP = snapshot.data![index].ip!.toString();
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
                                      child: Text(valveName),
                                    ),
                                    subtitle: Text(
                                      valveIP,
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
                                      print("Toggle switched to $value");
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
                builder: (context) => AddValveScreen(),
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
