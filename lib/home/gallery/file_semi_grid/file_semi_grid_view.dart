import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

class FileSemiGridView extends ConsumerWidget {
  const FileSemiGridView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var allPhotos = ref.watch(photosProvider.select((value) => value.list));
    var listedPhotos = photoList(allPhotos);
    var keys = listedPhotos.keys.toList();
    var numColumn =
        ref.watch(fileGridProvider.select((value) => value.numColumn));
    return ListView.builder(
      itemCount: keys.length,
      itemBuilder: ((context, idx) {
        var key = keys[idx];
        var photos = listedPhotos[key]!;
        var _dirname =
            ref.watch(launcherProvider).project!.targetDir.path.split("/").last;
        var label = key.substring(key.indexOf(_dirname));
        return ExpansionTile(
          title: Text(label),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: GridView.builder(
                shrinkWrap: true,
                primary: false,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: numColumn),
                cacheExtent: 1000,
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
