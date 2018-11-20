import 'package:faxina/config/db.dart';
import 'package:faxina/models/task.dart';

class TaskService {
  final DB db = new DB();

  TaskService() {
    this.db.initDb();
  }
  
  Future<List<Task>> getAllTasks() async {
    return await this.db.getTasks();
  }
  
  Future<int> saveTask(Task task) async {
    return await this.db.saveTask(task);
  }
  
  Future<int> updateTask(Task task) async {
    return await this.db.updateTask(task);
  }
}