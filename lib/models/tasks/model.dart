class TaskModel {
  final int? id;
  final String? name;

  static const String table = 'tasks';

  TaskModel({this.id, this.name});

  TaskModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name};
  }
}
