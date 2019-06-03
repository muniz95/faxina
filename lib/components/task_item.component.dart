import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/models/task.model.dart';
import 'package:flutter/material.dart';

class TaskItem extends StatelessWidget {
  final TaskBloc _bloc = new TaskBloc();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder<Task>(
        stream: _bloc.selectedTask,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final _topic = snapshot.data;
            return Text(_topic.name, style: TextStyle(fontSize: 14.0));
          }
          return Text('null');
        },
      )
    );
  }
}