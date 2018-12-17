// import 'dart:isolate';

import 'package:firebase_messaging/firebase_messaging.dart';
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
   final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();

   _firebaseMessaging.configure(
     onMessage: (Map<String, dynamic> message) {
       print("onMessage: $message");
     },
     onLaunch: (Map<String, dynamic> message) {
       print("onLaunch: $message");
     },
     onResume: (Map<String, dynamic> message) {
       print("onResume: $message");
     },
   );
   _firebaseMessaging.requestNotificationPermissions(
       const IosNotificationSettings(sound: true, badge: true, alert: true));
   _firebaseMessaging.onIosSettingsRegistered
       .listen((IosNotificationSettings settings) {
     print("Settings registered: $settings");
   });
   _firebaseMessaging.getToken().then((String token) {

   });
   _firebaseMessaging.subscribeToTopic("testing");
}
