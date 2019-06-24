// import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  int id;
  String name;
  DateTime lastDone;
  int interval;

  Task({this.id, this.name, this.lastDone, this.interval});

  factory Task.map(Map<String, dynamic> obj) {
    return Task(
      id: obj["id"],
      name: obj["name"],
      lastDone: obj["lastDone"],
      interval: obj["interval"],
    );
  }

  // factory Task.mapSnapshot(DocumentSnapshot obj) {
  //   return Task(
  //     id: obj.documentID,
  //     name: obj["name"],
  //     lastDone: (obj["lastDone"] as Timestamp)?.toDate(),
  //     interval: obj["interval"],
  //   );
  // }

  static Task fromMap(Map<String, dynamic> obj) => Task.map(obj);
  // static Task fromDocumentSnapshot(DocumentSnapshot obj) => Task.mapSnapshot(obj);

  // static List<Task> fromSnapshot(QuerySnapshot snapshot) {
  //   if (snapshot == null) {
  //     return [];
  //   }
  //   return snapshot.documents
  //     .cast<DocumentSnapshot>()
  //     .map(Task.fromDocumentSnapshot)
  //     .toList();
  // }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["lastDone"] = lastDone;
    map["interval"] = interval;

    return map;
  }

  Task clone() {
    return Task(
      id: this.id,
      name: this.name,
      lastDone: this.lastDone,
      interval: this.interval,
    );
  }
}
