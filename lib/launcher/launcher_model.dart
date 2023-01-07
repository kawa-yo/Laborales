import 'dart:io';

import 'package:flutter/material.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/preferences.dart';
import 'package:laborales/repository/secure_bookmarks.dart';

const prefix = "laborales/projects";

Future<List<Project>> loadProjectsFromPrefs() async {
  var projectNames = prefs.getStringList("$prefix/project_list");
  debugPrint("load projects from prefs: $projectNames");
  if (projectNames == null) {
    return [];
  }

  var list = <Project>[];
  for (var name in projectNames) {
    var saveFileBookmark =
        prefs.getString("$prefix/$name/project_file_bookmark");
    var targetDirBookmark =
        prefs.getString("$prefix/$name/target_directory_bookmark");

    debugPrint("project [$name]:");
    debugPrint("  project_file_bookmark: $saveFileBookmark");
    debugPrint("  target_dir_bookmark  : $targetDirBookmark");

    if (saveFileBookmark == null || targetDirBookmark == null) {
      /// remove the project from prefs.
      prefs.remove("$prefix/$name");
      var removed = projectNames..remove(name);
      prefs.setStringList("$prefix/project_list", removed);
      continue;
    }

    var saveFile = await resolveFileFrom(saveFileBookmark);
    debugPrint("saveFile's bookmark resolved.");
    var targetDir = await resolveDirectoryFrom(targetDirBookmark);
    debugPrint("targetDir's bookmark resolved.");

    debugPrint("project [$name]:");
    debugPrint("  project file    : $saveFile");
    debugPrint("  target directory: $targetDir");

    list.add(Project(
      name: name,
      targetDir: targetDir,
      saveFile: saveFile,
    ));
  }
  return list;
}

Future<void> saveProjectToPrefs(Project project) async {
  var saveFileBookmark = await getBookmarkOf(project.saveFile);
  var targetDirBookmark = await getBookmarkOf(project.targetDir);
  var existingProjects = prefs.getStringList("$prefix/project_list") ?? [];
  if (existingProjects.contains(project.name)) {
    debugPrint("project: ${project.name} already exists in preferences");
    return;
  }
  prefs.setStringList(
      "$prefix/project_list", [...existingProjects, project.name]);
  prefs.setString(
      "$prefix/${project.name}/project_file_bookmark", saveFileBookmark);
  prefs.setString(
      "$prefix/${project.name}/target_directory_bookmark", targetDirBookmark);
}

Future<File> projectSaveFile(String projectName) async {
  var home = Platform.environment["HOME"]!;
  var file = File("$home/.laborales/projects/$projectName.json");
  file.createSync(recursive: true);
  // await ensureToOpen(file);
  return file;
}
