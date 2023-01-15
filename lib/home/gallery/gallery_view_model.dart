import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_view_models.dart';
import 'package:laborales/home/gallery/gallery_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

final galleryProvider =
    ChangeNotifierProvider(((ref) => GalleryViewModel(ref)));

class GalleryViewModel extends ChangeNotifier {
  Map<String, String> _path2label;
  List<Photo> _list;
  int? _selectedIdx;
  int defaultTabIndex = 0;
  final Ref ref;

  GalleryViewModel(this.ref)
      : _list = [],
        _path2label = {} {
    defaultTabIndex = savedTabIndex() ?? defaultTabIndex;
  }

  List<Photo> get list => _list;
  Map<String, String> get path2label => _path2label;

  Photo? get selectedPhoto {
    int? idx = _selectedIdx;
    if (idx != null && idx < _list.length) {
      return _list[idx];
    }
    if (_list.isNotEmpty) {
      _selectedIdx = 0;
      return _list.first;
    }
    return null;
  }

  String labelOf(Photo? photo) {
    if (photo == null) {
      return "";
    }
    var label = _path2label[photo.src.path];
    return label ?? "";
  }

  void incrementSelection(int increment) {
    if (_selectedIdx == null) {
      return;
    }
    int idx = _selectedIdx! + increment;
    if (idx < 0 || idx >= _list.length) {
      return;
    }
    select(idx);
  }

  void select(int idx) {
    _selectedIdx = idx;
    notifyListeners();
  }

  void selectByPath(String path) {
    int idx = _list.indexWhere((e) => e.src.path == path);
    if (idx != -1) {
      _selectedIdx = idx;
      notifyListeners();
    }
  }

  void setLabel(Photo photo, String label) {
    _path2label[photo.src.path] = label;
    notifyListeners();
  }

  Future<bool> initialize() async {
    var project = ref.watch(launcherProvider).project;
    if (project == null) {
      return false;
    }
    var rootDir = project.targetDir;
    var jsonFile = project.saveFile;

    clear();
    ref.read(fileTreeProvider).setRoot(rootDir);

    await _loadLabels(jsonFile);
    await _loadPhotos(rootDir);

    return true;
  }

  Future<void> _loadPhotos(Directory rootDir) async {
    await for (var files in bfsOnFileSystem(rootDir)) {
      bool firstAddition = _list.isEmpty;

      addPhotos(files);
      await ref.read(fileTreeProvider).addNodes(files);

      if (firstAddition) {
        select(0);
      }
    }
  }

  Future<void> _loadLabels(File jsonFile) async {
    var savedLabels = await loadLabelsFromJson(jsonFile);
    if (savedLabels != null) {
      _path2label = savedLabels;
    }
  }

  void clear() {
    _list = [];
    notifyListeners();
  }

  void addPhotos(List<File> files) {
    var addition = <Photo>[];
    for (int i = 0; i < files.length; i++) {
      var photo = Photo(files[i], idx: _list.length + i);
      addition.add(photo);
    }
    _list = [..._list, ...addition];
    debugPrint("#photo: ${_list.length}");
    notifyListeners();
  }

  int? savedTabIndex() {
    var project = ref.read(launcherProvider).project;
    if (project == null) {
      return null;
    }
    return loadTabIndexFromPrefs(project);
  }

  void onTabChanged(int idx) {
    var project = ref.read(launcherProvider).project;
    if (project == null) {
      return;
    }
    saveTabIndexToPrefs(idx, project);
  }
}