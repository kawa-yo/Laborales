import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

const prefix = "laborales/projects";

Future<List<Project>> loadProjectsFromPrefs() async {
  var projectNames = prefs.getStringList("$prefix/project_list");
  if (projectNames == null) {
    return [];
  }

  var list = <Project>[];
  for (var name in projectNames) {
    var saveFilePath = prefs.getString("$prefix/$name/project_file");
    var targetPath = prefs.getString("$prefix/$name/target_directory");
    if (saveFilePath == null || targetPath == null) {
      continue;
    }
    var saveFile = await ensureToOpen(File(saveFilePath));
    var targetDir = await ensureToOpen(Directory(targetPath));
    list.add(Project(name: name, targetDir: targetDir, saveFile: saveFile));
  }
  return list;
}

Future<void> saveProjectToPrefs(Project project) async {
  // var bookmark = await getBookmarkOf(project.saveFile);
  var existingProjects = prefs.getStringList("$prefix/project_list") ?? [];
  if (existingProjects.contains(project.name)) {
    debugPrint("project: ${project.name} already exists in preferences");
    return;
  }
  prefs.setStringList(
    "$prefix/project_list",
    [...existingProjects, project.name],
  );
  prefs.setString(
      "$prefix/${project.name}/project_file", project.saveFile.path);
  prefs.setString(
      "$prefix/${project.name}/target_directory", project.targetDir.path);
}

Future<File> projectSaveFile(String projectName) async {
  var home = Platform.environment["HOME"]!;
  var file = File("$home/.laborales/projects/$projectName.json");
  file.createSync(recursive: true);
  // await ensureToOpen(file);
  return file;
}
