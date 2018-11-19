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
        home: new FaxinaPage(title: 'Lista de afazeres'),
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
  TaskBloc _bloc;
  
  @override
  Widget build(BuildContext context) {
    _bloc = Provider.of(context).taskBloc;
    _bloc.fetchTasks();

    // List<Task> _taskList;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: StreamBuilder(
        stream: _bloc.taskList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List<Task> taskList = snapshot.data as List<Task>;
            return new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Text('Total de tarefas: ${taskList.length.toString()}'),
                ],
              ),
            );
          } else {
            return new Center(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Não há dados'),
                ],
              ),
            );
          }
        }
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
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