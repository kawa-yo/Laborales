import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view_model.dart';

final filterProvider = ChangeNotifierProvider((ref) => FilterViewModel(ref));

class FilterViewModel extends ChangeNotifier {
  Ref ref;
  Set<String> _selectedDirs = {};

  FilterViewModel(this.ref);

  bool isSelected(String dir) {
    return _selectedDirs.contains(dir);
  }

  // bool isAllSelected() {
  //   var allDirs = ref.read(fileSemiGridProvider).dirs.toSet();
  //   return setEquals(allDirs, _selectedDirs);
  // }

  bool isAllDeselected() {
    return _selectedDirs.isEmpty;
  }

  void toggle(String dir) {
    if (isSelected(dir)) {
      _deselect(dir);
    } else {
      _select(dir);
    }
  }

  void toggleAll() {
    if (isAllDeselected()) {
      _selectAll();
    } else {
      _deselectAll();
    }
  }

  void _select(String dir) {
    _selectedDirs.add(dir);
    notifyListeners();
  }

  void _deselect(String dir) {
    _selectedDirs.remove(dir);
    notifyListeners();
  }

  void _selectAll() {
    _selectedDirs = ref.read(fileSemiGridProvider).dirs.toSet();
    notifyListeners();
  }

  void _deselectAll() {
    _selectedDirs.clear();
    notifyListeners();
  }
}
