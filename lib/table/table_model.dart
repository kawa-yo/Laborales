import 'dart:io';
import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';

void dumpToJson(
  File jsonFile,
  List<String> paths,
  List<String> photoLabels,
  List<String> allLabels,
) {}

Future<bool> saveAsCSV(
  File csvFile,
  List<String> paths,
  List<String> labels, {
  bool includeIndex = true,
}) async {
  List<List<dynamic>> rows;
  if (includeIndex) {
    rows = [
      for (int i = 0; i < paths.length; i++) [i, paths[i], labels[i]]
    ];
  } else {
    rows = [
      for (int i = 0; i < paths.length; i++) [paths[i], labels[i]]
    ];
  }
  var p = ReceivePort();
  await Isolate.spawn(_saveAsCSV, [rows, csvFile, p.sendPort]);
  return true;
}

void _saveAsCSV(List<dynamic> arguments) {
  List<List<dynamic>> rows = arguments[0];
  File csvFile = arguments[1];
  SendPort p = arguments[2];

  String csv = const ListToCsvConverter().convert(rows);
  csvFile.writeAsStringSync(csv);
  debugPrint("save to $csvFile... done!");
  Isolate.exit(p);
}
