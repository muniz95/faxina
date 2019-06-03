import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/models/task.model.dart';
import 'package:faxina/screens/task_form.screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskCardComponent extends StatelessWidget {
  final Task task;
  final TaskBloc bloc;

  const TaskCardComponent({Key key, this.task, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                trailing: new Text(task.lastDone != null ? bloc.leftDays(task) : 'Pendente'),
                onTap: () {
                  bloc.selectTask(task);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => TaskFormScreen(),
                    ),
                  );
                }
              )
            ),
            actions: <Widget>[
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
}