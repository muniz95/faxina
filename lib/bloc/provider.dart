import 'package:faxina/bloc/auth.bloc.dart';
import 'package:faxina/bloc/task.dart';
import 'package:flutter/material.dart';

class Provider extends InheritedWidget {
  final Widget child;
  final TaskBloc taskBloc = TaskBloc();
  final AuthBloc authBloc = AuthBloc();

  Provider({this.child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(Provider);
  }
}