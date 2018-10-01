import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:faxina/models/task.dart';
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
  final TaskBloc _bloc = new TaskBloc();
  List<Task> _taskList;
  
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'Nenhuma tarefa adicionada.',
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: new Icon(Icons.add),
      ),
    );
  }
}