// import 'package:faxina/bloc/auth.bloc.dart';
import 'package:faxina/bloc/provider.dart';
import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/components/task_card.component.dart';
import 'package:faxina/models/task.model.dart';
import 'package:faxina/screens/task_form.screen.dart';
import 'package:flutter/material.dart';

class TasksScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskBloc _taskBloc;
  // AuthBloc _authBloc;

  @override
  void didChangeDependencies() {
    // _authBloc ??= Provider.of(context).authBloc;
    _taskBloc ??= Provider.of(context).taskBloc..fetchTasks();
    // _authBloc.signIn().then((_) {
    //   _taskBloc.fetchTasks();
    // });
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Container(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.red,
                    ),
                    child: StreamBuilder<List<Task>>(
                      stream: _taskBloc.taskList,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          int totalLate = snapshot.data
                            .where((Task t) => _taskBloc.daysRemaining(t) > t.interval)
                            .length;
                          return Text("Atraso: $totalLate", style: TextStyle(color: Colors.white),);
                        }

                        return CircularProgressIndicator();
                      },
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                  ),
                  Container(
                    width: 80,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("Atividades"),
                  InkWell(
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.add_circle, color: Colors.amber,),
                        Text(
                          "Adicionar tarefa",
                          style: TextStyle(
                            color: Colors.amber
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      _taskBloc.clearSelectedTask();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => TaskFormScreen(),
                        )
                      );
                    },
                  )
                ],
              ),
            ),
            StreamBuilder<List<Task>>(
              stream: _taskBloc.taskList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Task> taskList = snapshot.data;
                  if (taskList.length > 0) {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: taskList.length,
                        itemBuilder: (_, int index) =>
                          TaskCardComponent(task: taskList[index], bloc: _taskBloc, isLastElement: (index == taskList.length-1))
                      ),
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
                      backgroundColor: Colors.transparent,
                      elevation: 0,
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
            StreamBuilder<bool>(
              stream: _taskBloc.isLoading,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasData && snapshot.data) {
                  return Dialog(
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
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}