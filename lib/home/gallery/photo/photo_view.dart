import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';

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
    // debugPrint("build: PhotoView(${photo.idx})");
    bool selected = ref
        .watch(photosProvider.select((value) => value.selectedPhoto == photo));
    String label =
        ref.watch(photosProvider.select((value) => value.labelOf(photo)));
    Color color =
        ref.watch(labelerProvider.select((value) => value.colorOf(label))) ??
            Colors.transparent;

    return GestureDetector(
      onTap: () => ref.read(photosProvider).select(photo.idx),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2.5,
              color: selected ? Colors.black87 : Colors.grey[50]!,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(7.5)),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(
                width: 5.0,
                color: color,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(5)),
            ),
            child: Image.file(photo.src, width: width, height: height),
          ),
        ),
      ),
    );
  }
}
