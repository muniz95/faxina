import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
import 'package:faxina/screens/taskForm.dart';
import 'package:flutter/material.dart';

class FaxinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Faxina',
        theme: new ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: new FaxinaPage(title: 'Flutter Demo Home Page'),
      )
    );
  }
}

class FaxinaPage extends StatefulWidget {
  FaxinaPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _FaxinaPageState createState() => new _FaxinaPageState();
}

class _FaxinaPageState extends State<FaxinaPage> {
  
  @override
  Widget build(BuildContext context) {
    final TaskBloc _bloc = Provider.of(context).taskBloc;
    // List<Task> _taskList;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _bloc.selectedTask,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            Task taskList = snapshot.data as Task;
            return new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Nenhuma tarefa adicionada.'),
                  new Text(taskList.name),
                ],
              ),
            );
          }
          return Text('Não há dados');
        }
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _bloc.addTask(new Task(name: 'teste'));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TaskForm(),
            ),
          );
        },
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}