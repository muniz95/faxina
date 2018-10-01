import "package:rxdart/rxdart.dart";
import 'package:faxina/models/task.dart';

class TaskBloc {
  final BehaviorSubject<List<Task>> _taskList = BehaviorSubject<List<Task>>();
  BehaviorSubject<List<Task>> get taskList => _taskList;
  
  final BehaviorSubject<Task> _selectedTask = BehaviorSubject<Task>();
  BehaviorSubject<Task> get selectedTask => _selectedTask;

  Future<Null> fetchTasks() async {
    
  }

  void dispose() {
    _taskList.close();
    _selectedTask.close();
  }
}