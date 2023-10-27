import 'package:flutter/material.dart';
import 'package:valve_control/screens/valves_screen.dart';

void main() {
  runApp(const ValveControl());
}

class ValveControl extends StatelessWidget {
  const ValveControl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ValvesScreen());
  }
}
