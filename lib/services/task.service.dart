import 'package:faxina/config/db.dart';
import 'package:faxina/models/task.model.dart';
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
  
  Future<String> saveTask(Task task) async {
    try {
      DocumentReference ref = await Firestore.instance.collection('task').add(task.toMap());
      return ref.documentID;
    } catch (Exception) {
      return null;
    }
    // return await this.db.saveTask(task);
  }
  
  Future<bool> updateTask(Task task) async {
    try {
      await Firestore.instance.collection('task').document(task.id).updateData(task.toMap());
      return true;
    } catch (Exception) {
      return false;
    }
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

  // Future<List<Task>> getAllTasks() async {
  //   var docs = await Firestore.instance.collection('task').getDocuments();
  //   return Task.fromSnapshot(docs);
  // }
  
  // Future<String> saveTask(Task task) async {
  //   try {
  //     DocumentReference ref = await Firestore.instance.collection('task').add(task.toMap());
  //     return ref.documentID;
  //   } catch (Exception) {
  //     return null;
  //   }
  //   // return await this.db.saveTask(task);
  // }
  
  // Future<bool> updateTask(Task task) async {
  //   try {
  //     await Firestore.instance.collection('task').document(task.id).updateData(task.toMap());
  //     return true;
  //   } catch (Exception) {
  //     return false;
  //   }
  //   // return await this.db.updateTask(task);
  // }
}