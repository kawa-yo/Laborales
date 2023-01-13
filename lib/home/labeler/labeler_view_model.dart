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

  List<String> _labels;
  List<Color> _colors;

  List<String> get labels => _labels;
  List<Color> get colors => _colors;

  LabelerViewModel(this.ref)
      : _colors = [],
        _labels = [] {
    addLabel("label1");
    addLabel("label2");
    addLabel("label3");
    addLabel("label4");
  }

  void addLabel(String label, [Color? color]) {
    if (color == null) {
      for (var c in tenColors) {
        if (!_colors.contains(c)) {
          color = c;
          break;
        }
      }
    }
    _labels.add(label);
    _colors.add(color ?? Colors.grey);

    notifyListeners();
  }

  void removeLabel(String label) {
    int idx = _labels.indexOf(label);
    if (idx >= 0) {
      _labels.removeAt(idx);
      _colors.removeAt(idx);
      notifyListeners();
    }
  }

  Color? colorOf(String label) {
    int idx = _labels.indexOf(label);
    if (idx == -1) {
      return null;
    }
    return _colors[idx];
  }

  void onLabelSelected(String label) {
    setSelectedPhotoLabel(label);
    debugPrint("set label");

    _debounce?.cancel();
    _debounce = Timer(debounceDuration, () => savePhotoLabelsToJson());
    debugPrint("reserve to save");
  }

  Future<bool> savePhotoLabelsToJson() async {
    var jsonFile = ref.read(launcherProvider).project!.saveFile;
    var path2label = ref.read(galleryProvider).path2label;
    return await dumpToJson(jsonFile, path2label, labels);
  }

  void setSelectedPhotoLabel(String label) {
    var galleryViewModel = ref.read(galleryProvider);
    var selectedPhoto = galleryViewModel.selectedPhoto;
    if (selectedPhoto != null) {
      galleryViewModel.setLabel(selectedPhoto, label);
    }
  }
}
