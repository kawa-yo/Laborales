import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedFileProvider = ChangeNotifierProvider<SelectedFileViewModel>(
    (ref) => SelectedFileViewModel());

final filesProvider =
    ChangeNotifierProvider<FilesViewModel>(((ref) => FilesViewModel()));

class SelectedFileViewModel extends ChangeNotifier {
  File? _file;
  int? _idx;

  File? get file => _file;
  int? get idx => _idx;

  SelectedFileViewModel();

  void update(File? file, int? idx) {
    _file = file;
    _idx = idx;
    notifyListeners();
  }
}

class FilesViewModel extends ChangeNotifier {
  final List<File> _list;

  FilesViewModel() : _list = [];

  List<File> get list => _list;
  // File? get selected {
  //   if (_list.length < _selectedIdx) {
  //     return _list[_selectedIdx];
  //   }
  //   if (_list.isNotEmpty) {
  //     _selectedIdx = 0;
  //     return _list.first;
  //   }
  //   return
  // }

  void add(File file) {
    _list.add(file);
    notifyListeners();
  }

  void addAll(Iterable<File> files) {
    _list.addAll(files);
    notifyListeners();
  }

  void clear() {
    _list.clear();
    notifyListeners();
  }
}
