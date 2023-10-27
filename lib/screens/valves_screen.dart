import 'package:flutter/material.dart';
import 'package:valve_control/db/db_handler.dart';
import 'package:valve_control/models/model.dart';
import 'package:valve_control/screens/add_valve_screen.dart';

class ValvesScreen extends StatefulWidget {
  const ValvesScreen({super.key});

  @override
  State<ValvesScreen> createState() => _ValvesScreenState();
}

class _ValvesScreenState extends State<ValvesScreen> {
  DBHandler? dbHandler;
  late Future<List<Model>> valveDataList;
  @override
  void initState() {
    super.initState();
    dbHandler = DBHandler();
    loadData();
  }

  loadData() async {
    valveDataList = dbHandler!.getDataList('valves');
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
            builder: (context, AsyncSnapshot<List<Model>> snapshot) {
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
