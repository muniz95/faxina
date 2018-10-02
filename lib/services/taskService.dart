import 'package:faxina/config/db.dart';
import 'package:faxina/models/task.dart';

class TaskService {
  final DB db = new DB();
  
  static List<Task> getAllTasks() {
    return new List<Task>();
  }
}