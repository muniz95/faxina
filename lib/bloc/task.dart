import 'package:faxina/services/taskService.dart';
import "package:rxdart/rxdart.dart";
import 'package:faxina/models/task.dart';

class TaskBloc {
  final BehaviorSubject<List<Task>> _taskList = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get taskList => _taskList.stream;
  
  final BehaviorSubject<Task> _selectedTask = BehaviorSubject<Task>();
  Stream<Task> get selectedTask => _selectedTask.stream;

  Function(Task) get selectTask => _selectedTask.add;

  final TaskService _service = new TaskService();

  fetchTasks() {
    new TaskService().getAllTasks().then((tasks) {
      _taskList.add(tasks);
      return tasks;
    });

  }

  clearSelectedTask() {
    _selectedTask.add(new Task());
  }

  addTask(Task task) async {
    List<Task> tasks = _taskList.value ?? new List<Task>();
    if (await _service.saveTask(task) != null) {
      tasks.add(task);
      _taskList.add(tasks);
    }
  }
  
  updateTask(Task task) async {
    if (await _service.updateTask(task) != null) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      tasks.removeWhere((Task t) => t.id == task.id);
      tasks.add(task);
      _taskList.add(tasks);
    }
  }
  
  checkTask(Task task) async {
    task.lastDone = DateTime.now();
    if (await _service.updateTask(task) != null) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      tasks.removeWhere((Task t) => t.id == task.id);
      tasks.add(task);
      _taskList.add(tasks);
    }
  }

  void dispose() {
    _taskList.close();
    _selectedTask.close();
  }
}