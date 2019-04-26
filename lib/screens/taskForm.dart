import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class TaskForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => TaskFormState();
}

class TaskFormState extends State<TaskForm> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of(context).taskBloc;

    return StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) =>
        snapshot.hasData 
          ? _hasDataWidget(_bloc, snapshot.data)
          : _loadingDataWidget()
    );
  }

  Widget _hasDataWidget(TaskBloc _bloc, Task task) =>
    Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de tarefas"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Text(
              "Nova tarefa",
              textScaleFactor: 2.0,
            ),
            Form(
              key: formKey,
              child: Column(
                children: <Widget>[
                  _nameField(task),
                  _intervalField(task),
                  _lastDoneField(task),
                ],
              ),
            ),
            _submitBtn(_bloc, task),
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
        ),
      )
    );

  Widget _loadingDataWidget() =>
    Center(
      child: Dialog(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            Text("Loading"),
          ],
        ),
      ),
    );

  Padding _nameField(Task task) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        initialValue: task.name,
        onSaved: (val) {
          task.name = val;
        },
        validator: (val) {
          return val.length < 1
              ? "Name must have atleast 1 chars"
              : null;
        },
        decoration: InputDecoration(labelText: "Nome"),
      ),
    );

  Padding _intervalField(Task task) =>
    Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
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
        decoration: InputDecoration(labelText: "Intervalo de tempo (em dias)"),
      ),
    );

  _lastDoneField(Task task) {
    final dateFormat = DateFormat("dd/MM/yyyy");
    BehaviorSubject<DateTime> lastDone = BehaviorSubject<DateTime>()..sink.add(task.lastDone);
    return StreamBuilder(
      stream: lastDone,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          DateTime _lastDone = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text('Realizada em ${dateFormat.format(_lastDone)}'),
                IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    task.lastDone = null;
                    lastDone..add(null)..close();
                  },
                ),
              ],
            ),
          );
        }
        else {
          return Text('');
        }
      }
    );
  }
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
    return RaisedButton(
      onPressed: () {
        _submit(bloc, task);
        Navigator.of(context).pop();
      },
      child: Text("Salvar"),
    );
  }

}