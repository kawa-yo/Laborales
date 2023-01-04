import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/photo/photo_view.dart';
import 'package:laborales/root/root_view_model.dart';

class GalleryView extends ConsumerWidget {
  final int numColumn = 5;

  const GalleryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(filesProvider.select((value) => value.list));
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numColumn),
      padding: const EdgeInsets.all(2),
      cacheExtent: 2000,
      itemCount: files.length,
      itemBuilder: (context, idx) => AspectRatio(
        aspectRatio: 1.0,
        child: PhotoView(files[idx], idx: idx),
      ),
    );
  }
}
