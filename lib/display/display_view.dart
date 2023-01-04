import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/gallery_view_model.dart';

class DisplayView extends ConsumerWidget {
  const DisplayView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final file = ref.watch(filesProvider.select((value) => value.selectedFile));
    final image = file != null ? Image.file(file) : const Icon(Icons.image);

    return Container(
      padding: const EdgeInsets.all(10),
      child: FittedBox(
        fit: BoxFit.contain,
        child: image,
      ),
    );
    // final image = file != null
    //     ? Image.file(file, width: double.infinity, fit: BoxFit.contain)
    //     : const Icon(Icons.image, size: 300);
    // final label = file != null
    //     ? Text(file.path, style: TextStyle(fontSize: 20))
    //     : Container();
    // return Container(
    //   padding: const EdgeInsets.all(10),
    //   // child: FittedBox(
    //   //   fit: BoxFit.contain,
    //   //   child: image,
    //   // ),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       image,
    //       label,
    //       const SizedBox(height: 10),
    //     ],
    //   ),
    // );
  }
}
