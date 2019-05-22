import 'package:faxina/config/db.dart';
import 'package:faxina/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final DB db = new DB();

  TaskService() {
    this.db.initDb();
  }
  
  Future<List<Task>> getAllTasks() async {
    var docs = await Firestore.instance.collection('task').getDocuments();
    return Task.fromSnapshot(docs);
  }
  
  saveTask(Task task) async {
    DocumentReference ref = await Firestore.instance.collection('task').add(task.toMap());
    // return await this.db.saveTask(task);
  }
  
  Future<int> updateTask(Task task) async {
    await Firestore.instance.collection('task').document(task.id).updateData(task.toMap());
    // return await this.db.updateTask(task);
  }
  
  Future<List<Task>> getAllLocalTasks() async {
    return await this.db.getTasks();
  }
  
  Future<int> saveLocalTask(Task task) async {
    return await this.db.saveTask(task);
  }
  
  Future<int> updateLocalTask(Task task) async {
    return await this.db.updateTask(task);
  }
}