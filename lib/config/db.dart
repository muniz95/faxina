import 'package:faxina/models/task.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io' as io;

class DB {
  static final DB _instance = new DB.internal();
  factory DB() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DB.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }
  
  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute("""
      CREATE TABLE Task(
        id INTEGER PRIMARY KEY,
        name TEXT,
        lastDone Date,
        interval int
      )
    """);
    print("Created tables");
  }

  Future<int> saveTask(Task task) async {
    var dbClient = await db;
    int res = await dbClient.insert("Task", task.toMap());
    return res;
  }

  Future<int> deleteTasks() async {
    var dbClient = await db;
    int res = await dbClient.delete("Task");
    return res;
  }

  Future<List<Task>> getTasks() async {
    var dbClient = await db;
    List<Task> tasks = new List<Task>();
    List<Map> taskRaw = await dbClient.query("Task");
    
    if (taskRaw.length > 0) {
      taskRaw.forEach((task) {
        tasks.add(new Task.map(task));
      });
    }

    return tasks;
  }

}