import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/launcher/project_builder/project_builder_model.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

final projectBuilderProvider =
    StateProvider((ref) => ProjectBuilderViewModel(ref));

class ProjectBuilderViewModel {
  TextEditingController nameController;
  TextEditingController dirController;
  Ref ref;

  ProjectBuilderViewModel(this.ref)
      : nameController = TextEditingController(),
        dirController = TextEditingController();

  String? nameValidator(String? projectName) {
    var projectNames = ref.watch(launcherProvider).projects.map((e) => e.name);
    if (projectName == null || projectName.isEmpty) {
      return "Fill the blank.";
    }
    if (projectNames.contains(projectName)) {
      return "This project already exists.";
    }
    return null;
  }

  String? dirValidator(String? dirName) {
    if (dirName == null || dirName.isEmpty) {
      return "Fill the blank.";
    }
    if (!Directory(dirName).existsSync()) {
      return "Unexisting directory.";
    }
    return null;
  }

  Future<void> onSearchIconPressed() async {
    var dir = await pickDirectory();
    if (dir == null) {
      return;
    }
    await ensureToOpen(dir);
    dirController.text = dir.path;
  }

  void onSubmitted(BuildContext context) {
    var projectName = nameController.text;
    var targetDir = Directory(dirController.text);
    if (nameValidator(projectName) == null &&
        dirValidator(targetDir.path) == null) {
      ref.watch(launcherProvider).newProject(projectName, targetDir).then((_) {
        Navigator.of(context, rootNavigator: true).pop();
      });
    }
  }
}
