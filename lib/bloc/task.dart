import 'package:faxina/services/taskService.dart';
import "package:rxdart/rxdart.dart";
import 'package:faxina/models/task.dart';

class TaskBloc {
  final BehaviorSubject<List<Task>> _taskList = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get taskList => _taskList.stream;
  
  final BehaviorSubject<Task> _selectedTask = BehaviorSubject<Task>();
  Stream<Task> get selectedTask => _selectedTask.stream;

  final TaskService _service = new TaskService();

  Future<Null> fetchTasks() async {
    List<Task> tasks = _taskList.value ?? await new TaskService().getAllTasks();
    _taskList.add(tasks);
  }

  addTask(Task task) async {
    List<Task> tasks = _taskList.value ?? new List<Task>();
    if (await _service.saveTask(task) != null) {
      tasks.add(task);
      _taskList.add(tasks);
    }
  }

  void dispose() {
    _taskList.close();
    _selectedTask.close();
  }
}