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
  TaskBloc _bloc;
  Task task = new Task();

  @override
  Widget build(BuildContext context) {
    var submitBtn = new RaisedButton(
      onPressed: () {
        _submit();
        Navigator.of(context).pop();
      },
      child: new Text("Salvar"),
    );

    _bloc = Provider.of(context).taskBloc;
    return new StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                      _nameField(),
                      _intervalField(),
                    ],
                  ),
                ),
                submitBtn
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
          )
        );
      },
    );
  }

  Padding _nameField() =>
    new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
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

  Padding _intervalField() =>
    new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new TextFormField(
        keyboardType: TextInputType.number,
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

  void _submit() async {
    final form = formKey.currentState;
    SystemChannels.textInput.invokeMethod('TextInput.hide');

    if (form.validate()) {
      form.save();
      await _bloc.addTask(task);
    }
  }

}