import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_model.dart';

final fileGridProvider =
    ChangeNotifierProvider(((ref) => FileGridViewModel(ref)));

class FileGridViewModel extends ChangeNotifier {
  /// finalにすると，要素を出し入れしてもhashCodeが変わらないから，変更が監視されない
  int _numColumn = 5;
  final Ref ref;

  FileGridViewModel(this.ref) {
    initialize();
  }

  int get numColumn => _numColumn;

  void initialize() {
    _numColumn = loadNumColumnOfGridFromPrefs() ?? 5;
  }

  void setNumColumn(int value) {
    if (0 < value && value <= 10) {
      _numColumn = value;
      saveNumColumnOfGridToPrefs(numColumn);
      notifyListeners();
    }
  }
}
