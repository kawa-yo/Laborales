import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/themes/theme.dart';

final labelerProvider = ChangeNotifierProvider((ref) => LabelerViewModel());

class LabelerViewModel extends ChangeNotifier {
  List<String> _labels;
  List<Color> _colors;

  List<String> get labels => _labels;
  List<Color> get colors => _colors;

  LabelerViewModel()
      : _colors = [],
        _labels = [] {
    addLabel("label1");
    addLabel("label2");
    addLabel("label3");
    addLabel("label4");
  }

  void addLabel(String label, [Color? color]) {
    if (color == null) {
      for (var c in tenColors) {
        if (!_colors.contains(c)) {
          color = c;
          break;
        }
      }
    }
    _labels.add(label);
    _colors.add(color ?? Colors.grey);

    notifyListeners();
  }

  void removeLabel(String label) {
    int idx = _labels.indexOf(label);
    if (idx >= 0) {
      _labels.removeAt(idx);
      _colors.removeAt(idx);
      notifyListeners();
    }
  }

  Color? colorOf(String label) {
    int idx = _labels.indexOf(label);
    if (idx == -1) {
      return Colors.grey;
    }
    return _colors[idx];
  }
}
