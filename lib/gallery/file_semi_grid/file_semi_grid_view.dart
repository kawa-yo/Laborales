import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_semi_grid/file_semi_grid_view_model.dart';
import 'package:laborales/gallery/photo/photo_view.dart';
import 'package:laborales/gallery/photo/photo_view_model.dart';
import 'package:laborales/root/root_view_model.dart';

class FileSemiGridView extends ConsumerWidget {
  const FileSemiGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allPhotos = ref.watch(photosProvider.select((value) => value.list));
    var listedPhotos = photoList(allPhotos);
    var keys = listedPhotos.keys.toList();
    var numColumn =
        ref.watch(fileSemiGridProvider.select((value) => value.numColumn));
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: ((context, idx) {
        var key = keys[idx];
        var photos = listedPhotos[key]!;
        var _dirname =
            ref.watch(rootProvider).project!.targetDir.path.split("/").last;
        var label = key.substring(key.indexOf(_dirname));
        return ExpansionTile(
          title: Text(label),
          children: [
            // for (int i = 0; i < (photos.length / numColumn).ceil(); i++)
            //   Row(
            //     children: [
            //       for (int j = 0;
            //           j < numColumn && i * numColumn + j < photos.length;
            //           j++)
            //         Expanded(child: PhotoView(photos[i * numColumn + j]))
            //     ],
            //   )

            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numColumn),
                cacheExtent: 2000,
                itemCount: photos.length,
                itemBuilder: ((context, idx) {
                  return PhotoView(photos[idx]);
                }),
              ),
            ),
          ],
        );
      }),
    );
  }
}
