import 'package:faxina/services/task.service.dart';
import "package:rxdart/rxdart.dart";
import 'package:faxina/models/task.model.dart';

class TaskBloc {
  final BehaviorSubject<List<Task>> _taskList = BehaviorSubject<List<Task>>();
  Stream<List<Task>> get taskList => _taskList.stream;
  
  final BehaviorSubject<Task> _selectedTask = BehaviorSubject<Task>();
  Stream<Task> get selectedTask => _selectedTask.stream;
  
  final BehaviorSubject<bool> _isLoading = BehaviorSubject<bool>();
  Stream<bool> get isLoading => _isLoading.stream;

  Function(Task) get selectTask => _selectedTask.add;

  final TaskService _service = new TaskService();

  void fetchTasks() async {
    _taskList.add(await TaskService().getAllTasks()..sort(_byNearest));
  }

  void clearSelectedTask() {
    _selectedTask.add(Task());
  }

  Future addTask(Task task) async {
    List<Task> tasks = _taskList.value ?? new List<Task>();
    Task createdTask = await _service.saveTask(task);
    if (createdTask != null) {
      _taskList.add(
        tasks
          ..add(createdTask)
          ..sort(_byNearest)
      );
    }
  }
  
  Future updateTask(Task task) async {
    if (await _service.updateTask(task) != null) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      _taskList.add(
        tasks
          ..removeWhere((Task t) => t.id == task.id)
          ..add(task)
          ..sort(_byNearest)
      );
    }
  }
  
  Future checkTask(Task task) async {
    _isLoading.add(true);
    task.lastDone = DateTime.now();
    if (await _service.updateTask(task)) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      _taskList.add(
        tasks
          ..removeWhere((Task t) => t.id == task.id)
          ..add(task.clone())
          ..sort(_byNearest)
      );
    }
    _isLoading.add(false);
  }
  
  Future deleteTask(Task task) async {
    _isLoading.add(true);
    if (await _service.deleteTask(task)) {
      List<Task> tasks = _taskList.value ?? new List<Task>();
      _taskList.add(
        tasks
          ..removeWhere((Task t) => t.id == task.id)
          ..sort(_byNearest)
      );
    }
    _isLoading.add(false);
  }

  String leftDays(Task task) {
    int leftDays = _daysRemaining(task);

    if (leftDays == 1) {
      return "Falta 1 dia";
    } else if (leftDays == 0) {
      return "Dia da tarefa ser feita";
    } else if (leftDays > 1) {
      return 'Faltam $leftDays dias';
    }
    return "Tarefa atrasada em ${-leftDays} dias";
  }

  int _daysRemaining(Task task) => 
    (task.lastDone ?? DateTime.now())
      .add(Duration(days: task.interval + 1))
      .difference(DateTime.now())
      .inDays;

  int _byNearest(Task a, Task b) =>
    _daysRemaining(a).compareTo(_daysRemaining(b));

  void dispose() {
    _taskList.close();
    _selectedTask.close();
    _isLoading.close();
  }
}