import 'package:flutter/material.dart';
import 'package:sqflite/sqlite_api.dart';

class Label {
  final String name;
  final Color color;
  const Label({required this.name, required this.color});
}

enum Table {
  labels("labels"),
  photos("photos");

  const Table(this.name);
  final String name;
}

class SqliteExecutor {
  late Database _database;
}
