class Task {
  int id;
  String name;
  DateTime lastDone;
  int interval;

  Task({this.id, this.name, this.lastDone, this.interval});

  factory Task.map(dynamic obj) {
    return new Task(
      id: obj["id"],
      name: obj["name"],
      // lastDone: DateTime.parse(obj["lastDone"]),
      lastDone: (obj["lastDone"] == null) ? null : DateTime.parse(obj["lastDone"]),
      interval: obj["interval"],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map["id"] = id;
    map["name"] = name;
    map["lastDone"] = (lastDone != null) ? lastDone.toIso8601String() : null;
    map["interval"] = interval;

    return map;
  }
}
