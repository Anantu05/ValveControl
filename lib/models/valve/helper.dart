import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:valve_control/models/constants.dart';
import 'package:valve_control/models/valve/model.dart';

class ValveDBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, Constants.db);
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    // if using any more models, just create more tables here
    await db.execute(
        "CREATE TABLE valves(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, ip TEXT NOT NULL)");
  }

  Future<ValveModel> insert(ValveModel model) async {
    var dbClient = await db;
    await dbClient?.insert(ValveModel.table, model.toMap());
    return model;
  }

  Future<List<ValveModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> queryResult =
        await _db!.query(ValveModel.table);
    return queryResult.map((e) => ValveModel.fromMap(e)).toList();
  }

  Future<int> update(ValveModel model) async {
    var dbClient = await db;
    return await dbClient!.update(ValveModel.table, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
  }
}
