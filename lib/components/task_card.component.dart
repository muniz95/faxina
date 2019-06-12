import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/models/task.model.dart';
import 'package:faxina/screens/task_form.screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class TaskCardComponent extends StatelessWidget {
  final Task task;
  final TaskBloc bloc;

  const TaskCardComponent({Key key, this.task, this.bloc}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      background: Container(
        alignment: Alignment.centerLeft,
        color: Colors.green,
        child: Icon(Icons.delete),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(Icons.check),
      ),
      key: Key(task.hashCode.toString()),
      child: Container(
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                leading: (task.lastDone != null) ? Icon(Icons.check, color: (task.lastDone == null) ? Colors.grey : Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.grey,),
                title: Text(task.name ?? '---'),
                trailing: Text(task.lastDone != null ? bloc.leftDays(task) : 'Pendente'),
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
            Divider(color: Colors.grey)
          ],
        )
      ),
      onDismissed: (DismissDirection direction) async {
        switch (direction) {
          case DismissDirection.startToEnd:
            await bloc.checkTask(task);
            break;
          default:
            break;
        }
      },
    );
  }
}