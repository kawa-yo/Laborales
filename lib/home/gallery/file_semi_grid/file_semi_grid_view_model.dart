import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';

Map<String, List<Photo>> _listPhoto(List<Photo> photos) {
  var listed = <String, List<Photo>>{};

  for (var photo in photos) {
    String dir = photo.src.parent.path;
    listed[dir] = (listed[dir] ?? [])..add(photo);
  }
  return listed;
}

final fileSemiGridProvider =
    ChangeNotifierProvider((ref) => FileSemiGridViewModel(ref));

class FileSemiGridViewModel extends ChangeNotifier {
  final Ref ref;
  Map<String, List<Photo>> _dir2photos = {};
  Map<String, bool> _dir2expanded = {};
  Map<String, GlobalObjectKey<FileGridViewState>> _dir2key = {};

  Map<String, List<Photo>> get dir2photos => _dir2photos;
  Map<String, bool> get dir2expanded => _dir2expanded;
  List<String> get dirs => dir2photos.keys.toList();
  Map<String, GlobalObjectKey<FileGridViewState>> get dir2key => _dir2key;

  FileSemiGridViewModel(this.ref) {
    var photos = ref.watch(galleryProvider.select((value) => value.list));
    _dir2photos = _listPhoto(photos);
    _dir2expanded = {for (var dir in dirs) dir: false};
    _dir2key = {for (var dir in dirs) dir: GlobalObjectKey(dir)};
    notifyListeners();
  }

  void expandFor(Photo photo) {
    for (var dir in dirs) {
      _dir2expanded[dir] = false;
    }
    _dir2expanded[photo.src.parent.path] = true;
    notifyListeners();
  }

  void setExpanded(String dir, bool value) {
    if (_dir2expanded[dir] != value) {
      _dir2expanded[dir] = value;
      notifyListeners();
    }
  }
}
