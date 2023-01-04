import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/file_tree/file_tree_view_models.dart';
import 'package:laborales/gallery/gallery_view_model.dart';

class DisplayView extends ConsumerWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(filesProvider.select((value) => value.selectedFile));
    Widget image = const Icon(Icons.image, size: 300);
    Widget label = Container();
    if (file != null) {
      image = Image.file(file, width: double.infinity, fit: BoxFit.contain);
      label = Text(
        file.path,
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
