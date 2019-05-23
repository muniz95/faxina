import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/models/task.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

class TaskFormScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  TaskBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = Provider.of(context).taskBloc;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _bloc.selectedTask,
      builder: (BuildContext context, AsyncSnapshot snapshot) =>
        snapshot.hasData 
          ? _hasDataWidget(snapshot.data)
          : _loadingDataWidget()
    );
  }

  Widget _hasDataWidget(Task task) =>
    Scaffold(
      appBar: AppBar(
        title: Text("Cadastro de tarefas"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
    Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Dialog(
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              Divider(),
              Text("Loading"),
            ],
          ),
        ),
      ),
    );

  Widget _nameField(Task task) =>
    Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.amber
      ),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        initialValue: task.name,
        onSaved: (val) {
          task.name = val;
        },
        validator: (val) {
          return val.length < 1
              ? "Name must have atleast 1 chars"
              : null;
        },
        style: TextStyle(
          height: 0
        ),
        decoration: InputDecoration(
          labelText: "Nome",
          border: InputBorder.none
        ),
      ),
    );

  Widget _intervalField(Task task) =>
    Container(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.amber
      ),
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
        style: TextStyle(
          height: 0
        ),
        decoration: InputDecoration(
          labelText: "Intervalo de tempo (em dias)",
          border: InputBorder.none
        ),
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
            padding: const EdgeInsets.all(10.0),
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
          return Container();
        }
      }
    );
  }
  Future _submit(TaskBloc bloc, Task task) async {
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
      onPressed: () async {
        await _submit(bloc, task);
        Navigator.of(context).pop();
      },
      child: Text("Salvar"),
    );
  }

}