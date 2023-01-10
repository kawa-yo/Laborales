import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:laborales/gallery/photo/photo_view_model.dart';
import 'package:laborales/labeler/labeler_view_model.dart';

class LabelerView extends ConsumerWidget {
  const LabelerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var viewModel = ref.watch(labelerProvider);
    var photosViewModel = ref.watch(photosProvider);
    var selectedPhoto = photosViewModel.selectedPhoto;
    var label = photosViewModel.labelOf(selectedPhoto);
    var labels = viewModel.labels;
    var colors = viewModel.colors;
    return ListView.builder(
      itemCount: labels.length,
      itemBuilder: ((context, idx) {
        return CheckboxListTile(
          title: Text(labels[idx]),
          side: BorderSide(color: colors[idx], width: 3),
          activeColor: colors[idx],
          controlAffinity: ListTileControlAffinity.leading,
          value: label == labels[idx],
          onChanged: (value) {
            debugPrint("${labels[idx]}: $value");
            if (value == true && selectedPhoto != null) {
              photosViewModel.setLabel(selectedPhoto, labels[idx]);
            }
          },
        );
      }),
    );
  }
}
