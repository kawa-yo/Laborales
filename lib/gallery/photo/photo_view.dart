import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/gallery/photo/photo_view_model.dart';

class PhotoView extends ConsumerWidget {
  final Photo photo;
  final double width;
  final double height;
  const PhotoView(
    this.photo, {
    super.key,
    this.width = 50,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // debugPrint("build: PhotoView($idx)");
    bool selected = ref
        .watch(photosProvider.select((value) => value.selectedPhoto == photo));

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
        onTap: () => ref.read(photosProvider).select(photo.idx),
        child: FittedBox(
          fit: BoxFit.fill,
          child: Image.file(photo.src, width: width, height: height),
        ),
      ),
    );
  }
}
