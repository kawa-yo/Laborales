import 'dart:async';
import 'dart:io';

import 'package:laborales/repository/dto/label_dto.dart';
import 'package:laborales/repository/sqlite.dart';

Future<bool> insertLabelIntoDB(File dbFile, LabelDTO labelDTO) async {
  if (database?.path != dbFile.path) {
    await openMyDatabase(dbFile);
  }
  int id = await database!.insert(MyTable.label.name, labelDTO.toMap());
  return id != 0;
}

Future<bool> deleteLabelFromDB(File dbFile, LabelDTO labelDTO) async {
  if (database?.path != dbFile.path) {
    await openMyDatabase(dbFile);
  }
  int deleteCount = await database!.delete(
    MyTable.label.name,
    where: "${LabelDTO.columnName} = ?",
    whereArgs: [labelDTO.name],
  );
  return deleteCount != 0;
}

Future<List<LabelDTO>> selectLabelsFromDB(File dbFile) async {
  if (database?.path != dbFile.path) {
    await openMyDatabase(dbFile);
  }
  List<Map<String, dynamic>> selected = await database!.query(
    MyTable.label.name,
    columns: LabelDTO.columns,
  );
  var labels = selected.map((e) => LabelDTO.fromMap(e)).toList();
  return labels;
}
