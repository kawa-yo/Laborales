import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

Future<bool> dumpToJson(
  File jsonFile,
  Map<String, String> path2label,
  List<String> labels,
  Map<String, Color> label2color,
) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
    _dumpToJson,
    [receivePort.sendPort, jsonFile, path2label, labels, label2color],
  );
  return await receivePort.first as bool;
}

bool _dumpToJson(List<dynamic> args) {
  debugPrint("dumpToJson: start");
  SendPort p = args[0];
  File jsonFile = args[1];
  Map<String, String> path2label = args[2];
  List<String> labels = args[3];
  Map<String, Color> label2color = args[4];

  var label2rgba = label2color.map((key, value) => MapEntry(
        key,
        [value.red, value.green, value.blue, value.alpha],
      ));

  var jsonObject = {
    "labels": labels,
    "photos": path2label,
  };
  var jsonText = jsonEncode(jsonObject);
  jsonFile.writeAsStringSync(jsonText);
  debugPrint("jsonObject: $jsonObject");

  debugPrint("dumpToJson: end");
  Isolate.exit(p, true);
}

Future<Map<String, Color>?> loadLabelsFromJson(File jsonFile) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
    _loadLabelsFromJson,
    [receivePort.sendPort, jsonFile],
  );
  return await receivePort.first as Map<String, Color>?;
}

void _loadLabelsFromJson(List<dynamic> args) {
  SendPort p = args[0];
  File jsonFile = args[1];

  var jsonText = jsonFile.readAsStringSync();
  if (jsonText.isEmpty) {
    Isolate.exit(p, null);
  }
  debugPrint("$jsonFile: `$jsonText`");
  var jsonObject = jsonDecode(jsonText);
  var label2rgba = jsonObject["colors"] as Map?;
  if (label2rgba == null) {
    Isolate.exit(p, null);
  }
  var label2color = <String, Color>{};
  for (var entry in label2rgba.entries) {
    String label = entry.key;
    List rgba = entry.value;
    label2color[label] = Color.fromARGB(
      rgba[3],
      rgba[0],
      rgba[1],
      rgba[2],
    );
  }
  Isolate.exit(p, label2color);
}
