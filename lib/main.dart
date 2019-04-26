// import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:faxina/app.dart';
// import 'package:android_alarm_manager/android_alarm_manager.dart';

// void printHello() {
//   final DateTime now = new DateTime.now();
//   final int isolateId = Isolate.current.hashCode;
//   print("[$now] Hello, world! isolate=$isolateId function='$printHello'");
// }

void main() async {
  initState();
  // final int helloAlarmID = 0;
  runApp(new FaxinaApp());
  // await AndroidAlarmManager.periodic(const Duration(minutes: 1), helloAlarmID, printHello);
}

@override
void initState() {
   print("inicializando...");
}
