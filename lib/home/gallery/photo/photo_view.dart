import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/home/labeler/labeler_view_model.dart';
import 'package:laborales/themes/theme.dart';

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
        .watch(galleryProvider.select((value) => value.selectedPhoto == photo));
    String label =
        ref.watch(galleryProvider.select((value) => value.labelOf(photo)));
    Color color = ref.watch(
            labelerProvider.select((value) => value.label2color[label])) ??
        Colors.grey[200]!;

    return GestureDetector(
      onTap: () => ref.read(galleryProvider).select(photo.idx),
      child: FittedBox(
        fit: BoxFit.fill,
        child: Opacity(
          opacity: selected ? 1.0 : .5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border.all(
                width: selected ? 0.0 : 2.0,
                color: Colors.grey[50]!,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
                border: Border.all(
                  width: 2.5,
                  color: color,
                ),
                borderRadius: const BorderRadius.all(Radius.circular(5)),
              ),
              child: Image.file(photo.src, width: width, height: height),
            ),
          ),
        ),
      ),
    );
  }
}
