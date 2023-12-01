class TaskModel {
  final int? id;
  final String? name;
  final String? time;
  final String? state;

  static const String table = 'tasks';

  TaskModel({this.id, this.name, this.time, this.state});

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        time = res['time'],
        state = res['state'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'time': time, 'state': state};
  }
}
