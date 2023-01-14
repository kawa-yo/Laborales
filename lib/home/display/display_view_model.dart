import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/display/display_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';

final displayProvider = ChangeNotifierProvider((ref) => DisplayViewModel(ref));

class DisplayViewModel extends ChangeNotifier {
  final Ref ref;
  bool _reverse = false;
  double _threshold = 5;
  double _buffer = 0;

  bool get reverseScroll => _reverse;

  DisplayViewModel(this.ref) {
    initialize();
  }

  void setReverseScroll(bool value) {
    _reverse = value;
    saveReverseScrollToPrefs(value);
    notifyListeners();
  }

  void initialize() {
    _reverse = loadReverseScrollFromPrefs() ?? false;
  }

  void onDisplayDragged(double delta) {
    _buffer += delta;
    if (_buffer.abs() >= _threshold) {
      int increment = _buffer.sign.toInt();
      if (_reverse) {
        increment *= -1;
      }
      ref.read(galleryProvider).incrementSelection(increment);
      _buffer = 0;
    }
  }

  void onPointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) {
      debugPrint("${event.scrollDelta.dy}");
      int increment = event.scrollDelta.dy.sign.toInt();
      if (_reverse) {
        increment *= -1;
      }
      ref.read(galleryProvider).incrementSelection(increment);
    }
  }
}
