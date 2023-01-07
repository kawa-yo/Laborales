import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_grid/file_grid_view_model.dart';

class PhotoView extends ConsumerWidget {
  final File src;
  final int idx;
  final double width;
  final double height;
  const PhotoView(
    this.src, {
    super.key,
    required this.idx,
    this.width = 100,
    this.height = 100,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint("build: PhotoView($idx)");
    bool selected = ref.watch(
        filesProvider.select((value) => value.selectedFile?.path == src.path));

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(
            width: 3.0, color: selected ? Colors.redAccent : Colors.grey[500]!),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: GestureDetector(
        onTap: () => ref.read(filesProvider).select(idx),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.file(src, width: width, height: height),
        ),
      ),
    );
  }
}
