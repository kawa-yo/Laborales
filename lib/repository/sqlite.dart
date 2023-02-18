import 'dart:io';

import 'package:collection/collection.dart';
import 'package:laborales/repository/dto/label_dto.dart';
import 'package:laborales/repository/dto/photo_dto.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;
Database? get database => _database;

enum DBTable {
  label("Label", LabelDTO.columns),
  photo("Photo", PhotoDTO.columns);

  const DBTable(this.name, this.columns);
  final String name;
  final List<String> columns;
}

Future<void> openMyDatabase(File file) async {
  _database?.close();
  _database = await openDatabase(file.path);
  await _initializeDB(_database!);
}

Future<bool> _doesTableExists(Database db, DBTable table) async {
  var tables = await db.rawQuery("""
    SELECT 
        name
    FROM 
        sqlite_schema
    WHERE 
        type ='table' AND 
        name NOT LIKE 'sqlite_%';
  """);
  List<String> tableNames = tables.map((e) => e["name"] as String).toList();
  return tableNames.contains(table.name);
}

Future<bool> _isTableLatest(Database db, DBTable table) async {
  var columns = await db.rawQuery("""
    SELECT 
        name
    FROM 
        PRAGMA_TABLE_INFO('${table.name}')
  """);
  Set<String> columnNames = columns.map((e) => e["name"] as String).toSet();
  bool isLatest =
      const SetEquality().equals(columnNames, table.columns.toSet());
  print("existing: $columnNames");
  print("latest  : ${table.columns.toSet()}");
  print("is latest: $isLatest");
  return isLatest;
}

Future<void> _dropTable(Database db, DBTable table) async {
  await db.rawQuery("DROP TABLE ${table.name}");
}

Future<void> _createLabelTable(Database db) async {
  await db.execute("""
    CREATE TABLE ${DBTable.label.name} (
      ${LabelDTO.columnName} TEXT PRIMARY KEY,
      ${LabelDTO.columnColorR} INTEGER NOT NULL, 
      ${LabelDTO.columnColorG} INTEGER NOT NULL, 
      ${LabelDTO.columnColorB} INTEGER NOT NULL, 
      ${LabelDTO.columnColorA} INTEGER NOT NULL
    )
  """);
}

Future<void> _createPhotoTable(Database db) async {
  await db.execute("""
    CREATE TABLE ${DBTable.photo.name} (
      ${PhotoDTO.columnRelativePath} TEXT PRIMARY KEY,
      ${PhotoDTO.columnLabel} TEXT NOT NULL, 
      FOREIGN KEY (${PhotoDTO.columnLabel})
        REFERENCES ${DBTable.label.name}(${LabelDTO.columnName})
    )
  """);
}

Future<void> _initializeDB(Database db) async {
  if (!await _doesTableExists(db, DBTable.label)) {
    await _createLabelTable(db);
  }
  if (!await _doesTableExists(db, DBTable.photo)) {
    await _createPhotoTable(db);
  }

  // if (!await _isTableLatest(db, DBTable.photo)) {
  //   await _dropTable(db, DBTable.photo);
  //   await _createPhotoTable(db);
  // }
}
