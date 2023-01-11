import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';

class FileGridView extends ConsumerWidget {
  const FileGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(photosProvider.select((value) => value.list));
    final numColumn =
        ref.watch(fileGridProvider.select((value) => value.numColumn));

    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numColumn),
      padding: const EdgeInsets.all(2),
      cacheExtent: 1000,
      itemCount: photos.length,
      itemBuilder: (context, idx) => AspectRatio(
        aspectRatio: 1.0,
        child: PhotoView(photos[idx]),
      ),
    );
  }
}
