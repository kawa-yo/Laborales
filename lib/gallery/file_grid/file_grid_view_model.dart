import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final fileGridProvider = ChangeNotifierProvider(((ref) => FileGridViewModel()));

class SingleIncrementSelectionIntent extends Intent {
  final int increment;
  const SingleIncrementSelectionIntent(this.increment);
}

class MultiIncrementSelectionIntent extends Intent {
  final int increment;
  const MultiIncrementSelectionIntent(this.increment);
}

class FileGridViewModel extends ChangeNotifier {
  /// finalにすると，要素を出し入れしてもhashCodeが変わらないから，変更が監視されない
  List<File> _list;
  int? _selectedIdx;
  int _numColumn = 5;

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

  int get numColumn => _numColumn;

  final shortcuts = {
    const SingleActivator(LogicalKeyboardKey.arrowLeft):
        const SingleIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowRight):
        const SingleIncrementSelectionIntent(1),
    const SingleActivator(LogicalKeyboardKey.arrowUp):
        const MultiIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowDown):
        const MultiIncrementSelectionIntent(1),
  };
  Map<Type, Action> get actions => {
        SingleIncrementSelectionIntent:
            CallbackAction<SingleIncrementSelectionIntent>(
                onInvoke: (intent) => incrementSelection(intent.increment)),
        MultiIncrementSelectionIntent:
            CallbackAction<MultiIncrementSelectionIntent>(
                onInvoke: (intent) =>
                    incrementSelection(intent.increment * numColumn)),
      };

  FileGridViewModel()
      : _list = [],
        _selectedIdx = null;

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
