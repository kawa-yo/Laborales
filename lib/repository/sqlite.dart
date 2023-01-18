import 'dart:io';

import 'package:laborales/repository/dto/label_dto.dart';
import 'package:laborales/repository/dto/photo_dto.dart';
import 'package:sqflite/sqflite.dart';

enum MyTable {
  label("Label"),
  photo("Photo");

  const MyTable(this.name);
  final String name;
}

Future<bool> _isInitialized(Database db) async {
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
  return tableNames.contains(MyTable.label.name) &&
      tableNames.contains(MyTable.photo.name);
}

Future<void> _createLabelTable(Database db) async {
  await db.execute("""
    CREATE TABLE ${MyTable.label.name} (
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
    CREATE TABLE ${MyTable.photo.name} (
      ${PhotoDTO.columnPath} TEXT PRIMARY KEY,
      ${PhotoDTO.columnLabel} TEXT NOT NULL, 
      FOREIGN KEY (${PhotoDTO.columnLabel})
        REFERENCES ${MyTable.label.name}(${LabelDTO.columnName})
    )
  """);
}

Future<bool> _initializeDB(Database db) async {
  if (await _isInitialized(db)) {
    return false;
  }
  await _createLabelTable(db);
  await _createPhotoTable(db);
  return true;
}

Database? _database;
Database? get database => _database;

Future<void> openMyDatabase(File file) async {
  _database?.close();
  _database = await openDatabase(file.path);
  await _initializeDB(_database!);
}
