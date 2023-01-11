import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';

class SingleIncrementSelectionIntent extends Intent {
  final int increment;
  const SingleIncrementSelectionIntent(this.increment);
}

class MultiIncrementSelectionIntent extends Intent {
  final int increment;
  const MultiIncrementSelectionIntent(this.increment);
}

class DigitKeyIntent extends Intent {
  final int digit;
  const DigitKeyIntent(this.digit);
}

final homeViewProvider = ChangeNotifierProvider((ref) => HomeViewModel(ref));

class HomeViewModel extends ChangeNotifier {
  final Ref ref;
  HomeViewModel(this.ref);

  final shortcuts = {
    const SingleActivator(LogicalKeyboardKey.arrowLeft):
        const SingleIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowRight):
        const SingleIncrementSelectionIntent(1),
    const SingleActivator(LogicalKeyboardKey.arrowUp):
        const MultiIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowDown):
        const MultiIncrementSelectionIntent(1),
    const SingleActivator(LogicalKeyboardKey.digit1): const DigitKeyIntent(1),
    const SingleActivator(LogicalKeyboardKey.digit2): const DigitKeyIntent(2),
    const SingleActivator(LogicalKeyboardKey.digit3): const DigitKeyIntent(3),
    const SingleActivator(LogicalKeyboardKey.digit4): const DigitKeyIntent(4),
    const SingleActivator(LogicalKeyboardKey.digit5): const DigitKeyIntent(5),
    const SingleActivator(LogicalKeyboardKey.digit6): const DigitKeyIntent(6),
    const SingleActivator(LogicalKeyboardKey.digit7): const DigitKeyIntent(7),
    const SingleActivator(LogicalKeyboardKey.digit8): const DigitKeyIntent(8),
    const SingleActivator(LogicalKeyboardKey.digit9): const DigitKeyIntent(9),
    const SingleActivator(LogicalKeyboardKey.numpad1): const DigitKeyIntent(1),
    const SingleActivator(LogicalKeyboardKey.numpad2): const DigitKeyIntent(2),
    const SingleActivator(LogicalKeyboardKey.numpad3): const DigitKeyIntent(3),
    const SingleActivator(LogicalKeyboardKey.numpad4): const DigitKeyIntent(4),
    const SingleActivator(LogicalKeyboardKey.numpad5): const DigitKeyIntent(5),
    const SingleActivator(LogicalKeyboardKey.numpad6): const DigitKeyIntent(6),
    const SingleActivator(LogicalKeyboardKey.numpad7): const DigitKeyIntent(7),
    const SingleActivator(LogicalKeyboardKey.numpad8): const DigitKeyIntent(8),
    const SingleActivator(LogicalKeyboardKey.numpad9): const DigitKeyIntent(9),
  };
  Map<Type, Action> get actions => {
        SingleIncrementSelectionIntent:
            CallbackAction<SingleIncrementSelectionIntent>(
                onInvoke: (intent) => ref
                    .read(photosProvider)
                    .incrementSelection(intent.increment)),
        MultiIncrementSelectionIntent: CallbackAction<
                MultiIncrementSelectionIntent>(
            onInvoke: (intent) => ref.read(photosProvider).incrementSelection(
                intent.increment * ref.read(fileGridProvider).numColumn)),
        DigitKeyIntent: CallbackAction<DigitKeyIntent>(onInvoke: (intent) {
          int idx = intent.digit - 1;
          var labels = ref.read(labelerProvider).labels;
          if (idx < labels.length) {
            var label = labels[idx];
            ref.read(labelerProvider).setSelectedPhotoLabel(label);
          }
        })
      };
}
