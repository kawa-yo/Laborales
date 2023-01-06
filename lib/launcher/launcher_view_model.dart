import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:laborales/launcher/launcher_model.dart';

class Project {
  final String name;
  final Directory targetDir;
  final File saveFile;

  const Project({
    required this.name,
    required this.targetDir,
    required this.saveFile,
  });

  String get lastModified => DateFormat("yyyy-MM-dd HH:mm", "ja_JP")
      .format(saveFile.lastModifiedSync());

  @override
  int get hashCode => Object.hash(name, targetDir, saveFile);
  @override
  bool operator ==(Object other) =>
      other is Project &&
      name == other.name &&
      targetDir.path == other.targetDir.path &&
      saveFile.path == other.saveFile.path;
  @override
  String toString() {
    return """
    Project(
      name=$name,
      targetDir=$targetDir,
      saveFile=$saveFile
    )
    """;
  }
}

final launcherProvider = ChangeNotifierProvider(((ref) => LauncherViewModel()));

class LauncherViewModel extends ChangeNotifier {
  List<Project> _projectList;

  List<Project> get projects => _projectList;

  LauncherViewModel() : _projectList = [];

  Future<void> initialize() async {
    _projectList = await loadProjectsFromPrefs();
    _projectList.sort((p1, p2) => p2.saveFile
        .lastModifiedSync()
        .compareTo(p1.saveFile.lastModifiedSync()));
    // notifyListeners();
  }

  Future<void> newProject(String projectName, Directory targetDir) async {
    File saveFile = await projectSaveFile(projectName);
    var project = Project(
      name: projectName,
      targetDir: targetDir,
      saveFile: saveFile,
    );
    await saveProjectToPrefs(project);
    _projectList.add(project);
    notifyListeners();
  }
}
