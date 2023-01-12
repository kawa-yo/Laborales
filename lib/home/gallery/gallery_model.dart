import 'dart:collection';
import 'dart:io';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

const imageExtension = [".png", ".jpg", ".jpeg"];

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
      debugPrint("symlink: ${fse} is skipped");
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
