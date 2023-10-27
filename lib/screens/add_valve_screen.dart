import 'package:flutter/material.dart';
import 'package:valve_control/db/db_handler.dart';
import 'package:valve_control/models/model.dart';

class AddValveScreen extends StatefulWidget {
  const AddValveScreen({super.key});

  @override
  State<AddValveScreen> createState() => _AddValveScreenState();
}

class _AddValveScreenState extends State<AddValveScreen> {
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
    return const Placeholder();
  }
}
