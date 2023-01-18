import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/launcher/launcher_model.dart';
import 'package:laborales/repository/sqlite.dart';
import 'package:laborales/root/root_view.dart';
import 'package:window_size/window_size.dart';

class Project {
  final String name;
  final Directory targetDir;
  final File dbFile;

  const Project({
    required this.name,
    required this.targetDir,
    required this.dbFile,
  });

  String get lastModified =>
      DateFormat("yyyy-MM-dd HH:mm", "ja_JP").format(dbFile.lastModifiedSync());

  @override
  int get hashCode => Object.hash(name, targetDir, dbFile);
  @override
  bool operator ==(Object other) =>
      other is Project &&
      name == other.name &&
      targetDir.path == other.targetDir.path &&
      dbFile.path == other.dbFile.path;
  @override
  String toString() {
    return """
Project(
  name=$name,
  targetDir=$targetDir,
  saveFile=$dbFile
)""";
  }
}

final launcherProvider =
    ChangeNotifierProvider(((ref) => LauncherViewModel(ref)));

class LauncherViewModel extends ChangeNotifier {
  final Ref ref;

  List<Project> _projectList;
  Project? _selectedProject;

  List<Project> get projects => _projectList;
  Project? get project => _selectedProject;

  LauncherViewModel(this.ref) : _projectList = [];

  Future<bool> initialize() async {
    debugPrint("initialize laucherviewmodel");
    _projectList = await loadProjectsFromPrefs();
    _projectList.sort((p1, p2) =>
        p2.dbFile.lastModifiedSync().compareTo(p1.dbFile.lastModifiedSync()));
    debugPrint("projects: $_projectList");
    notifyListeners();
    return true;
  }

  Future<void> newProject(String projectName, Directory targetDir) async {
    File dbFile = await projectDbFile(projectName);
    var project = Project(
      name: projectName,
      targetDir: targetDir,
      dbFile: dbFile,
    );
    await saveProjectToPrefs(project);
    _projectList.add(project);
    notifyListeners();
  }

  void selectProject(Project? project) {
    _selectedProject = project;
    notifyListeners();
  }

  void onProjectSelected(BuildContext context, Project project) async {
    debugPrint("$project selected.");
    selectProject(project);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RootView(),
      ),
    );
    setWindowTitle("laborales   [ ${project.name} ]");
    await openMyDatabase(project.dbFile);
    await ref.read(galleryProvider).initialize();
  }
}
