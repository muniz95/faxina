import 'package:faxina/bloc/auth.bloc.dart';
import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:faxina/models/task.dart';
import 'package:faxina/screens/task_form.screen.dart';
import 'package:flutter/material.dart';

class FaxinaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      child: MaterialApp(
        title: 'Faxina',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: FaxinaPage(),
      )
    );
  }
}

class FaxinaPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _FaxinaPageState();
}

class _FaxinaPageState extends State<FaxinaPage> {
  TaskBloc _taskBloc;
  AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    _taskBloc ??= Provider.of(context).taskBloc..fetchTasks();
    _authBloc ??= Provider.of(context).authBloc..signIn();
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: StreamBuilder(
          stream: _authBloc.currentUser,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return StreamBuilder<List<Task>>(
                stream: _taskBloc.taskList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Task> taskList = snapshot.data;
                    if (taskList.length > 0) {
                      return ListView.builder(
                        itemCount: taskList.length,
                        itemBuilder: (_, int index) =>
                          _slidableCard(taskList[index], _taskBloc, context),
                      );
                    } else {
                      return Center(
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Não há dados'),
                          ],
                        ),
                      );
                    }
                  } else {
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
              );
            }
            else {
              return Container();
            } 
          }
        ),
      ),      
      floatingActionButton: new FloatingActionButton(
        onPressed: () {
          _taskBloc.clearSelectedTask();
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => TaskFormScreen(),
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
                      builder: (BuildContext context) => TaskFormScreen(),
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