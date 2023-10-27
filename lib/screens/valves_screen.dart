import 'package:flutter/material.dart';

class ValvesScreen extends StatefulWidget {
  const ValvesScreen({super.key});

  @override
  State<ValvesScreen> createState() => _ValvesScreenState();
}

class _ValvesScreenState extends State<ValvesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Valves"),
        centerTitle: true,
        elevation: 0,
      ),
    );
  }
}
