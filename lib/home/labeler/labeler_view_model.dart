import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/labeler/labeler_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/repository/dto/label_dto.dart';
import 'package:laborales/themes/theme.dart';

final labelerProvider = ChangeNotifierProvider((ref) => LabelerViewModel(ref));

class LabelerViewModel extends ChangeNotifier {
  final Ref ref;

  Map<String, Color> _label2color;

  List<String> get labels => _label2color.keys.toList();
  Map<String, Color> get label2color => _label2color;

  LabelerViewModel(this.ref) : _label2color = {} {
    initialize();
    ref.listen(
      launcherProvider.select((value) => value.project),
      (previous, next) {
        initialize();
      },
    );
  }

  Future<void> initialize() async {
    debugPrint("labeler initializing...");
    bool success = await _loadLabels();
    if (!success) {
      addLabel("label1");
      addLabel("label2");
      addLabel("label3");
      addLabel("label4");
    }
  }

  void addLabel(String label, {Color? color}) {
    color ??= tenColors.firstWhere(
      (color) => !_label2color.containsValue(color),
      orElse: () => Colors.grey,
    );
    _label2color[label] = color;
    _saveLabel(label);

    notifyListeners();
  }

  void removeLabel(String label) {
    _label2color.remove(label);
    _deleteLabel(label);

    notifyListeners();
  }

  void setSelectedPhotoLabel(String label) {
    var galleryViewModel = ref.read(galleryProvider);
    var selectedPhoto = galleryViewModel.selectedPhoto;
    if (selectedPhoto != null) {
      galleryViewModel.setLabel(selectedPhoto, label);
    }
  }

  Future<bool> _saveLabel(String label) async {
    var dbFile = ref.read(launcherProvider).project!.dbFile;
    var dto = LabelDTO(name: label, color: _label2color[label]!);
    bool succeeded = await insertLabelIntoDB(dbFile, dto);
    return succeeded;
  }

  Future<bool> _deleteLabel(String label) async {
    var dbFile = ref.read(launcherProvider).project!.dbFile;
    var dto = LabelDTO(name: label, color: _label2color[label]!);
    bool succeeded = await deleteLabelFromDB(dbFile, dto);
    return succeeded;
  }

  Future<bool> _loadLabels() async {
    var dbFile = ref.read(launcherProvider).project!.dbFile;
    var savedLabels = await selectLabelsFromDB(dbFile);
    if (savedLabels.isEmpty) {
      return false;
    }
    _label2color = {for (var label in savedLabels) label.name: label.color};
    notifyListeners();
    return true;
  }
}
