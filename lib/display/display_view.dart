import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/root/root_view_model.dart';

class DisplayView extends ConsumerWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFileViewModel = ref.watch(selectedFileProvider);
    final file = selectedFileViewModel.file;
    // final idx = selectedFileViewModel.idx;
    final image = file != null ? Image.file(file) : const Icon(Icons.image);

    // final files = ref.watch(filesProvider).list;
    return Container(
      padding: const EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.contain,
        child: image,
      ),
    );
  }
}
