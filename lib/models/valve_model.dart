import 'package:valve_control/models/model.dart';

class ValveModel extends Model {
  @override
  // ignore: overridden_fields
  final int? id;
  final String? name;
  final String? ip;

  ValveModel({this.id, this.name, this.ip});

  ValveModel.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        name = res['name'],
        ip = res['ip'];

  @override
  Map<String, Object?> toMap() {
    return {'id': id, 'name': name, 'ip': ip};
  }

  @override
  String get table => 'valves';
}
