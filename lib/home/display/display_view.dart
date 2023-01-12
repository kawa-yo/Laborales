import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/home/gallery/gallery_view_model.dart';
import 'package:laborales/launcher/launcher_view_model.dart';

class DisplayView extends ConsumerWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo =
        ref.watch(galleryProvider.select((value) => value.selectedPhoto));
    Widget image = const Icon(Icons.image, size: 300);
    Widget label = Container();
    if (photo != null) {
      var _dirname =
          ref.watch(launcherProvider).project!.targetDir.path.split("/").last;
      var _start = max(0, photo.src.path.indexOf(_dirname));
      var caption = photo.src.path.substring(_start);
      image =
          Image.file(photo.src, width: double.infinity, fit: BoxFit.contain);
      label = Text(
        caption,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: image),
          label,
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
