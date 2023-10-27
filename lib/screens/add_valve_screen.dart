import 'package:flutter/material.dart';
import 'package:valve_control/db/db_handler.dart';
import 'package:valve_control/models/model.dart';
import 'package:valve_control/models/valve_model.dart';

class AddValveScreen extends StatefulWidget {
  const AddValveScreen({super.key});

  @override
  State<AddValveScreen> createState() => _AddValveScreenState();
}

class _AddValveScreenState extends State<AddValveScreen> {
  DBHandler? dbHandler;
  late Future<List<Model>> valveDataList;

  final _fromKey = GlobalKey<FormState>();

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
    final nameController = TextEditingController();
    final ipController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Valve"),
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
                  child: TextFormField(
                    keyboardType: TextInputType.url,
                    controller: ipController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "IP Address",
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "Enter IP Address";
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          Container(
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
                        ipController.clear();
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
                        dbHandler!.insert(ValveModel(
                            name: nameController.text, ip: ipController.text));
                        Navigator.of(context).pop();
                        nameController.clear();
                        ipController.clear();
                        print("Valve Added");
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
