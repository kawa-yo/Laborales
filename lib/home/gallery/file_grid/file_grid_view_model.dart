import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';

final fileGridProvider =
    ChangeNotifierProvider(((ref) => FileGridViewModel(ref)));

class FileGridViewModel extends ChangeNotifier {
  /// finalにすると，要素を出し入れしてもhashCodeが変わらないから，変更が監視されない
  int _numColumn = 5;
  final Ref ref;

  FileGridViewModel(this.ref);

  int get numColumn => _numColumn;
}
