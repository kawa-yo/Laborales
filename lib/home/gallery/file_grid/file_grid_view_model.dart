import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_model.dart';

final fileGridProvider =
    ChangeNotifierProvider(((ref) => FileGridViewModel(ref)));

class FileGridViewModel extends ChangeNotifier {
  final Ref ref;
  final double padding = 2;

  int _numColumn = 5;
  double _cacheExtent = 1000;

  FileGridViewModel(this.ref) {
    initialize();
  }

  int get numColumn => _numColumn;
  double get cacheExtent => _cacheExtent;

  void initialize() {
    _numColumn = loadNumColumnOfGridFromPrefs() ?? 5;
    _cacheExtent = loadCacheExtentOfGridFromPrefs() ?? 1000;
  }

  void setNumColumn(int value) {
    assert(value > 0);
    _numColumn = value;
    saveNumColumnOfGridToPrefs(numColumn);
    notifyListeners();
  }

  void setCacheExtent(double value) {
    assert(value >= 0);
    debugPrint("set cache extent to $value");
    _cacheExtent = value;
    saveCacheExtentOfGridToPrefs(value);
    notifyListeners();
  }
}
