import 'dart:io';

class Photo {
  final File src;
  final int idx;

  Photo(this.src, {required this.idx});

  @override
  bool operator ==(Object other) =>
      other is Photo && src.path == other.src.path && idx == other.idx;
  @override
  int get hashCode => Object.hash(src.path, idx);
}
