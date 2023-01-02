import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/root/root_view_model.dart';
import 'package:laborales/themes/theme.dart';

class PhotoView extends ConsumerWidget {
  final File src;
  final int idx;
  final double width;
  final double height;
  const PhotoView(
    this.src, {
    super.key,
    required this.idx,
    this.width = 200,
    this.height = 150,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    debugPrint("build: PhotoView($idx)");
    bool selected = ref.watch(
        filesProvider.select((value) => value.selectedFile?.path == src.path));

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: primaryColor,
        border: Border.all(
            width: 1.0, color: selected ? Colors.redAccent : Colors.white70),
        borderRadius: const BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: GestureDetector(
        onTap: () => ref.read(filesProvider).select(idx),
        child: Image.file(src, width: width, height: height),
      ),
    );
  }
}
