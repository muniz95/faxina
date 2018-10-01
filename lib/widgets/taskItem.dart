import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final TaskBloc _bloc = new TaskBloc();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
        stream: _bloc.selectedTask,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final _topic = snapshot.data as Task;
            return Text(_topic.name, style: TextStyle(fontSize: 14.0));
          }
          return Text('null');
        },
      )
    );
  }
}