import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filesProvider =
    ChangeNotifierProvider<FilesViewModel>(((ref) => FilesViewModel()));

class FilesViewModel extends ChangeNotifier {
  /// finalにすると，要素を出し入れしてもhashCodeが変わらないから，変更が監視されない
  List<File> _list;
  int? _selectedIdx;

  List<File> get list => _list;
  File? get selectedFile {
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

  FilesViewModel()
      : _list = [],
        _selectedIdx = null;

  void select(int idx) {
    _selectedIdx = idx;
    notifyListeners();
  }

  void selectByPath(String path) {
    int idx = _list.indexWhere((e) => e.path == path);
    if (idx != -1) {
      _selectedIdx = idx;
      notifyListeners();
    }
  }

  void update(Iterable<File> files) {
    _list = files.toList();
    notifyListeners();
  }
}
