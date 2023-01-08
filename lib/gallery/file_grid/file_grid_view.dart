import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/gallery/photo/photo_view.dart';

class FileGridView extends ConsumerWidget {
  const FileGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final files = ref.watch(fileGridProvider.select((value) => value.list));
    final numColumn =
        ref.watch(fileGridProvider.select((value) => value.numColumn));

    return FocusableActionDetector(
      shortcuts: ref.read(fileGridProvider).shortcuts,
      actions: ref.read(fileGridProvider).actions,
      autofocus: true,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: numColumn),
        padding: const EdgeInsets.all(2),
        cacheExtent: 2000,
        itemCount: files.length,
        itemBuilder: (context, idx) => AspectRatio(
          aspectRatio: 1.0,
          child: PhotoView(files[idx], idx: idx),
        ),
      ),
    );
  }
}
