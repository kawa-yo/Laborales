import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/data/table/table_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';

final tableProvider = ChangeNotifierProvider((ref) => TableViewModel(ref));

class TableViewModel extends ChangeNotifier {
  final Ref ref;
  TableViewModel(this.ref);

  Future<File?> saveToFile() async {
    var savePath = await FilePicker.platform.saveFile(
      fileName: "output.csv",
      allowedExtensions: ["csv"],
    );
    if (savePath == null) {
      return null;
    }
    var galleryViewModel = ref.read(galleryProvider);
    var photos = galleryViewModel.list;
    var labelOf_ = galleryViewModel.labelOf;
    var paths = photos.map((e) => e.src.path).toList();
    var labels = photos.map((e) => labelOf_(e)).toList();
    var file = File(savePath);

    var success = await saveAsCSV(file, paths, labels);
    return success ? file : null;
  }
}
