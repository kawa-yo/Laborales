import 'dart:io';

import 'package:laborales/repository/dto/label_dto.dart';
import 'package:laborales/repository/dto/photo_dto.dart';
import 'package:sqflite/sqflite.dart';

Database? _database;
Database? get database => _database;

enum DBTable {
  label("Label"),
  photo("Photo");

  const DBTable(this.name);
  final String name;
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
      ${PhotoDTO.columnPath} TEXT PRIMARY KEY,
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
}
