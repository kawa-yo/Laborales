import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view_model.dart';
import 'package:laborales/home/gallery/file_tree/file_tree_view_models.dart';
import 'package:laborales/home/gallery/gallery_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/dto/photo_dto.dart';
import 'package:path/path.dart';

final galleryProvider =
    ChangeNotifierProvider(((ref) => GalleryViewModel(ref)));

class GalleryViewModel extends ChangeNotifier {
  Map<String, String> _path2label;
  List<Photo> _list;
  int? _selectedIdx;
  int tabIndex = 0;
  final Ref ref;

  GalleryViewModel(this.ref)
      : _list = [],
        _path2label = {} {
    tabIndex = savedTabIndex() ?? tabIndex;
  }

  Future<bool> initialize() async {
    var project = ref.read(launcherProvider).project;
    if (project == null) {
      return false;
    }
    var rootDir = project.targetDir;

    clear();
    ref.read(fileTreeProvider).setRoot(rootDir);

    await _loadPhotoLabels();
    await _loadPhotos(rootDir);

    return true;
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
    if (0 <= idx && idx < _list.length) {
      /// [FileSemiGridView]
      if (tabIndex == 1) {
        var prev = _list[_selectedIdx!];
        var next = _list[idx];
        ref.read(fileSemiGridProvider).selectPhoto(prev, next);
      }

      /// [FileSemiGridView]
      if (tabIndex == 2) {
        select(idx);
      }
    }
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
    _savePhotoLabel(photo, label);
    notifyListeners();
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

  Future<bool> _loadPhotoLabels() async {
    var dbFile = ref.read(launcherProvider).project!.dbFile;
    var root = ref.read(launcherProvider).project!.targetDir;
    List<PhotoDTO> dtos = await selectPhotosFromDB(dbFile);
    if (dtos.isEmpty) {
      return false;
    }
    _path2label = {
      for (var dto in dtos) join(root.path, dto.relativePath): dto.label
    };
    return true;
  }

  Future<bool> _savePhotoLabel(Photo photo, String label) async {
    var dbFile = ref.read(launcherProvider).project!.dbFile;
    var root = ref.read(launcherProvider).project!.targetDir;
    var relativePath = photo.src.path.substring(root.path.length);
    if (relativePath.startsWith("/")) {
      relativePath = relativePath.substring(1);
    }
    var dto = PhotoDTO(relativePath: relativePath, label: label);
    debugPrint("save: $relativePath");
    bool succeeded = await upsertPhotoIntoDB(dbFile, dto);
    return succeeded;
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
    tabIndex = idx;
    var project = ref.read(launcherProvider).project;
    if (project == null) {
      return;
    }
    saveTabIndexToPrefs(idx, project);
  }
}
