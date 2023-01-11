import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';

// final fileSemiGridProvider =
//     ChangeNotifierProvider((ref) => FileSemiGridViewModel(ref));
//
// class FileSemiGridViewModel extends ChangeNotifier {
//   int _numColumn = 5;
//   final Ref ref;
//
//   FileSemiGridViewModel(this.ref);
//
//   int get numColumn => _numColumn;
// }

Map<String, List<Photo>> photoList(List<Photo> photos) {
  var listed = <String, List<Photo>>{};

  for (var photo in photos) {
    String key = photo.src.parent.path;
    listed[key] = (listed[key] ?? [])..add(photo);
  }
  return listed;
}
