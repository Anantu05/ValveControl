import 'dart:async';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:valve_control/models/tasks/model.dart';

class TasksDBHelper {
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
    String path = join(documentDirectory.path, "tasks");
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    // if using any more models, just create more tables here
    await db.execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, ip TEXT NOT NULL)");
  }

  Future<TaskModel> insert(TaskModel model) async {
    var dbClient = await db;
    await dbClient?.insert(TaskModel.table, model.toMap());
    return model;
  }

  Future<List<TaskModel>> getDataList() async {
    await db;
    final List<Map<String, Object?>> queryResult =
        await _db!.query(TaskModel.table);
    return queryResult.map((e) => TaskModel.fromMap(e)).toList();
  }

  Future<int> update(TaskModel model) async {
    var dbClient = await db;
    return await dbClient!.update(TaskModel.table, model.toMap(),
        where: 'id = ?', whereArgs: [model.id]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!
        .delete(TaskModel.table, where: 'id = ?', whereArgs: [id]);
  }
}
