import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/labeler/labeler_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';
import 'package:laborales/themes/theme.dart';

final labelerProvider = ChangeNotifierProvider((ref) => LabelerViewModel(ref));

class LabelerViewModel extends ChangeNotifier {
  final Ref ref;
  Timer? _debounce;
  Duration debounceDuration = const Duration(seconds: 1);

  // List<String> _labels;
  Map<String, Color> _label2color;

  List<String> get labels => _label2color.keys.toList();
  Map<String, Color> get label2color => _label2color;
  // List<Color> get colors => _colors;

  LabelerViewModel(this.ref) : _label2color = {} {
    initialize();
  }

  Future<void> initialize() async {
    bool success = await loadLabels();
    if (!success) {
      addLabel("label1");
      addLabel("label2");
      addLabel("label3");
      addLabel("label4");
    }
  }

  void addLabel(String label, [Color? color]) {
    color ??= tenColors.firstWhere(
      (color) => !_label2color.containsValue(color),
      orElse: () => Colors.grey,
    );
    _label2color[label] = color;
    savePhotoLabels();

    notifyListeners();
  }

  void removeLabel(String label) {
    _label2color.remove(label);
    savePhotoLabels();

    notifyListeners();
  }

  void onLabelSelected(String label) {
    setSelectedPhotoLabel(label);
    debugPrint("set label");

    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () => savePhotoLabels());
    debugPrint("reserve to save");
  }

  Future<bool> savePhotoLabels() async {
    var jsonFile = ref.read(launcherProvider).project!.saveFile;
    var path2label = ref.read(galleryProvider).path2label;
    return await dumpToJson(jsonFile, path2label, labels, label2color);
  }

  Future<bool> loadLabels() async {
    var jsonFile = ref.read(launcherProvider).project!.saveFile;
    var savedLabels = await loadLabelsFromJson(jsonFile);
    if (savedLabels == null) {
      return false;
    }
    _label2color = savedLabels;
    notifyListeners();
    return true;
  }

  void setSelectedPhotoLabel(String label) {
    var galleryViewModel = ref.read(galleryProvider);
    var selectedPhoto = galleryViewModel.selectedPhoto;
    if (selectedPhoto != null) {
      galleryViewModel.setLabel(selectedPhoto, label);
    }
  }
}
