import 'package:flutter/material.dart';
import 'package:valve_control/validators/valve_validator.dart';
import 'package:valve_control/models/valve/helper.dart';
import 'package:valve_control/models/valve/model.dart';

class AddValveScreen extends StatefulWidget {
  const AddValveScreen({super.key});

  @override
  State<AddValveScreen> createState() => _AddValveScreenState();
}

class _AddValveScreenState extends State<AddValveScreen> {
  ValveDBHelper? dbHandler;
  late Future<List<ValveModel>> valveDataList;
  final nameController = TextEditingController();
  late final ipController = TextEditingController();

  final _fromKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHandler = ValveDBHelper();
    loadData();
  }

  loadData() async {
    valveDataList = dbHandler!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
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
                  ),
                ),
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
                    onTap: () async {
                      if (await ValveValidator().validate(ipController.text)) {
                        dbHandler!.insert(ValveModel(
                            name: nameController.text, ip: ipController.text));
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).pop(true);
                        nameController.clear();
                        ipController.clear();
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
