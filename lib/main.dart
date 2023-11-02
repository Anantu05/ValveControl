import 'package:flutter/material.dart';
import 'package:valve_control/screens/valves_screen.dart';

void main() {
  runApp(MaterialApp(home:ValveControl()));
}

class ValveControl extends StatefulWidget {
  @override
  // ignore: library_private_types_in_public_api
  _ValveControlState createState() => _ValveControlState();
}
class _ValveControlState extends State<ValveControl>{
  int _currentIndex = 0;
  _getDrawerItemWidget(int pos){
    switch (pos){
      case 0:
        return ValvesScreen();
      case 1:
        return Placeholder();
    }
  }
  //List<String> titleList = ["Home", "Scheduler"];
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSurface.withOpacity(.60),
        selectedLabelStyle: textTheme.bodySmall,
        unselectedLabelStyle: textTheme.bodySmall,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            label: 'Home',
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: 'Scheduler',
            icon: Icon(Icons.punch_clock),
          ),
        ],
      ),
      body: _getDrawerItemWidget(_currentIndex),
    );
  }
}
