import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';

Future<bool> dumpToJson(
  File jsonFile,
  Map<String, String> path2label,
  List<String> labels,
) async {
  var receivePort = ReceivePort();
  await Isolate.spawn(
    _dumpToJson,
    [receivePort.sendPort, jsonFile, path2label, labels],
  );
  return await receivePort.first as bool;
}

bool _dumpToJson(List<dynamic> args) {
  debugPrint("dumpToJson: start");
  SendPort p = args[0];
  File jsonFile = args[1];
  Map<String, String> path2label = args[2];
  List<String> labels = args[3];

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
