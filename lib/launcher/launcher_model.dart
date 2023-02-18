import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

const prefix = "laborales/projects";

String _projectNamesKey() => "$prefix/project_list";
String _dbFileBookmarkKey(String projectName) =>
    "$prefix/$projectName/db_file_bookmark";
String _targetDirBookmarkKey(String projectName) =>
    "$prefix/$projectName/target_directory_bookmark";
String _projectKey(String projectName) => "$prefix/$projectName";

Future<List<Project>> loadProjectsFromPrefs() async {
  var projectNames = prefs.getStringList(_projectNamesKey());
  debugPrint("load projects from prefs: $projectNames");
  if (projectNames == null) {
    return [];
  }

  var list = <Project>[];
  for (var name in projectNames) {
    var dbFileBookmark = prefs.getString(_dbFileBookmarkKey(name));
    var targetDirBookmark = prefs.getString(_targetDirBookmarkKey(name));

    if (dbFileBookmark == null || targetDirBookmark == null) {
      await removeProjectFromPrefs(name);
      continue;
    }

    var saveFile = await resolveFileFrom(dbFileBookmark);
    var targetDir = await resolveDirectoryFrom(targetDirBookmark);

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
  var dbFileBookmark = await getBookmarkOf(project.dbFile);
  var targetDirBookmark = await getBookmarkOf(project.targetDir);
  var existingProjects = prefs.getStringList(_projectNamesKey()) ?? [];
  if (existingProjects.contains(project.name)) {
    debugPrint("project: ${project.name} already exists in preferences");
    return;
  }
  prefs.setStringList(
      "$prefix/project_list", [...existingProjects, project.name]);
  prefs.setString(_dbFileBookmarkKey(project.name), dbFileBookmark);
  prefs.setString(_targetDirBookmarkKey(project.name), targetDirBookmark);
}

Future<File> projectDbFile(String projectName) async {
  var home = Platform.environment["HOME"]!;
  var file = File("$home/.laborales/projects/$projectName.db");
  file.createSync(recursive: true);
  // await ensureToOpen(file);
  return file;
}
