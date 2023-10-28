class ValveModel {
  final int? id;
  final String? name;
  final String? ip;

  static const String table = 'valves';

  ValveModel({this.id, this.name, this.ip});

  ValveModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        ip = res['ip'];

  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'ip': ip};
  }
}
