import 'package:faxina/bloc/task.bloc.dart';
import 'package:faxina/models/task.model.dart';
import 'package:faxina/screens/task_form.screen.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class TaskCardComponent extends StatelessWidget {
  final Task task;
  final TaskBloc bloc;
  final bool isLastElement;

  const TaskCardComponent({Key key, this.task, this.bloc, this.isLastElement}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    '50%',
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.3,
                    child: Text(
                      '30%',
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Text(
                      '20%',
                    ),
                  ),
                ),
              ],
            ),
          ],
        )
      ),
    );
  }
}