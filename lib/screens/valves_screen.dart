import 'package:flutter/material.dart';
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

              return Container();
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
              ));
        },
      ),
    );
  }
}
