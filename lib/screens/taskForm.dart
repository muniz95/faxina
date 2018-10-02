import 'package:faxina/bloc/provider.dart';
import 'package:faxina/models/task.dart';
import 'package:flutter/material.dart';

class TaskForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of(context).taskBloc;
    return new StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Task task = snapshot.data as Task;
        if (snapshot.hasData) {
          return new Scaffold(
            body: new Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Tarefa: ${task.name}'),
                ],
              ),
            )
          );
        } else {
          return new Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text('não'),
                new Text('há'),
                new Text('dados'),
                new Text('para'),
                new Text('exibir'),
              ],
            ),
          );
        }
      },
    );
  }

}