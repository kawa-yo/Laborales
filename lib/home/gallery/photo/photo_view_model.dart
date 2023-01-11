import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Photo {
  final File src;
  final int idx;

  Photo(this.src, {required this.idx});

  @override
  bool operator ==(Object other) =>
      other is Photo && src.path == other.src.path && idx == other.idx;
  @override
  int get hashCode => Object.hash(src.path, idx);
}

final photosProvider = ChangeNotifierProvider(((ref) => PhotoViewModel()));

class PhotoViewModel extends ChangeNotifier {
  Map<Photo, String> _photo2label;
  List<Photo> _list;
  int? _selectedIdx;

  PhotoViewModel()
      : _list = [],
        _photo2label = {};

  List<Photo> get list => _list;
  // Map<Photo, String> get photo2label => _photo2label;

  Photo? get selectedPhoto {
    int? idx = _selectedIdx;
    if (idx != null && idx < _list.length) {
      return _list[idx];
    }
    if (_list.isNotEmpty) {
      _selectedIdx = 0;
      return _list.first;
    }
    return null;
  }

  String labelOf(Photo? photo) {
    var label = _photo2label[photo];
    return label ?? "";
  }

  void incrementSelection(int increment) {
    if (_selectedIdx == null) {
      return;
    }
    int idx = _selectedIdx! + increment;
    if (idx < 0 || idx >= _list.length) {
      return;
    }
    select(idx);
  }

  void select(int idx) {
    _selectedIdx = idx;
    notifyListeners();
  }

  void selectByPath(String path) {
    int idx = _list.indexWhere((e) => e.src.path == path);
    if (idx != -1) {
      _selectedIdx = idx;
      notifyListeners();
    }
  }

  void update(Iterable<Photo> photos) {
    _list = photos.toList();
    notifyListeners();
  }

  void setLabel(Photo photo, String label) {
    _photo2label[photo] = label;
    notifyListeners();
  }
}
