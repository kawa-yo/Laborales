import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

final rootProvider = ChangeNotifierProvider((ref) => RootViewModel());

class RootViewModel extends ChangeNotifier {
  Project? _project;
  Project? get project => _project;

  RootViewModel();

  void updateProject(Project? p) {
    _project = p;
    // notifyListeners();
  }
}
