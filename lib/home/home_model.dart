import 'dart:io';
import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';

const root = "laborales/projects";

Offset? loadFloatingPositionFromPrefs(Project project) {
  String prefix = "$root/${project.name}/settings/labeler_position";

  double? dx = prefs.getDouble("$prefix/dx");
  double? dy = prefs.getDouble("$prefix/dy");
  if (dx == null || dy == null) {
    return null;
  }
  return Offset(dx, dy);
}

Future<void> saveFloatingPositionToPrefs(Offset pos, Project project) async {
  String prefix = "$root/${project.name}/settings/labeler_position";

  await prefs.setDouble("$prefix/dx", pos.dx);
  await prefs.setDouble("$prefix/dy", pos.dy);
}
