import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/home/gallery/photo/photo_view.dart';
import 'package:laborales/home/gallery/photo/photo_view_model.dart';

/// adopt [ConsumerStatefulWidget] to use [GlobalKey]
///
class FileGridView extends ConsumerStatefulWidget {
  final List<Photo> photos;
  const FileGridView({required this.photos, super.key});

  @override
  ConsumerState<FileGridView> createState() => FileGridViewState();
}

class FileGridViewState extends ConsumerState<FileGridView> {
  final scrollController = ScrollController();

  void scrollTo(Photo photo, {required BuildContext context}) {
    if (widget.photos.isEmpty) {
      return;
    }
    if (photo.idx < widget.photos.first.idx ||
        photo.idx > widget.photos.last.idx) {
      return;
    }
    int idx = photo.idx - widget.photos.first.idx;
    int numColumn =
        ref.read(fileGridProvider.select((value) => value.numColumn));
    var box = context.findRenderObject() as RenderBox?;
    if (box == null) {
      return;
    }
    double photoSize = (box.size.width - 4) / numColumn;
    int row = idx ~/ numColumn;
    double pos = photoSize * row;

    double renderedTop = scrollController.position.pixels;
    double renderedBottom = renderedTop + box.size.height;
    // debugPrint("$pos [$renderedTop, $renderedBottom]");
    if (pos < renderedTop) {
      scrollController.jumpTo(pos);
    }
    if (pos + photoSize > renderedBottom) {
      scrollController.jumpTo(pos + photoSize - box.size.height);
    }
  }

  @override
  Widget build(BuildContext context) {
    final numColumn =
        ref.watch(fileGridProvider.select((value) => value.numColumn));

    /// auto scrolling when selected photo changed.
    ref.listen(
      galleryProvider.select((value) => value.selectedPhoto),
      (prev, next) {
        if (next != null) {
          scrollTo(next, context: context);
        }
      },
    );

    return GridView.builder(
      controller: scrollController,
      shrinkWrap: true,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: numColumn),
      padding: const EdgeInsets.all(2),
      cacheExtent: 1000,
      itemCount: widget.photos.length,
      itemBuilder: (context, idx) => AspectRatio(
        aspectRatio: 1.0,
        child: PhotoView(widget.photos[idx]),
      ),
    );
  }
}
