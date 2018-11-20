import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final formKey = new GlobalKey<FormState>();
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of(context).taskBloc;

    return new StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        Task task = snapshot.data as Task;
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("Cadastro de tarefas"),
          ),
          body: new Center(
            child: new Column(
              children: <Widget>[
                new Text(
                  "Nova tarefa",
                  textScaleFactor: 2.0,
                ),
                new Form(
                  key: formKey,
                  child: new Column(
                    children: <Widget>[
                      _nameField(task),
                      _intervalField(task),
                    ],
                  ),
                ),
                _submitBtn(_bloc, task),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )
        );
      },
    );
  }

  Padding _nameField(Task task) =>
    new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
        initialValue: task.name,
        onSaved: (val) {
          task.name = val;
        },
        validator: (val) {
          return val.length < 1
              ? "Name must have atleast 1 chars"
              : null;
        },
        decoration: new InputDecoration(labelText: "Nome"),
      ),
    );

  Padding _intervalField(Task task) =>
    new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
        keyboardType: TextInputType.number,
        initialValue: '${task.interval ?? ''}',
        onSaved: (val) {
          task.interval = int.parse(val);
        },
        validator: (val) {
          return int.parse(val) < 1
              ? "O intervalo deve ser de no mínimo 1 dia"
              : null;
        },
        decoration: new InputDecoration(labelText: "Intervalo de tempo (em dias)"),
      ),
    );

  void _submit(TaskBloc bloc, Task task) async {
    final form = formKey.currentState;
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (form.validate()) {
      form.save();
      if (task.id != null) {
        await bloc.updateTask(task);
      } else {
        await bloc.addTask(task);
      }
    }
  }

  RaisedButton _submitBtn(TaskBloc bloc, Task task) {
    return new RaisedButton(
      onPressed: () {
        _submit(bloc, task);
        Navigator.of(context).pop();
      },
      child: new Text("Salvar"),
    );
  }

}