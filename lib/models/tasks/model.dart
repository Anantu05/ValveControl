class TaskModel {
  final int? id;
  final String? name;
  final String? time;

  static const String table = 'tasks';

  TaskModel({this.id, this.name, this.time});

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        time = res['time'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'time': time};
  }
}
