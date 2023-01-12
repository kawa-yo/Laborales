import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/table/table_model.dart';

final tableProvider = Provider((ref) => TableViewModel(ref));

class TableViewModel {
  final Ref ref;
  const TableViewModel(this.ref);

  Future<File?> saveToFile() async {
    var savePath = await FilePicker.platform.saveFile(
      fileName: "output.csv",
      allowedExtensions: ["csv"],
    );
    if (savePath == null) {
      return null;
    }
    var photosViewModel = ref.read(photosProvider);
    var photos = photosViewModel.list;
    var labelOf_ = photosViewModel.labelOf;
    var paths = photos.map((e) => e.src.path).toList();
    var labels = photos.map((e) => labelOf_(e)).toList();
    var file = File(savePath);

    var success = await saveAsCSV(file, paths, labels);
    return success ? file : null;
  }
}
