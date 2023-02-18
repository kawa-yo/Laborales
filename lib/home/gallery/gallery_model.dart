import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/dto/photo_dto.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/repository/secure_bookmarks.dart';
import 'package:laborales/repository/sqlite.dart';
import 'package:sqflite/sqlite_api.dart';

const imageExtension = [".png", ".jpg", ".jpeg"];

const key = "laborales/general/gallery_idx";

bool isImagePath(String path) {
  var lower = path.toLowerCase();
  return imageExtension.any((ext) => lower.endsWith(ext));
}

Stream<List<File>> bfsOnFileSystem(Directory dir, {int unit = 1000}) async* {
  var receivePort = ReceivePort();
  var isolate =
      await Isolate.spawn(_bfsOnFileSystem, [receivePort.sendPort, dir, unit]);
  await for (var message in receivePort) {
    if (message == null) {
      isolate.kill();
      break;
    }
    List<File> files = message;
    yield files;
  }
  debugPrint("bfs done.");
}

Future<void> _bfsOnFileSystem(List<dynamic> args) async {
  SendPort p = args[0];
  Directory dir = args[1];
  int sendUnit = args[2];

  final Q = Queue<FSE>();
  Q.addLast(dir);
  var list = <File>[];
  while (Q.isNotEmpty) {
    final fse = Q.removeFirst();
    if (FSE.isLinkSync(fse.path)) {
      debugPrint("symlink: $fse is skipped");
      continue;
    }

    if (fse is File && isImagePath(fse.path)) {
      list.add(fse);
      if (list.length == sendUnit) {
        p.send([...list]);
        list.clear();
      }
    }

    if (fse is Directory) {
      for (final child in fse.listSync()
        ..sort((a, b) => a.path.compareTo(b.path))) {
        Q.addLast(child);
      }
    }
  }
  p.send([...list]);
  Isolate.exit(p);
}

int? loadTabIndexFromPrefs(Project project) {
  return prefs.getInt(key);
}

Future<void> saveTabIndexToPrefs(int idx, Project project) async {
  await prefs.setInt(key, idx);
}

Future<bool> upsertPhotoIntoDB(File dbFile, PhotoDTO photoDTO) async {
  if (database?.path != dbFile.path) {
    await openMyDatabase(dbFile);
  }
  int id = await database!.insert(
    DBTable.photo.name,
    photoDTO.toMap(),
    conflictAlgorithm: ConflictAlgorithm.replace,
  );
  return id != 0;
}

Future<List<PhotoDTO>> selectPhotosFromDB(File dbFile) async {
  if (database?.path != dbFile.path) {
    await openMyDatabase(dbFile);
  }
  List<Map<String, dynamic>> selected = await database!.query(
    DBTable.photo.name,
  );
  var dtos = selected.map((e) => PhotoDTO.fromMap(e)).toList();
  return dtos;
}
