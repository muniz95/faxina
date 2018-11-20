import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

class FaxinaPage extends StatelessWidget {
  FaxinaPage({Key key, this.title}) : super(key: key);

  final String title;
  
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of(context).taskBloc;

    // List<Task> _taskList;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(title),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: StreamBuilder(
          initialData: _bloc.fetchTasks(),
          stream: _bloc.taskList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              List<Task> taskList = snapshot.data as List<Task>;
              if (taskList.length > 0) {
                return ListView.builder(
                  itemCount: taskList.length,
                  itemBuilder: (_, int index) =>
                    _slidableCard(taskList[index], _bloc, context),
                );
              }
              else {
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
            else {
              return Center(
                child: new Dialog(
                  child: new Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new CircularProgressIndicator(),
                      new Text("Loading"),
                    ],
                  ),
                ),
              );
            } 
          }
        ),
      ),      
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _bloc.clearSelectedTask();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TaskForm(),
            ),
          );
        },
        tooltip: 'Adicionar tarefa',
        child: new Icon(Icons.add),
      ),
    );
  }

  _slidableCard(Task task, TaskBloc bloc, BuildContext ctx) {
    return Container(
      child: new Column(
        children: <Widget>[
          Slidable(
            delegate: new SlidableDrawerDelegate(),
            actionExtentRatio: 0.25,
            child: new Container(
              color: Colors.white,
              child: ListTile(
                leading: (task.lastDone != null) ? new Icon(Icons.check, color: (task.lastDone == null) ? Colors.grey : Colors.green,) : new Icon(Icons.check_box_outline_blank, color: Colors.grey,),
                title: new Text(task.name ?? '---'),
                trailing: new Text(task.lastDone != null ? _leftDays(task) : 'Pendente'),
                onTap: () {
                  print(task.id);
                }
              )
            ),
            actions: <Widget>[
              new IconSlideAction(
                caption: 'Editar',
                color: Colors.blue,
                icon: Icons.archive,
                onTap: () {
                  bloc.selectTask(task);
                  Navigator.push(
                    ctx,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TaskForm(),
                    ),
                  );
                }
              ),
            ],
            secondaryActions: <Widget>[
              new IconSlideAction(
                caption: 'Concluir',
                color: Colors.green,
                icon: Icons.check,
                onTap: () {
                  bloc.checkTask(task);
                },
              ),
            ],
            closeOnScroll: true,
          ),
          new Divider(color: Colors.grey)
        ],
      )
    );
  }

  String _leftDays(Task task) {
    int leftDays = task.lastDone
      .add(Duration(days: task.interval))
      .difference(DateTime.now())
      .inDays;
    return leftDays == 1 ? 'Falta 1 dia' : 'Faltam $leftDays dias';
  }
}