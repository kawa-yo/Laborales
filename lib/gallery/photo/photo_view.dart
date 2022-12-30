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
    final selectedFileViewModel = ref.read(selectedFileProvider);

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
      ),
      child: GestureDetector(
        onTap: () => selectedFileViewModel.update(src, idx),
        child: Image.file(src, width: width, height: height),
      ),
    );
  }
}
