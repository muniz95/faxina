import 'package:faxina/bloc/task.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final Widget child;
  final TaskBloc taskBloc = new TaskBloc();

  Provider({this.child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(Provider) as Provider);
  }
}