import 'dart:async';
import 'package:path/path.dart';
import 'package:pedometerproject/models/datetimeclass.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static const _databaseName = "step.db";
  static const _databaseVersion = 1;
  static const table = "step_table";
  static const columnid = "id";
  static const columndate = "date";
  static const columnstep = "step";


  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;


  Future<Database> get database async{
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async  {
    String path = join(await getDatabasesPath(),_databaseName);
    return await openDatabase(path,version: _databaseVersion,onCreate: _onCreate);
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    create table $table (
    $columnid integer primary key autoincrement,
    $columndate double not null,
    $columnstep double not null)
    ''');
  }
  Future<int> insert(StepDateTime stepclass) async{
    Database db = await instance.database;
    return await db.insert(table,{"date":stepclass.date,"step":stepclass.step});
  }


  // Future<int> update  (StepDateTime stepclass) async{
  //   Database db = await instance.database;
  //   int id = stepclass.toMap()["id"];
  //   return await db.update(table,stepclass.toMap(),where: '$columnid = ?', whereArgs: [id]);
  // }
  // Future<int> delete(int id) async{
  //   Database db = await instance.database;
  //   return await db.delete(table,where: '$columnid = ?', whereArgs: [id]);
  // }
  Future<List<Map<String,dynamic>>> queryRows(date) async{
    Database db = await instance.database;
    return await db.query(table,where:"$columndate LIKE '%$date%'");
  }
  Future<List<Map<String,dynamic>>> queryAllRows() async{
    Database db = await instance.database;
    return await db.query(table);
  }
  // Future<int?> queryRowCount() async{
  //   Database db = await instance.database;
  //   return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  // }
  Future deleteDatabase() async{
    Database db = await instance.database;
    return await db.execute("DELETE FROM $table");
  }
}