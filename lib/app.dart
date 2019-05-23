import 'package:faxina/bloc/provider.dart';
import 'package:faxina/screens/tasks.screen.dart';
import 'package:flutter/material.dart';

class FaxinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Faxina',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: TasksScreen(),
      )
    );
  }
}
