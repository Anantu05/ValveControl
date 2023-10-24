import 'package:flutter/material.dart';

void main() {
runApp(const ValveControl());
}

class ValveControl extends StatelessWidget {
const ValveControl({Key? key}) : super(key: key);

@override
Widget build(BuildContext context) {
	return MaterialApp(
		home: Scaffold(
	appBar: AppBar(
		title: const Text('Valve Control'),
	),
	body: const Center(child: Text('Valving my way through!')),
	));
}
}
