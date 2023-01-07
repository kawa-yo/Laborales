import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

final rootProvider = Provider((ref) => RootViewModel());

class RootViewModel {
  Project? _project;
  Project? get project => _project;

  RootViewModel();

  void updateProject(Project? p) {
    _project = p;
  }
}
