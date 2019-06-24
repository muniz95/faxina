import 'package:dio/dio.dart';
import 'package:faxina/config/db.dart';
import 'package:faxina/constants.dart';
import 'package:faxina/models/task.model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

class TaskService {
  final DB db = new DB();
  final dio = Dio();

  TaskService() {
    this.db.initDb();
  }
  
  Future<List<Task>> getAllTasks() async {
    var response = await dio.get("$baseURL/tasks");
    if (response.statusCode == 200) {
      var data = response.data as List;
      return data
        .cast<Map<String, dynamic>>()
        .map(Task.fromMap)
        .toList();
    }

    return <Task>[];
  }
  
  Future<Task> saveTask(Task task) async {
    var response = await dio.post("$baseURL/tasks", data: task.toMap());
    return Task.map(response.data);
}
  
  Future<bool> updateTask(Task task) async {
    var response = await dio.put("$baseURL/tasks/${task.id}", data: task.toMap());
    return response.data;
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