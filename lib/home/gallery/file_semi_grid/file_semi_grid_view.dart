import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view.dart';
import 'package:laborales/home/gallery/file_semi_grid/file_semi_grid_view_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

class FileSemiGridView extends ConsumerWidget {
  final scrollController = ScrollController();
  FileSemiGridView({super.key});

  void scrollTo(
    Photo photo, {
    required BuildContext context,
    required WidgetRef ref,
  }) {
    var dir = photo.src.parent.path;
    var viewModel = ref.read(fileSemiGridProvider);
    // viewModel.setExpanded(dir, true);
    var key = viewModel.dir2key[dir];
    if (key == null) {
      return;
    }
    // TODO: somehow multiple opened FileGridViews called.
    var gridView = key.currentState;
    var gridViewContext = key.currentContext;
    if (gridView == null || gridViewContext == null) {
      return;
    }
    gridView.scrollTo(photo, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// auto scrolling when selected photo changed.
    ref.listen(
      galleryProvider.select((value) => value.selectedPhoto),
      (prev, next) {
        if (next != null) {
          scrollTo(next, context: context, ref: ref);
        }
      },
    );

    var selectedDir = ref.watch(galleryProvider
        .select((value) => value.selectedPhoto?.src.parent.path));

    var viewModel = ref.watch(fileSemiGridProvider);
    var dirs = viewModel.dirs;
    var dir2photos = viewModel.dir2photos;
    var dir2expanded = viewModel.dir2expanded;
    var dir2key = viewModel.dir2key;

    return ListView.builder(
      controller: scrollController,
      itemCount: dirs.length,
      itemBuilder: ((context, idx) {
        var dir = dirs[idx];
        var photos = dir2photos[dir]!;
        var expanded = dir2expanded[dir]!;
        var key = dir2key[dir]!;
        var dirname_ =
            ref.read(launcherProvider).project!.targetDir.path.split("/").last;
        int start_ = max(0, dir.indexOf(dirname_));
        var label = dir.substring(start_);

        return ExpansionTile(
          initiallyExpanded: expanded,
          onExpansionChanged: (value) =>
              ref.read(fileSemiGridProvider).setExpanded(dir, value),
          title: Text(
            label,
            style: TextStyle(
                fontWeight: dir == selectedDir ? FontWeight.bold : null),
          ),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 600),
              child: FileGridView(key: key, photos: photos),
            ),
          ],
        );
      }),
    );
  }
}
