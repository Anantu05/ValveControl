import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String timeOfDayToISO8601(TimeOfDay timeOfDay) {
  DateTime now = DateTime.now();
  DateTime dateTime =
      DateTime(now.year, now.month, now.day, timeOfDay.hour, timeOfDay.minute);
  return DateFormat("HH:mm:ss").format(dateTime);
}

TimeOfDay iso8601ToTimeOfDay(String iso8601String) {
  DateTime dateTime = DateFormat("HH:mm:ss").parse(iso8601String);
  return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
}
