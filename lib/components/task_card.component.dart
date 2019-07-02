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
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: _sideBorderColor(task),
              width: 5,
            ),
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              child: ListTile(
                leading: (task.lastDone != null) ? Icon(Icons.check, color: (task.lastDone == null) ? Colors.grey : Colors.green,) : Icon(Icons.check_box_outline_blank, color: Colors.grey,),
                title: Text(task.name ?? '---'),
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
            Container(
              color: Colors.white,
              height: 50,
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      task.lastDone != null ? bloc.leftDays(task) : 'Pendente'
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.check_circle, color: Colors.green,),
                            Text(
                              "Concluir",
                              style: TextStyle(
                                color: Colors.green
                              ),
                            ),
                          ],
                        ),
                        onTap: () => bloc.checkTask(task),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }

  Color _sideBorderColor(Task task) {
    int daysRemaining = bloc.daysRemaining(task);
    if (task.lastDone != null) {
      return daysRemaining < 0 ? Colors.red : daysRemaining > 0 ? Colors.green : Colors.amber;
    }

    return Colors.blue;
  }
}