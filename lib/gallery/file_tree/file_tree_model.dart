import 'dart:collection';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:laborales/gallery/file_tree/file_tree_view_models.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

const imageExtension = [".png", ".jpg", ".jpeg"];

bool isImagePath(String path) {
  var lower = path.toLowerCase();
  return imageExtension.any((ext) => lower.endsWith(ext));
}

Stream<FSE> bfsOnFileSystem(Directory dir) async* {
  final Q = Queue<FSE>();
  Q.addLast(dir);
  while (Q.isNotEmpty) {
    final fse = Q.removeFirst();
    if (FSE.isLinkSync(fse.path)) {
      debugPrint("symlink: ${fse} is skipped");
      continue;
    }

    if (fse is File && isImagePath(fse.path)) {
      yield fse;
    }

    if (fse is Directory) {
      for (final child in fse.listSync()
        ..sort((a, b) => a.path.compareTo(b.path))) {
        Q.addLast(child);
      }
    }
  }
}

Future<List<FSE>> dfsOnFileSystem(FSE fse) async {
  throw UnimplementedError();
  if (fse is File && isImagePath(fse.path)) {
    return [fse];
  }
  if (fse is Directory) {
    var list = <FSE>[];
    for (var child in fse.listSync()
      ..sort((a, b) => a.path.compareTo(b.path))) {
      list.addAll(await dfsOnFileSystem(child));
    }
  }
  return [];
}

Future<Directory?> pickDirectory() async {
  var path = await FilePicker.platform
      .getDirectoryPath(dialogTitle: "Pick the Directory");
  if (path != null) {
    var dir = Directory(path);
    dir = await ensureToOpen(dir);
    return dir;
  }
  return null;
}
