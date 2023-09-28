import 'dart:io';

import 'package:file_picker/file_picker.dart';

Future<Directory?> pickDirectory() async {
  var path = await FilePicker.platform
      .getDirectoryPath(dialogTitle: "Pick the Directory");
  if (path != null) {
    var dir = Directory(path);
    // dir = await ensureToOpen(dir);
    return dir;
  }
  return null;
}
