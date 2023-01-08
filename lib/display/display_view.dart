import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/file_grid/file_grid_view_model.dart';
import 'package:laborales/root/root_view_model.dart';

class DisplayView extends ConsumerWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file =
        ref.watch(fileGridProvider.select((value) => value.selectedFile));
    Widget image = const Icon(Icons.image, size: 300);
    Widget label = Container();
    if (file != null) {
      var _dirname =
          ref.watch(rootProvider).project!.targetDir.path.split("/").last;
      var _start = file.path.indexOf(_dirname);
      var caption = file.path.substring(_start);
      image = Image.file(file, width: double.infinity, fit: BoxFit.contain);
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
