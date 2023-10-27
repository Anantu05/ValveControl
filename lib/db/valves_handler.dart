import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:valve_control/models/model.dart';

class ValvesDBHandler {
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
    String path = join(documentDirectory.path, 'valves.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    // if using any more models, just create more tables here
    await db.execute(
        "CREATE TABLE valves(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, ip TEXT NOT NULL)");
  }

  Future<Model> insert(Model model) async {
    var dbClient = await db;
    await dbClient?.insert(model.table, model.toMap());
    return model;
  }

  Future<List<Model>> getDataList(String table) async {
    await db;
    final List<Map<String, Object?>> queryResult =
        await _db!.rawQuery("SELECT * FROM ?", [table]);
    return queryResult.map((e) => Model.fromMap(e)).toList();
  }

  Future<int> update(Model model) async {
    var dbClient = await db;
    return await dbClient!.update(model.table, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
  }
}
