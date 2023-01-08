import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/photo/photo_view_model.dart';

class SingleIncrementSelectionIntent extends Intent {
  final int increment;
  const SingleIncrementSelectionIntent(this.increment);
}

class MultiIncrementSelectionIntent extends Intent {
  final int increment;
  const MultiIncrementSelectionIntent(this.increment);
}

final fileGridProvider =
    ChangeNotifierProvider(((ref) => FileGridViewModel(ref)));

class FileGridViewModel extends ChangeNotifier {
  /// finalにすると，要素を出し入れしてもhashCodeが変わらないから，変更が監視されない
  int _numColumn = 5;
  final Ref ref;

  FileGridViewModel(this.ref);

  int get numColumn => _numColumn;

  final shortcuts = {
    const SingleActivator(LogicalKeyboardKey.arrowLeft):
        const SingleIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowRight):
        const SingleIncrementSelectionIntent(1),
    const SingleActivator(LogicalKeyboardKey.arrowUp):
        const MultiIncrementSelectionIntent(-1),
    const SingleActivator(LogicalKeyboardKey.arrowDown):
        const MultiIncrementSelectionIntent(1),
  };
  Map<Type, Action> get actions => {
        SingleIncrementSelectionIntent:
            CallbackAction<SingleIncrementSelectionIntent>(
                onInvoke: (intent) => ref
                    .read(photosProvider)
                    .incrementSelection(intent.increment)),
        MultiIncrementSelectionIntent:
            CallbackAction<MultiIncrementSelectionIntent>(
                onInvoke: (intent) => ref
                    .read(photosProvider)
                    .incrementSelection(intent.increment * numColumn)),
      };
}
