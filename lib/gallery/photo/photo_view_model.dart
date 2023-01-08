import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/photo/photo_view.dart';

class Photo {
  final File src;
  final int idx;
  String label;

  Photo(this.src, {required this.idx}) : label = "";

  @override
  bool operator ==(Object other) =>
      other is Photo &&
      src.path == other.src.path &&
      label == other.label &&
      idx == other.idx;
  @override
  int get hashCode => Object.hash(src.path, idx, label);
}

final photosProvider = ChangeNotifierProvider(((ref) => PhotoViewModel()));

class PhotoViewModel extends ChangeNotifier {
  List<Photo> _list;
  int? _selectedIdx;

  PhotoViewModel() : _list = [];

  List<Photo> get list => _list;

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
}
