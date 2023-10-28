import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool initialValue;
  final ValueChanged<bool> onToggle;

  ToggleSwitch({required this.initialValue, required this.onToggle});

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _toggle() {
    setState(() {
      _value = !_value;
      widget.onToggle(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        width: 60.0,
        height: 30.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: _value ? Colors.green : Colors.grey,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 5.0,
          ),
          child: Row(
            mainAxisAlignment:
                _value ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 23.0,
                height: 23.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
