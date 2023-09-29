import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

class LauncherModelLinux extends LauncherModel {
  static const prefix = "laborales/projects";

  String _projectNamesKey() => "$prefix/project_list";
  String _dbFilePathKey(String projectName) =>
      "$prefix/$projectName/db_file_path";
  String _targetDirPathKey(String projectName) =>
      "$prefix/$projectName/target_directory_path";
  String _projectKey(String projectName) => "$prefix/$projectName";

  Future<List<Project>> loadProjectsFromPrefs() async {
    var projectNames = prefs.getStringList(_projectNamesKey());
    debugPrint("load projects from prefs: $projectNames");
    if (projectNames == null) {
      return [];
    }

    var list = <Project>[];
    for (var name in projectNames) {
      var dbFilePath = prefs.getString(_dbFilePathKey(name));
      var targetDirPath = prefs.getString(_targetDirPathKey(name));

      if (dbFilePath == null || targetDirPath == null) {
        await removeProjectFromPrefs(name);
        continue;
      }

      var saveFile = File(dbFilePath);
      var targetDir = Directory(targetDirPath);

      debugPrint("project [$name]:");
      debugPrint("  project file    : $saveFile");
      debugPrint("  target directory: $targetDir");

      list.add(Project(
        name: name,
        targetDir: targetDir,
        dbFile: saveFile,
      ));
    }
    return list;
  }

  Future<void> removeProjectFromPrefs(String projectName) async {
    var projectNames = prefs.getStringList(_projectNamesKey());
    if (projectNames == null || projectName.isEmpty) {
      return;
    }
    var removed = projectNames..remove(projectName);
    prefs.remove(_projectKey(projectName));
    prefs.setStringList(_projectNamesKey(), removed);

    var dbFile = await projectDbFile(projectName);
    dbFile.deleteSync();
  }

  Future<void> saveProjectToPrefs(Project project) async {
    var dbFilePath = project.dbFile.path;
    var targetDirPath = project.targetDir.path;
    var existingProjects = prefs.getStringList(_projectNamesKey()) ?? [];
    if (existingProjects.contains(project.name)) {
      debugPrint("project: ${project.name} already exists in preferences");
      return;
    }
    prefs.setStringList(
        "$prefix/project_list", [...existingProjects, project.name]);
    prefs.setString(_dbFilePathKey(project.name), dbFilePath);
    prefs.setString(_targetDirPathKey(project.name), targetDirPath);
  }
}
