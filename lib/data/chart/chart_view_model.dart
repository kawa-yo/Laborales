import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chartProvider = ChangeNotifierProvider((ref) => ChartViewModel());

class ChartViewModel extends ChangeNotifier {
  bool _includeNull = true;
  bool get includeNull => _includeNull;

  ChartViewModel();

  void setIncludeNull(bool value) {
    _includeNull = value;
    notifyListeners();
  }
}
