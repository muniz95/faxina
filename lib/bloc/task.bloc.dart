import 'package:faxina/services/task.service.dart';
import "package:rxdart/rxdart.dart";
import 'package:faxina/models/task.model.dart';

class TaskBloc {
  final BehaviorSubject<List<Task>> _taskList = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get taskList => _taskList.stream;
  
  final BehaviorSubject<Task> _selectedTask = BehaviorSubject<Task>();
  Stream<Task> get selectedTask => _selectedTask.stream;

  Function(Task) get selectTask => _selectedTask.add;

  final TaskService _service = new TaskService();

  void fetchTasks() async {
    _taskList.add(await TaskService().getAllTasks());
  }

  void clearSelectedTask() {
    _selectedTask.add(new Task());
  }

  Future addTask(Task task) async {
    List<Task> tasks = _taskList.value ?? new List<Task>();
    String taskId = await _service.saveTask(task);
    if (taskId != null) {
      task.id = taskId;
      tasks.add(task);
      _taskList.add(tasks);
    }
  }
  
  Future updateTask(Task task) async {
    if (await _service.updateTask(task) != null) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      tasks.removeWhere((Task t) => t.id == task.id);
      tasks.add(task);
      _taskList.add(tasks);
    }
  }
  
  Future checkTask(Task task) async {
    task.lastDone = DateTime.now();
    if (await _service.updateTask(task)) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      tasks.removeWhere((Task t) => t.id == task.id);
      tasks.add(task);
      _taskList.add(tasks);
    }
  }

  String leftDays(Task task) {
    int leftDays = task.lastDone
      .add(Duration(days: task.interval))
      .difference(DateTime.now())
      .inDays;
    return leftDays == 1 ? 'Falta 1 dia' : 'Faltam $leftDays dias';
  }

  void dispose() {
    _taskList.close();
    _selectedTask.close();
  }
}