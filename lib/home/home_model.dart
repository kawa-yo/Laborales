import 'package:flutter/material.dart';
import 'package:laborales/repository/preferences.dart';

const prefix = "laborales/general/labeler_position";

Offset? loadFloatingPositionFromPrefs() {
  double? dx = prefs.getDouble("$prefix/dx");
  double? dy = prefs.getDouble("$prefix/dy");
  if (dx == null || dy == null) {
    return null;
  }
  return Offset(dx, dy);
}

Future<void> saveFloatingPositionToPrefs(Offset pos) async {
  await prefs.setDouble("$prefix/dx", pos.dx);
  await prefs.setDouble("$prefix/dy", pos.dy);
}
